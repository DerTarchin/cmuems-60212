#includepath "~/Documents/;%USERPROFILE%Documents";
#include "basiljs/bundle/basil.js";

var StringData = b.loadString("data.txt");
var data = b.loadString('data.txt').split("\n");

var side = 7.5*72;
var img;

function parseData(texts) { 
  var hourlyData = [];
  var hours = texts.split("-");
  hourlyData.push([hours[0]]);
  for(var i=1; i<hours.length; i++)
    hourlyData.push(hours[i].split("&"));
  return hourlyData;
}

function getMetaData(hourlyData){
  var info = [];
  info.push(hourlyData[0][0]);
  var texts = 0;
  var chars = 0;
  var atts = 0;
  for(var i=1; i<hourlyData.length; i++) {
    texts += parseInt(hourlyData[i][0]);
    chars += parseInt(hourlyData[i][1]);
    atts += parseInt(hourlyData[i][2]);
  }
  info.push(texts);
  info.push(chars);
  info.push(atts);
  return info;
}

function setup() {

  b.clear (b.doc());
  
  b.noStroke(); 
  img = b.image("dedication_s.png", 0, 0, side, side);
  b.fill(255,255,255);
  b.textSize(12);
  b.textFont("Avenir","Light"); 
  b.textAlign(Justification.CENTER_ALIGN); 
  b.text("for nicole", 0, side/2-8, side, 16);

  // b.fill(175,175,175);
  // b.textSize(13);
  // b.text("special thanks to", 0, side/2-58, side, 16);
  // b.textSize(10);
  // b.text("golan levin", 0, side/2-8, side, 16);
  // b.text("justin livi", 0, side/2+12, side, 16);
  // b.text("adam knuckey", 0, side/2+32, side, 16);

  return

  for(var i=0; i<data.length; i++) {
    b.addPage();

    var date = getMetaData(parseData(data[i]))[0].split(",")[0].split(" ");
    var date_space = 10;
    
    b.fill(175,175,175);
    var tbh = 30;
    b.textSize(tbh-5);
    b.textFont("Avenir","Light"); 
    b.textAlign(Justification.RIGHT_ALIGN);

    b.text(date[0].toUpperCase().substring(0,3), 0, side/2-tbh/2, side/2-date_space/2, tbh);
    b.textFont("Avenir","Black"); 
    b.textAlign(Justification.LEFT_ALIGN);
    b.text(date[1], side/2+date_space/2, side/2-tbh/2, side/2, tbh);

    var y = side-72;
    var iconHeight = 15;
    var chatWidth = iconHeight*1.6;
    var leftSpace = 5;
    var typeX = chatWidth+leftSpace+chatWidth*1.5;
    var clipX = typeX+chatWidth+leftSpace+chatWidth*2;
    var totalWidth = clipX + chatWidth*0.55 + leftSpace + chatWidth*2;
    var x = side/2-totalWidth/2;

    b.textSize(10);
    b.fill(220,220,220);
    b.textFont("Avenir","Black"); 

    img = b.image("chat.png", x, y, chatWidth, iconHeight);
    b.text(getMetaData(parseData(data[i]))[1], x+chatWidth+leftSpace, y+1.5, chatWidth*1.5, 15);
    img = b.image("type.png", x+ typeX, y+1.5, chatWidth, iconHeight*.8);
    b.text(getMetaData(parseData(data[i]))[2], x+typeX+chatWidth+leftSpace, y+1.5, chatWidth*2, 15);
    img = b.image("clip.png", x+ clipX, y+1.5, chatWidth*0.55, iconHeight*.8);
    b.text(getMetaData(parseData(data[i]))[3], x+clipX+chatWidth*0.55+leftSpace, y+1.5, chatWidth*2, 15);


    b.addPage();

    img = b.image("renders/render"+i+".png", 0, 0, side, side);
  }
}

b.go(); 