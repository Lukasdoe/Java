import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Tanker extends PApplet {

boolean[] keys;
Tank red;
Tank blue;

public void setup(){
  
  keys = new boolean[256];
  red = new Tank(new PVector(width/2, height/2), PVector.random2D(), 38, 37, 39, 17, color(255, 0, 0));
  blue = new Tank(new PVector(width/2 + 100, height/2 + 100), PVector.random2D(), 87, 65, 68, 70, color(0, 0, 255));
}

public void draw(){
  background(70);
  
  red.update(keys);
  blue.update(keys);
  
  red.display();
  blue.display();
}

public void keyPressed(){
  keys[keyCode] = true;
}

public void keyReleased(){
  keys[keyCode] = false;
}

class Tank{
  PVector dir;
  PVector pos;
  
  int up;
  int left;
  int right;
  int shoot;
  
  int col;
  
  float speedfactor;
  
  Tank(PVector _pos, PVector _dir, int _up, int _left, int _right, int _shoot, int _col){
    dir = _dir.normalize();
    pos = _pos;
    up = _up;
    left = _left;
    right = _right;
    shoot = _shoot;
    speedfactor = 1;
    col = _col;
  }
  
  public void update(boolean[] pressed){
    if(pressed[up]){
      pos.add(dir.copy().mult(speedfactor));
      speedfactor += 0.01f;
    }
    else{
      speedfactor = 1;
    }
    
    if(pressed[left]) dir.rotate(-0.03f);
    if(pressed[right]) dir.rotate(0.03f);
    if(pressed[shoot]);
  }
  
  public void display(){
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    fill(col);
    stroke(120);
    strokeWeight(3);
    rect(-10, -5, 20, 10);
    popMatrix();
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Tanker" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
