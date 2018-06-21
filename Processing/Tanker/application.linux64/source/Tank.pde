
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
    
  color col;
  
  float speedfactor;
  
  Tank(PVector _pos, PVector _dir, int _up, int _left, int _right, int _down, int _shoot, color _col){
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
  
  void update(boolean[] pressed, Cell cell, boolean[] edges){
    if(pressed[up] && !collide(pos.copy().add(dir.copy().mult(speedfactor)), cell, edges)){
      pos.add(dir.copy().mult(speedfactor));
      speedfactor += 0.01;
    }
    else if(pressed[down] && !collide(pos.copy().add(dir.copy().mult(-speedfactor)), cell, edges)){
      pos.add(dir.copy().mult(-speedfactor));
      speedfactor += 0.01;
    }
    else{
      speedfactor = 1.5;
    }
    
    if(pressed[left]) dir.rotate(-0.03);
    if(pressed[right]) dir.rotate(0.03);
    if(pressed[shoot]);
    cell.highlight();
  }
  
  boolean collide(PVector pos, Cell cell, boolean[] edges){ //edges is TL BL TR BR
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
  
  PVector getDistance( float x1, float y1, float x2, float y2, float x, float y ){
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

  
  void display(){
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
