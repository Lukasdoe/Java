class dragger {
  PVector start;
  PVector end;
  PVector dir;
  dragger(int x, int y) {
    start = new PVector(x, y);
  }

  float released(int x, int y) {
    end = new PVector(x, y);
    dir = end.sub(start);
    return sqrt(pow((end.x - start.x), 2) + pow((end.y - start.y), 2));
  }
}