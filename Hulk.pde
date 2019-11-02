public class Hulk extends Robot {
  int slowTime;


  boolean display() {
    setGo();
    if (slowTime > 0) {
      if (slowTime == 1) {
        speed = 1.7f;
      }
      slowTime--;
    }
    float xe = position.x, ye = position.y ;
    fill(255, 0, 0) ;
    ellipse(xe, ye, size, size) ;
    int newxe = (int)(xe + 6.5 * cos(orientation)) ;
    int newye = (int)(ye + 6.5 * sin(orientation)) ;
    fill(255, 255, 0);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);
    if (flee) {
      target = player.getPosition();
      speed = 3.6f;
      targetVel.x = xe - target.x+30;
      targetVel.y = ye - target.y+30;
      integrate(targetVel) ;
      target = followPath();
    } else {
      speed = 1.7f;
      targetVel.x = target.x - xe ;
      targetVel.y = target.y - ye ;
      integrate(targetVel) ;
      if (path != null) {
        if (path.size()>1) {
          target = followPath();
        } else {
          while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
            randomTarget = map.getSpawnCell(false).getCentre().copy();
          }
          target = randomTarget;
          path = getPath(target);
        }
      }
    }
    return this.alive;
  }

  void hit() {
    speed = 0.5f;
    slowTime = 15;
  }


  Hulk(Cell startCell) {
    alive = true;
    slowTime = 0;
    go = false;
    size = 19; 
    speed = 1.7f;
    velocity = new PVector(0, 0);
    position = startCell.getCentre().copy();
    randomTarget = map.getSpawnCell(false).getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell(false).getCentre().copy();
    }
    acceleration = new PVector(0, 0);
    target = randomTarget;
    path = getPath(target);
    if (path!=null) {
      target = path.get(0);
    } else {
      path = getPath(map.getSpawnCell(false).getCentre());
      target = path.get(0);
    }
    targetVel = new PVector(0, 0) ;
  }
}
