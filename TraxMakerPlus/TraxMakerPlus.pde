import g4p_controls.*; //Separate Windows

import java.io.FileWriter; //File Output

import java.awt.Point; //Point class to store window location
import java.awt.MouseInfo; //Get mouse locations

import processing.awt.*; //To be able to cast PSurface to Frame to get the location of the window relative to the display
import java.awt.Frame;
import java.lang.reflect.Field;

import java.lang.System; //Nanotime, Temporary

//============================================================================================================================================================================
//============================================================================================================================================================================
//============================================================================================================================================================================

//Edit Fields
LineSegment selectedTrack, placingTrack; //Objects that hold temporary access to linesegment objects that are currently being edited
Text selectedText, placingText, editText; //Same as tracks, but for text
Component placingComponent, selectedComponent, editComponent;//Same as tracks, but for components

Layer curLayer; //Keeps track of the current selected layer
ArrayList<Layer> layers; //List of all of the layers

//Viewport Fields
PVector curView; //Offset from the screen
boolean[] movePressed; //{'W', 'A', 'S', 'D'} || {UP, LEFT, DOWN, UP}
float panSpeed = 8; //Speed of offset movement
float viewScale = 1; //Global scale when drawing in the viewport
boolean invertedScroll = false; //
final float zoomMin = 0.1, zoomMax = 3; //Maximum and minimum viewScale values
PVector viewPortMax, viewPortMin; //viewPort corners relative to curView and viewScale

//Tools
PImage[] icons; //Tool icons appearing in toolbox (Left of screen)
PImage highlightTool, selectedTool; //Showing hovering or selected tool (also used for other highlights)
int[] iconOffset; //The offset for each tool. This will display the tool shifted over to this x coordinate (Center).
final int minIconOffset = -15, maxIconOffset = 37; //Offest values to target when going up or down
int offsetIncSpeed = 6; //The rate at which offset values are increased or decreased

//Snapping
PVector snapPoint; //Global snapping point value
int snapAngle = 30; //Angle to snap to when the angle snapping mode is "Angular"
final int snapDist = 20; //Distance to snap at

//File Icons
final int minFileOffset = -15; //Same thing as iconOffset with their min and max
final int maxFileOffset = 30;

//Dialogues
//These objects will setup the windows or will extend PApplet to be the
//windows for the dialogues that will take certain inputs and change the
//state of the application
newFileDialogue nfWin;
createTextDialogue cText;
chooseComponentDialogue cComp;
layerOptionsDialogue lOptions;
deleteLayerDialogue dLayer;
chooseColorDialogue ccD;

//Layer Manager
int managerScrolled = 0; //Amount by which to offset the layer manager. Updates when scrolled in the manager
int maxAmount = 1; //Amount of layers that can be displayed in the manager. (Defaults to 1, but gets recalculated regularly).
float managerOffset = 82; //Distance from the bottom that the manager starts

//Components
Component[] masterComponents; //Components that will be loaded in and copied whenever making new components.
boolean showOfficialNames = false; //Instead of the names given by the program, uses official names. (EG. SIP 3 instead of Three Pad)

//Misc
boolean doFullScreen = true; //Not yet implemented

//============================================================================================================================================================================
//============================================================================================================================================================================
//============================================================================================================================================================================

void settings() {
    size(displayWidth, displayHeight, JAVA2D); //Window starts off as the width and height of the display
}

void setup() {
    frameRate(30);
    
    surface.setResizable(true);
    surface.setTitle("Traxmaker Plus");
    G4P.messagesEnabled(false);
    //=====================================
    //============LAYER SETUP==============
    //=====================================
    layers = new ArrayList<Layer>();
    curLayer = new Layer(30);
    curView = new PVector();
    movePressed = new boolean[4];
    selectedTrack = null; 
    placingTrack = null;
    snapPoint = null;
    layers.add(curLayer);
    
    
    masterComponents = loadMaster();
    //=====================================
    //============LOAD ICONS===============
    //=====================================
    icons = loadToolIcons();
    highlightTool = loadImage("Icons/Misc/Highlight.png");
    selectedTool = loadImage("Icons/Misc/Selected.png");
    snapIcon = loadImage("Icons/Snap/SnapIcon.png");
    AngleSnap.icons = new PImage[3];
    AngleSnap.icons[0] = loadImage("Icons/Snap/NoAngleSnapIcon.png");
    AngleSnap.icons[1] = loadImage("Icons/Snap/Deg90Icon.png");
    AngleSnap.icons[2] = loadImage("Icons/Snap/AngleSnapIcon.png");

    iconOffset = new int[Tool.toolName.length];
    for (int i = 0; i < iconOffset.length; i++) {
        iconOffset[i] = minIconOffset;
    }

    fileIcons = new PImage[]{loadImage("Icons/File/NewFileIcon.png"), loadImage("Icons/File/OpenIcon2.png"), loadImage("Icons/File/SaveIcon.png")};
    fileIconLoc = new PVector[]{new PVector(width - 160, minFileOffset), new PVector(width - 100, minFileOffset), new PVector(width - 40, minFileOffset)};

    visibleIcon = loadImage("Icons/Material/Visible.png");
    visibleIcon.resize(18, 18);
    invisibleIcon = loadImage("Icons/Material/Invisible.png");
    invisibleIcon.resize(18, 18);
    
    NLIcon = loadImage("Icons/Layer/NewLayer.png");
    ELIcon = loadImage("Icons/Layer/EditLayer.png");
    DLIcon = loadImage("Icons/Layer/DeleteLayer.png");
    
    NLHighlight = makeHighlight(NLIcon);
    ELHighlight = makeHighlight(ELIcon);
    DLHighlight = makeHighlight(DLIcon);

    //=====================================
    //============GUI Window===============
    //=====================================

    surface.setAlwaysOnTop(true);
    window = GWindow.getWindow(this, "Dialogue", width/2, height/2, 100,100,JAVA2D);
    window.setActionOnClose(G4P.KEEP_OPEN);
    nfWin = new newFileDialogue();
    cText = new createTextDialogue();
    lOptions = new layerOptionsDialogue();
    dLayer = new deleteLayerDialogue();
    ccD = new chooseColorDialogue();
    cComp = new chooseComponentDialogue();
    window.setVisible(false);
    surface.setAlwaysOnTop(false);
    dialogueSurface = window.getSurface();
    setDialogue(-1);
    
    //=====================================
    //============Miscellaneous============
    //=====================================
    
    imageMode(CENTER);
    textAlign(CENTER);
    blendMode(REPLACE);
    
    
    
    surface.setIcon(loadImage("Icons/Tools/TrackIcon.png"));
}

void draw() {
    background(200);
    updateApp();
    drawApp();
}

void updateApp() { //Updates the app values
    snapPoint = null;
    updateView();
    updateOffset();
    updateSelected();
    updatePlacing();
    if (Tool.curTool == Tool.FitViewToBoard) {
        fitBoardToView();
        changeTool(Tool.Select);
    }
    
}

void drawApp() { //Draws the elements of the app
    //Viewport Stuff
    pushMatrix();
    translate(curView.x, curView.y);
    scale(viewScale);
    drawReferencePoints();
    drawLayers();
    if (snapPoint != null)
        drawSnapPoint(snapPoint);
    popMatrix();
    //UI Stuff
    drawLayerManager();
    drawIcons();
    drawFileIcon();
    drawSnap();
    drawInfo();
}
