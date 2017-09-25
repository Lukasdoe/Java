PVector now;
ArrayList<PVector> prev;
PVector next;

float factor = 3;

void setup() {
  size(800, 800);
  now = new PVector(width/2, height/2);
  next = now.copy();
  prev = new ArrayList<PVector>();
  background(0);
  frameRate(100);
}

void draw() {
  for (int i = 0; i< 100; i++) {
    prev.add(now);
    now = ran();
    point(now.x, now.y);
    next = now.copy();
    strokeWeight(2);
    stroke(map(now.x, 0, width, 0, 255), map(now.y, 0, height, 0, 255), 150);
  }
}


PVector ran() {
  boolean goon;
  do {
    int r = floor(random(6));
    switch(r) {
    case 0:
      next.x += factor;
      break;
    case 1:
      next.x -=factor;
      break;
    case 2:
      next.y +=factor;
      break;
    case 3:
      next.y -=factor;
      break;
    case 4:
      next.z +=factor;
      break;
    case 5:
      next.z -=factor;
      break;
    }
    goon = false;
    for (PVector item : prev) {
      if (item.x == next.x && item.y == next.y && item.z == next.z || next.x > width || next.x < 0 || next.y > height || next.y < 0) {

        goon = true;
        break;
      }
      if (next.x > width) next.x -= factor*2;
      if (next.x < 0)next.x += factor*2;
      if (next.y > height)next.y -= factor*2;
      if (next.y < 0)next.y += factor*2;
      if (next.z < -500)next.z += factor*2;
      if (next.z > +500)next.z -= factor*2;
    }
  } while (goon);
  return next.copy();
}

void mousePressed() {
  save("img4.jpg");
}