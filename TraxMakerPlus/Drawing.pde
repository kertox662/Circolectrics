PImage visibleIcon, invisibleIcon;
PImage NLIcon, DLIcon, ELIcon;
PImage NLHighlight, DLHighlight, ELHighlight;
int NLFrames, DLFrames, ELFrames;

void updateView() {
    if (movePressed[0]) {
        curView.y += max(2, panSpeed);
    }
    if (movePressed[1]) {
        curView.x += max(2, panSpeed);
    }
    if (movePressed[2]) {
        curView.y -= max(2, panSpeed);
    }
    if (movePressed[3]) {
        curView.x -= max(2, panSpeed);
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawReferencePoints() { //Draws points to signify each inch
    int minX, minY;
    stroke(150);
    strokeWeight(4/viewScale);
    if (curView.x >= 0) {
        minX = 0;
        while (minX < curView.x/viewScale)
            minX += 1000;
    } else {
        minX = 0;
        while (minX > curView.x/viewScale)
            minX -= 1000;
    }

    if (curView.y >= 0) {
        minY = 0;
        while (minY < curView.y/viewScale)
            minY += 1000;
    } else {
        minY = 0;
        while (minY > curView.y/viewScale)
            minY -= 1000;
    }

    //println(minY, minX, curView);

    minX *= -1;
    minY *= -1;

    for (int x = minX; x < (width - curView.x) / viewScale; x += 1000)
        for (int y = minY; y < (height - curView.y)/viewScale; y += 1000)
            point(x, y);
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawLayers() {
    for (int i = 0; i < layers.size(); i++) {
        try {
            if (layers.get(i).isVisible) {
                layers.get(i).drawTracks();
                layers.get(i).drawComponents();
            }
        } 
        catch(IndexOutOfBoundsException e) {
            e.printStackTrace();
        }
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

void updateSelected() {
}

void updatePlacing() {
    if (placingTrack == null) return;
    LineSegment p = (LineSegment)placingTrack;
    //p.points[1].set(mouseX*viewScale + curView.x, mouseY * viewScale + curView.y );
    PVector m = getRelativeMouse();
    p.points[1].set(m.x, m.y);

    PVector ps = new PVector();

    if (AngleSnap.curSnap == AngleSnap.Perpendicular) {
        if (abs(p.points[0].x - m.x) >= abs(p.points[0].y - m.y)) {
            ps.set(m.x, p.points[0].y);
        } else {
            ps.set(p.points[0].x, m.y);
        }

        snapPoint = null;
    } else ps = null;

    PVector psT = (Snap.curSnap == Snap.Perpendicular)? findSnapPoint(p.points[0]):findSnapPoint(m);
    if (psT != null)
        ps = psT;

    snapPoint = ps;


    if (ps != null) {
        p.points[1] = ps;
    }
}

void drawSnapPoint(PVector p) {
    rectMode(CENTER);
    noFill();
    strokeWeight(4/viewScale);
    stroke(0, 255, 0);
    pushMatrix();
    translate(p.x, p.y);
    rotate(QUARTER_PI);
    rect(0, 0, 10/viewScale, 10/viewScale);
    popMatrix();
    rectMode(CORNER);
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawBorders() {
    fill(255);
    stroke(0);
    //rect(0,0,width,60);
}

void drawIcons() {
    drawBoxUnder(0, 70, 80, 10 + 60*Tool.toolName.length);
    fill(0, 70);
    textSize(36);
    pushMatrix();
    translate(45, 85 + 60*Tool.toolName.length/2);
    rotate(-HALF_PI);
    text("Tools", 0, 0);
    popMatrix();
    //ellipse(30,100,50,50);
    for (int i = 0; i < icons.length; i++) {
        image(icons[i], iconOffset[i], 100 + i*60);
        if (dist(mouseX, mouseY, iconOffset[i], 100 + i*60) <= 25) {
            if (Tool.curTool.ordinal() != i)
                image(highlightTool, iconOffset[i], 100 + i*60);
            fill(0);
            textSize(8);
            text(Tool.toolName[i], iconOffset[i], 133 + i*60);
        }
        fill(0);
        textSize(8);
        if (Tool.curTool.ordinal() == i)
            text(Tool.toolName[i], iconOffset[i], 133 + i*60);
    }

    image(selectedTool, iconOffset[Tool.curTool.ordinal()], 100 + 60 * Tool.curTool.ordinal());
}

boolean isInToolBox() {
    return (mouseX <= 80 && mouseY >= 70 && mouseY <= 80 + 60*Tool.toolName.length);
}

//======================================================================================
//======================================================================================
//======================================================================================

void updateOffset() {
    int j = Tool.toolName.length + 1;
    if (isInToolBox() && focused && isInsideScreen()) {
        j = int(mouseY - 70) / 60;
    }

    for (int i = 0; i < Tool.toolName.length; i++)
        iconOffset[i] = (i == j || i == Tool.curTool.ordinal())? min(maxIconOffset, iconOffset[i] + offsetIncSpeed): max(minIconOffset, iconOffset[i] - offsetIncSpeed);
}


//======================================================================================
//======================================================================================
//======================================================================================

void drawSnap() {
    drawBoxUnder(width - 160, height - 80, 160, 80);
    image(AngleSnap.icons[AngleSnap.curSnap.ordinal()], width - 40, height - 50);
    textSize(10);
    textLeading(10);
    fill(70);
    text("Angle Snap:\n" + AngleSnap.options[AngleSnap.curSnap.ordinal()], width - 40, height - 15);

    image(snapIcon, width - 110, height - 50);
    text("Track Snap:\n" + Snap.options[Snap.curSnap.ordinal()], width - 110, height - 15);

    if (isInSnapBox()) {
        if (dist(mouseX, mouseY, width - 40, height - 50) <= 25)
            image(highlightTool, width - 40, height - 50);
        else if (dist(mouseX, mouseY, width - 110, height - 50) <= 25) 
            image(highlightTool, width - 110, height - 50);
    }
}
boolean isInSnapBox() {
    return (mouseX >= width - 160 && mouseY >= height - 80);
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawFileIcon() {
    drawBoxUnder(width - 200, 0, 200, 70);
    for (int i = 0; i < 3; i++) {
        PVector p = fileIconLoc[i];
        if (mouseX >= width - 185 + 60*i && mouseX <= width - 135 + 60*i && isInFileBox())
            p.y = min(p.y + offsetIncSpeed, maxFileOffset);
        else
            p.y = max(p.y - offsetIncSpeed, minFileOffset);

        fill(0, 25);
        textSize(36);
        text("File", width - 100, 50);

        image(fileIcons[i], p.x, p.y);
        if (dist(mouseX, mouseY, p.x, p.y) <= 25) {
            image(highlightTool, p.x, p.y);
            textSize(10);
            fill(70);
            text(fileIconNames[i], p.x, p.y + 35);
        }
    }
}

boolean isInFileBox() {
    return (mouseX >= width - 200 && mouseY <= 70);
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawBoxUnder(float x, float y, float w, float h) {
    fill(170);
    stroke(127);
    strokeWeight(3);
    rect(x, y, w, h);
}

void drawInfo() {
    textAlign(LEFT);
    fill(0);
    textSize(12);
    text("X:" + str(round((mouseX - curView.x)/viewScale)) + " Y:" + str(round((mouseY - curView.y) / viewScale)), 5, 52);
    text("Scale: " + str(roundAny(viewScale * 100, 1) ) + "%", 5, 65);
    text("Framerate: " + str(roundAny(frameRate, 2)), 5, 39);
    textAlign(CENTER);
}

//======================================================================================
//======================================================================================
//======================================================================================

boolean isInsideScreen() {
    Point mouse = MouseInfo.getPointerInfo().getLocation();
    PSurface s = getSurface();
    Point win = getJFrame(s).getLocation();
    int x = mouse.x-win.x, y = mouse.y - win.y;
    if (x >= 0 && width >= x && y >= 0 && height >= y)
        return true;
    return false;
}

//======================================================================================
//======================================================================================
//======================================================================================

void fitBoardToView() {
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
    } else {
        Text t = l0.texts.get(0);
        xMin = t.base.x;
        xMax = t.base.x;
        yMin = t.base.y;
        yMax = t.base.y;
    }

    //println("Starting:", xMin, xMax, yMin, yMax);

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
        }
        for (int k = 0; k < l.texts.size(); k++) {
            Text t = l.texts.get(i);
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
    viewScale = min(zoomMax, max(zoomMin, min((width - 240) / dX, (height - 150) / dY)));
    curView.set(-xMin * viewScale + 80, -yMin * viewScale + 70);

    if ((width - 240) / dX < (height - 150) / dY) {
        float dif = (height - 150) - dY * viewScale;
        curView.y += dif/2;
    } else {
        float dif = (width - 240) - dX * viewScale;
        curView.x += dif/2;
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawLayerManager() {
    stroke(127);
    strokeWeight(3);
    fill(230);
    rect(width - 160, 72, 160, height - 154);
    
    fill(180);
    textSize(36);
    pushMatrix();
    translate(width - 85, 70 + (height - 150) / 2);
    rotate(HALF_PI);
    text("Layers", 0, 0);
    popMatrix();
    
    
    textSize(16);
    fill(0);
    textAlign(LEFT);
    rectMode(CENTER);
    //for(int i = 92; i <= height - 96; i+= 20){
    //    text(str(i), width - 80, i);
    //}
    maxAmount = (height - 168) / 20;
    if (layers.size() > maxAmount) {
        for (int i = 0; i < layers.size(); i++) {
            float y = height - 96  - i * 20 + managerScrolled;
            if (y <= height - 96 && y >= 92) {
                if (layers.get(i) == curLayer) {
                    rectMode(CORNER);
                    noStroke();
                    fill(200);
                    //println(width - 158, y - 4);
                    rect(width - 158, y - 14, 160, 20);
                }
                rectMode(CENTER);
                image((layers.get(i).isVisible)?visibleIcon:invisibleIcon, width - 125, y-4);
                fill(0);
                text(layers.get(i).name, width-115, y);
                fill(ccD.colors[layers.get(i).colorIndex]);
                stroke(5);
                rect(width - 145, y - 5, 16, 16);
            }
        }
    } else {
        int x = 0;
        for (int i = height - 96; i >= 92 && x < layers.size(); i-=20) {
            if (layers.get(x) == curLayer) {
                rectMode(CORNER);
                noStroke();
                fill(200);
                rect(width - 158, i - 14, 160, 20);
            }
            rectMode(CENTER);
            image((layers.get(x).isVisible)?visibleIcon:invisibleIcon, width - 125, i-4);
            fill(0);
            text(layers.get(x).name, width-115, i);
            fill(ccD.colors[layers.get(x).colorIndex]);
            stroke(5);
            rect(width - 145, i - 5, 16, 16);
            x++;
        }
    }
    
    fill(0);
    if(moveToInd - movingLayerInd  > 1 || moveToInd - movingLayerInd  < 0){
        line(width - 150, height - 90 - 20*moveToInd, width, height - 90 - 20*moveToInd);
    }

    textAlign(CENTER);
    rectMode(CORNER);

    fill(180);
    stroke(127);
    rect(width - 160, 72, 160, 50);
    fill(0);
    textSize(10);
    textLeading(10);

    if (NLFrames > 0) {
        image(NLHighlight, width - 130, 88);
        NLFrames--;
    } else
        image(NLIcon, width - 130, 88);
    text("Add\nLayer", width - 130, 107);


    if (ELFrames > 0) {
        image(ELHighlight, width - 80, 88);
        ELFrames--;
    } else
        image(ELIcon, width - 80, 88);
    text("Edit\nLayer", width - 80, 107);


    if (DLFrames > 0) {
        image(DLHighlight, width - 30, 88);
        DLFrames--;
    } else
        image(DLIcon, width - 30, 88);
    text("Delete\nLayer", width - 30, 107);
}

boolean isInManager() {
    return (mouseX >= width - 160 && mouseY >= 122 && mouseY <= height - 82);
}

boolean isInLayerTab() {
    return (mouseX >= width - 160 && mouseY >= 72 && mouseY <= 122);
}

boolean isInViewport() {
    return (!(isInToolBox() || isInSnapBox() || isInFileBox() || isInManager() || isInLayerTab()));
}

void defineViewPortSize() {
    viewPortMin.set( -curView.x/viewScale, -curView.y/viewScale);
    viewPortMax.set((width - curView.x)/viewScale, (height - curView.y) / viewScale);
}
