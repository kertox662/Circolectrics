class Component {
    String name, officialName;
    PVector[] basePoints; //Where to draw pads as well as snapping points. The first element of the array is the one by which the component will be placed.
    PVector loc; //Where the center of the component is located. Also where the image will be centered around.
    PImage img, imgTinted; //img is black, imgTinted is the component's layer's color;
    float rotation;
    int w, h; //Width and Height

    PVector c1, c2, c3, c4,c5;

    color tinted;
    String defaultImage; //Path to default image
    PImage[] possibleImages; //For master components to store images
    String[] imageNames; //For master components to store image variant names.


    void display() {
        if (-curView.x/viewScale > loc.x + w/2 || (-curView.x + width)/viewScale < loc.x - w/2 || -curView.y/viewScale > loc.y + h/2 || (-curView.y + height)/viewScale < loc.y - h/2) return;

        pushMatrix();
        translate(loc.x, loc.y);
        rotate(rotation);
        image(img, 0, 0);
        for (int i = 1; i < basePoints.length; i++) { //For each basepoint, creates a polygon there. Octagon if not pad 1, or if only 2 pads, if it is the first pad, then a square.
            PVector p = basePoints[i];
            fill(0);
            noStroke();
            polygon(p.x, p.y, 36, ((i == 1)? 4:8));
            fill(255);
            ellipse(p.x, p.y, 36, 36); //"Hole" inside the polygon
        }

        popMatrix();
    }

    void display(color c, boolean b) { //Display but with a tinted image
        if (-curView.x/viewScale > loc.x + w/2 || (-curView.x + width)/viewScale < loc.x - w/2 || -curView.y/viewScale > loc.y + h/2 || (-curView.y + height)/viewScale < loc.y - h/2) {
            return;
        }

        pushMatrix();
        translate(loc.x, loc.y);
        rotate(rotation);
        if (c != tinted) {
            imgTinted = switchColor(img, c);
            tinted  = c;
        }
        if(b)
            image(imgTinted, 0, 0);
        else
            image(img, 0, 0);
        for (int i = 1; i < basePoints.length; i++) {
            PVector p = basePoints[i];
            fill(c);
            stroke(0);
            strokeWeight(2);
            polygon(p.x, p.y, (i == 1 && basePoints.length > 3)? 36*sqrt(2):36, ((i == 1 && basePoints.length > 3)? 4:8));
            fill(255);
            ellipse(p.x, p.y, 36, 36);
            
        }
        popMatrix();
    }

    void displayPreview(int imgIndex) { //Display, but in the create Component dialogue. Only called for masterComponents
        if (img != possibleImages[imgIndex]) {
            img = possibleImages[imgIndex];
        }
        displayPreview();
    }

    void displayPreview() { //Display, but for create Component dialogue.
        try {
            cComp.image(img, 0, 0);
            for (int i = 1; i < basePoints.length; i++) {
                PVector p = basePoints[i];
                cComp.fill(0);
                cComp.noStroke();
                if (basePoints.length > 3)
                    cComp.polygon(p.x, p.y, ((i == 1)? 36*sqrt(2):36), ((i == 1)? 4:8));
                else
                    cComp.polygon(p.x, p.y, 36, 8);
                cComp.fill(255);
                cComp.ellipse(p.x, p.y, 36, 36);
            }
        } 
        catch (NullPointerException e) {
            e.printStackTrace();
        }
    }

    Component copy() { //Copies information and returns a new Component
        Component c = new Component();
        c.name = name;
        c.officialName = name;
        c.loc = loc.copy();
        c.img = img.copy();
        c.w = w;
        c.h = h;
        c.rotation = 0;
        c.basePoints = new PVector[basePoints.length];
        for (int i = 0; i < basePoints.length; i++) {
            c.basePoints[i] = basePoints[i].copy();
        }
        return c;
    }

    void setLocation(PVector l) {
        loc = l;
    }

    void setLocation(float x, float y) {
        loc.set(x, y);
    }

    void setImage(PImage i) {
        img = i;
    }

    void setImage(String s) {
        PImage temp = loadImage(s);
        if (temp != null) img = temp;
    }
    
    boolean isInsideImage(PVector m){
        float iW = img.width, iH = img.height;
        float cr = cos(-rotation), sr = sin(-rotation);
        
        m.x -= loc.x;
        m.y -= loc.y;
        
        PVector mouseRot = new PVector((m.x*cr - m.y*sr) + loc.x, (m.x*sr + m.y*cr) + loc.y);
        
        m.x += loc.x;
        m.y += loc.y;
        
        if(mouseRot.x >= loc.x - iW/2 && mouseRot.x <= loc.x + iW/2)
            if(mouseRot.y >= loc.y - iH/2 && mouseRot.y <= loc.y + iH/2)
                return true;
        
        return false;
    }
    
    boolean shouldSelect(){
        
        
        return true;
    }
}

Component loadComponent(String path) { //Loads the component from specified file
    Component c = new Component();
    c.loc = new PVector();
    String[] parts = trim(loadStrings(path));
    c.name = parts[0];
    c.defaultImage = "Components/" + parts[0] + "/" + parts[0] + ".png";
    c.officialName = parts[1];
    c.w = int(parts[2]);
    c.h = int(parts[3]);
    c.basePoints = new PVector[int(parts[4])];
    int i;
    for (i = 0; i < c.basePoints.length; i++) {
        int x = int(parts[5 + i].split(",")[0]);
        int y = int(parts[5 + i].split(",")[1]);
        c.basePoints[i] = new PVector(x, y);
    }
    //println(c.name, parts.length - (i + 4));
    c.possibleImages = new PImage[parts.length - (i + 4)];
    c.possibleImages[0] = loadImage(c.defaultImage);
    c.imageNames = new String[c.possibleImages.length];
    c.imageNames[0] = "Default";
    for (int j = 1; j < c.possibleImages.length; j++) {
        c.possibleImages[j] = loadImage("Components/" + c.name + "/" + parts[4 + i + j] + ".png");
        c.imageNames[j] = parts[4 + i + j];
    }
    c.img = c.possibleImages[0];
    return c;
}

Component loadComponent(String path, PVector p) {//Loads component and gives location
    Component c = loadComponent(path);
    c.loc = p;
    return c;
}

Component[] loadMaster() { //Loads components based on a text document documenting all components.
    String[] names = loadStrings("Components/Components.txt");
    Component[] cs = new Component[names.length];
    for (int i = 0; i < names.length; i++) {
        cs[i] = loadComponent("Components/data/" + names[i] + ".cmp");
    }
    return cs;
}
