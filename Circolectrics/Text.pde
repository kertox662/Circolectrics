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
    
    void display(color c){
        fill(c);
        textSize(fontSize);
        textLeading(fontSize);
        text(text, base.x, base.y);
    }
    
    void setColor(color c){
        this.c = c;
    }
    
    void setText(String t){
        text = t;
    }
    
    void setSize(int size){
        if(size > 0)
            fontSize = size;
    }
}
