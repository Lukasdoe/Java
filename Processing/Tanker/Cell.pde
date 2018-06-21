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
