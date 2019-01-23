PImage snapIcon;

enum Snap {
  Off, 
    Closest, 
    Perpendicular, 
    Endpoint, 
    Aligned;


  static Snap curSnap = Snap.Off;
  static String[] options = {"Off", "Closest", "Perpendicular", "Endpoint", "Aligned"};

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
  alignedSnapPoint = null;
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
            PVector bP = c.basePoints[k].copy();
            float cosRot = cos(c.rotation), sinRot = sin(c.rotation);
            float xTemp = bP.x, yTemp = bP.y;
            bP.x = (xTemp*cosRot - yTemp*sinRot) + c.loc.x;
            bP.y = (xTemp * sinRot + yTemp * cosRot) + c.loc.y;
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
            PVector bP = c.basePoints[k].copy();
            float cosRot = cos(c.rotation), sinRot = sin(c.rotation);
            float xTemp = bP.x, yTemp = bP.y;
            bP.x = (xTemp*cosRot - yTemp*sinRot) + c.loc.x;
            bP.y = (xTemp * sinRot + yTemp * cosRot) + c.loc.y;
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
    } else if (Snap.curSnap == Snap.Aligned) {
      for (int i = 0; i < layers.size(); i++) {
        Layer l = layers.get(i);
        for (int j = 0; j < l.tracks.size(); j++) {
          LineSegment ls = l.tracks.get(j);
          if (ls == placingTrack) continue;
          PVector X1Y2_1 = new PVector(p.x, ls.points[0].y), X2Y1_1 = new PVector(ls.points[0].x, p.y);
          PVector X1Y2_2 = new PVector(p.x, ls.points[1].y), X2Y1_2 = new PVector(ls.points[1].x, p.y);
          PVector[] testPoints = {X1Y2_1, X2Y1_1, X1Y2_2, X2Y1_2};
          for (int k = 0; k < testPoints.length; k++) {
            PVector point = testPoints[k];
            float d = dist(mouse, point);
            if (d < smallestDist) {
              ps = point;
              smallestDist = d;
              alignedSnapPoint = (k < 2)?ls.points[0]:ls.points[1];
            }
          }
        }

        for (int j = 0; j < l.components.size(); j++) {
          Component c = l.components.get(j);
          for (int k = 0; k < c.basePoints.length; k++) {
            PVector bP = c.basePoints[k].copy();
            float cosRot = cos(c.rotation), sinRot = sin(c.rotation);
            float xTemp = bP.x, yTemp = bP.y;
            bP.x = (xTemp*cosRot - yTemp*sinRot) + c.loc.x;
            bP.y = (xTemp * sinRot + yTemp * cosRot) + c.loc.y;
            PVector X1Y2 = new PVector(p.x, bP.y), X2Y1 = new PVector(bP.x, p.y);
            //println(X1Y2,X2Y1);
            float d = dist(mouse, X1Y2);
            if (d < smallestDist) {
              ps = X1Y2;
              smallestDist = d;
              alignedSnapPoint = bP;
            }

            d = dist(mouse, X2Y1);
            if (d < smallestDist) {
              ps = X2Y1;
              smallestDist = d;
              alignedSnapPoint = bP;

            }
          }
        }
        
      }
    }
  }

  return ps;
}
