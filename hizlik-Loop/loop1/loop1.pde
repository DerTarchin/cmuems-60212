float x;
float y;
int count = 0;

void setup() {
  size(480, 480);
  background(0);
  noStroke();
  fill(255);
  ellipse(width/2, height/2, min(width, height), min(width, height));
  fill(255,0,0);
  
  float ballR = min(width, height)/2;
  float pathR = min(width, height)/2 - ballR/2;
  float mDiv = 1000.0;
  float t = millis()/mDiv;
  float x = width/2+pathR*cos(t);
  float y = height/2+pathR*sin(t);
  ellipse(x,y,ballR,ballR);
  
  for(int i=0; i<5; i++) {
    fill(200-(i*50), 0,0);
    mDiv /= 2;
    t = millis()/mDiv;
    ballR /= 2;
    pathR = pathR/2;
    x = x+pathR*cos(t);
    y = y+pathR*sin(t);
    ellipse(x,y,ballR,ballR);
  }
}

void draw() {
  count++;
  background(255);
  
  fill(0);
  ellipse(width/2, height/2, min(width, height), min(width, height));
  fill(255);
  float ballR = min(width, height)/2;
  float pathR = min(width, height)/2 - ballR/2;
  float mDiv = 1000.0;
  float t = millis()/mDiv;
  float x = width/2+pathR*cos(t);
  float y = height/2+pathR*sin(t);
  ellipse(x,y,ballR,ballR);
 
  boolean fillB = true;
  
  for(int i=0; i<5; i++) {
    noStroke();
    if(fillB) fill(0);
    else fill(255);
    fillB = !fillB;
    //fill(200-(i*50), 0,0);
    mDiv /= 2;
    t = millis()/mDiv;
    ballR /= 2;
    pathR = pathR/2;
    x = x+pathR*cos(t);
    y = y+pathR*sin(t);
    ellipse(x,y,ballR,ballR);
  }
  saveFrame();
}  