//Code by Lukas Döllerer, FramePatch

Point[][] image;
PVector acc;
PVector vel;
PVector ballpos;

void setup() {
  size(1302, 638);
  image = new Point[width][height];

  //initialize the mover vectors
  ballpos = new PVector(200, 200);
  acc = new PVector(0, 0);
  vel = new PVector(0, 0);
}

void draw() {
  background(30);
  
  //paint the traingle strip
  beginShape(TRIANGLE_STRIP);
  if (ballpos.x < width && ballpos.y < height && ballpos.x > 0 && ballpos.y > 0)  image[floor(ballpos.x)][floor(ballpos.y)] = new Point(floor(ballpos.x), floor(ballpos.y));
  for (int newx = 0; newx < image.length; newx++) {
    for (int newy = 0; newy < image[0].length; newy++) {
      if (image[newx][newy] != null) {
        image[newx][newy].update();
        image[newx][newy].display();
      }
    }
  }
  endShape();

  for (int x = 0; x < width; x++) {
    for (int y =0; y < height; y++) {
      if (x > 0 && x < image.length && y > 0 && y < image[0].length) {
        if (image[x][y] != null) {
          image[x][y].applyForce(PVector.random2D().setMag(random(0.1, 2)));
        }
      }
    }
  }
  
  //make the mover move
  PVector dir = PVector.random2D();
  dir.setMag(1);
  acc = dir;
  vel.add(acc);
  ballpos.add(vel);
  acc.mult(0);

  //check for the mover on the edges
  if (ballpos.x > width) {
    ballpos.x -= 7;
    vel.mult(-1);
  }
  else if (ballpos.x < 0) {
    ballpos.x += 7;
    vel.mult(-1);
  }
  else if (ballpos.y < 0) {
    ballpos.y += 7;
    vel.mult(-1);
  }
  else if (ballpos.y > height) {
    ballpos.y -=7 ;
    vel.mult(-1);
  }
}

void keyPressed() {
  save("canvas.png");
}