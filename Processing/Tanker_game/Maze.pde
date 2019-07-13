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
  
  void addTank(PVector _pos, PVector _dir, int _up, int _left, int _right, int _down, int _shoot, color _col){
    Cell cell = getCell(_pos.x, _pos.y);
    tanks.add(new Tank(new PVector(cell.i * cell.size + cell.size /2, cell.j * cell.size + cell.size / 2), _dir, _up, _left, _right, _down, _shoot, _col));
  }
  
  void revive(){
    for(Tank tank : tanks){
      Cell cell = getCell(random(width * 0.1 , width - width * 0.1), random(height * 0.1 , height - height * 0.1));
      tank.revive(new PVector(cell.i * cell.size + cell.size /2, cell.j * cell.size + cell.size / 2), PVector.random2D());
    }
  }
  
  Cell getCell(float x, float y){
    if(floor(x/s) >= 0 && floor(y/s) >= 0 && floor(x/s) < cols && floor(y/s) < rows){
      return grid[floor(x/s)][floor(y/s)];
    }
    return null;
  }
  
  void updateTanks(boolean[] pressed){
   for(Tank tank : tanks){
     Cell cell = getCell(tank.pos.x, tank.pos.y);
     tank.update(pressed, cell, isEdge(cell.i, cell.j));
     if(pressed[tank.shoot]){
        bullets.add(new Standart_Bullet(tank.pos.copy().add(tank.dir.copy().setMag(tank.h)), tank.dir.copy(), 5.2)); 
        pressed[tank.shoot] = false;
     }
   }
  }
  
  void updateBullets(){
    for(Bullet bullet : bullets){
     if(bullet != null && bullet.pos.x >= 0 && bullet.pos.y >= 0 && bullet.pos.x < width && bullet.pos.y < height){
       Cell cell = getCell(bullet.pos.x, bullet.pos.y);
       if(cell != null){
         bullet.update(cell, isEdge(cell.i, cell.j));
         bullet.display();
       }
       for(Tank tank : tanks){
        if(dist(bullet.pos.x, bullet.pos.y, tank.pos.x, tank.pos.y) < tank.h){
          background(255, 0, 0, 20);
          for(Tank otherTanks : tanks) if(otherTanks != tank) otherTanks.score++;
          createMaze();
          maze.revive();
          bullets.clear();
          return;
        }
       }
     }
     else{
       bullets.remove(bullet);
       break;
     }
   }
  }
  
  void createMaze(){
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
  
  void removeWalls(Cell a, Cell b){
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
  
  void display(){
    for(int x = 0; x < cols; x++){
      for(int y = 0; y < rows; y++){
        grid[x][y].display(s);
      }
    }
    
    for(Tank tank : tanks){
      tank.display(); 
      textSize(tank.w);
      fill(tank.col, 95);
      textSize(tank.w * 2);
      if(tanks.indexOf(tank) == 0) text(tank.score, s / 3 , s / 2);
      else text(tank.score, s * cols - s * 2 / 3, s / 2); 
    }
  }
  
  boolean[] isEdge(int i, int j){
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
