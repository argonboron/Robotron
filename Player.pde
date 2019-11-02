public class Player extends Being {
  int lives;
  int score;
  boolean invincible, forceField, invisible;

  boolean display() {
    alive = lives > 0;
    velocity.add(acceleration.copy());
    collisionCheck(true);
    velocity.setMag(speed);
    position.add(velocity.copy());
    if (forceField) {
      fill(color(103, 3, 252), 50);
      stroke(103, 3, 252, 50);
      ellipse(position.x, position.y, 100, 100);
      stroke(0);
    }
    if (invincible) {
      int rgb = (int) random(1, 7);
      if (rgb ==1) {
        fill(color(255, 0, (int)random(0, 256)));
      } else if (rgb == 2) {
        fill(color(255, (int)random(0, 256), 0));
      } else if (rgb == 3) {
        fill(color((int)random(0, 256), 0, 255));
      } else if (rgb == 3) {
        fill(color(0, (int)random(0, 256), 255));
      } else if (rgb == 3) {
        fill(color((int)random(0, 256), 255, 0));
      } else if (rgb == 3) {
        fill(color(0, 255, (int)random(0, 256)));
      }
    } else {
      if (invisible) {
        stroke(0, 20);
        fill(255, 20);
        stroke (0);
      } else {
        fill(255);
      }
    }
    ellipseMode(CENTER);
    ellipse(position.x, position.y, size, size);
    fill(255);
    return alive;
  }

  void forceField(boolean force) {
    forceField = force;
  }

  boolean isInvincible() {
    return this.invincible;
  }

  boolean isInvisible() {
    return this.invisible;
  }

  void invisible() {
    invisible = true;
  }

  boolean hasForceField() {
    return this.forceField;
  }

  void gotHuman(int type) {
    //implement scoring
  }

  boolean isMoving() {
    return (velocity.x!=0 || velocity.y !=0);
  }

  void invincible(boolean invincibleHit) {
    if (invincibleHit) {
      invincible = true;
      speed = 4.6;
    } else {
      invincible = false;
      speed = 4;
    }
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
        acceleration.add(new PVector(0, -speed));
      } else {
        acceleration.add(new PVector(0, speed));
      }
    } else if (abs(velocity.x) == 0 && abs(acceleration.x) == 0) {
      if (dir ==2) {
        acceleration.add(new PVector(-speed, 0));
      } else if (dir == 3) {
        acceleration.add(new PVector(speed, 0));
      }
    }
  }

  Player(Cell startCell) {
    speed = 4;
    alive = true;
    invisible = false;
    forceField = false;
    invincible = false;
    size = 18.5; 
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    lives = 3;
    position = startCell.getCentre().copy();
  }
}
