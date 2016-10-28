import processing.pdf.*;
boolean bRecordingPDF;

void setup() {
  size(1000, 1000);
  background(255);
  strokeWeight(2);
  bRecordingPDF = true;
  if (bRecordingPDF) {
    beginRecord(PDF, "render.pdf");
  }
}
boolean canfreeze = true;
void draw() {
  if(canfreeze && millis() > 6770) {
    endRecord();
    bRecordingPDF = false;
    noLoop();
  }
  float ballR = min(width, height)/3;
  float pathR = min(width, height)/3 - ballR/3;
  float mDiv = 1000.0;
  float t = millis()/mDiv;
  float x = width/2.3+pathR*cos(t);
  float y = height/2+pathR*sin(t);
  
  for(int i=0; i<3; i++) {
    //CHANGE THIS NUM:
    float var = 3+i;
    
    fill(0);
    mDiv /= 2;
    t = millis()/mDiv*var;
    pathR = pathR/2;
    x = x+pathR*cos(t);
    y = y+pathR*sin(t);
    point(x,y);
  }
}  

//void mouseClicked() {
//  noLoop();
//  saveFrame();
//}

void keyPressed() {
  endRecord();
  bRecordingPDF = false;
}