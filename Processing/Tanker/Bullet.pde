abstract class Bullet{
 PVector pos;
 PVector dir;
 float speed;
 float w;
 float h; 
 
 abstract void update(Cell cell, boolean[] edges);
 abstract void display();
 abstract boolean collide(PVector pos, Cell cell, boolean[] edges, PVector dir);
 abstract PVector getDistance( float x1, float y1, float x2, float y2, float x, float y );
}
