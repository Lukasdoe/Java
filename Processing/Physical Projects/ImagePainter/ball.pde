class ball {
  int x;
  int y;
  
  float i = 0;

  PVector acc;
  PVector vel;
  PVector pos;

  public ball(int _x, int _y) {
    x = _x; 
    y = _y;

    pos = new PVector(x, y);
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
  }

  void display() {
    fill(#e57824);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
  }

  void applyForce(PVector strength) {
    acc = strength;
  }

  void update() {
        PVector dir = pos.copy().sub(new PVector(x, y));
    dir.mult(-1);
    dir.setMag(1);
    if(pos.x != x && pos.y != y) this.applyForce(dir);
    
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    
    if(abs(pos.copy().sub(new PVector(x, y)).mag()) < i){
      pos.x = x;
      pos.y = y;
    }
    
    i += 0.5;
  }
}
  