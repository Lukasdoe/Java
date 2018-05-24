boolean[] keys;
Maze maze;

void setup(){
  fullScreen();
  keys = new boolean[256];
  
  maze = new Maze(width/10);
  maze.addTank(new PVector(random(width * 0.1 , width - width * 0.1), random(height * 0.1 , height - height * 0.1)), PVector.random2D(), 38, 37, 39, 40, 17, color(255, 0, 0));
  maze.addTank(new PVector(random(width * 0.1 , width - width * 0.1), random(height * 0.1 , height - height * 0.1)), PVector.random2D(), 87, 65, 68, 83, 70, color(0, 0, 255));
  maze.createMaze();
}

void draw(){
  background(70);
  
  maze.updateTanks(keys);
  maze.updateBullets();
  maze.display();
}

void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
}
