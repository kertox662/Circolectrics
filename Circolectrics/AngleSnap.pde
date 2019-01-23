enum AngleSnap{
    Free,
    Perpendicular,
    Angular;
    
    static AngleSnap curSnap = AngleSnap.Free;
    static String[] options = {"Free", "Perpendicular", "Angular"};
    
    static void nextSnap(){
        curSnap = AngleSnap.values()[(curSnap.ordinal() + 1)%AngleSnap.values().length];
        //Snap.resetSnap();
    }
    
    static void resetSnap(){
        curSnap = AngleSnap.Free;
    }
    
    static PImage[] icons;
}
