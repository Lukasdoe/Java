
class Tank{
  PVector dir;
  PVector pos;
  
  int up;
  int left;
  int right;
  int shoot;
  int down;
  
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
  
  void update(boolean[] pressed){
    if(pressed[up]){
      pos.add(dir.copy().mult(speedfactor));
      speedfactor += 0.01;
    }
    else if(pressed[down]){
      pos.add(dir.copy().mult(-speedfactor));
      speedfactor += 0.01;
    }
    else{
      speedfactor = 1.5;
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
    rect(-width/30 / 2, -width/60 / 2, width/30, width/60);
    popMatrix();
  }
}
