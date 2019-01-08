enum Tool {     
    Track, 
        Component, 
        Text, 
        Select, 
        Pan, 
        FitViewToBoard, 
        None;

    static Tool curTool = Tool.Track;
    static String[] toolName = {"Add Track", "Add Component", "Add Text", "Select", "Pan View", "Fit Board To View", "Cancel"};
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

PImage[] loadToolIcons() {
    PImage[] imgs = new PImage[7];
    imgs[0] = loadImage("Icons/Tools/TrackIcon.png");
    imgs[1] = loadImage("Icons/Tools/ComponentIcon.png");
    imgs[2] = loadImage("Icons/Tools/TextIcon.png");
    imgs[3] = loadImage("Icons/Tools/SelectIcon.png");
    imgs[4] = loadImage("Icons/Tools/PanIcon.png");
    imgs[5] = loadImage("Icons/Tools/BoardViewIcon.png");
    imgs[6] = loadImage("Icons/Tools/CancelIcon2.png");

    return imgs;
}
