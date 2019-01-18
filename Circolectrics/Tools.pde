enum Tool {     
    Track, 
        Component, 
        Text, 
        Select,
        Rotate ,
        Pan, 
        FitViewToBoard;

    static Tool curTool = Tool.Select;
    static String[] toolName = {"Add Track", "Add Component", "Add Text", "Select", "Rotate", "Pan View", "Fit Board To View"};
}

void changeTool(Tool t) {
    if (t == Tool.curTool) Tool.curTool = Tool.Select;
    else {
        if (Tool.curTool == Tool.Track) {
            if (placingTrack != null) {
                curLayer.tracks.remove(placingTrack);
                placingTrack = null;
            }
        }    
        Tool.curTool = t;
    }
}

void resetActions() {
    Tool t = Tool.curTool;
    if (t != Tool.Track) {
    }
    if (t != Tool.Component) {
    }
    if (t != Tool.Text) {
    }
    if (t != Tool.Select) {
    }
    if (t != Tool.Pan) {
    }
    if (t != Tool.FitViewToBoard) {
    }
    if (t != Tool.Rotate) {
    }
}

PImage[] loadToolIcons() {
    PImage[] imgs = new PImage[7];
    imgs[0] = loadImage("Icons/Tools/TrackIcon.png");
    imgs[1] = loadImage("Icons/Tools/ComponentIcon.png");
    imgs[2] = loadImage("Icons/Tools/TextIcon.png");
    imgs[3] = loadImage("Icons/Tools/SelectIcon.png");
    imgs[4] = loadImage("Icons/Tools/RotateIcon.png");
    imgs[5] = loadImage("Icons/Tools/PanIcon.png");
    imgs[6] = loadImage("Icons/Tools/BoardViewIcon.png");
    

    return imgs;
}

void resetElements() {
    resetTrack();
    resetComponent();
    resetText();
}

void resetTrack() {
    if (placingTrack != null) {
        curLayer.tracks.remove(placingTrack);
        placingTrack = null;
    }
}

void resetComponent() {
    if (placingComponent != null) {
        curLayer.components.remove(placingComponent);
        placingComponent = null;
    }
    
    editComponent = null;
    cComp.setVisible(false);
}

void resetText() {
    if (placingText != null) {
        curLayer.texts.remove(placingText);
        placingText = null;
    }
    editText = null;
    cText.cleanupWin();
    window.setVisible(false);
}
