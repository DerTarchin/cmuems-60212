/*
 * WatercolorSediment
 * May, 2011
 *
 * Copyright 2011  Justin Livi
 * justinlivi.net
 * Written in Processing
 *
 */

int seedcount = 10; // default = 50
float h, maxh, start; // overall distance from center
float vspeed, rspeed;
float theta = 0;
float speed = 1;
float rot;
boolean up = false;
float[] hm; // hue array
float[] sm; // saturation array
float[] lm; // lightness array
float[] dhm; // delta hue array
float[] dsm; // delta saturation array
float[] dlm; // delta lightness array
float[] dm; // distance array
float[] stm; // streakiness array
HSL hsl = new HSL();

int count = 0;
boolean a = true;
boolean pause;

void setup() {
  size(1700, 1700);
  smooth();
  noStroke();
  background(255);
  if(width > height)
    maxh = height;
  else
    maxh = width;
  hm = new float[seedcount];
  sm = new float[seedcount];
  lm = new float[seedcount];
  dhm = new float[seedcount];
  dsm = new float[seedcount];
  dlm = new float[seedcount];
  dm = new float[seedcount];
  stm = new float[seedcount];
  reset();
}

void draw() {
  if(pause) { return; }
  if (theta < width) {
    pushMatrix();
      translate(theta, 0);
      rotate(PI/2);
      generate();
    popMatrix();
    theta++;
  }
  else if(count<400) {
    if(a) {
      saveFrame("paintings/painting-"+count+"_a.png");
      a = false;
    }
    else {
      saveFrame("paintings/painting-"+count+"_b.png");
      a = true;
      count++;
    }
    reset();
  }
}

void mousePressed() {
  pause = !pause;
  //background(255);
  //reset();
}

void reset() {
  seedcount = (int)random(8, seedcount); 
  float centerhue = random(0, 360);
  float variance = random(10, 40);
  for(int count = 0; count < seedcount; count++) {
    hm[count] = random(centerhue-variance, centerhue+variance);
    sm[count] = random(45, 70);
    lm[count] = random(20, 90);
    dhm[count] = hm[count];
    dsm[count] = sm[count];
    dlm[count] = lm[count];
    dm[count] = random(maxh);
    stm[count] = random(.1, 1);
  }
  dm[0] = 0;
  dm[seedcount-1] = height;
  dm = sort(dm, seedcount);
  h = 0;
  start = h;
  theta = -20;
  vspeed = random(1, 9);
  rspeed = random(1, 4);
}

void generate() {
  for(int count = 0; count < seedcount; count++) {
    changeDm(count);
    fill(hsl.toRGB(dhm[count],dsm[count],dlm[count],100));
    blend(count, dm[count]); 
  }
  dm = sort(dm, seedcount);
}


// ---------------------- POSITION! ------------------------------------ // 

void changeDm(int count) {
  int prev = 0;
  int next = seedcount-1;
  if(count > 0)
    prev = count-1;
  if(count < seedcount-1)
    next = count+1;
  if(count == seedcount-1)
    prev = seedcount-1;
  if(count == 0)
    next = 0;
  dm[count] = constrain(dm[count]+random(-1, 1), 0, height);
  if (count == 0)
    dm[count] = 0;
  else if (count == seedcount-1)
    dm[count] = height;
}


// ---------------------- BLEND! ------------------------------------ // 

void blend(int count, float distance) {
  int prev = seedcount-1;
  if(count < seedcount-1)
    prev = count+1;
  float formax = abs(dm[prev]-distance);
  changeColor(count);
  for(int count2 = 0; count2 < formax; count2++) {
    for(int count3 = 0; count3 < (10/3.0*stm[count]+5/3.0); count3++) {
      float hi = (dhm[prev]-dhm[count])/formax;
      float si = (dsm[prev]-dsm[count])/formax;
      float li = (dlm[prev]-dlm[count])/formax;
      fill(hsl.toRGB(dhm[count]+random(-1,1)+(count2*hi),
                    dsm[count]+random(-.5,.5)+(count2*si),
                    dlm[count]+random(-.5,.5)+(count2*li), random(2, 10)));
      pushMatrix();
        translate(distance+count2+random(-1,1), random(-stm[count]*10,stm[count]*10));
        rotate(random(PI*2));
        ellipse(0, 0, random(2, 10+5*stm[count]), random(2, 10+5*stm[count]));
      popMatrix();
    }
  }
}

void changeColor(int count) {
  stm[count] += random(-.01, .01);
  stm[count] = constrain(stm[count], .1, 1);
  dhm[count] += random(-stm[count], stm[count]);
  dhm[count] = constrain(dhm[count], hm[count]-20, hm[count]+20);
  dsm[count] += random(-stm[count], stm[count]);
  dsm[count] = constrain(dsm[count], sm[count]-20, sm[count]+20);
  dlm[count] += random(-stm[count], stm[count]);
  dlm[count] = constrain(dlm[count], lm[count]-20, lm[count]+20);
}

class HSL {
  color toRGB(float H, float S, float L) {
    float R = 0, G = 0, B = 0;
    H /= 360;
    S /= 100;
    L /= 100;
    float temp1 = 0, temp2 = 0, Rtemp3 = 0, Gtemp3 = 0, Btemp3 = 0;
    if (S == 0) {
      R = L;
      G = L;
      B = L;
    }
    else {
      if (L < 0.5)
        temp2 = L*(1.0+S);
      else if (L >= 0.5)
        temp2 = L+S-L*S;
      temp1 = 2.0*L-temp2;
      Rtemp3 = H+1.0/3.0;
      
      if (Rtemp3 < 0)
        Rtemp3 = Rtemp3 + 1.0;
      if (Rtemp3 > 1)
        Rtemp3 = Rtemp3 - 1.0;
        
      Gtemp3 = H;
      if (Gtemp3 < 0)
        Gtemp3 = Gtemp3 + 1.0;
      if (Gtemp3 > 1)
        Gtemp3 = Gtemp3 - 1.0;
        
      Btemp3 = H-1.0/3.0;
      if (Btemp3 < 0)
        Btemp3 = Btemp3 + 1.0;
      if (Btemp3 > 1)
        Btemp3 = Btemp3 - 1.0;
        
      if (6.0*Rtemp3 < 1)
        R = temp1+(temp2-temp1)*6.0*Rtemp3;
      else if (2.0*Rtemp3 < 1)
        R = temp2;
      else if (3.0*Rtemp3 < 2)
        R = temp1+(temp2-temp1)*((2.0/3.0)-Rtemp3)*6.0;
      else
        R = temp1;
        
      if (6.0*Gtemp3 < 1)
        G = temp1+(temp2-temp1)*6.0*Gtemp3;
      else if (2.0*Gtemp3 < 1)
        G = temp2;
      else if (3.0*Gtemp3 < 2)
        G = temp1+(temp2-temp1)*((2.0/3.0)-Gtemp3)*6.0;
      else
        G = temp1;
        
      if (6.0*Btemp3 < 1)
        B = temp1+(temp2-temp1)*6.0*Btemp3;
      else if (2.0*Btemp3 < 1)
        B = temp2;
      else if (3.0*Btemp3 < 2)
        B = temp1+(temp2-temp1)*((2.0/3.0)-Btemp3)*6.0;
      else
        B = temp1;
    }
      
    R *= 255;
    B *= 255;
    G *= 255;
    
    return color((int)R, (int)G, (int)B);
  }
  
  color toRGB(float H, float S, float L, float A) {
    float R = 0, G = 0, B = 0;
    H /= 360;
    S /= 100;
    L /= 100;
    float temp1 = 0, temp2 = 0, Rtemp3 = 0, Gtemp3 = 0, Btemp3 = 0;
    if (S == 0) {
      R = L;
      G = L;
      B = L;
    }
    else {
      if (L < 0.5)
        temp2 = L*(1.0+S);
      else if (L >= 0.5)
        temp2 = L+S-L*S;
      temp1 = 2.0*L-temp2;
      Rtemp3 = H+1.0/3.0;
      
      if (Rtemp3 < 0)
        Rtemp3 = Rtemp3 + 1.0;
      if (Rtemp3 > 1)
        Rtemp3 = Rtemp3 - 1.0;
        
      Gtemp3 = H;
      if (Gtemp3 < 0)
        Gtemp3 = Gtemp3 + 1.0;
      if (Gtemp3 > 1)
        Gtemp3 = Gtemp3 - 1.0;
        
      Btemp3 = H-1.0/3.0;
      if (Btemp3 < 0)
        Btemp3 = Btemp3 + 1.0;
      if (Btemp3 > 1)
        Btemp3 = Btemp3 - 1.0;
        
      if (6.0*Rtemp3 < 1)
        R = temp1+(temp2-temp1)*6.0*Rtemp3;
      else if (2.0*Rtemp3 < 1)
        R = temp2;
      else if (3.0*Rtemp3 < 2)
        R = temp1+(temp2-temp1)*((2.0/3.0)-Rtemp3)*6.0;
      else
        R = temp1;
        
      if (6.0*Gtemp3 < 1)
        G = temp1+(temp2-temp1)*6.0*Gtemp3;
      else if (2.0*Gtemp3 < 1)
        G = temp2;
      else if (3.0*Gtemp3 < 2)
        G = temp1+(temp2-temp1)*((2.0/3.0)-Gtemp3)*6.0;
      else
        G = temp1;
        
      if (6.0*Btemp3 < 1)
        B = temp1+(temp2-temp1)*6.0*Btemp3;
      else if (2.0*Btemp3 < 1)
        B = temp2;
      else if (3.0*Btemp3 < 2)
        B = temp1+(temp2-temp1)*((2.0/3.0)-Btemp3)*6.0;
      else
        B = temp1;
    }
      
    R *= 255;
    B *= 255;
    G *= 255;
    
    return color((int)R, (int)G, (int)B, (int)A);
  }
}