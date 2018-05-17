boolean[] keys;
Tank red;
Tank blue;

void setup(){
  fullScreen();
  keys = new boolean[256];
  red = new Tank(new PVector(width/2, height/2), PVector.random2D(), 38, 37, 39, 17, color(255, 0, 0));
  blue = new Tank(new PVector(width/2 + 100, height/2 + 100), PVector.random2D(), 87, 65, 68, 70, color(0, 0, 255));
}

void draw(){
  background(70);
  
  red.update(keys);
  blue.update(keys);
  
  red.display();
  blue.display();
}

void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
}
