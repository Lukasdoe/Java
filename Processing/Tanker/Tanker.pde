boolean[] keys;
Tank red;
Tank blue;
Maze maze;

void setup(){
  fullScreen();
  keys = new boolean[256];
  red = new Tank(new PVector(random(20 , width - 20), random(20 , height - 20)), PVector.random2D(), 38, 37, 39, 40, 17, color(255, 0, 0));
  blue = new Tank(new PVector(random(20 , width - 20), random(20 , height - 20)), PVector.random2D(), 87, 65, 68, 83, 70, color(0, 0, 255));

  maze = new Maze(width/10);
  maze.createMaze();
}

void draw(){
  background(70);
  
  red.update(keys);
  blue.update(keys);
  
  red.display();
  blue.display();
  
  maze.display();
}

void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
}
