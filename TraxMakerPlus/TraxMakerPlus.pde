import g4p_controls.*; //Separate Windows

import java.io.FileWriter; //FileIO

import java.awt.Point; //Point class to store window location
import java.awt.MouseInfo; //Get mouse locations

import processing.awt.*;
import java.awt.Frame;
import java.lang.reflect.Field;

import java.lang.System;

boolean temp = true;

LineSegment selectedTrack, placingTrack;
PVector snapPoint;

Layer curLayer;
ArrayList<Layer> layers;

PVector curView;
boolean[] movePressed; //{'W', 'A', 'S', 'D'} || {UP, LEFT, DOWN, UP}
float panSpeed = 8;
float viewScale = 1;
boolean invertedScroll = false;

PImage[] icons;
PImage highlightTool, selectedTool;

final float zoomMin = 0.1, zoomMax = 3;
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

Component[] cs;


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

    //=====================================
    //============GUI Window===============
    //=====================================

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
    dialogueSurface = window.getSurface();
    
    //=====================================
    //============Miscellaneous============
    //=====================================
    
    imageMode(CENTER);
    textAlign(CENTER);
    blendMode(REPLACE);
    
    
    cs = new Component[13]; 
    cs[0] = new TwoPad(new PVector(200,200));
    cs[1] = new TwoPad(new PVector(600,200));
    cs[2] = new TwoPadShort(new PVector(1000,200));
    cs[3] = new ThreePad(new PVector(1300, 200));
    cs[4] = new EightPin(new PVector(1800, 200));
    cs[5] = new FourteenPin(new PVector(2200, 200));
    cs[6] = new SixteenPin(new PVector(2600, 200));
    cs[7] = new EighteenPin(new PVector(3000, 200));
    cs[8] = new FortyPin(new PVector(300, 2000));
    cs[9] = new VResistor(new PVector(1500, 1500));
    cs[10] = new LCD(new PVector(1500,2000));
    cs[11] = new Power4(new PVector(3000,1500));
    cs[12] = new Power6(new PVector(3000, 2300));
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
    
    for(int i = 0; i < cs.length; i++)
        cs[i].display(ccD.colors[i]);
        //cs[i].display();
    
    popMatrix();
    drawLayerManager();
    drawIcons();
    drawFileIcon();
    drawSnap();
    drawInfo();
}
