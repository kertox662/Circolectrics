import g4p_controls.*; //Separate Windows

import java.io.FileWriter; //FileIO

import java.awt.Point; //Point class to store window location
import java.awt.MouseInfo; //Get mouse locations

import processing.awt.*;
import java.awt.Frame;
import java.lang.reflect.Field;

boolean temp = true;

LineSegment selectedTrack, placingTrack;
PVector snapPoint;

Layer curLayer;
ArrayList<Layer> layers;

PVector curView;
boolean[] movePressed; //{'W', 'A', 'S', 'D'}
float panSpeed = 8;
float viewScale = 1;
boolean invertedScroll = false;

PImage[] icons;
PImage highlightTool, selectedTool;

final float zoomMin = 0.1, zoomMax = 5;
final int minIconOffset = -15, maxIconOffset = 37;
final int snapDist = 20;

final int minFileOffset = -15;
final int maxFileOffset = 30;

int offsetIncSpeed = 6;
int[] iconOffset;

boolean doFullScreen = true;

newFileDialogue nfWin;
createTextDialogue cText;
chooseComponentDialogue cComp;
layerOptionsDialogue lOptions;
deleteLayerDialogue dLayer;
chooseColorDialogue ccD;

int managerScrolled = 0;
int maxAmount = 1;
float managerOffset = 82;

PVector viewPortMax, viewPortMin;


void settings() {
    size(displayWidth, displayHeight, JAVA2D);
}

void setup() {
    frameRate(30);
    
    surface.setResizable(true);
    surface.setTitle("Traxmaker Plus");
    

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

    surface.setAlwaysOnTop(true);
    window = GWindow.getWindow(this, "Dialogue", width/2, height/2, 100,100,JAVA2D);
    window.setActionOnClose(G4P.KEEP_OPEN);
    nfWin = new newFileDialogue();
    cText = new createTextDialogue();
    cComp = new chooseComponentDialogue();
    lOptions = new layerOptionsDialogue();
    dLayer = new deleteLayerDialogue();
    ccD = new chooseColorDialogue();
    window.setVisible(false);
    surface.setAlwaysOnTop(false);

    imageMode(CENTER);
    textAlign(CENTER);
}

void draw() {
    background(200);
    updateApp();
    drawApp();
}

void updateApp() {
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

void drawApp() {
    //int e = millis();
    pushMatrix();
    translate(curView.x, curView.y);
    scale(viewScale);
    drawReferencePoints();
    drawLayers();
    if (snapPoint != null)
        drawSnapPoint(snapPoint);
    popMatrix();
    drawLayerManager();
    drawIcons();
    drawFileIcon();
    drawSnap();
    drawInfo();
}
