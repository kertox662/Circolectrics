abstract class Component {
    PVector[] basePoints;
    PVector loc;
    PImage img, imgTinted;
    float rotation;
    int w, h;
    color tinted;


    void display() {
        if (-curView.x - w/2 > loc.x || -curView.x + width/viewScale + w/2 < loc.x || -curView.y - h/2 > loc.y || -curView.y + height/viewScale + h/2 < loc.y) return;

        pushMatrix();
        translate(loc.x, loc.y);
        rotate(rotation);
        image(img, 0, 0);
        for (int i = 1; i < basePoints.length; i++) {
            PVector p = basePoints[i];
            fill(0);
            noStroke();
            polygon(p.x, p.y, 36, ((i == 1)? 4:8));
            fill(255);
            ellipse(p.x, p.y, 36, 36);
        }

        popMatrix();

        //println((System.nanoTime() - s) / 1.0e6);
    }

    void display(color c) {
        println(curView.x, curView.y, -curView.x + width/viewScale, -curView.y + height/viewScale);
        if (-curView.x - w/2 > loc.x || -curView.x + width/viewScale + w/2 < loc.x || -curView.y - h/2 > loc.y || -curView.y + height/viewScale + h/2 < loc.y) return;

        pushMatrix();
        translate(loc.x, loc.y);
        rotate(rotation);
        if (c != tinted) {
            imgTinted = switchColor(img, c);
            tinted  = c;
        }
        image(imgTinted, 0, 0);
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

    Component copy() {
        return null;
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
}

class TwoPad extends Component {
    String defaultImage = "Components/Simple/2-Pad/TwoPad.png";
    float w = 300, h = 100;

    TwoPad(PVector l) {
        loc = l;
        basePoints = new PVector[3];
        basePoints[0] = new PVector();
        basePoints[1] = new PVector(-150, 0);
        basePoints[2] = new PVector(150, 0);
        img = loadImage(defaultImage);
    }

    TwoPad(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[3];
        basePoints[0] = new PVector();
        basePoints[1] = new PVector(-150, 0);
        basePoints[2] = new PVector(150, 0);
        img = loadImage(imgPath);
    }
}

class TwoPadShort extends Component {
    String defaultImage = "Components/Simple/2-Pad-Short/TwoPadShort.png";
    float w = 200, h = 60;

    TwoPadShort(PVector l) {
        loc = l;
        basePoints = new PVector[3];
        basePoints[0] = new PVector();
        basePoints[1] = new PVector(-50, 0);
        basePoints[2] = new PVector(50, 0);
        img = loadImage(defaultImage);
    }

    TwoPadShort(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[3];
        basePoints[0] = new PVector();
        basePoints[1] = new PVector(-50, 0);
        basePoints[2] = new PVector(50, 0);
        img = loadImage(imgPath);
    }
}

class ThreePad extends Component {
    String defaultImage = "Components/Simple/3-Pad/ThreePad.png";
    float w = 300, h = 100;

    ThreePad(PVector l) {
        loc = l;
        basePoints = new PVector[4];
        basePoints[0] = new PVector(-100, 0);
        basePoints[1] = new PVector(-100, 0);
        basePoints[2] = new PVector(0, 0);
        basePoints[3] = new PVector(100, 0);
        img = loadImage(defaultImage);
    }

    ThreePad(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[4];
        basePoints[0] = new PVector();
        basePoints[1] = new PVector();
        basePoints[2] = new PVector(100, 0);
        basePoints[3] = new PVector(200, 0);
        img = loadImage(imgPath);
    }
}

class EightPin extends Component {
    String defaultImage = "Components/IC/Eight Pin/EightPin.png";
    float w = 380, h = 400;

    EightPin(PVector l) {
        loc = l;
        basePoints = new PVector[9];
        basePoints[0] = new PVector(0, -150);
        basePoints[1] = new PVector(-150, -150);
        basePoints[2] = new PVector(-150, -50);
        basePoints[3] = new PVector(-150, 50);
        basePoints[4] = new PVector(-150, 150);
        basePoints[7] = new PVector(150, -150);
        basePoints[5] = new PVector(150, -50);
        basePoints[6] = new PVector(150, 50);
        basePoints[8] = new PVector(150, 150);
        img = loadImage(defaultImage);
    }

    EightPin(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[9];
        basePoints[0] = new PVector(0, -150);
        basePoints[1] = new PVector(-150, -150);
        basePoints[2] = new PVector(-150, -50);
        basePoints[3] = new PVector(-150, 50);
        basePoints[4] = new PVector(-150, 150);
        basePoints[5] = new PVector(150, -150);
        basePoints[6] = new PVector(150, -50);
        basePoints[7] = new PVector(150, 50);
        basePoints[8] = new PVector(150, 150);
        img = loadImage(imgPath);
    }
}

class FourteenPin extends Component {
    String defaultImage = "Components/IC/Fourteen Pin/FourteenPin.png";
    float w = 380, h = 700;

    FourteenPin(PVector l) {
        loc = l;
        basePoints = new PVector[15];
        basePoints[0] = new PVector(0, -300);

        basePoints[1] = new PVector(-150, -300);
        basePoints[2] = new PVector(-150, -200);
        basePoints[3] = new PVector(-150, -100);
        basePoints[4] = new PVector(-150, 0);
        basePoints[5] = new PVector(-150, 100);
        basePoints[6] = new PVector(-150, 200);
        basePoints[7] = new PVector(-150, 300);

        basePoints[8] = new PVector(150, -300);
        basePoints[9] = new PVector(150, -200);
        basePoints[10] = new PVector(150, -100);
        basePoints[11] = new PVector(150, 0);
        basePoints[12] = new PVector(150, 100);
        basePoints[13] = new PVector(150, 200);
        basePoints[14] = new PVector(150, 300);
        img = loadImage(defaultImage);
    }

    FourteenPin(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[15];
        basePoints[0] = new PVector(0, -300);

        basePoints[1] = new PVector(-150, -300);
        basePoints[2] = new PVector(-150, -200);
        basePoints[3] = new PVector(-150, -100);
        basePoints[4] = new PVector(-150, 0);
        basePoints[5] = new PVector(-150, 100);
        basePoints[6] = new PVector(-150, 200);
        basePoints[7] = new PVector(-150, 300);

        basePoints[8] = new PVector(150, -300);
        basePoints[9] = new PVector(150, -200);
        basePoints[10] = new PVector(150, -100);
        basePoints[11] = new PVector(150, 0);
        basePoints[12] = new PVector(150, 100);
        basePoints[13] = new PVector(150, 200);
        basePoints[14] = new PVector(150, 300);
        img = loadImage(imgPath);
    }
}

class SixteenPin extends Component {
    String defaultImage = "Components/IC/Sixteen Pin/SixteenPin.png";
    float w = 380, h = 800;

    SixteenPin(PVector l) {
        loc = l;
        basePoints = new PVector[17];
        basePoints[0] = new PVector(0, -350);

        basePoints[1] = new PVector(-150, -350);
        basePoints[2] = new PVector(-150, -250);
        basePoints[3] = new PVector(-150, -150);
        basePoints[4] = new PVector(-150, -50);
        basePoints[5] = new PVector(-150, 50);
        basePoints[6] = new PVector(-150, 150);
        basePoints[7] = new PVector(-150, 250);
        basePoints[15] = new PVector(-150, 350);

        basePoints[8] = new PVector(150, -350);
        basePoints[9] = new PVector(150, -250);
        basePoints[10] = new PVector(150, -150);
        basePoints[11] = new PVector(150, -50);
        basePoints[12] = new PVector(150, 50);
        basePoints[13] = new PVector(150, 150);
        basePoints[14] = new PVector(150, 250);
        basePoints[16] = new PVector(150, 350);
        img = loadImage(defaultImage);
    }

    SixteenPin(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[17];
        basePoints[0] = new PVector(0, -350);

        basePoints[1] = new PVector(-150, -350);
        basePoints[2] = new PVector(-150, -250);
        basePoints[3] = new PVector(-150, -150);
        basePoints[4] = new PVector(-150, -50);
        basePoints[5] = new PVector(-150, 50);
        basePoints[6] = new PVector(-150, 150);
        basePoints[7] = new PVector(-150, 250);
        basePoints[15] = new PVector(-150, 350);

        basePoints[8] = new PVector(150, -350);
        basePoints[9] = new PVector(150, -250);
        basePoints[10] = new PVector(150, -150);
        basePoints[11] = new PVector(150, -50);
        basePoints[12] = new PVector(150, 50);
        basePoints[13] = new PVector(150, 150);
        basePoints[14] = new PVector(150, 250);
        basePoints[16] = new PVector(150, 350);
        img = loadImage(imgPath);
    }
}

class EighteenPin extends Component {
    String defaultImage = "Components/IC/Eighteen Pin/EighteenPin.png";
    float w = 380, h = 900;

    EighteenPin(PVector l) {
        loc = l;
        basePoints = new PVector[19];
        basePoints[0] = new PVector(0, -300);

        basePoints[1] = new PVector(-150, -400);
        basePoints[2] = new PVector(-150, -300);
        basePoints[3] = new PVector(-150, -200);
        basePoints[4] = new PVector(-150, -100);
        basePoints[5] = new PVector(-150, 0);
        basePoints[6] = new PVector(-150, 100);
        basePoints[7] = new PVector(-150, 200);
        basePoints[8] = new PVector(-150, 300);
        basePoints[9] = new PVector(-150, 400);


        basePoints[10] = new PVector(150, -400);
        basePoints[11] = new PVector(150, -300);
        basePoints[12] = new PVector(150, -200);
        basePoints[13] = new PVector(150, -100);
        basePoints[14] = new PVector(150, 0);
        basePoints[15] = new PVector(150, 100);
        basePoints[16] = new PVector(150, 200);
        basePoints[17] = new PVector(150, 300);
        basePoints[18] = new PVector(150, 400);
        img = loadImage(defaultImage);
    }

    EighteenPin(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[19];
        basePoints[0] = new PVector(0, -300);

        basePoints[1] = new PVector(-150, -400);
        basePoints[2] = new PVector(-150, -300);
        basePoints[3] = new PVector(-150, -200);
        basePoints[4] = new PVector(-150, -100);
        basePoints[5] = new PVector(-150, 0);
        basePoints[6] = new PVector(-150, 100);
        basePoints[7] = new PVector(-150, 200);
        basePoints[8] = new PVector(-150, 300);
        basePoints[9] = new PVector(-150, 400);


        basePoints[10] = new PVector(150, -400);
        basePoints[11] = new PVector(150, -300);
        basePoints[12] = new PVector(150, -200);
        basePoints[13] = new PVector(150, -100);
        basePoints[14] = new PVector(150, 0);
        basePoints[15] = new PVector(150, 100);
        basePoints[16] = new PVector(150, 200);
        basePoints[17] = new PVector(150, 300);
        basePoints[18] = new PVector(150, 400);
        img = loadImage(imgPath);
    }
}

class FortyPin extends Component {
    String defaultImage = "Components/IC/Forty Pin/FortyPin.png";
    float w = 680, h = 2000;

    FortyPin(PVector l) {
        loc = l;
        basePoints = new PVector[41];
        basePoints[0] = new PVector(0, -300);

        basePoints[1] = new PVector(-300, -950);
        basePoints[2] = new PVector(-300, -850);
        basePoints[3] = new PVector(-300, -750);
        basePoints[4] = new PVector(-300, -650);
        basePoints[5] = new PVector(-300, -550);
        basePoints[6] = new PVector(-300, -450);
        basePoints[7] = new PVector(-300, -350);
        basePoints[8] = new PVector(-300, -250);
        basePoints[9] = new PVector(-300, -150);
        basePoints[10] = new PVector(-300, -50);
        basePoints[11] = new PVector(-300, 50);
        basePoints[12] = new PVector(-300, 150);
        basePoints[13] = new PVector(-300, 250);
        basePoints[14] = new PVector(-300, 350);
        basePoints[15] = new PVector(-300, 450);
        basePoints[16] = new PVector(-300, 550);
        basePoints[17] = new PVector(-300, 650);
        basePoints[18] = new PVector(-300, 750);
        basePoints[19] = new PVector(-300, 850);
        basePoints[20] = new PVector(-300, 950);


        basePoints[21] = new PVector(300, -950);
        basePoints[22] = new PVector(300, -850);
        basePoints[23] = new PVector(300, -750);
        basePoints[24] = new PVector(300, -650);
        basePoints[25] = new PVector(300, -550);
        basePoints[26] = new PVector(300, -450);
        basePoints[27] = new PVector(300, -350);
        basePoints[28] = new PVector(300, -250);
        basePoints[29] = new PVector(300, -150);
        basePoints[30] = new PVector(300, -50);
        basePoints[31] = new PVector(300, 50);
        basePoints[32] = new PVector(300, 150);
        basePoints[33] = new PVector(300, 250);
        basePoints[34] = new PVector(300, 350);
        basePoints[35] = new PVector(300, 450);
        basePoints[36] = new PVector(300, 550);
        basePoints[37] = new PVector(300, 650);
        basePoints[38] = new PVector(300, 750);
        basePoints[39] = new PVector(300, 850);
        basePoints[40] = new PVector(300, 950);

        img = loadImage(defaultImage);
    }

    FortyPin(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[41];
        basePoints[0] = new PVector(0, -300);

        basePoints[1] = new PVector(-300, -950);
        basePoints[2] = new PVector(-300, -850);
        basePoints[3] = new PVector(-300, -750);
        basePoints[4] = new PVector(-300, -650);
        basePoints[5] = new PVector(-300, -550);
        basePoints[6] = new PVector(-300, -450);
        basePoints[7] = new PVector(-300, -350);
        basePoints[8] = new PVector(-300, -250);
        basePoints[9] = new PVector(-300, -150);
        basePoints[10] = new PVector(-300, -50);
        basePoints[11] = new PVector(-300, 50);
        basePoints[12] = new PVector(-300, 150);
        basePoints[13] = new PVector(-300, 250);
        basePoints[14] = new PVector(-300, 350);
        basePoints[15] = new PVector(-300, 450);
        basePoints[16] = new PVector(-300, 550);
        basePoints[17] = new PVector(-300, 650);
        basePoints[18] = new PVector(-300, 750);
        basePoints[19] = new PVector(-300, 850);
        basePoints[20] = new PVector(-300, 950);


        basePoints[21] = new PVector(300, -950);
        basePoints[22] = new PVector(300, -850);
        basePoints[23] = new PVector(300, -750);
        basePoints[24] = new PVector(300, -650);
        basePoints[25] = new PVector(300, -550);
        basePoints[26] = new PVector(300, -450);
        basePoints[27] = new PVector(300, -350);
        basePoints[28] = new PVector(300, -250);
        basePoints[29] = new PVector(300, -150);
        basePoints[30] = new PVector(300, -50);
        basePoints[31] = new PVector(300, 50);
        basePoints[32] = new PVector(300, 150);
        basePoints[33] = new PVector(300, 250);
        basePoints[34] = new PVector(300, 350);
        basePoints[35] = new PVector(300, 450);
        basePoints[36] = new PVector(300, 550);
        basePoints[37] = new PVector(300, 650);
        basePoints[38] = new PVector(300, 750);
        basePoints[39] = new PVector(300, 850);
        basePoints[40] = new PVector(300, 950);

        img = loadImage(imgPath);
    }
}

class VResistor extends Component {
    String defaultImage = "Components/VR/VR.png";
    float w = 400, h = 450;

    VResistor(PVector l) {
        loc = l;
        basePoints = new PVector[4];
        basePoints[0] = new PVector();
        basePoints[1] = new PVector(0, -75);
        basePoints[2] = new PVector(-100, 25);
        basePoints[3] = new PVector(100, 25);
        img = loadImage(defaultImage);
    }

    VResistor(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[4];
        basePoints[0] = new PVector();
        basePoints[1] = new PVector(0, -75);
        basePoints[2] = new PVector(-100, 25);
        basePoints[3] = new PVector(100, 25);
        img = loadImage(imgPath);
    }
}

class LCD extends Component {
    String defaultImage = "Components/LCD/LCD.png";
    float w = 1600, h = 100;

    LCD(PVector l) {
        loc = l;
        basePoints = new PVector[17];
        basePoints[0] = new PVector(-750, 0);

        basePoints[1] = new PVector(-750, 0);
        basePoints[2] = new PVector(-650, 0);
        basePoints[3] = new PVector(-550, 0);
        basePoints[4] = new PVector(-450, 0);
        basePoints[5] = new PVector(-350, 0);
        basePoints[6] = new PVector(-250, 0);
        basePoints[7] = new PVector(-150, 0);
        basePoints[8] = new PVector(-50, 0);

        basePoints[16] = new PVector(750, 0);
        basePoints[15] = new PVector(650, 0);
        basePoints[14] = new PVector(550, 0);
        basePoints[13] = new PVector(450, 0);
        basePoints[12] = new PVector(350, 0);
        basePoints[11] = new PVector(250, 0);
        basePoints[10] = new PVector(150, 0);
        basePoints[9] = new PVector(50, 0);

        img = loadImage(defaultImage);
    }

    LCD(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[17];
        basePoints[0] = new PVector(-750, 0);

        basePoints[1] = new PVector(-750, 0);
        basePoints[2] = new PVector(-650, 0);
        basePoints[3] = new PVector(-550, 0);
        basePoints[4] = new PVector(-450, 0);
        basePoints[5] = new PVector(-350, 0);
        basePoints[6] = new PVector(-250, 0);
        basePoints[7] = new PVector(-150, 0);
        basePoints[8] = new PVector(-50, 0);

        basePoints[16] = new PVector(750, 0);
        basePoints[15] = new PVector(650, 0);
        basePoints[14] = new PVector(550, 0);
        basePoints[13] = new PVector(450, 0);
        basePoints[12] = new PVector(350, 0);
        basePoints[11] = new PVector(250, 0);
        basePoints[10] = new PVector(150, 0);
        basePoints[9] = new PVector(50, 0);

        img = loadImage(imgPath);
    }
}

class Power4 extends Component {
    String defaultImage = "Components/Terminal/Power4.png";
    float w = 800, h = 400;

    Power4(PVector l) {
        loc = l;
        basePoints = new PVector[5];
        basePoints[0] = new PVector(-300, 0);
        basePoints[1] = new PVector(-300, 0);
        basePoints[2] = new PVector(-100, 0);
        basePoints[3] = new PVector(100, 0);
        basePoints[4] = new PVector(300, 0);
        img = loadImage(defaultImage);
    }

    Power4(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[5];
        basePoints[0] = new PVector(-300, 0);
        basePoints[1] = new PVector(-300, 0);
        basePoints[2] = new PVector(-100, 0);
        basePoints[3] = new PVector(100, 0);
        basePoints[4] = new PVector(300, 0);
        img = loadImage(imgPath);
    }
}

class Power6 extends Component {
    String defaultImage = "Components/Terminal/Power6.png";
    float w = 1200, h = 400;

    Power6(PVector l) {
        loc = l;
        basePoints = new PVector[7];
        basePoints[0] = new PVector(-500, 0);
        basePoints[1] = new PVector(-500, 0);
        basePoints[2] = new PVector(-300, 0);
        basePoints[3] = new PVector(-100, 0);
        basePoints[4] = new PVector(100, 0);
        basePoints[5] = new PVector(300, 0);
        basePoints[6] = new PVector(500, 0);
        img = loadImage(defaultImage);
    }

    Power6(PVector l, String imgPath) {
        loc = l;
        basePoints = new PVector[7];
        basePoints[0] = new PVector(-500, 0);
        basePoints[1] = new PVector(-500, 0);
        basePoints[2] = new PVector(-300, 0);
        basePoints[3] = new PVector(-100, 0);
        basePoints[4] = new PVector(100, 0);
        basePoints[5] = new PVector(300, 0);
        basePoints[6] = new PVector(500, 0);
        img = loadImage(imgPath);
    }
}
