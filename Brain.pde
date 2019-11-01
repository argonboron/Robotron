public class Brain extends Being {
  Cell targetCell;

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
    float xe = position.x, ye = position.y ;
    fill(30, 255, 0) ;
    ellipse(xe, ye, size, size) ;
    int newxe = (int)(xe + 6.5 * cos(orientation)) ;
    int newye = (int)(ye + 6.5 * sin(orientation)) ;
    fill(255, 255, 255);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);

    targetVel.x = target.x - xe ;
    targetVel.y = target.y - ye ;
    
    integrate(targetVel) ;
    hunt = targetCell != null;
    if (hunt) {
      if (path != null) {
        if (targetCell.getCentre() != map.pointToCell(path.get(path.size()-1)).getCentre()) {
          path = getPath(targetCell.getCentre());
        }
      } else {
        path = getPath(map.getSpawnCell().getCentre());
      }
      if (path != null) {
        if (path.size()>1) {
          target = followPath();
        } else {
          target = targetCell.getCentre();
        }
      }
    } else {
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
    }
    return this.alive;
  }
  
  void setTarget(Cell targetCell) {
    this.targetCell = targetCell;
  }


  Brain(Cell startCell, Cell humanTargetCell) {
    alive = true;
    speed = 2.7f;
    size = 18.5;
    velocity = new PVector(0, 0);
    position = startCell.getCentre().copy();
    targetCell = humanTargetCell;
    randomTarget = map.getSpawnCell().getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell().getCentre().copy();
    }
    acceleration = new PVector(0, 0);
    hunt = targetCell != null;
    if (hunt) {
      target = targetCell.getCentre();
    } else {
      target = randomTarget;
    }
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
