public class Hulk extends Being {
  int slowTime;


  boolean display() {
    //Draw A* path
    //if (path!=null) {
    //  for (int i = 1; i < path.size(); i++) {
    //    stroke(color(0, 255, 255));
    //    fill(color(0, 255, 255));
    //    line(path.get(i-1).x, path.get(i-1).y, path.get(i).x, path.get(i).y);
    //    stroke(0);
    //  }
    //}
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

    targetVel.x = target.x - xe ;
    targetVel.y = target.y - ye ;
    integrate(targetVel) ;
    if (path != null) {
      if (path.size()>1) {
        target = followPath();
      } else {
        while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
          randomTarget = map.getSpawnCell().getCentre().copy();
        }
        target = randomTarget;
        path = getPath(target);
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
    size = 19; 
    speed = 1.7f;
    velocity = new PVector(0, 0);
    position = startCell.getCentre().copy();
    randomTarget = map.getSpawnCell().getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell().getCentre().copy();
    }
    acceleration = new PVector(0, 0);
    target = randomTarget;
    path = getPath(target);
    if (path!=null) {
      target = path.get(0);
    } else {
      path = getPath(map.getSpawnCell().getCentre());
      target = path.get(0);
    }
    targetVel = new PVector(0, 0) ;
  }
}
