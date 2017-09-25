class Point {
  //i is the "lifetime" variable
  float i;

  PVector acc;
  PVector vel;
  PVector pos;

  public Point(int _x, int _y) {
    pos = new PVector(_x, _y);
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
    i = 0;
  }

  void display() {
    if (i < 100) {
      fill(#e57824);
      vertex(pos.x, pos.y);
    }
  }

  void applyForce(PVector strength) {
    if (i < 100) {
      acc = strength;
    }
  }

  void update() {
    if (i < 100) {
      this.applyForce( PVector.random2D());

      vel.add(acc);
      pos.add(vel);
      acc.mult(0);

      i += 5;
    }
  }
}