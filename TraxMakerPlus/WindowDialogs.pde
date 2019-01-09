PApplet main = this;
GWindow window;

void setDialogue(int x) {
    window.setVisible(false);
    println("X:", x);
    if (x != 0) { 
        nfWin.cleanupWin();
        println("Clean: New File");
    }
    if (x != 1) { 
        cText.cleanupWin();
        println("Clean: Text");
    }
    if (x != 2) { 
        cComp.cleanupWin();
        println("Clean: Comp");
    }
    if (x != 3) { 
        lOptions.cleanupWin();
        println("Clean: Layer Options");
    }
    if (x != 4) { 
        dLayer.cleanupWin();
        println("Clean: Delete Layer");
    }
    if (x != 5) { 
        ccD.getSurface().setVisible(false);
        println("Clean: Colors");
    }
    if (x == -1) { 
        window.setVisible(false); 
        println("Clean: Full");
        return;
    }

    

    if (x == 0) { //New File Window
        nfWin.setupWin();
        println("New File");
    } else if (x == 1) { //Create Text
        cText.setupWin();
        println("Text");
    } else if (x == 2) { //Add Component
        cComp.setupWin();
        println("Comp");
    } else if (x == 3) { //Edit Layer
        lOptions.setupWin();
        println("Edit Layer");
    } else if (x == 4) { //Delete Layer
        dLayer.setupWin();
        println("Delete Layer");
    } else if (x == 5) { //Choose Color
        if (ccD.isRunning == false) ccD.run();
        else ccD.setVisible(true);
        ccD.changeIndex = (height - 86 - mouseY + managerScrolled)/20;
        return;
    }

    window.setVisible(true);
}

//======================================================================================
//======================================================================================
//======================================================================================

class newFileDialogue {
    GTextField widthEntry, heightEntry, firstThickness;
    GLabel outline, fileName, unit;
    GButton startFile, create, cancel;
    GCheckbox check;

    File initFile;

    newFileDialogue() {
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

        cancel = new GButton(window, 65, 170, 50, 20);
        cancel.setText("Cancel");
        cancel.addEventHandler(main, "cancelNF");
    }

    void setupWin() {
        window.getSurface().setSize(300, 200);
        widthEntry.setVisible(true);
        heightEntry.setVisible(true);
        firstThickness.setVisible(true);
        outline.setVisible(true);
        fileName.setVisible(true);
        unit.setVisible(true);
        startFile.setVisible(true);
        create.setVisible(true);
        cancel.setVisible(true);
        check.setVisible(true);
    }

    void cleanupWin() {
        widthEntry.setVisible(false);
        heightEntry.setVisible(false);
        firstThickness.setVisible(false);
        outline.setVisible(false);
        fileName.setVisible(false);
        unit.setVisible(false);
        startFile.setVisible(false);
        create.setVisible(false);
        cancel.setVisible(false);
        check.setVisible(false);

        widthEntry.setText("Width");
        heightEntry.setText("Height");
        check.setSelected(false);
        initFile = null;
        fileName.setText("No File Selected");
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
    setDialogue(-1);
    
}

void cancelNF(GButton b, GEvent e) {
    setDialogue(-1);
}

//======================================================================================
//======================================================================================
//======================================================================================

class createTextDialogue {
    createTextDialogue() {
    }

    void setupWin() {
    }

    void cleanupWin() {
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

class chooseComponentDialogue {
    chooseComponentDialogue() {
    }

    void setupWin() {
    }

    void cleanupWin() {
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

class layerOptionsDialogue {
    GCheckbox check;
    GTextField name;
    GButton accept, cancel;
    int changeIndex = 0;

    layerOptionsDialogue() {

        check = new GCheckbox(window, 5, 10, 120, 20);
        check.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
        check.setText("Is Visible");
        check.setOpaque(true);

        name = new GTextField(window, 5, 35, 150, 20);
        name.setText(layers.get(changeIndex).name);

        accept = new GButton(window, 5, 60, 60, 20);
        accept.setText("Accept");
        accept.addEventHandler(main, "submitLO");

        cancel = new GButton(window, 70, 60, 60, 20);
        cancel.setText("Cancel");
        cancel.addEventHandler(this, "submitLO");
    }

    void setupWin() {
        window.getSurface().setSize(200, 119);
        
        if (isInManager())
            changeIndex = (height - 86 - mouseY + managerScrolled)/20;
        else
            changeIndex = layers.indexOf(curLayer);
        check.setSelected(curLayer.isVisible);
        name.setText(layers.get(lOptions.changeIndex).name);
        
        check.setVisible(true);
        name.setVisible(true);
        accept.setVisible(true);
        cancel.setVisible(true);
        
    }

    void cleanupWin() {
        check.setVisible(false);
        name.setVisible(false);
        accept.setVisible(false);
        cancel.setVisible(false);
        println("LOPTIONS:", check.isVisible(), name.isVisible(), accept.isVisible(), cancel.isVisible());
        lOptions.changeIndex = -1;
    }
}

void submitLO(GButton b, GEvent e) {
    if (b == lOptions.accept) {
        Layer l = layers.get(lOptions.changeIndex);
        l.name = lOptions.name.getText();
        l.isVisible = lOptions.check.isSelected();
    }

    setDialogue(-1);
}

//======================================================================================
//======================================================================================
//======================================================================================

class deleteLayerDialogue {
    GButton y, n;
    GLabel info;

    deleteLayerDialogue() {

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
    }

    void setupWin() {
        window.getSurface().setSize(200, 120);
        info.setVisible(true);
        y.setVisible(true);
        n.setVisible(true);
    }

    void cleanupWin() {
        info.setVisible(false);
        y.setVisible(false);
        n.setVisible(false);
    }
}

void dlSubmit(GButton b, GEvent e) {
    if (b == dLayer.y) {
        int i = layers.indexOf(curLayer);
        layers.remove(curLayer);
        curLayer = layers.get(min(i, layers.size() - 1 ));
    }
    
    setDialogue(-1);
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
        fill((overButton() == 1)?color(100, 200, 100):255);
        rect(20, 170, 70, 20);
        fill((overButton() == 2)?color(100, 200, 100):255);
        rect(100, 170, 70, 20);
        textAlign(CENTER);
        fill(0);
        text("Accept", 20, 172, 70, 20);
        text("Cancel", 100, 172, 70, 20);
    }

    void setVisible(boolean b) {
        surface.setVisible(b);
    }

    void run() {
        PApplet.runSketch(new String[]{"Choose Color"}, this);
    }

    void exit() {
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

        if (overButton() != 0) finish();
    }

    void finish() {
        if (overButton() == 1) { 
            if (index != -1)
                layers.get(changeIndex).setColor(index);
        }
        surface.setVisible(false);
        index = -1;
        changeIndex = 0;
    }

    int overButton() {
        if (mouseX >= 20 && mouseX <= 90) if (mouseY >= 170 && mouseY <= 190) return 1;
        if (mouseX >= 100 && mouseX <= 170) if (mouseY >= 170 && mouseY <= 190) return 2;
        return 0;
    }
}
