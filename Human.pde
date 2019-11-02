public class Human extends Being {
  int type;
  int state;
  final float size = 15.7;
  PVector storedPos;

  void seek(PVector player) {
    state = 2;
    target = player;
  }

  void flee(PVector robot) {
    state = 3;
    target = robot;
  }

  void wander() {
    state = 1;
    target = randomTarget;
  }

  boolean display() {
    go = player.go;
    float xe = position.x, ye = position.y ;
    // Show orientation
    switch(type) {
    case 1:
      fill(0, 155, 255);
      break;
    case 2:
      fill(0, 255, 155);
      break;
    case 3:
      fill(0, 255, 255);
      break;
    }
    ellipse(position.x, position.y, size, size) ;
    fill(0);
    int newxe = (int)(xe + 4 * cos(orientation)) ;
    int newye = (int)(ye + 4 * sin(orientation)) ;
    fill(255, 255, 0);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);
    if (state==1) {
        speed = 3f;
      if (path != null) {
        if (path.size()>1) {
          target = followPath();
          targetVel.x = target.x - xe ;
          targetVel.y = target.y - ye ;
        } else {
          while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
            randomTarget = map.getSpawnCell(false).getCentre().copy();
          }
          target = randomTarget;
          path = getPath(target);
          targetVel.x = target.x - xe ;
          targetVel.y = target.y - ye ;
        }
      }
    } else {
      if (state == 2) {
        speed = 3f;
        targetVel.x = target.x - xe ;
        targetVel.y = target.y - ye ;
      } else if (state == 3) {
        speed = 3.6f;
        targetVel.x = xe - target.x+30;
        targetVel.y = ye - target.y+30;
      }
    }
    integrate(targetVel) ;
    return alive;
  }

  void checkProgress() {
    if (storedPos !=null) {
      if (PVector.dist(position, storedPos)<10) {
        newPath();
      } else {
        storedPos = position.copy();
      }
    } else {
      storedPos = position.copy();
    }
  }

  void newPath() {
    if (randomTarget!=null) {
      path = getPath(randomTarget);
      target = path.get(0);
      state = 1;
    } else {
      randomTarget = map.getSpawnCell(false).getCentre().copy();
      path = getPath(randomTarget);
      println(path!=null);
      target = path.get(0);
      state = 1;
    }
  }

  public Human(Cell startCell, int type) {
    alive = true;
    state = 1;
    go = false;
    speed = 3f;
    this.type = type;
    targetVel = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = startCell.getCentre().copy();
    randomTarget = map.getSpawnCell(false).getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell(false).getCentre().copy();
    }
    acceleration = new PVector(0, 0);
    target = randomTarget.copy();
    path = getPath(target);
    if (path!=null) {
      target = path.get(0);
    } else {
      path = getPath(map.getSpawnCell(false).getCentre());
      target = path.get(0);
    }
  }
}
