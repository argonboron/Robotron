public class Bullet {
  PVector position;
  PVector velocity;
  PVector target;
  final float size = 7; 

  void display() {
    position.add(velocity);
    ellipseMode(CENTER);
    fill(0, 80, 222);
    ellipse(position.x, position.y, size, size);
    fill(255);
  }

  public Bullet(PVector start, PVector target) {
    this.position = start;
    velocity = target.copy().sub(start);
    velocity.normalize();
    velocity.setMag(5);
  }
}
