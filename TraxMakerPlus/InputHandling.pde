void mousePressed(MouseEvent e) {
    if (mouseButton == LEFT) {
        if (isInViewport()) { //If On Main Track
            if (Tool.curTool == Tool.Track) {//Track Tool
                if (placingTrack == null && selectedTrack == null) { //
                    PVector p0 = findSnapPoint(new PVector((mouseX - curView.x)/viewScale, (mouseY - curView.y) / viewScale));
                    p0 = (p0 == null)? new PVector((mouseX - curView.x)/viewScale, (mouseY - curView.y) / viewScale): p0;
                    placingTrack = new LineSegment(p0, new PVector((mouseX - curView.x)/viewScale, (mouseY - curView.y) / viewScale));
                    curLayer.addTrack(placingTrack);
                } else if (selectedTrack == null) {
                    placingTrack.setSlope();
                    placingTrack = null;
                }
            }
        } else if (isInToolBox()) {
            for (int i = 0; i < Tool.toolName.length; i++) {
                if (dist(mouseX, mouseY, iconOffset[i], 100 + i*60) <= 25) {
                    changeTool(Tool.values()[i]);
                }
            }
        } else if (isInSnapBox()) {
            if (dist(mouseX, mouseY, width - 40, height - 50) <= 25)
                AngleSnap.nextSnap();
            else if (dist(mouseX, mouseY, width - 110, height - 50) <= 25) {
                Snap.nextSnap();
            }
        } else if (isInFileBox()) {
            if (dist(mouseX, mouseY, fileIconLoc[0].x, fileIconLoc[0].y) <= 25) {
                setDialogue(0);
            } else if (dist(mouseX, mouseY, fileIconLoc[1].x, fileIconLoc[1].y) <= 25) {
                //openFile();
            } else if (dist(mouseX, mouseY, fileIconLoc[2].x, fileIconLoc[2].y) <= 25) {
                selectOutput("Save File", "saveToFile");
            }
        } else if (isInManager()) {
            int index = (height - 96 - mouseY + managerScrolled)/20;
            movingLayerInd = index;
            moveToInd = (height - 86 - mouseY + managerScrolled)/20;
            ;
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
            if (dist(mouseX, mouseY, width - 130, 88) <= 20) {
                Layer l = new Layer(curLayer.defaultThickness);
                layers.add(l);
                NLFrames = 3;
            } else if (dist(mouseX, mouseY, width - 80, 88) <= 20) {
                setDialogue(3);
                ELFrames = 3;
            } else if (dist(mouseX, mouseY, width - 30, 88) <= 20) {
                if (layers.size() > 1)
                    setDialogue(4);
                DLFrames = 3;
            }
        }
    } else if (mouseButton == RIGHT) {
        if (placingTrack != null) {
            curLayer.tracks.remove(placingTrack);
            placingTrack = null;
        }
    }


    //makeNewFile();
    //nfWin = new newFileDialogue();
    //getFrame(p.getSurface()).dispose();
    //delay(50);
    //p = new PWin(400,200);
}

void mouseClicked(MouseEvent e) {
    if (mouseButton == LEFT) {
        if (isInManager()) {
            if (e.getCount() == 2) {
                setDialogue(3);
            }
        }
    }
}

void mouseDragged() {
    if (isInViewport()) {
        if (Tool.curTool == Tool.Pan) {
            curView.x += (mouseX - pmouseX);
            curView.y += (mouseY - pmouseY);
        }
    } 
    if (isInManager()) {
        int index = (height - 86 - mouseY + managerScrolled)/20;
        moveToInd = min(index, layers.size());
    }
}

void mouseReleased() {
    if (moveToInd - movingLayerInd > 1) {
        layers.remove(curLayer);
        layers.add(moveToInd - 1, curLayer);
    } else if (moveToInd - movingLayerInd < 0) {
        layers.remove(curLayer);
        layers.add(moveToInd, curLayer);
    }
    moveToInd = -1;
    movingLayerInd = -1;
}

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
        }
    } else {
        switch(key) {
        case 'w':
        case 'W':
            movePressed[0] = true;
            break;
        case 'a':
        case 'A':
            movePressed[1] = true;
            break;
        case 's':
        case 'S':
            movePressed[2] = true;
            break;
        case 'd':
        case 'D':
            movePressed[3] = true;
            break;
        case ' ':
            nfWin.window.setVisible(false);
            temp = false;
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
        }
    } else {
        switch(key) {
        case 'w':
        case 'W':
            movePressed[0] = false;
            break;
        case 'a':
        case 'A':
            movePressed[1] = false;
            break;
        case 's':
        case 'S':
            movePressed[2] = false;
            break;
        case 'd':
        case 'D':
            movePressed[3] = false;
            break;
        case 'r':
        case 'R':
            resetView();
            break;
        case ' ':
            //println(curView);
        }
    }
}
