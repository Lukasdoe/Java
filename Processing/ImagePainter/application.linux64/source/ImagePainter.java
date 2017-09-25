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

public class ImagePainter extends PApplet {

ball[][] image;

public void setup() {
  
  image = new ball[width][height];
  image[0][0] = new ball(0, 0);
}

public void draw() {
  if(mousePressed && mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height)image[mouseX][mouseY] = new ball(mouseX, mouseY);
  background(180);
  for (int newx = 0; newx < image.length; newx++) {
    for (int newy = 0; newy < image[0].length; newy++) {
      if (image[newx][newy] != null) {
        image[newx][newy].update();
        image[newx][newy].display();
      }
    }
  }

  for (int x = mouseX - 10; x < mouseX + 10; x++) {
    for (int y = mouseY - 10; y < mouseY + 10; y++) {
      if (x > 0 && x < image.length && y > 0 && y < image[0].length) {
        if (image[x][y] != null){
          image[x][y].applyForce(PVector.random2D().setMag(random(0.1f, 10)));
          image[x][y].i = 0;
        }
      }
    }
  }
}

public void keyPressed(){
  save("canvas.png");
}
class ball {
  int x;
  int y;
  
  float i = 0;

  PVector acc;
  PVector vel;
  PVector pos;

  public ball(int _x, int _y) {
    x = _x; 
    y = _y;

    pos = new PVector(x, y);
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
  }

  public void display() {
    fill(0xffe57824);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
  }

  public void applyForce(PVector strength) {
    acc = strength;
  }

  public void update() {
        PVector dir = pos.copy().sub(new PVector(x, y));
    dir.mult(-1);
    dir.setMag(1);
    if(pos.x != x && pos.y != y) this.applyForce(dir);
    
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    
    if(abs(pos.copy().sub(new PVector(x, y)).mag()) < i){
      pos.x = x;
      pos.y = y;
    }
    
    i += 0.5f;
  }
}
  
  public void settings() {  size(1302, 638); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "ImagePainter" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
