class Text{
    String text;
    int fontSize;
    PVector base;
    int c;

    Text(String t, int fs, PVector b){
        text = t;
        fontSize = fs;
        base = b;
    }
    
    
    void display(){
        fill(ccD.colors[c]);
        textSize(fontSize);
        textLeading(fontSize);
        text(text, base.x, base.y);
    }
}
