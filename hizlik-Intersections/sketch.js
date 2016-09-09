var lines = [];
var numLines = 12;
var width = 720;
var height = 480;

var colors = ['#dad66f', '#8fc942', '#ea76ff', '#54c7b0']

function setup() {
	createCanvas(720, 480);
	background(0);
	initLines();
}

function draw() {}

function mousePressed() {
	background(0);
	initLines();
}

function initLines() {
	lines = []
	for(var i=0; i<numLines; i++) {
		var l = new Line();
	    lines[i] = l;
	    stroke(random(colors));
    	strokeWeight(random(2,6));
	    line(l.x1, l.y1, l.x2, l.y2);
	}
	showIntersections();
}

function Line() {
	this.x1 = random(width);
	this.y1 = random(height);
	this.x2 = random(width);
	this.y2 = random(height);
}

function Coord(x,y) { 
	this.x = x;
	this.y = y;
}

function showIntersections() {
	stroke(255);
	fill(0);
	strokeWeight(3);

	for(var a=0; a<lines.length; a++) {
		for(var b=a+1; b<lines.length; b++) {
			var coord = getIntersection(lines[a], lines[b]);
			var el_w = random(10,20);
			if(coord != null) ellipse(coord.x, coord.y, el_w, el_w);
		}
	}
}

function getIntersection(a, b) {
  var coord = null;
  var de = ((b.y2-b.y1)*(a.x2-a.x1))-((b.x2-b.x1)*(a.y2-a.y1));
  var ua = (((b.x2-b.x1)*(a.y1-b.y1))-((b.y2-b.y1)*(a.x1-b.x1))) / de;
  var ub = (((a.x2-a.x1)*(a.y1-b.y1))-((a.y2-a.y1)*(a.x1-b.x1))) / de;
  if((ua > 0) && (ua < 1) && (ub > 0) && (ub < 1)) {
    var x = a.x1 + (ua * (a.x2-a.x1));
    var y = a.y1 + (ua * (a.y2-a.y1));
    coord = new Coord(x, y);
  }
  return coord;
}