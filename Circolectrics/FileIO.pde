PImage[] fileIcons; //<>//
String[] fileIconNames = {"Print", "New File", "Open File", "Save"};
PVector[] fileIconLoc;
String fileExtension = ".tmf";

void makeNewFile() {
    curView.set(0, 0);
    selectedTrack.clear(); 
    selectedComponent.clear();
    selectedText.clear();
    placingComponent = null;
    placingText = null;
    placingTrack = null;
    snapPoint = null;
    layers.clear();

    float t = float(nfWin.firstThickness.getText());
    if (Float.isNaN(t) || t <= 0) t = 30;
    curLayer = new Layer(t);
    layers.add(curLayer);
}

void makeNewFile(File f) {
    makeNewFile();
    saveToFile(f);
}

void makeNewFile(int w, int h) {
    makeNewFile();

    float th = float(nfWin.firstThickness.getText());
    if (Float.isNaN(th) || th <= 0) {
        th = 30;
    }
    Layer l = new Layer(th, "Outline", 4);
    layers.add(0, l);

    PVector p1 = new PVector(0, 0);
    PVector p2 = new PVector(w, 0);
    PVector p3 = new PVector(w, h);
    PVector p4 = new PVector(0, h);
    float t = l.defaultThickness;
    LineSegment s1 = new LineSegment(p1, p2, t);
    LineSegment s2 = new LineSegment(p2, p3, t);
    LineSegment s3 = new LineSegment(p3, p4, t);
    LineSegment s4 = new LineSegment(p4, p1, t);
    l.addTrack(s1);
    l.addTrack(s2);
    l.addTrack(s3);
    l.addTrack(s4);
    fitBoardToView();
}

void makeNewFile(int w, int h, File f) {
    makeNewFile(w, h);
    saveToFile(f);
}



void openFile(File f) {
    if(f == null) return;
    makeNewFile();
    layers.clear();
    String[] parts = loadStrings(f);
    parts = trim(parts);
    
    for (String part : parts) {
        String[] element = part.split(" ");
        String[] stringE = part.split("!");
        if (element[0].equals("<Layer>")) {
            Layer l = new Layer(float(element[1]), stringE[1], int(element[2 + stringE[1].split(" ").length]));
            l.isVisible = (boolean(element[3 + stringE[1].split(" ").length]));
            layers.add(l);
        } else if (element[0].equals("<Track>")) {
            PVector p1 = new PVector(int(element[1]), int(element[2])), p2 = new PVector(int(element[3]), int(element[4]));;
            LineSegment ls = new LineSegment(p1, p2);
            layers.get(layers.size()-1).tracks.add(ls);
        } else if (element[0].equals("<Comp>")) {
            String name = stringE[1];
            for(int i = 0; i < masterComponents.length; i++){
                if(masterComponents[i].name.equals(name)){
                    Component c = masterComponents[i].copy();
                    c.loc.set(int(element[1 + stringE[1].split(" ").length]), int(element[2+ stringE[1].split(" ").length]));
                    c.rotation = float(element[3 + stringE[1].split(" ").length]);
                    c.img = masterComponents[i].possibleImages[int(element[4 + stringE[1].split(" ").length])];
                    layers.get(layers.size()-1).components.add(c);
                    break;
                }
            }
        } else if (element[0].equals("<Text>")) {
            PVector b = new PVector(int(element[1]), int(element[2]));
            color c = int(element[3]);
            int fs = int(element[4]);
            String t = stringE[1];
            Text T = new Text(t, fs, b);
            T.setColor(c);
            layers.get(layers.size()-1).texts.add(T);
        }
    }
    
    curLayer = layers.get(0);
    fileReady = false;
    
}

void saveToFile(File f) {
    if (f == null) return;
    if (!f.getPath().endsWith(fileExtension)) {//
        println("Please select a file with extension", fileExtension);
        return;
    }

    try {
        FileWriter fw = new FileWriter(f);//Must use filewriter because a File object is passed in
        for (int i = 0; i < layers.size(); i++) {
            Layer l = layers.get(i);
            String output = "<Layer> " + str(l.defaultThickness) + " !" +l.name + "! " + str(l.colorIndex) + " " + str(l.isVisible)  + '\n';
            fw.write(output);

            for (int j = 0; j < l.tracks.size(); j++) {
                LineSegment ls = l.tracks.get(j);
                fw.write("<Track> ");
                fw.write(str(ls.points[0].x) + " " + str(ls.points[0].y) + " " + str(ls.points[1].x) + " " + str(ls.points[1].y) + '\n');
            }

            for (int j = 0; j < l.components.size(); j++) {
                Component c = l.components.get(j);
                String o = "<Comp> !" + c.name + "! " + c.loc.x + " " + c.loc.y +  " " + c.rotation + " " + c.imgInd + "\n";
                fw.write(o);
            }

            for (int j = 0; j < l.texts.size(); j++) {
                Text t = l.texts.get(j);
                fw.write("<Text> ");
                fw.write(str(t.base.x) + " " + str(t.base.y) + " ");
                fw.write(str(t.c) + " ");
                fw.write(str(t.fontSize) + " ");
                fw.write("!" + t.text + "!\n");
            }
        }


        fw.flush();
        fw.close();
    }
    catch(IOException e) {
    }
}


void outputImages() {
    fitBoardToOutput();
    pushMatrix();
    translate(curView.x, curView.y);
    scale(viewScale);
    
    //LIGHT Output
    background(255);
    drawLayers();
    saveFrame("data/Output/OutputLight.jpg");

    //DARK Output (Negative)
    background(0);
    for (int i = 0; i < layers.size(); i++) {
        Layer l = layers.get(i);
        l.drawTracks(true);
        l.drawComponents(true);
    }

    saveFrame("data/Output/OutputDark.jpg");
    popMatrix();
}


void fitBoardToOutput() {
    if (areLayersEmpty()) return;
    int j = 0;
    while (isLayerEmpty(layers.get(j))) j++;
    Layer l0 = layers.get(j);
    float xMin = 0, xMax = 0, yMin = 0, yMax = 0;
    if (l0.tracks.size() > 0) {
        LineSegment ls = l0.tracks.get(0);
        xMin = ls.points[0].x;
        xMax = ls.points[0].x;
        yMin = ls.points[0].y;
        yMax = ls.points[0].y;
    } else if (l0.components.size()>0) {
        Component c = l0.components.get(0);
        xMin = c.loc.x;
        xMax = c.loc.x;
        yMin = c.loc.y;
        yMax = c.loc.y;
    } else {
        Text t = l0.texts.get(0);
        xMin = t.base.x;
        xMax = t.base.x;
        yMin = t.base.y;
        yMax = t.base.y;
    }

    for (int i = 0; i < layers.size(); i++) {
        Layer l = layers.get(i);
        for (int k = 0; k < l.tracks.size(); k++) {
            LineSegment t = l.tracks.get(k);
            float x1 = t.points[0].x, x2 = t.points[1].x, y1 = t.points[0].y, y2 = t.points[1].y;
            if (x1 > xMax) xMax = x1;
            else if (x1 < xMin) xMin = x1;
            if (x2 > xMax) xMax = x2;
            else if (x2 < xMin) xMin = x2;

            if (y1 > yMax) yMax = y1;
            else if (y1 < yMin) yMin = y1;
            if (y2 > yMax) yMax = y2;
            else if (y2 < yMin) yMin = y2;
        }
        for (int k = 0; k < l.components.size(); k++) {
            try {
                Component c = l.components.get(k);
                for (int m = 0; m < c.basePoints.length; m++) {
                    float x1 = c.loc.x + c.basePoints[m].x, y1 = c.loc.y + c.basePoints[m].y;
                    if (x1 > xMax) xMax = x1;
                    else if (x1 < xMin) xMin = x1;
                    if (y1 > yMax) yMax = y1;
                    else if (y1 < yMin) yMin = y1;
                }
            } 
            catch(Exception e) {
            }
        }
        for (int k = 0; k < l.texts.size(); k++) {
            Text t = l.texts.get(k);
            float x1 = t.base.x, y1 = t.base.y;
            if (x1 > xMax) xMax = x1;
            else if (x1 < xMin) xMin = x1;
            if (y1 > yMax) yMax = y1;
            else if (y1 < yMin) yMin = y1;
        }
    }

    xMin -= 100;
    xMax += 100;
    yMin -= 100;
    yMax += 100;

    float dX = xMax - xMin;
    float dY = yMax - yMin;
    viewScale = min(zoomMax, max(zoomMin, min(width / dX, height / dY)));
    curView.set(-xMin * viewScale, -yMin * viewScale);

    if (width / dX < height / dY) {
        float dif = height - dY * viewScale;
        curView.y += dif/2;
    } else {
        float dif = width - dX * viewScale;
        curView.x += dif/2;
    }
}
