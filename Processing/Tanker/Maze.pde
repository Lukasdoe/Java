class Cell{
  int i;
  int j;
  boolean[] walls;
  boolean visited;
  
  Cell(int x, int y){
    i = x;
    j = y;
    visited = false;
    walls = new boolean[]{true, true, true, true}; //top right bottom left
  }
  
  void display(int size){
    int x = i * size;
    int y = j * size;
    stroke(255);
    noFill();
    if(walls[0]) line(x, y , x + size, y); 
    if(walls[1]) line(x + size, y , x + size, y + size);
    if(walls[2]) line(x + size, y + size, x, y + size);
    if(walls[3]) line(x, y + size, x, y);
  }
 
  Cell pickNext(Cell[][] grid, int cols, int rows){
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    if(index(i, j - 1, cols, rows, grid)) neighbors.add(grid[i][j - 1]);
    if(index(i + 1, j, cols, rows, grid)) neighbors.add(grid[i + 1][j]); 
    if(index(i, j + 1, cols, rows, grid)) neighbors.add(grid[i][j + 1]);
    if(index(i - 1, j, cols, rows, grid)) neighbors.add(grid[i - 1][j]);
    if(neighbors.size() > 0) return neighbors.get(floor(random(0, neighbors.size())));
    else return null;
  }
  
  boolean index(int i, int j, int cols, int rows, Cell[][] grid){
    if (i < 0 || j < 0 || i > cols - 1 || j > rows - 1 || grid[i][j].visited) {
      return false;
    }
    return true;
  }
}

class Maze{
  int s;
  int cols;
  int rows;
  
  Cell curr;
  Cell next;
  Cell grid[][];
  
  ArrayList<Cell> stack;
  
  Maze(int _s){
    s = _s;
    cols = floor(width / s);
    rows = floor(height / s);
    grid = new Cell[cols][rows];
    
    for(int x = 0; x < cols; x++){
      for(int y = 0; y < rows; y++){
        grid[x][y] = new Cell(x, y);
      }
    }
    
    curr = grid[0][0];
    curr.visited = true;
    
    stack = new ArrayList<Cell>();
    stack.add(curr);
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
  }
}
