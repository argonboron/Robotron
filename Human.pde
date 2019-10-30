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

    //if (path!=null) {
    //  for (int i = 1; i < path.size(); i++) {
    //    stroke(color(255, 255, 255));
    //    fill(color(0, 255, 255));
    //    line(path.get(i-1).x, path.get(i-1).y, path.get(i).x, path.get(i).y);
    //    stroke(0);
    //  }
    //}
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
    int newxe = (int)(xe + 6.5 * cos(orientation)) ;
    int newye = (int)(ye + 6.5 * sin(orientation)) ;
    fill(255, 255, 0);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);
    if (state==1) {
      if (path != null) {
        if (path.size()>1) {
          target = followPath();
          targetVel.x = target.x - xe ;
          targetVel.y = target.y - ye ;
        } else {
          while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
            randomTarget = map.getSpawnCell().getCentre().copy();
          }
          target = randomTarget;
          path = getPath(target);
          targetVel.x = target.x - xe ;
          targetVel.y = target.y - ye ;
        }
      }
    } else {
      if (state == 2) {
        targetVel.x = target.x - xe ;
        targetVel.y = target.y - ye ;
      } else if (state == 3) {
        targetVel.x = xe - target.x;
        targetVel.y = ye - target.y;
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
      randomTarget = map.getSpawnCell().getCentre().copy();
      path = getPath(randomTarget);
      println(path!=null);
      target = path.get(0);
      state = 1;
    }
  }

  public Human(Cell startCell) {
    alive = true;
    state = 1;
    type = (int) random(1, 4);
    targetVel = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = startCell.getCentre().copy();
    randomTarget = map.getSpawnCell().getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell().getCentre().copy();
    }
    acceleration = new PVector(0, 0);
    target = randomTarget.copy();
    path = getPath(target);
    if (path!=null) {
      target = path.get(0);
    } else {
      path = getPath(map.getSpawnCell().getCentre());
      target = path.get(0);
    }
  }
}
