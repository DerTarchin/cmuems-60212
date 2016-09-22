float speed = 16;
int bg = 255;
int count;

ArrayList<Square> squares = new ArrayList<Square>();

void setup() {
  size(512, 512);
  squares.add(new Square(true));
}

void draw() {
  //count++;
  background(bg);
  //background(color(255,255,255,128));
  //if(count%50==0) {
  //  if(bg==0) squares.add(new Square(true));
  //  else squares.add(new Square(false));
  //  println("added new");
  //}
  for(int i=0; i<squares.size(); i++) {
    squares.get(i).grow();
    squares.get(i).draw();
    if(squares.get(i).isDone()) {
      squares.get(i).reverse();
      if(bg==0) bg = 255;
      else bg = 0;
    }
  }
}

public class Square {
  public float top = 0;
  public float left = 0;
  public float hori = 0;
  public float vert = 0;
  public boolean isBlack;
  public String dir = "right";
  public float transition = 0;
  
  public Square(boolean isBlack) {
    this.isBlack = isBlack;
  }
  
  public boolean isDone() {
    return dir == "done";
  }
  
  public void reverse() {
    if(isBlack) isBlack = false;
    else isBlack = true;
    dir = "right";
  }
  
  public void changeDir() {
    transition = 0;
    if(dir == "right") dir = "down";
    else if(dir == "down") dir = "left";
    else if(dir == "left") dir = "up";
    else if(dir == "up") dir = "done";
  }
  
  public void grow() {
    transition += speed;
    if(dir == "right") {
      hori = map(transition, 0, 100, 0, width*0.25);
      vert = map(transition, 0, 100, 0, height*0.25);
      left = map(transition, 0, 100, 0, width-(width*0.25));
    }
    else if(dir == "down") {
      hori = map(transition, 0, 100, width*0.25, width*0.5);
      vert = map(transition, 0, 100, height*0.25, height*0.5);
      left = map(transition, 0, 100, width-(width*0.25), width-(width*0.5));
      top = map(transition, 0, 100, 0, height-(height*0.5));
    }
    else if(dir == "left") {
      hori = map(transition, 0, 100, width*0.5, width*0.75);
      vert = map(transition, 0, 100, height*0.5, height*0.75);
      left = map(transition, 0, 100, width-(width*0.5), 0);
      top = map(transition, 0, 100, height-(height*0.5), height-(height*0.75));
    }
    else if(dir == "up") {
      hori = map(transition, 0, 100, width*0.75, width);
      vert = map(transition, 0, 100, height*0.75, height);
      top = map(transition, 0, 100, height-(height*0.75), 0);
    }
    if(transition >= 100) changeDir();
  }
  
  public void draw() {
    noStroke();
    if(isBlack) fill(color(0,0,0, 255));
    else fill(color(255,255,255, 255));
    
    rect(left, top, hori, vert);
  }
}