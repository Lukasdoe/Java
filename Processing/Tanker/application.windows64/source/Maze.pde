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
  
  Maze(int _s){
    tanks = new ArrayList<Tank>();
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
    tanks.add(new Tank(_pos, _dir, _up, _left, _right, _down, _shoot, _col));
  }
  
  Cell getCell(float x, float y, Cell[][] grid, int size){
    if(floor(x/size) >= 0 && floor(y/size) >= 0){
      return grid[floor(x/size)][floor(y/size)];
    }
    return null;
  }
  
  void updateTanks(boolean[] pressed){
   for(Tank tank : tanks){
     tank.update(pressed, getCell(tank.pos.x, tank.pos.y, grid, s));//, getCell(tank.pos.x - s, tank.pos.y - s, grid, s), getCell(tank.pos.x - s, tank.pos.y + s, grid, s), getCell(tank.pos.x + s, tank.pos.y - s, grid, s), getCell(tank.pos.x + s, tank.pos.y + s, grid, s));
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
    }
  }
}
