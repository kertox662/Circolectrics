class LineSegment {
    PVector[] points;
    float slope;
    float thickness;
    PVector[] revPoints;

    LineSegment(PVector a, PVector b, float t) {
        points = new PVector[]{a, b};
        revPoints = new PVector[2];
        slope = (b.y - a.y) / (b.x - a.x);
        if (slope == Float.NEGATIVE_INFINITY)
            slope = Float.POSITIVE_INFINITY;
        thickness = t;
    }

    LineSegment(PVector a, PVector b) {
        this(a, b, curLayer.defaultThickness);
    }

    LineSegment(PVector a, PVector b, Layer l) {
        this(a, b, l.defaultThickness);
    }


    void display() {
        strokeWeight(thickness);
        line(points[0], points[1]);
    }

    void setSlope() {
        slope = (points[1].y - points[0].y) / (points[1].x - points[0].x);
        if (slope == Float.NEGATIVE_INFINITY)
            slope = Float.POSITIVE_INFINITY;
    }

    boolean isPointOnSegment(PVector tested) {
        boolean sameSlope = (points[1].y - points[0].y) * (tested.x - points[1].x)    -     (points[1].x - points[0].x) * (tested.y - points[1].y) == 0; //Orientation function
        float minX = min(points[0].x, points[1].x);
        float maxX = max(points[0].x, points[1].x);
        float minY = min(points[0].y, points[1].y);
        float maxY = max(points[0].y, points[1].y);
        if (sameSlope) {
            if (minX <= tested.x && tested.x <= maxX && minY <= tested.y && tested.y <= maxY)//If tested point between the min and maxes
                return true;
        }
        return false;
    }

    float distToLine(PVector p) {
        if (slope == Float.POSITIVE_INFINITY)
            return abs(p.x - points[0].x);
        else if (slope == 0)
            return abs(p.y - points[0].y);
        else {
            float l2 = distSqr(points[0], points[1]);
            if (l2 == 0) return dist(points[0], points[1]);
            float t = ( (p.x - points[0].x) * (points[1].x - points[0].x)  +  (p.y - points[0].y) * (points[1].y - points[0].y) )/l2;
            t = max(0, min(1, t));
            PVector p2 = new PVector(
                points[0].x + t * (points[1].x - points[0].x), 
                points[0].y + t * (points[1].y - points[0].y)
                );

            return dist(p, p2);
        }
    }

    PVector instersectPoint(PVector p) {
        float l2 = distSqr(points[0], points[1]);
        float t = ( (p.x - points[0].x) * (points[1].x - points[0].x)  +  (p.y - points[0].y) * (points[1].y - points[0].y) )/l2;
        t = max(0, min(1, t));
        PVector p2 = new PVector(
            points[0].x + t * (points[1].x - points[0].x), 
            points[0].y + t * (points[1].y - points[0].y)
            );
        return p2;
    }
    
    boolean areSegmentsIntersecting(LineSegment ls){
        PVector p1 = points[0], q1 = points[1];
        PVector p2 = ls.points[0], q2 = ls.points[1];
        
        int[] orients = new int[4];
        orients[0] = getOrientation(p1,q1,p2);
        orients[1] = getOrientation(p1,q1,q2);
        orients[2] = getOrientation(p2,q2,p1);
        orients[3] = getOrientation(p2,q2,q1);
        if(orients[0] != orients[1] && orients[2] != orients[3])
            return true;
        
        return false;
    }



    void setPoint(PVector p, int i) {
        points[i%2] = p;
    }

    void sortPoints() {//Deprecated?
        if (points[0].x > points[1].x) {
            PVector temp = points[0];
            points[0] = points[1];
            points[1] = temp;
        }
    }
    
    boolean isInViewPort(){
        if(points[0].x > viewPortMin.x && points[0].x < viewPortMax.x)
            if(points[0].y > viewPortMin.y && points[0].y < viewPortMax.y) 
                return true;
        
        if(points[1].x > viewPortMin.x && points[1].x < viewPortMax.x)
            if(points[1].y > viewPortMin.y && points[1].y < viewPortMax.y) 
                return true;
        
        return false;
    }
    
    
}
