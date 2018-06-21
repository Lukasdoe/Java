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
Maze maze;

public void setup(){
  
  keys = new boolean[256];
  
  maze = new Maze(width/10);
  maze.addTank(new PVector(random(width * 0.1f , width - width * 0.1f), random(height * 0.1f , height - height * 0.1f)), PVector.random2D(), 38, 37, 39, 40, 17, color(255, 0, 0));
  maze.addTank(new PVector(random(width * 0.1f , width - width * 0.1f), random(height * 0.1f , height - height * 0.1f)), PVector.random2D(), 87, 65, 68, 83, 70, color(0, 0, 255));
  maze.createMaze();
}

public void draw(){
  background(70);
  
  maze.updateTanks(keys);
  maze.updateBullets();
  maze.display();
}

public void keyPressed(){
  keys[keyCode] = true;
}

public void keyReleased(){
  keys[keyCode] = false;
}
abstract class Bullet{
 PVector pos;
 PVector dir;
 float speed;
 float w;
 float h; 
 
 public abstract void update(Cell cell, boolean[] edges);
 public abstract void display();
 public abstract boolean collide(PVector pos, Cell cell, boolean[] edges, PVector dir);
 public abstract PVector getDistance( float x1, float y1, float x2, float y2, float x, float y );
}
class Cell{
  int i;
  int j;
  int size;
  boolean[] walls;
  boolean visited;
  
  Cell(int x, int y, int _size){
    i = x;
    j = y;
    size = _size;
    visited = false;
    walls = new boolean[]{true, true, true, true}; //top right bottom left
  }
  
  public void display(int size){
    int x = i * size;
    int y = j * size;
    stroke(255);
    noFill();
    if(walls[0]) line(x, y , x + size, y); 
    if(walls[1]) line(x + size, y , x + size, y + size);
    if(walls[2]) line(x + size, y + size, x, y + size);
    if(walls[3]) line(x, y + size, x, y);
  }
 
  public Cell pickNext(Cell[][] grid, int cols, int rows){
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    if(index(i, j - 1, cols, rows, grid)) neighbors.add(grid[i][j - 1]);
    if(index(i + 1, j, cols, rows, grid)) neighbors.add(grid[i + 1][j]); 
    if(index(i, j + 1, cols, rows, grid)) neighbors.add(grid[i][j + 1]);
    if(index(i - 1, j, cols, rows, grid)) neighbors.add(grid[i - 1][j]);
    if(neighbors.size() > 0) return neighbors.get(floor(random(0, neighbors.size())));
    else return null;
  }
  
  public boolean index(int i, int j, int cols, int rows, Cell[][] grid){
    if (i < 0 || j < 0 || i > cols - 1 || j > rows - 1 || grid[i][j].visited) {
      return false;
    }
    return true;
  }
  
  public void highlight(){
    noStroke();
    fill(255, 0, 0, 30);
    rect(i * size, j * size, size, size);
  }
}
class Maze{
  int s;
  int cols;
  int rows;
  
  ArrayList<Tank> tanks;
  Tank blue;
  
  Cell curr;
  Cell next;
  Cell grid[][];
  
  ArrayList<Cell> stack;
  ArrayList<Bullet> bullets;
  
  Maze(int _s){
    tanks = new ArrayList<Tank>();
    bullets = new ArrayList<Bullet>();
    s = _s;
    cols = floor(width / s);
    rows = floor(height / s);
    grid = new Cell[cols][rows];
    
    for(int x = 0; x < cols; x++){
      for(int y = 0; y < rows; y++){
        grid[x][y] = new Cell(x, y, s);
      }
    }
    
    curr = grid[0][0];
    curr.visited = true;
    
    stack = new ArrayList<Cell>();
    stack.add(curr);
  }
  
  public void addTank(PVector _pos, PVector _dir, int _up, int _left, int _right, int _down, int _shoot, int _col){
    Cell cell = getCell(_pos.x, _pos.y);
    tanks.add(new Tank(new PVector(cell.i * cell.size + cell.size /2, cell.j * cell.size + cell.size / 2), _dir, _up, _left, _right, _down, _shoot, _col));
  }
  
  public Cell getCell(float x, float y){
    if(floor(x/s) >= 0 && floor(y/s) >= 0 && floor(x/s) < cols && floor(y/s) < rows){
      return grid[floor(x/s)][floor(y/s)];
    }
    return null;
  }
  
  public void updateTanks(boolean[] pressed){
   for(Tank tank : tanks){
     Cell cell = getCell(tank.pos.x, tank.pos.y);
     tank.update(pressed, cell, isEdge(cell.i, cell.j));
     if(pressed[tank.shoot]){
        bullets.add(new Standart_Bullet(tank.pos.copy(), tank.dir.copy(), 5)); 
        println(tank.pos.copy().x);
        println(bullets.get(0).pos);
        pressed[tank.shoot] = false;
     }
   }
  }
  
  public void updateBullets(){
    for(Bullet bullet : bullets){
     if(bullet != null && bullet.pos.x >= 0 && bullet.pos.y >= 0 && bullet.pos.x < width && bullet.pos.y < height){
       Cell cell = getCell(bullet.pos.x, bullet.pos.y);
       if(cell != null){
         bullet.update(cell, isEdge(4, 4));
         bullet.display();
       }
     }
   }
  }
  
  public void createMaze(){
    while(stack.size() > 0){
      next = curr.pickNext(grid, cols, rows);
      if(next != null){
        next.visited = true;
        stack.add(curr);
        removeWalls(curr, next);
        curr = next;
      }
      else if (stack.size() > 0) {
        curr = stack.remove(stack.size()-1);
      }
    }
  }
  
  public void removeWalls(Cell a, Cell b){
   int x = a.i - b.i; //used for identify, which walls have to be removed
   int y = a.j - b.j;
   if(x == 1){
     a.walls[3] = false;
     b.walls[1] = false;
   }
   else if(x == -1){
     a.walls[1] = false;
     b.walls[3] = false;
   }
   else if(y == 1){
     a.walls[0] = false;
     b.walls[2] = false;
   }
   else if(y == -1){
     a.walls[2] = false;
     b.walls[0] = false;
   }
  }
  
  public void display(){
    for(int x = 0; x < cols; x++){
      for(int y = 0; y < rows; y++){
        grid[x][y].display(s);
      }
    }
    
    for(Tank tank : tanks){
      tank.display(); 
    }
  }
  
  public boolean[] isEdge(int i, int j){
    boolean[] edges = new boolean[4];
    Cell cell1 = getCell(i - 1, j - 1);
    Cell cell2 = getCell(i - 1, j + 1);
    Cell cell3 = getCell(i + 1, j - 1);
    Cell cell4 = getCell(i + 1, j + 1);
    if(cell1 != null && (cell1.walls[1] || cell1.walls[2])) edges[0] = true; 
    if(cell2 != null && (cell2.walls[0] || cell2.walls[1])) edges[1] = true; 
    if(cell3 != null && (cell3.walls[2] || cell3.walls[3])) edges[2] = true; 
    if(cell4 != null && (cell4.walls[3] || cell4.walls[0])) edges[3] = true; 
    return edges;
  }
}
class Standart_Bullet extends Bullet{
 
 Standart_Bullet(PVector _pos, PVector _dir, float _speed){
   pos = _pos;
   println(pos.x);
   dir = _dir;
   speed = _speed;
    w = 5;
    h = 5; 
 }
 
 public void update(Cell cell, boolean[] edges){
   if(!collide(pos.copy().add(dir.copy().mult(speed)), cell, edges, dir)){
      pos.add(dir.copy().mult(speed));
    }
 }
 
 public void display(){
   fill(20);
   stroke(20);
   ellipse(pos.x, pos.y, 5, 5);
 }

   public boolean collide(PVector pos, Cell cell, boolean[] edges, PVector dir){ //edges is TL BL TR BR
    int x = cell.i * cell.size;
    int y = cell.j * cell.size;
    if(cell.walls[0] && getDistance(x, y, x + cell.size, y, pos.x, pos.y).z < 2){  //top
      dir.y *= -1;
      return true;
    }
    if(cell.walls[1] && getDistance(x + cell.size, y, x + cell.size, y + cell.size, pos.x, pos.y).z < 2){  //right
      dir.x *= -1;
      return true;
    }
    if(cell.walls[2] && getDistance(x + cell.size, y + cell.size, x, y + cell.size, pos.x, pos.y ).z < 2){  //bottom
      dir.y *= -1;
      return true;
    }
    if(cell.walls[3] && getDistance(x, y + cell.size, x, y, pos.x, pos.y).z < 2){  //left
      dir.x *= -1;
      return true;
    }
    //else if((edges[0] && dist(cell.i * cell.size, cell.j * cell.size, pos.x, pos.y) < w / 2 - 1) ||
    //  (edges[1] && dist(cell.i * cell.size, cell.j * cell.size + cell.size, pos.x, pos.y) < w / 2 - 1) ||
    //  (edges[2] && dist(cell.i * cell.size + cell.size, cell.j * cell.size, pos.x, pos.y) < w / 2 - 1) ||
    //  (edges[3] && dist(cell.i * cell.size + cell.size, cell.j * cell.size + cell.size, pos.x, pos.y) < w / 2 - 1)){
    //  return true;
    //}
    return false; 
  }
  
  public PVector getDistance( float x1, float y1, float x2, float y2, float x, float y ){
    PVector result = new PVector(); 
    
    float dx = x2 - x1; 
    float dy = y2 - y1; 
    float d = sqrt( dx*dx + dy*dy ); 
    float ca = dx/d; // cosine
    float sa = dy/d; // sine 
    
    float mX = (-x1+x)*ca + (-y1+y)*sa; 
    
    if( mX <= 0 ){
      result.x = x1; 
      result.y = y1; 
    }
    else if( mX >= d ){
      result.x = x2; 
      result.y = y2; 
     }
    else{
      result.x = x1 + mX*ca; 
      result.y = y1 + mX*sa; 
    }
    
    dx = x - result.x; 
    dy = y - result.y; 
    result.z = sqrt( dx*dx + dy*dy ); 
    
    return result;   
  }

}

class Tank{
  PVector dir;
  PVector pos;
  
  int up;
  int left;
  int right;
  int shoot;
  int down;
  
  int w = width / 45;
  int h = width / 60;
    
  int col;
  
  float speedfactor;
  
  Tank(PVector _pos, PVector _dir, int _up, int _left, int _right, int _down, int _shoot, int _col){
    dir = _dir.normalize();
    pos = _pos;
    up = _up;
    left = _left;
    right = _right;
    down = _down;
    shoot = _shoot;
    speedfactor = 1;
    col = _col;
  }
  
  public void update(boolean[] pressed, Cell cell, boolean[] edges){
    if(pressed[up] && !collide(pos.copy().add(dir.copy().mult(speedfactor)), cell, edges)){
      pos.add(dir.copy().mult(speedfactor));
      speedfactor += 0.01f;
    }
    else if(pressed[down] && !collide(pos.copy().add(dir.copy().mult(-speedfactor)), cell, edges)){
      pos.add(dir.copy().mult(-speedfactor));
      speedfactor += 0.01f;
    }
    else{
      speedfactor = 1.5f;
    }
    
    if(pressed[left]) dir.rotate(-0.03f);
    if(pressed[right]) dir.rotate(0.03f);
    if(pressed[shoot]);
    cell.highlight();
  }
  
  public boolean collide(PVector pos, Cell cell, boolean[] edges){ //edges is TL BL TR BR
    int x = cell.i * cell.size;
    int y = cell.j * cell.size;
    if((cell.walls[0] && getDistance(x, y, x + cell.size, y, pos.x, pos.y - w / 2).z < 2) ||                                  //top
      (cell.walls[1] && getDistance(x + cell.size, y, x + cell.size, y + cell.size, pos.x + w / 2, pos.y).z < 2) ||          //right
      (cell.walls[2] && getDistance(x + cell.size, y + cell.size, x, y + cell.size, pos.x, pos.y + w / 2).z < 2) ||          //bottom
      (cell.walls[3] && getDistance(x, y + cell.size, x, y, pos.x - w / 2, pos.y).z < 2)){                                    //left
      return true;
    }
    else if((edges[0] && dist(cell.i * cell.size, cell.j * cell.size, pos.x, pos.y) < h / 2) ||
      (edges[1] && dist(cell.i * cell.size, cell.j * cell.size + cell.size, pos.x, pos.y) < h / 2) ||
      (edges[2] && dist(cell.i * cell.size + cell.size, cell.j * cell.size, pos.x, pos.y) < h / 2) ||
      (edges[3] && dist(cell.i * cell.size + cell.size, cell.j * cell.size + cell.size, pos.x, pos.y) < h / 2)){
      return true;
    }
    else{
     return false; 
    }
  }
  
  public PVector getDistance( float x1, float y1, float x2, float y2, float x, float y ){
    PVector result = new PVector(); 
    
    float dx = x2 - x1; 
    float dy = y2 - y1; 
    float d = sqrt( dx*dx + dy*dy ); 
    float ca = dx/d; // cosine
    float sa = dy/d; // sine 
    
    float mX = (-x1+x)*ca + (-y1+y)*sa; 
    
    if( mX <= 0 ){
      result.x = x1; 
      result.y = y1; 
    }
    else if( mX >= d ){
      result.x = x2; 
      result.y = y2; 
     }
    else{
      result.x = x1 + mX*ca; 
      result.y = y1 + mX*sa; 
    }
    
    dx = x - result.x; 
    dy = y - result.y; 
    result.z = sqrt( dx*dx + dy*dy ); 
    
    return result;   
  }

  
  public void display(){
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    fill(col);
    stroke(120);
    strokeWeight(3);
    rect(-w/ 2, -h/ 2, w, h);
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
