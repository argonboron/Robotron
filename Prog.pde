public class Prog extends Robot {

  boolean display() {
    float xe = position.x, ye = position.y ;
    fill(0, 0, 0) ;
    stroke(255) ;
    ellipse(xe, ye, size, size) ;
    stroke(0) ;
    int newxe = (int)(xe + 2 * cos(orientation)) ;
    int newye = (int)(ye + 2 * sin(orientation)) ;
    fill(255);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);
    if (flee) {
      target = player.getPosition();
      speed = 3.6f;
      targetVel.x = xe - target.x+30;
      targetVel.y = ye - target.y+30;
      integrate(targetVel) ;
            target = player.getPosition();
    } else if (!player.isInvisible()) {
      targetVel.x = target.x - xe ;
      targetVel.y = target.y - ye ;
      integrate(targetVel) ;
      if (path != null) {
        if (map.pointToCell(player.getPosition()).getCentre() != map.pointToCell(path.get(path.size()-1)).getCentre()) {
          path = getPath(map.pointToCell(player.getPosition()).getCentre());
        }
      } else {
        path = getPath(player.getPosition());
      }
      if (path != null) {
        if (path.size()>1) {
          target = followPath();
        } else {
          target = player.getPosition();
        }
      }
    } else {
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
    }
    return this.alive;
  }


  Prog(Cell startCell) {
    alive = true;
    speed = 4.3f;
    size = 13; 
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
      if (path.size()>0) {
        target = path.get(0);
      }
    } else {
      path = getPath(randomTarget);
      if (path.size()>0) {
        target = path.get(0);
      }
    }
    targetVel = new PVector(0, 0) ;
  }
}
