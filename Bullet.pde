public class Bullet {
  PVector position, velocity, target;
  final float size = 7; 
  boolean playerSend;

  void display() {
    this.position.add(velocity);
    ellipseMode(CENTER);
    if (playerSend) {
      fill(0, 80, 222);
    } else {
      fill(206, 0, 0);
    }
    ellipse(this.position.x, this.position.y, size, size);
    fill(255);
  }
  
  PVector getPosition() {
    return this.position.copy();
  }

  public Bullet(PVector start, PVector target, boolean playerSend) {
    this.position = start;
    this.velocity = target.copy().sub(start);
    this.velocity.normalize();
    this.velocity.setMag(5);
    this.playerSend = playerSend;
  }
}
