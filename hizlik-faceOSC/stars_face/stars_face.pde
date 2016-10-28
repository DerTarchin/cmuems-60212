import oscP5.*;
OscP5 oscP5;

int found;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();
float[] rawArray;
boolean showArray = false;

Coord center;
Coord new_center;
Coord bz_center;
Coord new_bz_center;
float speed = 0.02;
float ease = 0.1;
ArrayList<BezierLine> lines = new ArrayList<BezierLine>();
color[] colors = new color[4];

void setup() {
  size(1280, 720, OPENGL);
  //size(640, 360, OPENGL);
  //fullScreen(OPENGL);
  smooth(); 
  background(0);
  //frameRate(30);

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "rawData", "/raw");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  
  colors[0] = color(169,241,230,200);
  colors[1] = color(80,214,207,200);
  colors[2] = color(11,168,159,200);
  colors[3] = color(255,255,255,200);
  
  center = new Coord(width/2, height/2);
  new_center = new Coord(width/2, height/2);
  bz_center = new Coord(width/2, height/2);
  new_bz_center = new Coord(width/2, height/2);
  for(int i=0; i<500; i++) {
    lines.add(new BezierLine()); 
  }
}

void draw() {  
  // blur effect
  noStroke();
  fill(0,0, 0, 80);
  rect(0, 0, width, height);
  //background(0);
  
  if(found > 0) {
    new_bz_center.x= width-map(poseOrientation.y, -0.25, 0.25, 0, width);
    new_bz_center.y= height-map(poseOrientation.x, -0.25, 0.25, 0, height);
    new_center.x = map(posePosition.x, 100, 600, 0, width);
    new_center.y = height-map(posePosition.y, 100, 400, 0, height);
  }
  else {
    new_bz_center.x=mouseX;
    new_bz_center.y=mouseY;
    bz_center.x=mouseX;
    bz_center.y=mouseY;
    if(mousePressed) {
      new_center.x = mouseX;
      new_center.y = mouseY;
    }
  }
  
  move();
  
  fill(255);
  for(int i=0; i<lines.size(); i++) {
    lines.get(i).draw();
  }
  
  if (found != 0 && showArray) {
    for (int val = 0; val < rawArray.length -1; val+=2) {
      fill(255);
      ellipse(rawArray[val]-150, rawArray[val+1]-100, 5, 5); 
    }
  }
}

public void move(){
   float d_cx = new_center.x - center.x;
   float d_cy = new_center.y - center.y;
   float d_bzx = new_bz_center.x - bz_center.x;
   float d_bzy = new_bz_center.y - bz_center.y;
   float c_distance = sqrt(d_cx * d_cx + d_cy * d_cy);
   float bz_distance = sqrt(d_cx * d_cx + d_cy * d_cy);
   if (c_distance > 1) {
       center.x += d_cx * ease;
       center.y += d_cy * ease;
   }
   if (bz_distance > 1) {
       bz_center.x += d_bzx * ease;
       bz_center.y += d_bzy * ease;
   }
}

class BezierLine {
  private Coord end;
  private float distance;
  private int delay;
  private Coord vary;
  private color c;
  
  public BezierLine() {
    delay = int(random(100));
    int vary_amount = 5;
    vary = new Coord(random(-1*vary_amount,vary_amount), random(-1*vary_amount,vary_amount));
    resetEndpoint();
  }
  
  private void resetEndpoint() {
    float angle = random(360);
    float radius = sqrt((width*width)+(height*height))/2;
    float x = width/2 + cos(angle)*radius;
    float y = height/2 + sin(angle)*radius;
    end = new Coord(x,y);
    distance = constrain(random(-1,speed), 0, speed);
    int picker = (int)random(0,colors.length);
    c = colors[picker];
    println(picker);
  }
  
  public void draw() {
    if(delay > 0) {
      delay --;
      return;
    }
    float x1 = center.x + vary.x;
    float y1 = center.y + vary.y;
    float x2 = center.x + vary.x;
    float y2 = center.y + vary.y;
    float x3 = bz_center.x;
    float y3 = bz_center.y;
    float x4 = end.x;
    float y4 = end.y;
    
    noFill();
    stroke(255);
    //bezier(center.x, center.y, center.x, center.y, bz_center.x, bz_center.y, end.x, end.y);
    float len = map(distance, 0, 1, 0, random(.05));
    float thickness = map(distance, 0, 1, .5, random(1.5, 4));
    float tx1 = bezierPoint(x1, x2, x3, x4, distance);
    float ty1 = bezierPoint(y1, y2, y3, y4, distance);
    float tx2 = bezierPoint(x1, x2, x3, x4, constrain(distance+len, 0, 1));
    float ty2 = bezierPoint(y1, y2, y3, y4, constrain(distance+len, 0, 1));
    stroke(c);
    strokeWeight(thickness*2);
    line(tx1, ty1, tx2, ty2);
    stroke(255,255,255,128);
    strokeWeight(thickness);
    line(tx1, ty1, tx2, ty2);
    distance+=speed;
    if(distance > 1) {
      resetEndpoint();
    }
  }
}

class Coord {
  public float x;
  public float y;
  
  public Coord(float new_x, float new_y) {
    this.x = new_x;
    this.y = new_y;
  }
}

// OSC CALLBACK FUNCTIONS

public void found(int i) {
  //println("found: " + i);
  found = i;
}

public void rawData(float[] raw) {
  rawArray = raw; // stash data in array
}

public void posePosition(float x, float y) {
  //println("pose position\tX: " + x + " Y: " + y );
  //println(center.x + ", " + center.y);
  posePosition.set(x, y, 0);
}

public void poseOrientation(float x, float y, float z) {
  //println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
}