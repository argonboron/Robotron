public class Prog extends Being {


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
    fill(0, 0, 0) ;
    stroke(255) ;
    ellipse(xe, ye, size, size) ;
    stroke(0) ;
    int newxe = (int)(xe + 2 * cos(orientation)) ;
    int newye = (int)(ye + 2 * sin(orientation)) ;
    fill(255);
    ellipse(newxe, newye, 5.5, 5.5) ;  
    fill(255);
    targetVel.x = target.x - xe ;
    targetVel.y = target.y - ye ;
    integrate(targetVel) ;
    hunt = (player.getPosition().dist(position)<175);
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
