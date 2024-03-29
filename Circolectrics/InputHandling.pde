void mousePressed(MouseEvent e) {
    if (mouseButton == LEFT) {
        setDialogue(-1);
        if (isInViewport()) { //If On Main Track
            if (Tool.curTool == Tool.Track) {//Track Tool
                if (placingTrack == null) { //
                    Snap tempSnap = Snap.curSnap;
                    Snap.curSnap = Snap.Closest;
                    PVector p0 = findSnapPoint(getRelativeMouse());
                    p0 = (p0 == null)? getRelativeMouse(): p0;
                    placingTrack = new LineSegment(p0, getRelativeMouse());
                    curLayer.addTrack(placingTrack);
                    Snap.curSnap = tempSnap;
                } else {
                    placingTrack = null;
                }
            } else if (Tool.curTool == Tool.Text) {
                if (placingText == null) {
                    PVector mouse = getRelativeMouse();
                    placingText = new Text("Text", 28, mouse);
                    curLayer.texts.add(placingText);
                } else {
                    editText = placingText;
                    placingText = null;
                    setDialogue(1);
                }
            } else if (Tool.curTool == Tool.Component) {
                if (placingComponent == null) {
                    setDialogue(2);
                } else {
                    //placingComponent = null;
                    //setDialogue(-1);
                    Component c = placingComponent.copy();
                    c.imgInd = placingComponent.imgInd;
                    curLayer.addComponent(c);
                }
            } else if (Tool.curTool == Tool.Select) {
                PVector m = getRelativeMouse();
                selectBoxStart = m.copy();
                for (int i = 0; i < layers.size(); i++) {
                    Layer l = layers.get(i);

                    if (!shiftDown) {
                        selectedText.clear();
                        selectedComponent.clear();
                        selectedTrack.clear();
                    }

                    for (int j = 0; j < l.texts.size(); j++) {
                        Text t = l.texts.get(j);
                        textSize(t.fontSize);
                        float wT = textWidth(t.text)/2;
                        if (m.x >= t.base.x - wT && m.x <= t.base.x + wT)
                            if (m.y >= t.base.y - t.fontSize/2 - (10/28) * t.fontSize && m.y <= t.base.y + t.fontSize/2 - (10/28) * t.fontSize) {
                                if (shiftDown) {
                                    if (selectedText.contains(t)) 
                                        selectedText.remove(t);
                                    else 
                                    selectedText.add(t);
                                } else {
                                    selectedText.clear();
                                    selectedComponent.clear();
                                    selectedTrack.clear();
                                    selectedText.add(t);
                                }
                            }
                    }

                    for (int j = 0; j < l.tracks.size(); j++) {
                        LineSegment ls = l.tracks.get(j);
                        if (ls.distToLine(m) <= ls.thickness/2) {      
                            if (shiftDown) {
                                if (selectedTrack.contains(ls)) selectedTrack.remove(ls);
                                else selectedTrack.add(ls);
                            } else {
                                selectedTrack.clear();
                                selectedComponent.clear();
                                selectedText.clear();
                                selectedTrack.add(ls);
                            }
                        }
                    }

                    for (int j = 0; j < l.components.size(); j++) {
                        Component c = l.components.get(j);
                        if (c.isInsideImage(m)) {
                            if (shiftDown) {
                                if (selectedComponent.contains(c)) selectedComponent.remove(c);
                                else selectedComponent.add(c);
                            } else {
                                selectedComponent.clear();
                                selectedTrack.clear();
                                selectedText.clear();
                                selectedComponent.add(c);
                            }
                        }
                    }
                }
            } else if (Tool.curTool == Tool.Move) {
                if (movingBase == null) {
                    PVector m = getRelativeMouse();
                    Snap tempSnap = Snap.curSnap;
                    Snap.curSnap = Snap.Closest;
                    PVector ps = findSnapPoint(m);
                    movingBase = ps;
                    Snap.curSnap = tempSnap;

                    for (int i = 0; i < selectedTrack.size(); i++) {
                        LineSegment ls = selectedTrack.get(i);
                        ls.revPoints[0] = ls.points[0].copy();
                        ls.revPoints[1] = ls.points[1].copy();
                    }

                    for (int i = 0; i < selectedComponent.size(); i++) {
                        Component c = selectedComponent.get(i);
                        c.revLoc = c.loc.copy();
                    }

                    for (int i = 0; i < selectedText.size(); i++) {
                        Text t = selectedText.get(i);
                        t.revBase = t.base.copy();
                    }
                } else {
                    movingBase = null;
                    for (int i = 0; i < selectedTrack.size(); i++) {
                        LineSegment ls = selectedTrack.get(i);
                        ls.revPoints[0] = null;
                        ls.revPoints[1] = null;
                    }

                    for (int i = 0; i < selectedComponent.size(); i++) {
                        Component c = selectedComponent.get(i);
                        c.revLoc = null;
                    }

                    for (int i = 0; i < selectedText.size(); i++) {
                        Text t = selectedText.get(i);
                        t.revBase = null;
                    }
                }
            }
        } else if (isInToolBox()) {
            resetElements();
            for (int i = 0; i < Tool.toolName.length; i++) {
                if (dist(mouseX, mouseY, iconOffset[i], 100 + i*60) <= 25) {
                    changeTool(Tool.values()[i]);
                }
            }
        } else if (isInSnapBox()) {
            resetElements();
            if (dist(mouseX, mouseY, width - 40, height - 50) <= 25)
                AngleSnap.nextSnap();
            else if (dist(mouseX, mouseY, width - 110, height - 50) <= 25) {
                Snap.nextSnap();
            }
        } else if (isInFileBox()) {
            resetElements();
            if (dist(mouseX, mouseY, fileIconLoc[1].x, fileIconLoc[1].y) <= 25) {
                setDialogue(0);
            } else if (dist(mouseX, mouseY, fileIconLoc[2].x, fileIconLoc[2].y) <= 25) {
                selectInput("Open File", "openFile");
            } else if (dist(mouseX, mouseY, fileIconLoc[3].x, fileIconLoc[3].y) <= 25) {
                selectOutput("Save File", "saveToFile");
            } else if (dist(mouseX, mouseY, fileIconLoc[0].x, fileIconLoc[0].y) <= 25) {
                outputImages();
            }
        } else if (isInManager()) {
            resetElements();


            int index = (height - 96 - mouseY + managerScrolled)/20;//, layerIndex = 0;
            //int indProgress = 0;
            //boolean layerClicked = false;

            //for(int i = 0; i < layers.size(); i++){
            //    Layer l = layers.get(i);
            //    if(l.showElements){

            //    } else{
            //        if(index - indProgress == 1){
            //            layerClicked = true;
            //            break;
            //        } else{
            //            layerIndex++;
            //            indProgress++;
            //        }
            //    }
            //}


            //int index = 0;
            movingLayerInd = index;
            moveToInd = (height - 86 - mouseY + managerScrolled)/20;
            if (index >= layers.size()) return;
            if (mouseX >= width - 115) {
                curLayer = layers.get(index);
            } else if (mouseX >= width - 135) {
                layers.get(index).toggleVisibility();
            } else if (mouseX >= width - 158) {
                setDialogue(5);
            }

            if (e.getCount() == 2) {
                setDialogue(3);
            }
        } else if (isInLayerTab()) {
            resetElements();
            if (dist(mouseX, mouseY, width - 130, 88) <= 20) {
                Layer l = new Layer(curLayer.defaultThickness);
                layers.add(l);
                curLayer = l;
                NLFrames = 3;
            } else if (dist(mouseX, mouseY, width - 80, 88) <= 20) {
                setDialogue(3);
                ELFrames = 3;
            } else if (dist(mouseX, mouseY, width - 30, 88) <= 20) {
                if (layers.size() > 1)
                    setDialogue(4);
                DLFrames = 3;
            }
        } else if(isInSettingsIcon()){
            setDialogue(6);
        }
    } else if (mouseButton == RIGHT) {
        if (placingTrack != null) {
            curLayer.tracks.remove(placingTrack);
            placingTrack = null;
        }

        if (placingComponent != null) {
            curLayer.components.remove(placingComponent);
            placingComponent = null;
        }
    }
}

void mouseClicked(MouseEvent e) {
    if (mouseButton == LEFT) {
        if (isInManager()) {
            if (e.getCount() == 2) { //If double click
                setDialogue(3);
            }
        } else if (isInViewport() && e.getCount() >= 2 && Tool.curTool == Tool.Select) {
            boolean foundClickedElement = false;
            PVector m = getRelativeMouse();
            for (int i = 0; i < selectedComponent.size() && !foundClickedElement; i++) {
                Component c = selectedComponent.get(i);
                if (c.isInsideImage(m)) {
                    editComponent = c;
                    setDialogue(2);
                    foundClickedElement = true;
                    break;
                }
            }

            for (int i = 0; i < selectedTrack.size() && !foundClickedElement; i++) {
                LineSegment ls = selectedTrack.get(i);
                if (ls.distToLine(m) <= ls.thickness/2) {
                    Tool.curTool = Tool.Track;
                    float d1 = dist(m, ls.points[0]), d2 = dist(m,ls.points[1]);
                    if(d1 < d2){
                        PVector temp = ls.points[0];
                        ls.points[0] = ls.points[1];
                        ls.points[1] = temp;
                    }
                    placingTrack = ls;
                    foundClickedElement = true;
                    break;
                }
            }

            for (int i = 0; i < selectedText.size() && !foundClickedElement; i++) {
                Text t = selectedText.get(i);
                textSize(t.fontSize);
                float wT = textWidth(t.text)/2;
                if (m.x >= t.base.x - wT && m.x <= t.base.x + wT)
                    if (m.y >= t.base.y - t.fontSize/2 - (10/28) * t.fontSize && m.y <= t.base.y + t.fontSize/2 - (10/28) * t.fontSize) {
                        editText = t;
                        setDialogue(1);
                        break;
                    }
            }
        }
    }
}

void mouseDragged() {
    if (isInViewport()) {
        if (mouseButton == CENTER) {
            curView.x += (mouseX - pmouseX);
            curView.y += (mouseY - pmouseY);
        } else if (Tool.curTool == Tool.Rotate) {
            for (int i = 0; i < selectedComponent.size(); i++) {
                selectedComponent.get(i).rotation += (mouseX - pmouseX)*0.02;
            }
        } else if (Tool.curTool == Tool.Select) {
            selectBoxEnd = getRelativeMouse();
        }
    } 
    if (isInManager()) {
        int index = (height - 86 - mouseY + managerScrolled)/20;
        moveToInd = min(index, layers.size());
    }
}

void mouseReleased(MouseEvent e) {
    if (mouseButton == LEFT) {
        selectBoxStart = null;
        selectBoxEnd = null;
    }
    if (layers.size() > 0) {
        if (moveToInd - movingLayerInd > 1) {
            layers.remove(curLayer);
            layers.add(moveToInd - 1, curLayer);
        } else if (moveToInd - movingLayerInd < 0) {
            layers.remove(curLayer);
            layers.add(moveToInd, curLayer);
        }
    }
    moveToInd = -1;
    movingLayerInd = -1;
}


//void mouseReleased() {}


void mouseWheel(MouseEvent e) {
    int count = e.getCount();
    if (!(isInToolBox() || isInSnapBox() || isInFileBox() || isInManager())) {
        float prevScale = viewScale;
        //viewScale = max(zoomMin, min(zoomMax, viewScale + count * ((invertedScroll)?0.03:-0.03)));
        //float scaleRatio = viewScale - prevScale;
        //float x = (mouseX - curView.x)/viewScale;
        //float y = (mouseY - curView.y) / viewScale;
        curView.x -= mouseX;
        curView.y -= mouseY;
        float delta = count < 0 ? 1.03: count > 0 ? 1.0/1.03 : 1.0;
        if (invertedScroll) delta = 1/delta;
        viewScale *= delta;
        viewScale = min(zoomMax, max(zoomMin, viewScale));
        delta = viewScale / prevScale;
        curView.x *= delta;
        curView.y *= delta;
        curView.x += mouseX;
        curView.y += mouseY;

        //curView.x -= mouseX*scaleRatio;
        //curView.x = x - mouseX * viewScale;
        //curView.y = y - mouseY * viewScale;
        //curView.y -= mouseY*scaleRatio;
    } else if ( isInManager()) {
        int numElements = 0;
        //for(int i = 0; i < layers.size(); i++){
        //    Layer l = layers.get(i);
        //    if(!l.showElements) continue;
        //    numElements += l.tracks.size();
        //    numElements += l.components.size();
        //    numElements += l.texts.size();
        //}
        managerScrolled  = max(0, min((layers.size() - maxAmount) * 20, managerScrolled - count*5));
    }
}

void keyPressed() {

    if (key == CODED) {
        switch(keyCode) {
        case UP:
            movePressed[0] = true;
            break;
        case LEFT:
            movePressed[1] = true;
            break;
        case DOWN:
            movePressed[2] = true;
            break;
        case RIGHT:
            movePressed[3] = true;
            break;
        case SHIFT:
            shiftDown = true;
            break;
        }
    } else {
        switch(key) {
            //case 'w':
            //case 'W':
            //    movePressed[0] = true;
            //    break;
            //case 'a':
            //case 'A':
            //    movePressed[1] = true;
            //    break;
            //case 's':
            //case 'S':
            //    movePressed[2] = true;
            //    break;
            //case 'd':
            //case 'D':
            //    movePressed[3] = true;
            //    break;
        case 'r':
        case 'R':
            changeTool(Tool.Rotate);
            break;
        case 'f':
        case 'F':
            changeTool(Tool.FitViewToBoard);
            break;
        case 'c':
        case 'C':
            Snap.nextSnap();
            break;
        case 'v':
        case 'V':
            AngleSnap.nextSnap();
            break;
        case '1':
            changeTool(Tool.Track);
            break;
        case '2':
            changeTool(Tool.Component);
            break;
        case '3':
            changeTool(Tool.Text);
            break;
        case BACKSPACE:
        case DELETE:
            deleteSelected();
            break;
        }
    }
}

//======================================================================================
//======================================================================================
//======================================================================================

void keyReleased() {
    if (key == CODED) {
        switch(keyCode) {
        case UP:
            movePressed[0] = false;
            break;
        case LEFT:
            movePressed[1] = false;
            break;
        case DOWN:
            movePressed[2] = false;
            break;
        case RIGHT:
            movePressed[3] = false;
            break;
        case SHIFT:
            shiftDown = false;
            break;
        }
    } else {
        switch(key) {
            //case 'w':
            //case 'W':
            //    movePressed[0] = false;
            //    break;
            //case 'a':
            //case 'A':
            //    movePressed[1] = false;
            //    break;
            //case 's':
            //case 'S':
            //    movePressed[2] = false;
            //    break;
            //case 'd':
            //case 'D':
            //    movePressed[3] = false;
            //    break;
            //}
        }
    }
}
