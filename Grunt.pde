public class Grunt extends Robot {
  void display() {
    if (!path.isEmpty()) {
      for (int i = 1; i < path.size(); i++) {
        stroke(color(0, 255, 255));
        fill(color(0, 255, 255));
        line(path.get(i-1).x, path.get(i-1).y, path.get(i).x, path.get(i).y);
        stroke(0);
      }
    }
    
    ellipseMode(CENTER);
    fill(color(255, 255, 0));
    ellipse(position.x, position.y, 18.5, 18.5);
    fill(255);
  }
  Grunt(Cell startCell) {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    position = startCell.getCentre().copy();
    //target = map.getSpawnCell().getCentre().copy();
    target = player.getPosition().copy();
    path = getPath(target);
  }
}
