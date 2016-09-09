Line[] lines = new Line[12];
int width = 720;
int height = 480;

void setup() {
  size(720, 480);
  background(255);
  initLines();
  drawLines();
  showIntersections();
}

void draw() {
  
}

void mousePressed() {
  background(255);
  initLines();
  drawLines();
  showIntersections();
}

void initLines() {
  for(int i=0; i<lines.length; i++) {
    lines[i] = new Line();
  }
}

void drawLines() {
  for(int i=0; i<lines.length; i++) {
    Line l = lines[i];
    line(l.start.x, l.start.y, l.end.x, l.end.y);
  }
}

void showIntersections() {
  for(int a=0; a<lines.length; a++) {
    Line A = lines[a];
    for(int b=a+1; b<lines.length; b++) {
      Line B = lines[b];
      Tuple xing = getIntersection(A,B);
      fill(255,0,0);
      if(xing != null) {
        ellipse(xing.x, xing.y, 10, 10);
      }
    }
  }
}

Tuple getIntersection(Line a, Line b) {
  Tuple xing = null;
  float ua = (((b.end.x-b.start.x)*(a.start.y-b.start.y))-((b.end.y-b.start.y)*(a.start.x-b.start.x))) / 
  (((b.end.y-b.start.y)*(a.end.x-a.start.x))-((b.end.x-b.start.x)*(a.end.y-a.start.y)));
  float ub = (((a.end.x-a.start.x)*(a.start.y-b.start.y))-((a.end.y-a.start.y)*(a.start.x-b.start.x))) / 
  (((b.end.y-b.start.y)*(a.end.x-a.start.x))-((b.end.x-b.start.x)*(a.end.y-a.start.y)));
  if((ua > 0) && (ua < 1) && (ub > 0) && (ub < 1)) {
    float x = a.start.x + (ua * (a.end.x-a.start.x));
    float y = a.start.y + (ua * (a.end.y-a.start.y));
    xing = new Tuple(x, y);
  }
  return xing;
}

public class Line {
  public Tuple start;
  public Tuple end;
  public Line() {
    start = new Tuple(random(width), random(height));
    end = new Tuple(random(width), random(height));
  }
  public Tuple start() {
    return start;
  }
  public Tuple end() {
    return end;
  }
}

public class Tuple { 
  public final float x; 
  public final float y; 
  public Tuple(float x, float y) { 
    this.x = x; 
    this.y = y; 
  } 
  
  public float x(){
    return x;
  }
  
  public float y(){
    return y;
  }
} 