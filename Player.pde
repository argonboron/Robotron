public class Player extends Being {
  int lives;
  int score;

  boolean display() {
    alive = lives > 0;
    velocity.add(acceleration.copy());
    collisionCheck(true);
    velocity.setMag(4);
    position.add(velocity.copy());
    ellipseMode(CENTER);
    ellipse(position.x, position.y, size, size);
    return alive;
  }
  
  void gotHuman(int type) {
    //implement scoring
  }

  boolean isMoving() {
    return (velocity.x!=0 || velocity.y !=0);
  }

  void hit() {
    lives--;
  }

  void stop(int dir) {
    switch (dir) {
    case 0:
      acceleration.y = 0;
      velocity.y = 0;
      break;
    case 1:
      acceleration.y = 0;
      velocity.y = 0;
      break;
    case 2:
      acceleration.x = 0;
      velocity.x = 0;
      break;
    case 3:
      acceleration.x = 0;
      velocity.x = 0;
      break;
    }
  }

  void move(int dir) {
    if (dir < 2 && abs(velocity.y) == 0 && abs(acceleration.y) == 0) {
      if (dir ==0) {
        acceleration.add(new PVector(0, -4));
      } else {
        acceleration.add(new PVector(0, 4));
      }
    } else if (abs(velocity.x) == 0 && abs(acceleration.x) == 0) {
      if (dir ==2) {
        acceleration.add(new PVector(-4, 0));
      } else if (dir == 3) {
        acceleration.add(new PVector(4, 0));
      }
    }
  }

  Player(Cell startCell) {
    alive = true;
    size = 18.5; 
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    lives = 3;
    position = startCell.getCentre().copy();
  }
}
