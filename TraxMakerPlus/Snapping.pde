PImage snapIcon;

enum Snap {
    Off, 
        Closest, 
        Perpendicular, 
        Endpoint;


    static Snap curSnap = Snap.Off;
    static String[] options = {"Off", "Closest", "Perpendicular", "Endpoint"};

    static void nextSnap() {
        curSnap = Snap.values()[(curSnap.ordinal() + 1)%Snap.values().length];
        //AngleSnap.resetSnap();
    }

    static void resetSnap() {
        curSnap = Snap.Off;
    }
}

PVector findSnapPoint(PVector p) {
    PVector ps = null;
    if (Snap.curSnap != Snap.Off) {
        PVector mouse = getRelativeMouse();
        float smallestDist = snapDist + 1;
        if (Snap.curSnap == Snap.Closest) {
            for (int i = 0; i < layers.size(); i++) {
                Layer l = layers.get(i);
                for (int j = 0; j < l.tracks.size(); j++) {
                    LineSegment ls = l.tracks.get(j);
                    if (ls != placingTrack) {
                        float d = ls.distToLine(mouse);
                        if (d <= snapDist && d <= smallestDist) {
                            smallestDist = d;
                            ps = ls.intersect(mouse);
                        }
                    }
                }

                for (int j = 0; j < l.components.size(); j++) {
                    Component c = l.components.get(j);
                    for (int k = 0; k < c.basePoints.length; k++) {
                        PVector bP = PVector.add(c.basePoints[k], c.loc);
                        float d = dist(mouse, bP);
                        if (d < smallestDist) {
                            smallestDist = d;
                            ps = bP;
                            break;
                        }
                    }
                }
            }
        } else if (Snap.curSnap == Snap.Endpoint) {
            for (int i = 0; i < layers.size(); i++) {
                Layer l = layers.get(i);
                for (int j = 0; j < l.tracks.size(); j++) {
                    LineSegment ls = l.tracks.get(j);
                    if (ls == placingTrack) continue;
                    float d1 = dist(mouse.x, mouse.y, ls.points[0].x, ls.points[0].y);
                    float d2 = dist(mouse.x, mouse.y, ls.points[1].x, ls.points[1].y);
                    if (d1 <= snapDist && d1 <= smallestDist) {
                        smallestDist = d1;
                        ps = ls.points[0].copy();
                    }

                    if (d2 <= snapDist && d2 <= smallestDist) {
                        smallestDist = d2;
                        ps = ls.points[1].copy();
                    }
                }

                for (int j = 0; j < l.components.size(); j++) {
                    Component c = l.components.get(j);
                    for (int k = 0; k < c.basePoints.length; k++) {
                        PVector bP = PVector.add(c.basePoints[k], c.loc);
                        float d = dist(mouse, bP);
                        if (d < smallestDist) {
                            smallestDist = d;
                            ps = bP;
                            break;
                        }
                    }
                }
            }
        } else if (Snap.curSnap == Snap.Perpendicular) {
            for (int i = 0; i < layers.size(); i++) {
                Layer l = layers.get(i);
                for (int j = 0; j < l.tracks.size(); j++) {
                    LineSegment ls = l.tracks.get(j);
                    if (ls == placingTrack) continue;
                    PVector toTest = ls.intersect(p);
                    float d = dist(p, toTest);
                    float dl = ls.distToLine(mouse);
                    if (dl <= snapDist && dl <= smallestDist) {
                        smallestDist = d;
                        ps = toTest;
                    }
                }
            }
        }
    }
    return ps;
}
