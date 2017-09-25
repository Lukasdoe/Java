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

public class GraphicsFlyer extends PApplet {

//Code by Lukas D\u00f6llerer, FramePatch

Point[][] image;
PVector acc;
PVector vel;
PVector ballpos;

public void setup() {
  
  image = new Point[width][height];

  //initialize the mover vectors
  ballpos = new PVector(200, 200);
  acc = new PVector(0, 0);
  vel = new PVector(0, 0);
}

public void draw() {
  background(30);
  
  //paint the traingle strip
  beginShape(TRIANGLE_STRIP);
  if (ballpos.x < width && ballpos.y < height && ballpos.x > 0 && ballpos.y > 0)  image[floor(ballpos.x)][floor(ballpos.y)] = new Point(floor(ballpos.x), floor(ballpos.y));
  for (int newx = 0; newx < image.length; newx++) {
    for (int newy = 0; newy < image[0].length; newy++) {
      if (image[newx][newy] != null) {
        image[newx][newy].update();
        image[newx][newy].display();
      }
    }
  }
  endShape();

  for (int x = 0; x < width; x++) {
    for (int y =0; y < height; y++) {
      if (x > 0 && x < image.length && y > 0 && y < image[0].length) {
        if (image[x][y] != null) {
          image[x][y].applyForce(PVector.random2D().setMag(random(0.1f, 2)));
        }
      }
    }
  }
  
  //make the mover move
  PVector dir = PVector.random2D();
  dir.setMag(1);
  acc = dir;
  vel.add(acc);
  ballpos.add(vel);
  acc.mult(0);

  //check for the mover on the edges
  if (ballpos.x > width) {
    ballpos.x -= 7;
    vel.mult(-1);
    vel.add(PVector.random2D());
  }
  else if (ballpos.x < 0) {
    ballpos.x += 7;
    vel.mult(-1);
    vel.add(PVector.random2D());
  }
  else if (ballpos.y < 0) {
    ballpos.y += 7;
    vel.mult(-1);
    vel.add(PVector.random2D());
  }
  else if (ballpos.y > height) {
    ballpos.y -=7 ;
    vel.mult(-1);
    vel.add(PVector.random2D());
  }
}

public void keyPressed() {
  save("canvas.png");
}
class Point {
  //i is the "lifetime" variable
  float i;

  PVector acc;
  PVector vel;
  PVector pos;

  public Point(int _x, int _y) {
    pos = new PVector(_x, _y);
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
    i = 0;
  }

  public void display() {
    if (i < 100) {
      fill(0xffe57824);
      vertex(pos.x, pos.y);
    }
  }

  public void applyForce(PVector strength) {
    if (i < 100) {
      acc = strength;
    }
  }

  public void update() {
    if (i < 100) {
      this.applyForce( PVector.random2D());

      vel.add(acc);
      pos.add(vel);
      acc.mult(0);

      i += 5;
    }
  }
}
  public void settings() {  size(1302, 638); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "GraphicsFlyer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
