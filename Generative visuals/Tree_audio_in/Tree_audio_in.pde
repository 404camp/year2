/**
 * Recursive Tree
 * by Daniel Shiffman.  Edited to suit our needs by Nick Alexander and Lucian Blankevoort
 * 
 * Renders a simple tree-like structure via recursion. 
 * The branching angle is calculated as a function of 
 * the horizontal mouse location. Move the mouse left
 * and right to change the angle.
 * EDIT: Audio signal drives tree parameters
 */

import processing.sound.*;
Amplitude amp;
AudioIn in;

float theta;  
//float amplitude = amp.analyze();
//float m = map(amplitude, 0.0, 0.5, 10.0, 40.0);
int LINE_LENGTH = 200;
int lineColor = -1;
color strokeColor = 0xFF0000FF;



void setup() {
  //size(640, 360);
  fullScreen(1);
  background(0);
  noStroke();
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}

void mouseClicked() {
  
  println(lineColor);
  println(strokeColor);
  strokeColor =(lineColor < 3) ? (strokeColor << 8) : 0x000000FF;
  if(lineColor >= 3) lineColor = -1 ;
  lineColor++;
  
  
}

void modColor(){
   //strokeColor =(lineColor < 3) ? (strokeColor << 8) : 0x000000FF;
   int blue = (strokeColor >> 16) & 0xFF;
   blue = (ceil(blue+random(5)))%255;
   int red = (strokeColor >> 8) & 0xFF;;
   red = (ceil(red+random(5)))%255;
   int green = (strokeColor ) & 0xFF;
   green = (ceil(green+random(5)))%255;
   strokeColor =  0xFF000000 | (blue << 16) | (red << 8) | (green );
  //if(lineColor >= 3) lineColor = -1 ;
  //lineColor++;
  stroke(strokeColor);
}

void decay(float x) {
  if (newx < x){
    newx = newx-1;
  } else {
    newx = x;
  }
  return newx;
}

void draw() {
  background(0);
  frameRate(30);
  //println(amp.analyze());
 // println(lineColor);
 // println(strokeColor);
  //stroke((strokeColor | 0xFF000000));
  modColor();
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (((amp.analyze()*5)) + (mouseX / ((float) width))/2) * 90f;
  LINE_LENGTH = int((((amp.analyze()*2)) + (mouseY / ((float) height))/2)*(height/2));
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2,height);
  // Draw a line 120 pixels
  line(0,0,0,-LINE_LENGTH);
  // Move to the end of that line
  translate(0,-LINE_LENGTH);
  // Start the recursive branching!
  branch(LINE_LENGTH);

}

void branch(float h) {
  //modColor();
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}
