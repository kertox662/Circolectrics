int movingLayerInd = -1, moveToInd = -1;

class Layer {
    ArrayList<LineSegment> tracks;
    ArrayList<Component> components;
    ArrayList<Text> texts;
    float defaultThickness;
    int colorIndex;
    String name;
    boolean isVisible = true;

    int padShape = 8, padSize = 72;
    boolean doTint = true;

    Layer(float dt) {
        tracks = new ArrayList<LineSegment>();
        components = new ArrayList<Component>();
        texts = new ArrayList<Text>();
        defaultThickness = dt;
        colorIndex = 1;
        this.name = "Layer " + str(layers.size());
        int end = layers.size() + 1;
        while (isNameDuplicate(this)) {
            name = "Layer " + str(end);
            end++;
        }
    }

    Layer(float dt, String name) {
        this(dt);
        this.name = name;
    }

    Layer(float dt, String name, int c) {
        this(dt, name);
        this.colorIndex = c;
    }

    Layer(float dt, int c) {
        tracks = new ArrayList<LineSegment>();
        components = new ArrayList<Component>();
        defaultThickness = dt;
        colorIndex = c;
    }


    void addTrack(LineSegment t) {
        tracks.add(t);
    }

    void addComponent(Component c) {
        components.add(c);
    }

    void addText(Text t) {
        texts.add(t);
        t.c = colorIndex;
    }

    void drawTracks() {
        for (int i = 0; i < tracks.size(); i++) {
            try {
                LineSegment ls = tracks.get(i);
                //strokeWeight(ls.thickness*viewScale);
                stroke(ccD.colors[colorIndex]);
                //if(ls.isInViewPort())
                ls.display();
            } 
            catch(IndexOutOfBoundsException e) {
            }
        }
    }

    void drawComponents() {
        for (int i = 0; i < components.size(); i++) {
            try {
                if (doTint)
                    components.get(i).display(ccD.colors[colorIndex]);
                else
                    components.get(i).display();
            } 
            catch(IndexOutOfBoundsException e) {
            }
        }
    }

    void drawTexts() {
        for (int i = 0; i < texts.size(); i++) {
            try {
                texts.get(i).display(ccD.colors[colorIndex]);
            } 
            catch(IndexOutOfBoundsException e) {
            }
        }
    }

    void toggleVisibility() {
        isVisible = !isVisible;
    }

    void setColor(int index) {
        colorIndex = index;
        for (int i = 0; i < texts.size(); i++) {
            texts.get(i).c = index;
        }
    }

    void setThickness(float t) {
        defaultThickness = t;
        for (int i = 0; i < tracks.size(); i++)
            tracks.get(i).thickness = t;
    }
}

boolean isNameDuplicate(Layer l) {
    for (int i = 0; i < layers.size(); i++) {
        Layer l2 = layers.get(i);
        if (l == l2) continue;
        if (l.name.equals(l2.name))return true;
    }

    return false;
}

boolean areLayersEmpty() {
    for (int i = 0; i < layers.size(); i++) {
        Layer l = layers.get(i);
        if (!isLayerEmpty(l)) return false;
    }
    return true;
}

boolean isLayerEmpty(Layer l) {
    if (l.tracks.size() != 0 || l.components.size() != 0 || l.texts.size() != 0) return false;
    return true;
}
