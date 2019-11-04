public class Brain extends Robot {
  Cell targetCell;

  boolean display() {
    setGo(); //<>//
    float xe = position.x, ye = position.y ;
    fill(30, 255, 0) ;
    ellipse(xe, ye, size, size) ;
    int newxe = (int)(xe + 6.5 * cos(orientation)) ;
    int newye = (int)(ye + 6.5 * sin(orientation)) ;
    fill(255, 255, 255);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);
    if (flee) {
      target = player.getPosition();
      speed = 3.6f;
      targetVel.x = xe - target.x+30;
      targetVel.y = ye - target.y+30;
      integrate(targetVel) ;
    } else {
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
          path = getPath(map.getSpawnCell(false).getCentre());
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
              randomTarget = map.getSpawnCell(false).getCentre().copy();
            }
            target = randomTarget;
            path = getPath(target);
          }
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
    randomTarget = map.getSpawnCell(false).getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell(false).getCentre().copy();
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
      path = getPath(map.getSpawnCell(false).getCentre());
      target = path.get(0);
    }
    targetVel = new PVector(0, 0) ;
    go = false;
  }
}
