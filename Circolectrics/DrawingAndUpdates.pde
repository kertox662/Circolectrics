PImage visibleIcon, invisibleIcon;
PImage NLIcon, DLIcon, ELIcon;
PImage NLHighlight, DLHighlight, ELHighlight;
int NLFrames, DLFrames, ELFrames;

void updateView() {//Changes the curView to shift the position of the viewport.
    float factor = 30 / frameRate; //slower framerates will not affect the speed of panning

    if (movePressed[0]) {
        curView.y += panSpeed * factor;
    }
    if (movePressed[1]) {
        curView.x += panSpeed * factor;
    }
    if (movePressed[2]) {
        curView.y -= panSpeed * factor;
    }
    if (movePressed[3]) {
        curView.x -= panSpeed * factor;
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawReferencePoints() { //Draws points to signify each inch
    int minX, minY; //Starting points for the dots
    stroke(150);
    strokeWeight(4/viewScale); //Dots will always be the same size
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

    minX *= -1;//curView is negative values
    minY *= -1;

    for (int x = minX; x < (width - curView.x) / viewScale; x += 1000)
        for (int y = minY; y < (height - curView.y)/viewScale; y += 1000)
            point(x, y); //Draws points at every 1000 x and 1000 y
}

//======================================================================================
//======================================================================================
//======================================================================================

void drawLayers() { //Draws Tracks, Components, and text for each layer
    for (int i = 0; i < layers.size(); i++) {
        try {//In case the sizes get updated during drawing;
            Layer l = layers.get(i);
            if (l.isVisible) {
                if (!l.drawTracksOnTop)
                    l.drawTracks();
                l.drawComponents();
                if (l.drawTracksOnTop)
                    l.drawTracks();
                l.drawTexts();
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


void drawSelected() {
    stroke(255);
    try {
        for (int i = 0; i < selectedTrack.size(); i++) {
            selectedTrack.get(i).display();
        }
        for (int i = 0; i < selectedComponent.size(); i++) {
            selectedComponent.get(i).display(color(255), true);
        }
        for (int i = 0; i < selectedText.size(); i++) {
            selectedText.get(i).display(color(255));
        }
    } catch (Exception e){}
}

//======================================================================================
//======================================================================================
//======================================================================================

void updateSelected() {
}

void updatePlacingTrack() { //Updates the current track that is being placed
    if (placingTrack == null) return;
    LineSegment p = placingTrack;
    PVector m = getRelativeMouse();
    p.points[1].set(m.x, m.y); //Starts off by putting end to the mouse point

    PVector ps = new PVector();

    if (AngleSnap.curSnap == AngleSnap.Perpendicular) { //Only allow either x or y to be difference from the starting point
        if (abs(p.points[0].x - m.x) >= abs(p.points[0].y - m.y)) {
            ps.set(m.x, p.points[0].y);
        } else {
            ps.set(p.points[0].x, m.y);
        }

        snapPoint = null;
    } else if (AngleSnap.curSnap == AngleSnap.Angular) { //Allows only certain angles to starting point;
        float a = getClosestSnappedAngle(m, p.points[0]);
        float d = dist(m.x, m.y, p.points[0].x, p.points[0].y) * 2;
        int dir = (m.x - p.points[0].x > 0)?1:-1;
        PVector p2 = new PVector(p.points[0].x + d * cos(a) * dir, p.points[0].y + d * sin(a) * dir); //Makes a point in the distance at the closest angle
        LineSegment temp = new LineSegment(p.points[0].copy(), p2); //Temporary line segment at the angle
        ps = temp.intersect(m); //Intersects temporary line to get closest point

        //Draws possible angles
        for (int i = 0; i < 360; i+=snapAngle) {
            PVector t = p.points[0];
            float a2 = radians(i);
            PVector p3 = new PVector(t.x + (100/viewScale)*cos(a2), t.y + (100/viewScale)*sin(a2));
            LineSegment temp2 = new LineSegment(t, p3, 5 / viewScale);
            pushMatrix();
            stroke(0);
            translate(curView.x, curView.y);
            scale(viewScale);
            temp2.display();
            popMatrix();
        }
    } else ps = null;

    //Finds snapping point relative to the nearby line segments.
    PVector psT = (Snap.curSnap == Snap.Perpendicular)? findSnapPoint(p.points[0]):findSnapPoint(m);
    if (psT != null)
        ps = psT;

    snapPoint = ps;


    if (ps != null) {
        p.points[1] = ps;
    }
}



void updatePlacingText() {
    if (placingText == null) return;
    PVector mouse = getRelativeMouse();
    placingText.base.set(mouse.x, mouse.y);
}

void updatePlacingComp() {
    if (placingComponent != null) {
        PVector m = getRelativeMouse();
        Component pC = placingComponent;
        if (isInViewport())
            pC.loc = new PVector(m.x - pC.basePoints[0].x, m.y - pC.basePoints[0].y);
    }
}

void updatePlacing() {
    updatePlacingTrack();
    updatePlacingText();
    updatePlacingComp();
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
    textAlign(CENTER, CENTER);
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
            Component c = l0.components.get(k);
            for (int m = 0; m < c.basePoints.length; m++) {
                float x1 = c.loc.x + c.basePoints[m].x, y1 = c.loc.y + c.basePoints[m].y;
                if (x1 > xMax) xMax = x1;
                else if (x1 < xMin) xMin = x1;
                if (y1 > yMax) yMax = y1;
                else if (y1 < yMin) yMin = y1;
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
    if (moveToInd - movingLayerInd  > 1 || moveToInd - movingLayerInd  < 0) {
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


//======================================================================================
//======================================================================================
//======================================================================================

void drawSelectBox() {
    if (selectBoxStart != null && selectBoxEnd != null) {
        rectMode(CORNERS);
        PVector a = selectBoxStart, b = selectBoxEnd;
        noFill();
        stroke(0);
        strokeWeight(5/viewScale);
        pushMatrix();
        //scale(1/viewScale);
        rect(a.x, a.y, b.x, b.y);
        popMatrix();
        rectMode(CORNER);
    }
}
