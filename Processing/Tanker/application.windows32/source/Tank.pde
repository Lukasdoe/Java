
class Tank{
  PVector dir;
  PVector pos;
  
  int up;
  int left;
  int right;
  int shoot;
  
  color col;
  
  float speedfactor;
  
  Tank(PVector _pos, PVector _dir, int _up, int _left, int _right, int _shoot, color _col){
    dir = _dir.normalize();
    pos = _pos;
    up = _up;
    left = _left;
    right = _right;
    shoot = _shoot;
    speedfactor = 1;
    col = _col;
  }
  
  void update(boolean[] pressed){
    if(pressed[up]){
      pos.add(dir.copy().mult(speedfactor));
      speedfactor += 0.01;
    }
    else{
      speedfactor = 1;
    }
    
    if(pressed[left]) dir.rotate(-0.03);
    if(pressed[right]) dir.rotate(0.03);
    if(pressed[shoot]);
  }
  
  void display(){
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    fill(col);
    stroke(120);
    strokeWeight(3);
    rect(-10, -5, 20, 10);
    popMatrix();
  }
}
