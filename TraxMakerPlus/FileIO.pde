PImage[] fileIcons; //<>//
String[] fileIconNames = {"New File", "Open File", "Save"};
PVector[] fileIconLoc;
String fileExtension = ".tmf";

void makeNewFile() {
    
    curLayer = new Layer(30);
    curView.set(0, 0);
    selectedTrack = null; 
    placingTrack = null;
    snapPoint = null;
    layers.clear();
    layers.add(curLayer);
    nfWin.cleanupWin();
}

void makeNewFile(File f) {
    makeNewFile();
    saveToFile(f);
}

void makeNewFile(int w, int h) {
    makeNewFile();
    
    int th = 30;
    if(nfWin.check.isSelected()){
        String s = nfWin.firstThickness.getText();
        if(int(s) > 0)
            th = int(s);
        else
            println("Invalid Thickness");
    }
    
    Layer l = new Layer(th, "Outline", 4);
    layers.add(0, l);
    //int w2 = -w/2, h2 = -h/2;
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
    String[] parts = loadStrings(f);
    for (String part : parts) {
    }
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
            fw.write("<Layer> ");
            fw.write(str(l.defaultThickness));
            fw.write(" ");
            fw.write(str(l.colorIndex));
            fw.write(" ");
            fw.write(str(l.isVisible));
            fw.write(" ");
            fw.write(l.name);
            fw.write("\n");

            for (int j = 0; j < l.tracks.size(); j++) {
                LineSegment ls = l.tracks.get(j);
                fw.write("<Track> ");
                fw.write(str(ls.points[0].x) + " " + str(ls.points[0].y) + " " + str(ls.points[1].x) + " " + str(ls.points[1].y) + " ");
                fw.write(((ls.slope == Float.POSITIVE_INFINITY)?"I":str(ls.slope)) + " ");
                fw.write(str(ls.thickness) + "\n");
                //println(ls.slope);
            }

            for (int j = 0; j < l.components.size(); j++) {
            }

            for (int j = 0; j < l.texts.size(); j++) {
                Text t = l.texts.get(j);
                fw.write("<Text> ");
                fw.write(str(t.base.x) + " " + str(t.base.y) + " ");
                fw.write(str(t.c) + " ");
                fw.write(str(t.fontSize) + " ");
                fw.write(t.text + "\n");
            }
        }


        fw.flush();
        fw.close();
    }
    catch(IOException e) {
    }
}
