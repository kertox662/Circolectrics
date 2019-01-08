PApplet main = this;
PImage colorChooser, valueChooser;

void setDialogue(int x){
    if(x != 0){ //New File Window
        nfWin.reset();
    } else{
        nfWin.window.setVisible(true);
    }
    
    if(x != 1){ //Create Text
    
    } else{
    
    }
    
    if(x != 2){ //Add Component
    
    } else{
    
    }
    
    if(x != 3){ //Edit Layer
        lOptions.window.setVisible(false);
    } else{
        lOptions.window.setVisible(true);
    }
    
    if(x != 4){ //Delete Layer
        dLayer.window.setVisible(false);
    } else{
        dLayer.window.setVisible(true);
    }
    
    if(x != 5){ //Choose Color
        ccD.finish();
    } else{
        if(ccD.isRunning == false) ccD.run();
        else ccD.getSurface().setVisible(true);
        ccD.changeIndex = (height - 86 - mouseY + managerScrolled)/20;
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

class newFileDialogue {
    GWindow window;
    GTextField widthEntry, heightEntry, firstThickness;
    GLabel outline, fileName, unit;
    GButton startFile, create, cancel;
    GCheckbox check;

    File initFile;

    newFileDialogue() {
        window = GWindow.getWindow(main, "New File", 0, 0, 300, 200, JAVA2D);
        window.setActionOnClose(G4P.KEEP_OPEN);

        check = new GCheckbox(window, 5, 50, 120, 20);
        check.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
        check.setText("Start With Outline?");
        check.setOpaque(true);

        outline = new GLabel(window, 5, 5, 80, 40);
        outline.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        outline.setText("Outline Dimensions");
        outline.setOpaque(true);

        startFile = new GButton(window, 5, 80, 180, 20);
        startFile.setText("Choose Starting File (Optional)");
        startFile.addEventHandler(main, "setFileEvent");

        fileName = new GLabel(window, 5, 105, 180, 60);
        fileName.setTextAlign(GAlign.LEFT, GAlign.TOP);
        fileName.setText("No File Selected");
        fileName.setOpaque(true);

        widthEntry = new GTextField(window, 90, 5, 80, 20, G4P.SCROLLBARS_NONE);
        widthEntry.setText("Width");

        heightEntry = new GTextField(window, 90, 25, 80, 20, G4P.SCROLLBARS_NONE);
        heightEntry.setText("Height");

        firstThickness = new GTextField(window, 175, 5, 80, 20, G4P.SCROLLBARS_NONE);
        firstThickness.setText("Track Width");

        unit = new GLabel(window, 175, 30, 100, 30);
        unit.setTextAlign(GAlign.LEFT, GAlign.TOP);
        unit.setText("Units: Thousandth Inch");
        unit.setOpaque(true);

        create = new GButton(window, 5, 170, 50, 20);
        create.setText("Create");
        create.addEventHandler(main, "submitNF");

        create = new GButton(window, 65, 170, 50, 20);
        create.setText("Cancel");
        create.addEventHandler(main, "cancelNF");

        window.setVisible(false);
    }

    void reset() {
        widthEntry.setText("Width");
        heightEntry.setText("Height");
        check.setSelected(false);
        initFile = null;
        fileName.setText("No File Selected");
        window.setVisible(false);
    }
}

public void setFileEvent(GButton button, GEvent event) {
    selectOutput("Select File To Save To", "setFile");
}

void setFile(File f) {
    nfWin.initFile = f;
    try {
        nfWin.fileName.setText(f.getCanonicalPath());
    } 
    catch (IOException e) {
    }
}

void submitNF(GButton b, GEvent e) {
    if (nfWin.initFile != null && nfWin.check.isSelected()) {
        int w = int(nfWin.widthEntry.getText()), h = int(nfWin.heightEntry.getText());
        if (w > 0 && h > 0)
            makeNewFile(w, h, nfWin.initFile);
        else
            makeNewFile(nfWin.initFile);
    } else if (nfWin.initFile != null) {
        makeNewFile(nfWin.initFile);
    } else if (nfWin.check.isSelected()) {
        int w = int(nfWin.widthEntry.getText()), h = int(nfWin.heightEntry.getText());
        if (w > 0 && h > 0)
            makeNewFile(w, h);
        else
            makeNewFile();
    } else makeNewFile();
}

void cancelNF(GButton b, GEvent e) {
    nfWin.reset();
}

//======================================================================================
//======================================================================================
//======================================================================================

class createTextDialogue {
    GWindow window;
    createTextDialogue() {
        window = GWindow.getWindow(main, "Add Text", 0, 0, 400, 200, JAVA2D);

        window.setVisible(false);
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

class chooseComponentDialogue {
    GWindow window;
    chooseComponentDialogue() {
        window = GWindow.getWindow(main, "Add Component", 0, 0, 400, 200, JAVA2D);

        window.setVisible(false);
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

class layerOptionsDialogue {
    GWindow window;
    GCheckbox check;
    GImageButton hsbc;
    GImageButton vc;
    File initFile;

    int s = 100;

    layerOptionsDialogue() {
        window = GWindow.getWindow(main, "Layer Options", 0, 0, 400, 200, JAVA2D);
        //check = new GCheckbox(window, 200, 150, 120, 20);
        //check.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
        //check.setText("Is Visible");
        //check.setOpaque(false);
        window.setVisible(false);
    }

    void submit(GEvent e) {
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

class deleteLayerDialogue {
    GWindow window;
    GButton y, n;
    GLabel info;

    deleteLayerDialogue() {
        window = GWindow.getWindow(main, "Delete Layer", 0, 0, 200, 120, JAVA2D);
        window.setActionOnClose(G4P.KEEP_OPEN);

        info = new GLabel(window, 10, 10, 180, 60);
        info.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        info.setText("Are you sure you want to delete the current layer. You will not be able to get it back.");
        info.setOpaque(true);

        y = new GButton(window, 10, 80, 80, 20);
        y.setText("Yes");
        y.addEventHandler(main, "dlSubmit");

        n = new GButton(window, 110, 80, 80, 20);
        n.setText("No");
        n.addEventHandler(main, "dlSubmit");

        window.setVisible(false);
    }
}

void dlSubmit(GButton b, GEvent e) {
    if (b == dLayer.y) {
        int i = layers.indexOf(curLayer);
        layers.remove(curLayer);
        curLayer = layers.get(i);
    }

    dLayer.window.setVisible(false);
}

//======================================================================================
//======================================================================================
//======================================================================================

class chooseColorDialogue extends PApplet {
    color c, c2, c3;
    color[] colors;
    int index = -1, changeIndex = 0;
    boolean isRunning;

    chooseColorDialogue() {
        c = color(255);
        c2 = color(0);
        c3 = color(127);

        colors = new color[20];

        int x = 0;
        for (int i = 0; i <= 255; i+= 255) {
            for (int j = 0; j <= 255; j+= 255) {
                for (int k = 0; k <= 255; k += 255) {
                    color f = color(k, j, i);
                    if (f == c) continue;
                    colors[x] = f;
                    x++;
                }
            }
        }





        for (int i = 0; i <= 127; i+= 127) {
            for (int j = 0; j <= 127; j+= 127) {
                for (int k = 0; k <= 127; k += 127) {
                    color f = color(k, j, i);
                    if (f == c2) continue;
                    colors[x] = f;
                    x++;
                }
            }
        }

        for (int i = 127; i <= 255; i+= 128) {
            for (int j = 127; j <= 255; j+= 128) {
                for (int k = 127; k <= 255; k += 128) {
                    color f = color(k, j, i);
                    if (f == c3 || f == c) continue;
                    colors[x] = f;
                    x++;
                }
            }
        }
        
        run();
        isRunning = true;
    }

    void settings() {
        size(230, 200);
    }
    

    void setup() {
        surface.setTitle("Choose Color");
        surface.setVisible(false);
    }

    void draw() {
        background(255);
        rectMode(CENTER);
        strokeWeight(5);
        for (int i = 0; i < colors.length; i++) {
            fill(colors[i]);
            stroke(0);
            if (index == i) stroke(100, 200, 100);
            if (curLayer.colorIndex == i) stroke(255, 200, 100);
            rect(35 + 40*(i%5), 25 + 40*(i/5), 30, 30);
        }
        
        rectMode(CORNER);
        strokeWeight(2);
        fill((overButton() == 1)?color(100,200,100):255);
        rect(20,170,70,20);
        fill((overButton() == 2)?color(100,200,100):255);
        rect(100,170,70,20);
        textAlign(CENTER);
        fill(0);
        text("Accept", 20, 172, 70, 20);
        text("Cancel", 100, 172, 70, 20);
    }
    
    void run(){
        PApplet.runSketch(new String[]{"Choose Color"}, this);
    }
    
    void exit(){
        isRunning = false;
    }

    void mousePressed(MouseEvent e) {
        for (int i = 0; i < colors.length; i++) {
            int x = 35 + 40*(i%5);
            int y = 25 + 40*(i/5);
            if (mouseX >= x - 15 && mouseX <= x + 15) {
                if (mouseY >= y - 15 && mouseY <= y + 15) {
                    index = i;
                }
            }
        }
        
        if(overButton() != 0) finish();
        
    }

    void finish() {
        if (overButton() == 1) { 
            if(index != -1)
                layers.get(changeIndex).setColor(index);
        }
        surface.setVisible(false);
        index = -1;
        changeIndex = 0;
    }
    
    int overButton(){
        if(mouseX >= 20 && mouseX <= 90) if(mouseY >= 170 && mouseY <= 190) return 1;
        if(mouseX >= 100 && mouseX <= 170) if(mouseY >= 170 && mouseY <= 190) return 2;
        return 0;
    }
}
