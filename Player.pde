public class Player extends Being {
  int lives;
  PVector velocity;
  PVector position;
  PVector acceleration;

  void display() {
    velocity.add(acceleration.copy());
    collisionCheck();
    velocity.setMag(4);
    position.add(velocity.copy());
    ellipseMode(CENTER);
    ellipse(position.x, position.y, 18.5, 18.5);
  }

  void collisionCheck() {
    int[] index = map.pointToIndex(position.copy());
    int neighbours = map.countLivingNeighbours(index[0], index[1]);
    boolean hit = false;
    if (neighbours > 0) {
      if (map.isHittingWall(position.copy(), "up")) {
          hit = true;
        if (velocity.y < 0) {
          velocity.y=0;
        }
      }
      if (map.isHittingWall(position.copy(), "down")) {
          hit = true;
        if (velocity.y > 0) {
          velocity.y=0;
          hit = true;
        }
      }
      if (map.isHittingWall(position.copy(), "left")) {
          hit = true;
        if (velocity.x < 0) {
          velocity.x=0;
        }
      }
      if (map.isHittingWall(position.copy(), "right")) {
          hit = true;
        if (velocity.x > 0) {
          velocity.x=0;
        }
      }
      if (!hit) {
        if (map.isHittingWall(position.copy(), "topright")) {
          if (velocity.x > 0) {
            velocity.x=0;
          }
          if (velocity.y < 0) {
            velocity.y=0;
          }
        }
        if (map.isHittingWall(position.copy(), "bottomright")) {
          if (velocity.x > 0) {
            velocity.x=0;
          }        
          if (velocity.y > 0) {
            velocity.y=0;
          }
        }
        if (map.isHittingWall(position.copy(), "topleft")) {
          if (velocity.y < 0) {
            velocity.y=0;
          }
          if (velocity.x < 0) {
            velocity.x=0;
          }
        }
        if (map.isHittingWall(position.copy(), "bottomleft")) {
          if (velocity.y > 0) {
            velocity.y=0;
          }
          if (velocity.x < 0) {
            velocity.x=0;
          }
        }
      }
      hit = false;
    }
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
    println(acceleration);
    println(velocity);
    velocity.setMag(4);
  }

  Player(Cell startCell) {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    lives = 3;
    position = startCell.getCentre().copy();
  }
}
