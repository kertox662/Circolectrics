PApplet main = this;
GWindow window;
PSurface dialogueSurface;

void setDialogue(int x) {
    window.setVisible(false);
    if (x != 0) { 
        nfWin.cleanupWin();
    }
    if (x != 1) { 
        cText.cleanupWin();
    }
    if (x != 2) { 
        cComp.cleanupWin();
    }
    if (x != 3) { 
        lOptions.cleanupWin();
    }
    if (x != 4) { 
        dLayer.cleanupWin();
    }
    if (x != 5) { 
        ccD.getSurface().setVisible(false);
    }
    if (x != 6) {
        sD.cleanupWin();
    }
    if (x == -1) { 
        window.setVisible(false);
        return;
    }


    if (x == 0) { //New File Window
        nfWin.setupWin();
    } else if (x == 1) { //Create Text
        cText.setupWin();
    } else if (x == 2) { //Add Component
        cComp.setupWin();
        return;
    } else if (x == 3) { //Edit Layer
        lOptions.setupWin();
    } else if (x == 4) { //Delete Layer
        dLayer.setupWin();
    } else if (x == 5) { //Choose Color
        if (ccD.isRunning == false) ccD.run();
        else ccD.setVisible(true);
        ccD.changeIndex = min((height - 86 - mouseY + managerScrolled)/20, layers.size() - 1 );
        return;
    } else if (x == 6) {
        sD.setupWin();
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
        dialogueSurface.setSize(300, 200);
        dialogueSurface.setTitle("New File");
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
        firstThickness.setText("Track Width");
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
    GTextField text, size;
    GButton accept, cancel;
    GLabel textL, sizeL;

    createTextDialogue() {
        textL = new GLabel(window, 5, 10, 80, 20);
        textL.setText("Display Text");
        textL.setOpaque(true);
        sizeL = new GLabel(window, 95, 10, 80, 20);
        sizeL.setText("Font Size");
        sizeL.setOpaque(true);

        text =  new GTextField(window, 5, 35, 80, 20, G4P.SCROLLBARS_NONE);
        text.addEventHandler(main, "updateEditTextC");
        size = new GTextField(window, 95, 35, 80, 20, G4P.SCROLLBARS_NONE);
        size.addEventHandler(main, "updateEditSizeC");

        accept = new GButton(window, 5, 70, 50, 20);
        accept.setText("Accept");
        accept.addEventHandler(main, "submitText");
        cancel = new GButton(window, 60, 70, 50, 20);
        cancel.setText("Cancel");
        cancel.addEventHandler(main, "submitText");
    }

    void setupWin() {
        dialogueSurface.setSize(200, 100);
        dialogueSurface.setTitle("Create Text");

        text.setText(editText.text);
        size.setText(str(editText.fontSize));

        text.setVisible(true);
        size.setVisible(true);
        accept.setVisible(true);
        cancel.setVisible(true);
        textL.setVisible(true);
        sizeL.setVisible(true);
    }

    void cleanupWin() {
        text.setVisible(false);
        size.setVisible(false);
        accept.setVisible(false);
        cancel.setVisible(false);
        textL.setVisible(false);
        sizeL.setVisible(false);
    }
}

void submitText(GButton b, GEvent e) {
    if (b != cText.accept) {
        curLayer.texts.remove(editText);
    }
    editText = null;
    placingText = null;
    setDialogue(-1);
}

void updateEditTextC(GTextField s, GEvent e) {
    editText.setText(s.getText());
}

void updateEditSizeC(GTextField s, GEvent e) {
    float size = float(s.getText());
    if (!Float.isNaN(size))
    editText.setSize(int(size));
}

//======================================================================================
//======================================================================================
//======================================================================================

class chooseComponentDialogue extends PApplet {
    boolean isRunning;
    int chosenIndex = 0, imageIndex = 0;
    float scale = 1;

    chooseComponentDialogue() {
        run();
        isRunning = true;
    }

    void settings() {
        size(400, 600);
    }


    void setup() {
        surface.setTitle("Choose Component");
        surface.setVisible(false);
        imageMode(CENTER);
        changeScale();
    }

    void draw() {
        //if (focused == true) {
        background(210);
        strokeWeight(2);
        stroke(0);
        fill((overButton() == 1)?color(100, 200, 100):255);
        rect(20, 570, 70, 20);
        fill((overButton() == 2)?color(100, 200, 100):255);
        rect(100, 570, 70, 20);
        drawBoxes();
        drawComponentNames();
        drawImageNames();
        previewComp();

        textAlign(CENTER);
        fill(0);
        text("Accept", 20, 572, 70, 20);
        text("Cancel", 100, 572, 70, 20);
        //} else{
        //    setVisible(false);
        //}
    }

    void drawComponentNames() {
        textAlign(LEFT);
        for (int i = 0; i < masterComponents.length; i++) {
            if (i == chosenIndex) {
                fill(180);
                noStroke();
                rect(9, 30 + i*20, 173, 20);
            }
            fill(0);
            stroke(0);
            text("COMPONENT TYPE", 10, 22);
            text((showOfficialNames)?masterComponents[i].officialName:masterComponents[i].name, 10, 42 + i*20);
        }
    }

    void drawImageNames() {
        textAlign(LEFT);
        for (int i = 0; i < masterComponents[chosenIndex].imageNames.length; i++) {
            if (i == imageIndex) {
                fill(180);
                noStroke();
                rect(194, 435 + i*20, 194, 20);
            }
            fill(0);
            stroke(0);
            text("COMPONENT IMAGE", 195, 430);
            text(masterComponents[chosenIndex].imageNames[i], 195, 450 + i*20);
        }
    }

    void changeComponentIndex() {
        int newInd = (mouseY - 30) / 20;
        if (!(newInd >= masterComponents.length || newInd < 0)) { 
            chosenIndex = newInd;
            imageIndex = 0;
            changeScale();
        }
    }

    void changeImageIndex() {
        int newInd = (mouseY - 435) / 20;
        if (!(newInd >= masterComponents[chosenIndex].imageNames.length || newInd < 0)) { 
            imageIndex = newInd;
            changeScale();
        }
    }

    void changeScale() {
        Component c = masterComponents[chosenIndex];
        float xScale = 190.0 / c.w, yScale = 390.0 / c.h;
        //println(xScale, yScale);
        scale = (xScale > yScale)?yScale:xScale;
    }

    void previewComp() {
        pushMatrix();
        translate(290, 202);
        scale(scale);
        //println(scale);
        masterComponents[chosenIndex].displayPreview(imageIndex);
        popMatrix();
    }

    void polygon(float x, float y, float radius, int npoints) {
        float angle = TWO_PI / npoints;
        beginShape();
        for (float a = angle / 2; a < TWO_PI + angle; a += angle) {
            float sx = x + cos(a) * radius;
            float sy = y + sin(a) * radius;
            vertex(sx, sy);
        }
        endShape(CLOSE);
    }


    void drawBoxes() {
        fill(255);
        stroke(0);
        rect(5, 5, 180, 545);
        rect(190, 5, 200, 400);
        rect(190, 410, 200, 140);
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
        if (overButton() != 0) cleanupWin();
        if (isInNameBox()) changeComponentIndex();
        if (isInImageBox()) changeImageIndex();
    }

    void setupWin() {
        changeScale();
        surface.setVisible(true);
    }

    void cleanupWin() {
        if (overButton() == 1 && focused) {
            Component c = masterComponents[chosenIndex].copy();
            c.img = masterComponents[chosenIndex].possibleImages[imageIndex];
            c.imgInd = imageIndex;
            if (editComponent == null) {
                curLayer.components.add(c);
                placingComponent = c;
            } else {
                c.loc = editComponent.loc.copy();
                for (int i = 0; i < layers.size(); i++) {
                    Layer l = layers.get(i);
                    if (l.components.contains(editComponent)) {
                        l.components.remove(editComponent);
                        l.components.add(c);
                    }
                }
                selectedComponent.remove(editComponent);
                
            }
        }
        editComponent = null;
        surface.setVisible(false);
        chosenIndex = 0;
    }

    int overButton() {
        if (mouseX >= 20 && mouseX <= 90) if (mouseY >= 570 && mouseY <= 590) return 1;
        if (mouseX >= 100 && mouseX <= 170) if (mouseY >= 570 && mouseY <= 590) return 2;
        return 0;
    }

    boolean isInNameBox() {
        return (mouseX >= 5 && mouseX <= 185 && mouseY >= 5 && mouseY <= 550);
    }

    boolean isInImageBox() {
        return (mouseX >= 190 && mouseX <= 390 && mouseY >= 410 && mouseY <= 550);
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

class layerOptionsDialogue {
    GCheckbox check, trackTop, tintComp;
    GTextField name;
    GButton accept, cancel;
    GLabel thickInfo;
    GTextField thickness;
    int changeIndex = 0;

    layerOptionsDialogue() {

        check = new GCheckbox(window, 5, 85, 70, 20);
        check.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
        check.setText("Is Visible");
        check.setOpaque(true);

        trackTop = new GCheckbox(window, 80, 85, 125, 20);
        trackTop.setText("Draw Tracks on top");
        trackTop.setOpaque(true);

        tintComp = new GCheckbox(window, 5, 110, 110, 20);
        tintComp.setText("Tint components");
        tintComp.setOpaque(true);

        name = new GTextField(window, 5, 10, 150, 20);
        name.setText(layers.get(changeIndex).name);

        thickInfo = new GLabel(window, 5, 35, 100, 20);
        thickInfo.setText("Track Thickness");
        thickInfo.setOpaque(true);

        thickness = new GTextField(window, 5, 60, 100, 20);
        thickness.setText("0");

        accept = new GButton(window, 5, 135, 60, 20);
        accept.setText("Accept");
        accept.addEventHandler(main, "submitLO");

        cancel = new GButton(window, 70, 135, 60, 20);
        cancel.setText("Cancel");
        cancel.addEventHandler(main, "submitLO");
    }

    void setupWin() {
        dialogueSurface.setSize(210, 160);

        if (isInManager())
            changeIndex = (height - 86 - mouseY + managerScrolled)/20;
        else
            changeIndex = layers.indexOf(curLayer);

        check.setSelected(curLayer.isVisible);
        trackTop.setSelected(curLayer.drawTracksOnTop);
        tintComp.setSelected(curLayer.tintComponents);

        name.setText(layers.get(min(lOptions.changeIndex, layers.size() - 1)).name);
        thickness.setText(str(layers.get(min(lOptions.changeIndex, layers.size() - 1)).defaultThickness));

        check.setVisible(true);
        name.setVisible(true);
        accept.setVisible(true);
        cancel.setVisible(true);
        thickInfo.setVisible(true);
        thickness.setVisible(true);
        trackTop.setVisible(true);
        tintComp.setVisible(true);
    }

    void cleanupWin() {
        check.setVisible(false);
        name.setVisible(false);
        accept.setVisible(false);
        cancel.setVisible(false);
        thickInfo.setVisible(false);
        thickness.setVisible(false);
        trackTop.setVisible(false);
        tintComp.setVisible(false);
        lOptions.changeIndex = -1;
    }
}

void submitLO(GButton b, GEvent e) {
    if (b == lOptions.accept) {
        Layer l = layers.get(lOptions.changeIndex);
        l.name = lOptions.name.getText();
        l.isVisible = lOptions.check.isSelected();
        l.drawTracksOnTop = lOptions.trackTop.isSelected();
        l.tintComponents = lOptions.tintComp.isSelected();
        float t = float(lOptions.thickness.getText());
        if (!Float.isNaN(t))
            l.setThickness(t);
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
        dialogueSurface.setSize(200, 120);
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

        for (int j = 0; j < curLayer.tracks.size(); j++) {
            LineSegment ls = curLayer.tracks.get(j);
            selectedTrack.remove(ls);
        }
        for (int j = 0; j < curLayer.components.size(); j++) {
            Component c = curLayer.components.get(j);
            selectedComponent.remove(c);
        }
        for (int j = 0; j < curLayer.texts.size(); j++) {
            Text t = curLayer.texts.get(j);
            selectedText.remove(t);
        }


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
            if (curLayer.colorIndex == i) stroke(255, 200, 100);
            if (index == i) stroke(100, 200, 100);
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

//======================================================================================
//======================================================================================
//======================================================================================

class settingsDialogue {
    GTextField snapDistEntry, snapAngleEntry;
    GLabel snapDistLabel, snapAngleLabel, nameLabel, Title;
    GButton accept, cancel;
    GCheckbox names1, names2;

    File initFile;

    settingsDialogue() {
        names1 = new GCheckbox(window, 5, 75, 130, 40);
        names1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
        names1.setText("Use Circolectric Names");
        names1.setOpaque(true);
        names1.addEventHandler(main, "toggleNaming");

        names2 = new GCheckbox(window, 140, 75, 130, 40);
        names2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
        names2.setText("Use Official Names");
        names2.setOpaque(true);
        names2.addEventHandler(main, "toggleNaming");

        nameLabel = new GLabel(window, 5, 40, 80, 30);
        nameLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        nameLabel.setText("Component Naming");
        nameLabel.setOpaque(true);

        Title = new GLabel(window, 120, 5, 80, 20);
        Title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        Title.setText("Settings");
        Title.setOpaque(true);

        snapDistLabel = new GLabel(window, 5, 120, 150, 30);
        snapDistLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        snapDistLabel.setText("Snap Sensitivity (Pixels)");
        snapDistLabel.setOpaque(true);

        snapDistEntry = new GTextField(window, 5, 155, 80, 20, G4P.SCROLLBARS_NONE);

        snapAngleLabel = new GLabel(window, 160, 120, 135, 30);
        snapAngleLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        snapAngleLabel.setText("Snap Angle (Degrees)");
        snapAngleLabel.setOpaque(true);

        snapAngleEntry = new GTextField(window, 160, 155, 80, 20, G4P.SCROLLBARS_NONE);

        accept = new GButton(window, 5, 180, 50, 20);
        accept.setText("Accept");
        accept.addEventHandler(main, "submitSettings");

        cancel = new GButton(window, 65, 180, 50, 20);
        cancel.setText("Cancel");
        cancel.addEventHandler(main, "submitSettings");
    }

    void setupWin() {
        dialogueSurface.setSize(300, 210);
        dialogueSurface.setTitle("Settings");

        names1.setSelected(!showOfficialNames);
        names2.setSelected(showOfficialNames);
        snapDistEntry.setText(str(snapDist));
        snapAngleEntry.setText(str(snapAngle));

        names1.setVisible(true);
        names2.setVisible(true);
        snapDistEntry.setVisible(true);
        snapDistLabel.setVisible(true);
        snapAngleEntry.setVisible(true);
        snapAngleLabel.setVisible(true);
        Title.setVisible(true);
        nameLabel.setVisible(true);
        accept.setVisible(true);
        cancel.setVisible(true);
    }

    void cleanupWin() {
        names1.setVisible(false);
        names2.setVisible(false);
        snapDistEntry.setVisible(false);
        snapDistLabel.setVisible(false);
        snapAngleEntry.setVisible(false);
        snapAngleLabel.setVisible(false);
        Title.setVisible(false);
        nameLabel.setVisible(false);
        accept.setVisible(false);
        cancel.setVisible(false);
    }
}

void submitSettings(GButton b, GEvent e) {
    if (b == sD.accept) {
        showOfficialNames = sD.names2.isSelected();
        float temp = float(sD.snapDistEntry.getText());
        if (!Float.isNaN(temp)) snapDist = int(temp);
        temp = float(sD.snapAngleEntry.getText());
        if (!Float.isNaN(temp)) snapAngle = int(temp);
    }
    setDialogue(-1);
}

void toggleNaming(GCheckbox cb, GEvent e) {
    if (cb == sD.names1) {
        sD.names2.setSelected(!sD.names1.isSelected());
    } else {
        sD.names1.setSelected(!sD.names2.isSelected());
    }
}
