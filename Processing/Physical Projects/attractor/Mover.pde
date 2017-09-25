class Mover {

  PVector v;
  PVector a;
  PVector pos;
  PVector f;
  float G;

  Mover(int x, int y) {
    pos = new PVector(x, y);
    G = 100;//6.673;
    v = new PVector(0, 0);
    a = new PVector(0, 0);
  }

  void update() {
    v.add(a);
    pos.add(v);
    a.mult(0);
  }

  void display() {
    ellipse(pos.x, pos.y, 5, 5);
  }

  void attracted(PVector tarchet) {
    PVector tarchet_ = tarchet.copy();
    PVector position = pos.copy();
    PVector force = tarchet_.sub(position);
    float d = constrain(force.mag(), 1, 25);
    float strength = (G / (d*d));
    force.setMag(strength);
    a = a.add(force);
  }
}