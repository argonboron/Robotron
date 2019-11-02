public class Grunt extends Robot {


  boolean display() {
    setGo();
    float xe = position.x, ye = position.y ;
    fill(255, 255, 0) ;
    ellipse(xe, ye, size, size) ;
    int newxe = (int)(xe + 6.5 * cos(orientation)) ;
    int newye = (int)(ye + 6.5 * sin(orientation)) ;
    fill(255, 0, 0);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);
    if (flee) {
      target = player.getPosition();
      speed = 3.6f;
      targetVel.x = xe - target.x+30;
      targetVel.y = ye - target.y+30;
      integrate(targetVel) ;
      target = player.getPosition();
    } else {
      targetVel.x = target.x - xe ;
      targetVel.y = target.y - ye ;
      integrate(targetVel) ;
      hunt = (player.getPosition().dist(position)<175);
      if (hunt && !player.isInvisible()) {
        if (path != null) {
          if (map.pointToCell(player.getPosition()).getCentre() != map.pointToCell(path.get(path.size()-1)).getCentre()) {
            path = getPath(map.pointToCell(player.getPosition()).getCentre());
          }
        } else {
          path = getPath(map.getSpawnCell(false).getCentre());
        }
        if (path != null) {
          if (path.size()>1) {
            target = followPath();
          } else {
            target = player.getPosition();
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


  Grunt(Cell startCell) {
    alive = true;
    go = false;
    size = 18.5;
    speed = 3f;
    velocity = new PVector(0, 0);
    position = startCell.getCentre().copy();
    randomTarget = map.getSpawnCell(false).getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell(false).getCentre().copy();
    }
    acceleration = new PVector(0, 0);
    hunt = (player.getPosition().dist(position)<175);
    if (hunt) {
      target = player.getPosition();
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
  }
}
