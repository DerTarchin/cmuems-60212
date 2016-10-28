import java.util.*; 
boolean debug = false;

ArrayList<String[][]> texts = new ArrayList<String[][]>();
int index = 0;
int hour = 0;
boolean var3used = false;
boolean var4used = false;
boolean thinused = false;

// VARIATIONS
float overlap = 10;
float ignore = 10;
float xscap = 25;
float smallcap = 50;
float medcap = 200;
float tallcap = 500;

// CITY VARIABLES
float citystartx;
float citystarty;
float building_width;
ArrayList<PImage> trees = new ArrayList<PImage>();

// PAINT
ArrayList<PImage> floors = new ArrayList<PImage>();
ArrayList<PImage> lefts = new ArrayList<PImage>();
ArrayList<PImage> rights = new ArrayList<PImage>();
ArrayList<PImage> mids = new ArrayList<PImage>();

void setup() {
  size(1700,1700); //start 350 in from 1700
  String[] fileLines = loadStrings("../txtcounter/data.txt");
  for(int i=0; i<fileLines.length; i++)
    texts.add(parseData(fileLines[i]));
  
  // trees
  for(int i=0; i<12; i++)
    trees.add(loadImage("greenery/s_treeTop"+i+".png"));
  
  // floors
  for(int i=0; i<10; i++)
    floors.add(loadImage("brushes/floors/floor"+i+".png"));
  
  // lefts
  for(int i=0; i<12; i++)
    lefts.add(loadImage("brushes/lefts/left"+i+".png"));
  
  // rights
  for(int i=0; i<12; i++)
    rights.add(loadImage("brushes/rights/right"+i+".png"));
  
  // mids
  for(int i=0; i<46; i++)
    mids.add(loadImage("brushes/mids/mid"+i+".png"));
  
  citystartx = 350;
  citystarty = (height-350)-(height-700)/3.0;
  building_width = (width-700)/24.0;
  background(255);
  //buildCity(texts.get(index));
  println(getMetadata(texts.get(index)));
}

void draw() {
  // draw background
  if(hour == 0) {
    int floor = int(random(floors.size()));
    image(floors.get(floor),0,-2);
    int left = int(random(lefts.size()));
    if(round(random(2))>0)
      image(lefts.get(left),0,0);
    int right = int(random(rights.size()));
    if(round(random(2))>0)
      image(rights.get(right),0,0);
    for(int i=0; i<round(random(4,6)); i++) {
      int mid = int(random(mids.size()));
      image(mids.get(mid),random(-100,100),0);
    }
    hour ++;
  }
  // draw template
  String[][] data = texts.get(index);
  if(hour>0 && hour<data.length) {
    buildCity(data, hour);
    hour++;
  }
}

void reset() {
  hour = 0;
  background(255);
  var3used = false;
  var4used = false;
  thinused = false;
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    index--;
    if(index<0) index = texts.size()-1;
    println(getMetadata(texts.get(index)));
    reset();
  }
  if (key == 'n' || key == 'N') {
    index++;
    if(index >= texts.size()) index = 0;
    println(getMetadata(texts.get(index)));
    reset();
  }
  if (key == 's' || key == 'S') {
    String filename = "drawings/"+index+" "+texts.get(index)[0][0]+".png";
    saveFrame(filename);
  }
  if (key == 'r' || key == 'R') {
    reset();
  }
}

String getMetadata(String[][] data){
  String info = data[0][0]+" ";
  int texts = 0;
  int att = 0;
  for(int i=1; i<data.length; i++) {
    texts += parseInt(data[i][0]);
    att += parseInt(data[i][2]);
  }
  info += "("+texts+" texts, "+att+" attachments)";
  return info;
}

void buildCity(String[][] data, int i) {
  overlap = random(10);
  float limitter = 8000; //ave 755
  float hval = map(parseInt(data[i][1]), 0, limitter, 0, height/2);
  if(hval < smallcap) { //is small
    fill(255,0,0,128);
  }
  else if(hval >= smallcap && hval < medcap) { //is med
    fill(0,255,0,128);
  } 
  else if(hval >= medcap && hval < tallcap) { //is tall
    fill(0,0,255,128);
  } 
  else { //is super tall
    fill(128,128,128,128);
  }
  if(debug) {
    noStroke();
    rect(citystartx+building_width*(i-1)-overlap, citystarty, building_width+overlap, random(-100,-200));
  }
  if(hval != 0) {
    if(hval <= ignore && parseInt(data[i][2])>0)
      attGroup0(citystartx+building_width*(i-1)-overlap, citystarty, building_width+overlap, parseInt(data[i][2]));
    else
      randomBuilding(citystartx+building_width*(i-1)-overlap, citystarty, building_width+overlap, hval, parseInt(data[i][2]));
  }
}

void randomBuilding(float startx, float starty, float w, float h, int numAtt) {
  // is too small
  if(h <= ignore) {
    var11(startx, starty, w, h, numAtt);
  }
  
  // is xs
  else if(h < xscap) {
    if(round(random(1)) == 0)
      var11(startx, starty, w, h, numAtt);
    else
      var13(startx, starty, w, h, numAtt);
  }
  
  // is small
  else if(h < smallcap) {
    int choice = int(random(100));
    if(choice < 30)
      var9(startx, starty, w, h, numAtt);
    else if(choice < 60)
      oldRoof(startx, starty, w, h, numAtt);
    else if(choice < 90)
      slantRoof(startx, starty, w, h, numAtt);
    else
      basic(startx, starty, w, h, numAtt);
  }
  
  // is medium
  else if(h < medcap) { 
    int choice = int(random(8));
    if(choice == 0)
      oldRoof(startx, starty, w, h, numAtt);
    else if(choice == 1) {
      if(thinused)
        randomBuilding(startx, starty, w, h, numAtt);
      else
        thin(startx, starty, w, h, numAtt);
    }
    else if(choice == 2)
      slantRoof(startx, starty, w, h, numAtt);
    else if(choice == 3)
      basic(startx, starty, w, h, numAtt);
    else if(choice == 4)
      stairstep(startx, starty, w, h, numAtt);
    else if(choice == 5)
      angled(startx, starty, w, h, numAtt);
    else if(choice == 6)
      bevel(startx, starty, w, h, numAtt);
    else
      roundRoof(startx, starty, w, h, numAtt);
  }
  
  // is tall
  else if(h < tallcap) { 
    int choice = int(random(14));
    if(choice == 0)
      var1(startx, starty, w, h, numAtt);
    else if(choice == 1) {
      if(var3used)
        randomBuilding(startx, starty, w, h, numAtt);
      else
        var3(startx, starty, w, h, numAtt);
    }
    else if(choice == 2) {
      if(var4used)
        randomBuilding(startx, starty, w, h, numAtt);
      else
        var4(startx, starty, w, h, numAtt);
    }
    else if(choice == 3)
      var8(startx, starty, w, h, numAtt);
    else if(choice == 4)
      slant(startx, starty, w, h, numAtt);
    else if(choice == 5)
      stairstep(startx, starty, w, h, numAtt);
    else if(choice == 6)
      bevel(startx, starty, w, h, numAtt);
    else if(choice == 7)
      slice(startx, starty, w, h, numAtt);
    else if(choice == 8)
      angled(startx, starty, w, h, numAtt);
    else if(choice == 9)
      blockRoof(startx, starty, w, h, numAtt);
    else if(choice == 10)
      triangleRoof(startx, starty, w, h, numAtt);
    else if(choice == 11)
      basic(startx, starty, w, h, numAtt);
    else if(choice == 12) {
      if(thinused)
        randomBuilding(startx, starty, w, h, numAtt);
      else
        thin(startx, starty, w, h, numAtt);
    }
    else
      var2(startx, starty, w, h, numAtt);
  }
  
  // is super tall
  else { 
    int choice = int(random(100));
    if(choice < 20)
      var1(startx, starty, w, h, numAtt);
    else if(choice < 40)
      var5(startx, starty, w, h, numAtt);
    else if(choice < 60)
      var7(startx, starty, w, h, numAtt);
    else if(choice < 80)
      stairstep(startx, starty, w, h, numAtt);
    else
      var8(startx, starty, w, h, numAtt);
  }
}

String[][] parseData(String texts) { 
  String[][] hourlyData = new String[25][3];
  String[] hours = texts.split("-");
  hourlyData[0] = new String[1];
  hourlyData[0][0] = hours[0];
  for(int i=1; i<hours.length; i++) {
    hourlyData[i] = hours[i].split("&");
  }
  return hourlyData;
}

// ******************** VARIATION DESIGNS ********************* //

void basic(float startx, float starty, float w, float h, int numAtt) {
  noStroke();
  fill(0);
  rect(startx, starty, w, -1*h);
  
  if(numAtt>0)
    attGroup1(startx, starty, w, h, numAtt);
}

void slant(float startx, float starty, float w, float h, int numAtt) {
  int both = round(random(2));
  int left = round(random(1));
  float xr = random(w/6, w/3);
  float xl = random(w/6, w/3);
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  if(both==1) {
    vertex(startx+xl, starty-h);
    vertex(startx+w-xr, starty-h);
  }
  else {
    if(left==1) {
      vertex(startx+xl, starty-h);
      vertex(startx+w, starty-h);
    }
    else {
      vertex(startx, starty-h);
      vertex(startx+w-xr, starty-h);
    }
  }
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt > 0) {
    if(both == 1)
      attGroup1(startx+xl, starty, w-(xr+xl), h, numAtt);
    else if(left == 1)
      attGroup1(startx+xl, starty, w-xl, h, numAtt);
    else
      attGroup1(startx, starty, w-xr, h, numAtt);
  }
}

void bevel(float startx, float starty, float w, float h, int numAtt) {
  int both = round(random(2));
  int left = round(random(1));
  float x1 = random(w/6, w/3); // width of slant
  float y1 = random(h/5); // height of slant
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  if(both==1) {
    vertex(startx, starty-h+y1);
    vertex(startx+x1, starty-h);
    vertex(startx+w-x1, starty-h);
    vertex(startx+w, starty-h+y1);
  }
  else {
    if(left==1) {
      vertex(startx, starty-h+y1);
      vertex(startx+x1, starty-h);
      vertex(startx+w, starty-h);
    }
    else {
      vertex(startx, starty-h);
      vertex(startx+w-x1, starty-h);
      vertex(startx+w, starty-h+y1);
    }
  }
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt > 0) {
    if(both == 1)
      attGroup1(startx+x1, starty, w-x1*2, h, numAtt);
    else if(left == 1)
      attGroup1(startx+x1, starty, w-x1, h, numAtt);
    else
      attGroup1(startx, starty, w-x1, h, numAtt);
  }
}

void slice(float startx, float starty, float w, float h, int numAtt) {
  int left = round(random(1));
  float y1 = random(h/8, h/3); // height of slant
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  if(left==1) {
    vertex(startx, starty-h);
    vertex(startx+w, starty-h+y1);
  }
  else {
    vertex(startx, starty-h+y1);
    vertex(startx+w, starty-h);
  }
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt>0)
    attGroup2(startx+10+random(w-20), starty-h+y1, w, random(h/6, h/4), startx, starty, numAtt);
}

void angled(float startx, float starty, float w, float h, int numAtt) {
  float x1 = random(w/4, w-w/4); // corner point
  float yl = constrain(random(h/3),0,10); // height of left
  float yr = constrain(random(h/3),0,10); // height of right
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+yl);
  vertex(startx+x1, starty-h);
  vertex(startx+w, starty-h+yr);
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt>0)
    attGroup2(startx+10+random(w-20), starty-h+max(yl,yr), w, random(h/8, h/5), startx, starty, numAtt);
}

void stairstep(float startx, float starty, float w, float h, int numAtt) {
  int single = round(random(3));
  int left = round(random(1));
  float x1; //width of left
  float y1; //height of left
  if(single == 0) { // is both
    x1 = random(w/5, w/2);
    y1 = random(h/8, h/3);
  }
  else {
    x1 = random(w/4, w-w/4);
    y1 = random(h/8, h/3);
  }
  
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  if(single==0) {
    stairLeft(startx, starty, w, h, x1, y1);
    stairRight(startx, starty, w, h, x1, y1);
  }
  else if(left == 1) {
    stairLeft(startx, starty, w, h, x1, y1);
    vertex(startx+w, starty-h);
  }
  else {
    vertex(startx, starty-h);
    stairRight(startx, starty, w, h, x1, y1);
  }
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  numAtt = attGroup3(startx, starty, w, h-y1, numAtt);
  if(numAtt > 0) {
    if(single==0)
      attGroup0(startx, starty, w, numAtt);
    else if(left == 1)
      attGroup1(startx+x1, starty, w-x1, h, numAtt);
    else
      attGroup1(startx, starty, w-x1, h, numAtt);
  }
}

void stairLeft(float startx, float starty, float w, float h, float x1, float y1) {
  int steps = round(random(4,6));
  for(int i=0; i<=steps; i++) {
    float x = startx + ((x1/steps)*i);
    float y = (starty-h+y1) - ((y1/steps)*i);
    vertex(x,y);
    vertex(x+(x1/steps),y);
  }
}

void stairRight(float startx, float starty, float w, float h, float x2, float y2) {
  int steps = round(random(4,6));
  for(int i=0; i<steps; i++) {
    float x = startx + (w-x2) + ((x2/steps)*i);
    float y = (starty - h) + ((y2/steps)*i);
    vertex(x,y);
    vertex(x+(x2/steps),y);
  }
}

void blockRoof(float startx, float starty, float w, float h, int numAtt) {
  float y = random(h/2); // height of block
  if(y<20) y = 20;
  float space = random(5,13); //spacing between steps
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y);
  vertex(startx+(w/space), starty-h+y);
  vertex(startx+(w/space), starty-h+y/2);
  vertex(startx+((w/space)*2), starty-h+y/2);
  vertex(startx+((w/space)*2), starty-h);
  //mid
  vertex(startx+w-((w/space)*2), starty-h);
  vertex(startx+w-((w/space)*2), starty-h+y/2);
  vertex(startx+w-(w/space), starty-h+y/2);
  vertex(startx+w-(w/space), starty-h+y);
  vertex(startx+w, starty-h+y);
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  numAtt = attGroup3(startx, starty, w, h-y, numAtt);
  if(numAtt>0)
    attGroup2(startx+((w/space)*2)+5+random((startx+w-((w/space)*2))-(startx+((w/space)*2))-10), starty-h, w, random(h/6, h/4), startx, starty, numAtt);
}

void triangleRoof(float startx, float starty, float w, float h, int numAtt) {
  float y = random(h/15,h/5);
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y);
  vertex(startx+w/2, starty-h);
  vertex(startx+w, starty-h+y);
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt>0)
    attGroup2(startx+w/2, starty, w, h+random(h/6, h/4), startx, starty, numAtt);
}

void roundRoof(float startx, float starty, float w, float h, int numAtt) {
  float y = random(h/5);
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y);
  bezierVertex(startx, starty-h, startx+w/2, starty-h, startx+w/2, starty-h);
  bezierVertex(startx+w, starty-h, startx+w, starty-h+y, startx+w, starty-h+y);
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt>0)
    attGroup2(startx+5+random(w-10), starty, w, h+random(h/8, h/5), startx, starty, numAtt);
}

void oldRoof(float startx, float starty, float w, float h, int numAtt) {
  float x1 = overlap*0.75; //distance from edge
  float y1 = smallcap/4; //height
  float y2 = 3; //edge height
  if(h<=smallcap) {
    h = map(h, 0, smallcap, smallcap-smallcap/3, smallcap);
    float div = random(0.8, 1.8);
    startx += overlap*div;
    w -= (overlap*div)*2;
    x1 /= 3;
    y1 /= 3;
    y2 /= 3;
  }  
  noStroke();
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y1-y2);
  vertex(startx+y2, starty-h+y1-y2);
  vertex(startx+y2, starty-h+y1);
  vertex(startx+x1, starty-h+y1);
  vertex(startx+x1, starty-h+y2);
  vertex(startx+x1-y2, starty-h);
  //mid
  vertex(startx+w-x1+y2, starty-h);
  vertex(startx+w-x1, starty-h+y2);
  vertex(startx+w-x1, starty-h+y1);
  vertex(startx+w-y2, starty-h+y1);
  vertex(startx+w-y2, starty-h+y1-y2);
  vertex(startx+w, starty-h+y1-y2);
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  numAtt = attGroup3(startx, starty, w, h-y1, numAtt);
  if(numAtt > 0)
    attGroup4(startx, starty, w, h, numAtt);
}

void slantRoof(float startx, float starty, float w, float h, int numAtt) {
  float x1 = random(3,8); //horizontal size
  float y1 = random(3,15); //vertical size
  if(h<=smallcap) {
    h = map(h, 0, smallcap, smallcap-smallcap/3, smallcap);
    float div = random(0.8, 1.8);
    startx += overlap*div;
    w -= (overlap*div)*2;
    x1 /= 3;
    y1 /= 3;
  }
  noStroke();
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y1);
  vertex(startx-x1, starty-h);
  vertex(startx+w+x1, starty-h);
  vertex(startx+w, starty-h+y1);
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  numAtt = attGroup3(startx, starty, w, h-y1, numAtt);
}

void thin(float startx, float starty, float w, float h, int numAtt) {
  thinused = true;
  float x1 = random(w/10, w/3); // start point of thin
  float x2 = random(w/2, w*.75); // width of thin
  float y1 = random(h/5, h/3); // height of first
  float y2 = random(h/4, h/2); // height of second
  noStroke();
  fill(0);
  randomBuilding(startx+x1, starty, x2, h, numAtt);
  randomBuilding(startx-overlap/2, starty, overlap/2+x1+x2/2, y1, 0);
  randomBuilding(startx+x1+x2/2, starty, w-(x1+x2/2)+overlap/2, y2, 0);
}

// ******************** FULL DESIGNS ********************* //

void var1(float startx, float starty, float w, float h, int numAtt) {
  startx -= overlap/3;
  w += (overlap/3)*2;
  float x1 = random(w/6, w/4); //slant width
  float y1 = random(h/4, h-h/4); //left slant start
  float y2 = random(20); //slant height
  float y1r = random(h/4,h-h/4); //right slant start
  int uneven = round(random(5));
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-y1);
  vertex(startx+x1, starty-y1-y2);
  vertex(startx+x1, starty-h);
  vertex(startx+w-x1, starty-h);
  if(uneven > 0) {
    vertex(startx+w-x1, starty-y1r-y2);
    vertex(startx+w, starty-y1r);
  }
  else {
    vertex(startx+w-x1, starty-y1-y2);
    vertex(startx+w, starty-y1);
  }
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  attGroup1(startx+x1, starty, w-x1*2, h, numAtt);
}

void var2(float startx, float starty, float w, float h, int numAtt) {
  float x1 = random(w/6, w/4); //slant width
  float y1 = random(h-h/3); //bottom left slant start
  float y2 = random(20); //slant height
  float y1r = random(h-h/4); //bottom right slant start
  float y3 = random(h/3); //top height
  y1=constrain(y1,h/5,h-y3);
  y1r=constrain(y1,h/5,h-y3);
  int uneven = round(random(1));
  noStroke();
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-y1);
  vertex(startx+x1, starty-y1-y2);
  vertex(startx+x1, starty-(h-y3-y2*2));
  vertex(startx+w/4, starty-(h-y3-y2));
  vertex(startx+w/4, starty-(h-y2));
    //mid
  vertex(startx+w/2, starty-h);
  vertex(startx+w/2+w/4, starty-(h-y2));
  vertex(startx+w/2+w/4, starty-(h-y3-y2));
  vertex(startx+w-x1, starty-(h-y3-y2*2));
  if(uneven == 1) {
    vertex(startx+w-x1, starty-y1r-y2);
    vertex(startx+w, starty-y1r);
  }
  else {
    vertex(startx+w-x1, starty-y1-y2);
    vertex(startx+w, starty-y1);
  }
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt>0)
    attGroup2(startx+w/2, starty-h, w, random(h/7, h/4), startx, starty, numAtt);
}

void var3(float startx, float starty, float w, float h, int numAtt) {
  var3used = true;
  startx -= overlap/2;
  w += overlap;
  float y1 = random(h/5, h/2); // start of curve
  float x1 = random(5,w/4); // gap
  int bridges = round(random(1,5));
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y1);
  bezierVertex(startx, starty-h, startx+(w-x1)/2, starty-h, startx+(w-x1)/2, starty-h);
  vertex(startx+(w-x1)/2, starty);
  endShape(CLOSE);
  beginShape();
  vertex(startx+w, starty);
  vertex(startx+w, starty-h+y1);
  bezierVertex(startx+w, starty-h, (startx+w)-(w-x1)/2, starty-h, (startx+w)-(w-x1)/2, starty-h);
  vertex((startx+w)-(w-x1)/2, starty);
  endShape(CLOSE);
  boolean top = true;
  for(int i=0; i<bridges; i++) {
    float y2 = random(h/2); //height on building
    float x3 = random(3,8); //thickness
    if(top) {
      y2 = h-y2;
      top = false;
    } 
    else top = true;
    rect(startx+(w-x1)/2,starty-y2,x1,x3);    
  }
  
  if(numAtt>0)
    attGroup0(startx, starty, w, numAtt);
}

void var4(float startx, float starty, float w, float h, int numAtt) {
  var4used = true;
  float left = round(random(1));
  float xl = random(w/4, w/2); // left "waist" amount
  float xr = random(w/4, w/2); // right "waist" amount
  noStroke();  
  fill(0);
  beginShape();
  vertex(startx, starty);
  if(left == 1)
    vertex(startx+xl, starty-h/2);
  vertex(startx, starty-h);
  vertex(startx+w, starty-h);
  if(left == 0)
    vertex((startx+w)-xr, starty-h/2);
  vertex(startx+w, starty);   
  endShape(CLOSE);
  float weight = random(1.5,5);
  strokeWeight(weight);
  stroke(0);
  if(left==1)
    line(startx+weight, starty-weight, startx+weight, starty-h+weight);
  else
    line(startx+w-weight, starty-weight, startx+w-weight, starty-h+weight);
  
  if(numAtt>0)
    attGroup1(startx, starty, w, h, numAtt);
}

void var5(float startx, float starty, float w, float h, int numAtt) {
  float x1 = random(w/3, w*.75); //width of curve
  int left = round(random(1));
  w += x1/2; // *2?
  noStroke();
  fill(0);
  beginShape();
  if(left == 1) {
    startx -= x1/2;
    vertex(startx, starty);
    bezierVertex(startx+x1, starty, startx+x1, starty-h, startx+x1, starty-h);
    vertex(startx+w, starty-h);
    vertex(startx+w, starty);
  }
  else {
    vertex(startx+w, starty);
    bezierVertex(startx+w-x1, starty, startx+w-x1, starty-h, startx+w-x1, starty-h);
    vertex(startx, starty-h);
    vertex(startx, starty);
  }
  endShape(CLOSE);
  
  if(numAtt>0) {
    if(left == 1)
      attGroup1(startx+x1, starty, w-x1, h, numAtt);
    else
      attGroup1(startx, starty, w-x1, h, numAtt);
  }
}

void var7(float startx, float starty, float w, float h, int numAtt) {
  float x1 = random(w/10, w/3); // width of side
  float x2 = random(w/10, w/3);
  float y1 = random(h); // height of side
  float y2 = random(h);
  noStroke();
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y1);
  vertex(startx+x1, starty-h);
  vertex(startx+w-x2, starty-h);
  vertex(startx+w, starty-h+y2);
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt>0)
    attGroup1(startx+x1, starty, w-x1-x2, h, numAtt);
}

void var8(float startx, float starty, float w, float h, int numAtt) {
  float y1 = random(h-h/4, h); // height of angle corner
  float y2 = random(h/3, h/2); // height of start angle
  int left = round(random(1));
  noStroke();
  fill(0);
  beginShape();
  vertex(startx, starty);
  if(left == 1) {
    vertex(startx, starty-y2);
    vertex(startx+w/3, starty-y1);
    vertex(startx+w, starty-h);
  }
  else {
    vertex(startx, starty-h);
    vertex(startx+w-w/3, starty-y1);
    vertex(startx+w, starty-y2);
  }
  vertex(startx+w, starty);
  endShape(CLOSE);
  
  if(numAtt>0) {
    if(left == 1)
      attGroup2(startx+5+w/3+random(w-w/3-5), starty-y1, w, random(h/5, h/3), startx, starty, numAtt);
    else
      attGroup2(startx+random(w-w/3-5), starty-y1, w, random(h/5, h/3), startx, starty, numAtt);
  }
}

void var9(float startx, float starty, float w, float h, int numAtt) {
  float origW = w;
  w = random(w-w/4, w);
  float y1 = random(8); // side slant height
  float y2 = 8; // top slant height
  float y3 = 10; // tower base height
  float x1 = w/3; // inward amount
  constrain(h, y1+y2+y3+5, smallcap);
  noStroke();
  fill(0);
  beginShape();
  vertex(startx, starty);
  vertex(startx, starty-h+y2+y3+y1);
  vertex(startx+x1, starty-h+y2+y3);
  vertex(startx+x1, starty-h+y2);
  vertex(startx+w/2, starty-h);
    //mid
  vertex(startx+w-w/2, starty-h);
  vertex(startx+w-x1, starty-h+y2);
  vertex(startx+w-x1, starty-h+y2+y3);
  vertex(startx+w, starty-h+y2+y3+y1);
  vertex(startx+w, starty);
  endShape(CLOSE);
  fill(255);
  if(round(random(2)) > 0)
    ellipse(startx+w/2, starty-h+y2+y3/2, x1/3, x1/3);
    
  if(numAtt>0)
    attGroup0(startx, starty, origW, numAtt);
}

void var11(float startx, float starty, float w, float h, int numAtt) {
  float x1 = w/4; // width
  float x2 = random(3); // "wing"
  noStroke();
  fill(0);
  beginShape();
  vertex(startx+w/2-x1/2, starty);
  vertex(startx+w/2-x1/2, starty-h);
  vertex(startx+w/2-x1/2-x2, starty-h);
  vertex(startx+w/2, starty-h-random(4,10));
  vertex(startx+w/2+x1/2+x2, starty-h);
  vertex(startx+w/2+x1/2, starty-h);
  vertex(startx+w/2+x1/2, starty);
  endShape(CLOSE);
  
  if(numAtt>0)
    attGroup0(startx, starty, w, numAtt);
}

void var13(float startx, float starty, float w, float h, int numAtt) {
  float x1 = random(w/4,w); // width
  float x2 = random(3); // "wing"
  float y1 = random(4, 10);
  float start = startx + w/2;
  noStroke();
  fill(0);
  beginShape();
  vertex(start - x1/2, starty);
  vertex(start - x1/2, starty-h);
  vertex(start - x1/2 - x2, starty-h);
  vertex(start - x1/2 + x2*2, starty-h-y1);
  vertex(start + x1/2 - x2*2, starty-h-y1);
  vertex(start + x1/2 + x2, starty-h);
  vertex(start + x1/2, starty-h);
  vertex(start + x1/2, starty);
  endShape(CLOSE);
  
  if(round(random(1)) == 1) {
    beginShape();
    vertex(start - x2, starty-h-y1);
    vertex(start, starty-h-y1-y1/2);
    vertex(start + x2, starty-h-y1);
    endShape(CLOSE);
  }
  
  if(numAtt>0)
    attGroup0(startx, starty, w, numAtt);
}

// ******************** ATTACHMENT DESIGNS ********************* //

// limits to greenery
void attGroup0(float startx, float starty, float w, int numAtt) {
  while(numAtt>0) {
    tree(startx+random(w), starty);
    numAtt -= 10;
  }
}

// limits to blocks, antennas, greenery
void attGroup1(float startx, float starty, float w, float h, int numAtt) { //h = total height
  boolean antennaDone = false;
  while(numAtt > 0) {
    int doAntenna = round(random(1));
    int doSimple = round(random(1));
    if(numAtt>0 && doAntenna==1 && doSimple==0 && !antennaDone) { //two levels
      complexAntenna(constrain(startx+random(w),startx+10, (startx+w)-10), starty-h, random(h/7, h/4));
      numAtt -= 10;
      antennaDone = true;
    }
    if(numAtt>0 && doAntenna==1 && !antennaDone) {
      antenna(startx+5+random(w-10), starty-h, random(h/9, h/5));
      numAtt -= 10;
      antennaDone = true;
    }
    if(numAtt>0) {
      block(startx, startx+w, starty-h);
      numAtt -= 10;
    }
    //draw greenery, last resort
  }
}

// limits to single antenna starting at various heights (calculated beforehand), then greenery
void attGroup2(float startx, float starty, float w, float h, float treeStartx, float treeStarty, int numAtt) {
  antenna(startx, starty, h);
  numAtt -= 10;
  if(numAtt>0)
    attGroup0(treeStartx, treeStarty, w, numAtt);
}

// draws balconies alongside the two vertical edges, returns adjusted numAtt value
int attGroup3(float startx, float starty, float w, float h, int numAtt) {
  if(numAtt > 10) {
    balcony(startx, starty, h);
    balcony(startx+w, starty, h);
    return numAtt - 20;
  }
  return numAtt;
}

// limits to blocks, dishes, watertowers, and greenery
void attGroup4(float startx, float starty, float w, float h, int numAtt) { //h = total height
  boolean towerDone = false;
  boolean dishDone = false;
  while(numAtt > 0) {
    int doTower = round(random(5));
    int doDish = round(random(5));
    if(!towerDone && doTower == 1) {
      watertower(startx+5+random(w-25), starty-h, constrain(map(h,0,medcap,.1,.9), .1, .9));
      numAtt -= 10;
      towerDone = true;
    }
    if(!dishDone && doDish == 1 && numAtt > 0) {
      dish(startx+15+random(w-30), starty-h, constrain(map(h,0,medcap,.5,1), .5, 1));
      numAtt -= 10;
      dishDone = true;
    }
    if(numAtt>0) {
      block(startx+5, startx+w-10, starty-h);
      numAtt -= 10;
    }
    //draw greenery, last resort
  }
}

void antenna(float startx, float starty, float h) {
  strokeWeight(random(1.5,3));
  stroke(0);
  line(startx, starty, startx, starty-h);
}

void complexAntenna(float startx, float starty, float h) {
  float x1 = random(3,8); // distance between beams
  float y1 = random(h/7, h-h/4); // height of secondary beam
  float y2 = random(y1); //connector beam heights
  float y3 = random(y1);
  if(round(random(1))==1) x1 *= -1;
  strokeWeight(random(1.5,3));
  stroke(0);
  line(startx, starty, startx, starty-h);
  strokeWeight(random(1.5,3));
  line(startx+x1, starty, startx+x1, starty-y1);
  line(startx, starty-y2, startx+x1, starty-y2);
  line(startx, starty-y3, startx+x1, starty-y3);
}

void block(float startx, float endx, float starty) {
  float w = random(8, (endx-startx)-(endx-startx)/4); //width
  float h = -1*random(4, w/2); //height
  float x1 = random(startx, endx-w); //start position
  noStroke();
  fill(0);
  rect(x1, starty, w, h);
}

void balcony(float startx, float starty, float hval) {
  int amount = int(map(hval, 0, tallcap, 0, 40));
  float w = 8;
  float h = w/2;
  float x1 = random(w/3,w/2);
  noStroke();
  fill(0);
  for(int i=0; i<amount; i++) {
    rect(startx-x1, starty-(hval/amount)*i-h, w, h);
  }
}

void watertower(float startx, float starty, float scale) {
  float h = 22*scale;
  float w = 15*scale;
  float y1 = h/5.5; // barrel start
  float y2 = h/10; // barrel roof height
  float x1 = w*.8; // barrel width
  noStroke();
  fill(0);
  beginShape();
  vertex(startx, starty-y1);
  vertex(startx, starty-h+y2);
  bezierVertex(startx, starty-h,startx+x1/2, starty-h,startx+x1/2, starty-h);
  bezierVertex(startx+x1, starty-h,startx+x1, starty-h+y2,startx+x1, starty-h+y2);
  vertex(startx+x1, starty-y1);
  endShape(CLOSE);
  strokeWeight(2*scale);
  stroke(0);
  line(startx, starty, startx+w*.1, starty-y1);
  line(startx+x1, starty, (startx+x1)-w*.1, starty-y1);
  line(startx+x1/2, starty, startx+x1/2, starty-y1);
  strokeWeight(1.5*scale);
  line(startx+w, starty, startx+w, starty-h+y2);
  line(startx+w, starty-h+y2*2, startx+w-w*.3, starty-h+y2*2);
}

void dish(float startx, float starty, float scale) {
  float side = 25*scale;
  noFill();
  strokeWeight(2*scale);
  stroke(0);
  if(round(random(1)) == 1) {
    arc(startx, starty-side/2-5, side, side, PI/2, PI);
    line(startx-side*.35, starty, startx-side*.35, starty-side*.35);
    line(startx-side*.35, starty-side*.35, startx-side*.35+side*.2, starty-side*.35-side*.2);
  }
  else {
    arc(startx, starty-side/2-5, side, side, 0, PI-PI/2);
    line(startx+side*.35, starty, startx+side*.35, starty-side*.35);
    strokeWeight(1.5*scale);
    line(startx+side*.35, starty-side*.35, startx+side*.35-side*.2, starty-side*.35-side*.2);
  }
}

void tree(float startx, float starty) {
  int treeIndex = int(random(trees.size()));
  //int y = round(random(25, 50));
  PImage tree = trees.get(treeIndex);
  //tree.resize(0,y);
  image(tree, startx-tree.width/2, starty-tree.height+1);
}