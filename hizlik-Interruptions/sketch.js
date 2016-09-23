var lines;
var rowCount = 56;
var linelen = 16;
var frame = 720;
var padding = 60;

function setup() {
	createCanvas(frame, frame);
	background(255);
	initLines();
}

function draw() {
}

function mousePressed() {
	background(255);
	initLines();
}

function initLines() {
	lines = [];
	for(var r = 0; r<rowCount; r++) {
		lines.push([])
		for(var c = 0; c<rowCount; c++) {
			lines[r].push(new Line(new Coord((padding/2) + r*((frame-padding)/rowCount), (padding/2) + c*((frame-padding)/rowCount))));
		}
	}

	hideRandom();

	for(var r=0; r<lines.length; r++) {
		for(var c=0; c<lines[r].length; c++) {
			lines[r][c].draw();
		}
	}
}

function hideRandom() {
	// choose random number of spots to hide
	var numHiddenSpots = constrain(round(randomGaussian(3,6)),0,15);
	for(var i=0; i<numHiddenSpots; i++) {
		var spread = randomGaussian(6,6)
		var vortex = new Coord(round(random(0,rowCount)), round(random(0,rowCount)));
		for(var r=vortex.x-(spread/2); r<vortex.x+(spread/2); r++) {
			for(var c=vortex.y-(spread/2); c<vortex.y+(spread/2); c++) {
				var rI = round(r+randomGaussian(0,2));
				var cI = round(c+randomGaussian(0,2))
				if(rI >= 0 && rI < rowCount && cI >= 0 && cI < rowCount)
					// if(random(0,10)>3)
					lines[rI][cI].hide = true;
			}
		}
	}
}

function Line(c) {
	this.center = c;
	this.angle = random(0,360);
	this.start = new Coord(this.center.x + cos(radians(this.angle))*(linelen/2),
		this.center.y + sin(radians(this.angle))*(linelen/2));
	this.end = new Coord(this.center.x + cos(radians(this.angle))*(linelen/2*-1),
		this.center.y + sin(radians(this.angle))*(linelen/2*-1));
	this.hide = false;

	this.draw = function() {
		if(!this.hide) {
			line(this.start.x, this.start.y, this.end.x, this.end.y);			
		}
	}
}

function Coord(x,y) { 
	this.x = x;
	this.y = y;
}