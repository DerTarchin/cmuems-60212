PImage painting;
PImage drawing;
int index = 17;
int savedIndex = -1;
String file = "../Watercolor_JustinLivi/paintings/painting-"+int(random(400))+"_a.png";

ArrayList<String> used = new ArrayList<String>();

void setup() {
  size(1700,1700);
  reload();
}

void draw() {
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    index--;
    if(index<0) index = 365;
    reload();
  }
  if (key == 'n' || key == 'N') {
    index++;
    if(index >= 366) index = 0;
    reload();
  }
  if (key == 's' || key == 'S') {
    String filename = "renders/render"+index+".png";
    saveFrame(filename);
    if(savedIndex == index)
      used.remove(index);
    used.add(index, file);
    savedIndex = index;
  }
  if (key == 'r' || key == 'R') {
    reload();
  }
}

void reload() {
  background(255);
  String prevFile = file;
  while(used.contains(file) || prevFile.equals(file)) {
    if(round(random(1)) == 1)
      file = "../Watercolor_JustinLivi/paintings/painting-"+int(random(400))+"_a.png";
    else 
      file = "../Watercolor_JustinLivi/paintings/painting-"+int(random(400))+"_b.png";
  }
  println("drawing"+index+".png + "+ file);
  painting = loadImage(file);
  drawing = loadImage("../city_generator/drawings/drawing"+index+".png");
  drawing.filter(INVERT);
  painting.mask(drawing);
  image(painting, 0, 0);
}