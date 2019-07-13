class Standart_Bullet extends Bullet{
 
 Standart_Bullet(PVector _pos, PVector _dir, float _speed){
   pos = _pos;
   dir = _dir;
   speed = _speed;
    w = 7;
    h = 7; 
 }
 
 void update(Cell cell, boolean[] edges){
   if(!collide(pos.copy().add(dir.copy().mult(speed)), cell, edges, dir)){
      pos.add(dir.copy().mult(speed));
    }
 }
 
 void display(){
   fill(20);
   stroke(20);
   ellipse(pos.x, pos.y, 5, 5);
 }

   boolean collide(PVector pos, Cell cell, boolean[] edges, PVector dir){ //edges is TL BL TR BR
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
    if(edges[0] && dist(cell.i * cell.size, cell.j * cell.size, pos.x, pos.y) < 2){
      dir.y *= -1;
      return true;
    }
    if(edges[1] && dist(cell.i * cell.size, cell.j * cell.size + cell.size, pos.x, pos.y) < 2){
      dir.y *= -1;
      return true;
    }
    if(edges[2] && dist(cell.i * cell.size + cell.size, cell.j * cell.size, pos.x, pos.y) < 2){
      dir.y *= -1;
      return true;
    }
    if(edges[3] && dist(cell.i * cell.size + cell.size, cell.j * cell.size + cell.size, pos.x, pos.y) < 2){
      dir.y *= -1;
      return true;
    }
    return false; 
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

}
