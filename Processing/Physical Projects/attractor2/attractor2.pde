ArrayList<Mover> movers;
ArrayList<PVector> att;
dragger drag;

void setup() {
  //fullScreen();
  size(800, 800);
  translate(width/2, height/2);
  movers = new ArrayList<Mover>();
  att = new ArrayList<PVector>();
  frameRate(60);
}

void draw() {
  if(mousePressed && mouseButton == LEFT){
    beginShape();
    vertex(mouseX, mouseY);
    endShape();
  }
  
  background(0);
  Mover move = new Mover(200, floor(random(100,300)));
  move.v = new PVector(0, 8);
  movers.add(move);
  for (int i = 0; i< movers.size(); i++) {
    for (int j = 0; j< att.size(); j++) {
      movers.get(i).attracted(att.get(j));
      movers.get(i).update();
      movers.get(i).display();
      ellipse(att.get(j).x, att.get(j).y, 10, 10);
    }
  }
  
  if (movers.size() > 1000) {
    movers.remove(0);
  }
  
}

void mousePressed() {
  if (mouseButton == LEFT) {
    drag = new dragger(mouseX, mouseY);
  }
  if (mouseButton == RIGHT) {
    att.add(new PVector(mouseX, mouseY));
  }
}

void mouseReleased(){
  if (mouseButton == LEFT) {
    float lenght = drag.released(mouseX, mouseY);
    drag.dir.setMag(lenght/100);
    Mover move = new Mover(floor(drag.start.x), floor(drag.start.y));
    move.v = drag.dir;
    movers.add(move);
  }
}