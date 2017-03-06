//drawBalls() refers to the code in the book Generative Design
//in the folder P_2_1_2_03 on http://www.generative-gestaltung.de

//This project utlizes openCV to detect faces
//and draw grids of squares that reacts to the location and size of the face in 3D.

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.opengl.*;

Capture video;
OpenCV opencv;
color moduleColor = color(0);
int moduleAlpha = 180;

Rectangle[] faces;
int grid=30;

void setup() {
  size(640, 480,P3D); //Render the screen in 3D mode
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480); 
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
  
  
}

void draw() {
  opencv.loadImage(video);
  image(video, 0, 0 );
  
  faces=opencv.detect();
  if(faces.length>0){
  drawBalls();
  }
}



void drawBalls() {
  
  stroke(moduleColor, moduleAlpha);//Set stroke for squares
  strokeWeight(3);
  noFill();
  smooth();
  
  for (int gridY=0; gridY<height; gridY+=(grid+5)) {
    for (int gridX=0; gridX<width; gridX+=(grid+5)) {
      
      //Detect the center of the face
      float centerX=faces[0].x+faces[0].width/2;
      float centerY=faces[0].y+faces[0].height/2;
      //The closer to the face the square is, the smaller it is.
      float diameter = dist(centerX, centerY, gridX, gridY);
      diameter = diameter/300 * 40;
      
      pushMatrix();
      translate(gridX, gridY, diameter*5);
      
      //Half of the diagonal length of the face square
      float d=dist(centerX,centerY,faces[0].x,faces[0].y);
      
      //Draw squares only when they are outside the face square
      if(diameter/40*300>d*0.65){
        println(diameter/40*300-d*0.65);
        d=map(diameter/40*300-d*0.65,10,80,20,255);
        fill(255,d);//The closer to the face the square is, the more transparent.
        rect(0, 0, diameter, diameter);
      }
      
      popMatrix();
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}