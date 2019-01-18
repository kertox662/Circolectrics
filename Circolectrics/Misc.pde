PVector vCopy(PVector p) {
    return p.copy();
}

float distSqr(PVector a, PVector b) {
    return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
}

float dist(PVector a, PVector b) {
    return dist(a.x, a.y, b.x, b.y);
}


void point(PVector a) {
    point( a.x, a.y);
}

void resetView() {
    curView.set(0, 0);
    viewScale = 1;
}

void line(PVector a, PVector b) {
    line( a.x, a.y, b.x, b.y);
}

static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}

float roundAny(float x, int d) {
    x *= pow(10, d);
    x = round(x);
    x /= pow(10, d);
    return x;
}

Frame getFrame(PSurface surface) {
  Frame frame = null;
  try {
    Field f = ((PSurfaceAWT) surface).getClass().getDeclaredField("frame");
    f.setAccessible(true);
    frame  = (Frame) (f.get(((PSurfaceAWT) surface)));
  }
  catch(Exception e) {
    println(e);
  }
  return frame;
}

//int getColor(){}

//color hsbToRGB(long x){
    
//}

PImage makeHighlight(PImage i){
    PImage img = i.copy();
    img.loadPixels();
    for(int j = 0; j < img.pixels.length; j++){
        if(img.pixels[j] != 0) img.pixels[j] = color(255);
    }
    
    img.updatePixels();
    return img;
}

PImage switchColor(PImage i, color c){
    PImage img = i.copy();
    color tp = color(0,0);
    img.loadPixels();
    for(int j = 0; j < img.pixels.length; j++){
        if(img.pixels[j] == color(0)) img.pixels[j] = c;
        else img.pixels[j] = tp;
    }
    
    img.updatePixels();
    return img;
}

PVector getRelativeMouse(){
    return new PVector((mouseX - curView.x)/viewScale, (mouseY - curView.y) / viewScale);
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


float getClosestSnappedAngle(PVector p1, PVector p2) {
    float angle;
    try {
        angle = degrees(atan((p1.y - p2.y) / (p1.x - p2.x))); //Finds angle
    } 
    catch(ArithmeticException e) {
        if (p1.y - p2.y > 0) angle = 90;
        else angle = 270;
    }
    float a = radians(round(angle / snapAngle) * snapAngle); //Gets closest Angle to the angle to mouse
    return a;
}
