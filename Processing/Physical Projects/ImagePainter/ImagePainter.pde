ball[][] image;

void setup() {
  size(1302, 638);
  image = new ball[width][height];
  image[0][0] = new ball(0, 0);
}

void draw() {
  if(mousePressed && mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height)image[mouseX][mouseY] = new ball(mouseX, mouseY);
  background(180);
  for (int newx = 0; newx < image.length; newx++) {
    for (int newy = 0; newy < image[0].length; newy++) {
      if (image[newx][newy] != null) {
        image[newx][newy].update();
        image[newx][newy].display();
      }
    }
  }

  for (int x = mouseX - 10; x < mouseX + 10; x++) {
    for (int y = mouseY - 10; y < mouseY + 10; y++) {
      if (x > 0 && x < image.length && y > 0 && y < image[0].length) {
        if (image[x][y] != null){
          image[x][y].applyForce(PVector.random2D().setMag(random(0.1, 10)));
          image[x][y].i = 0;
        }
      }
    }
  }
}

void keyPressed(){
  save("canvas.png");
}