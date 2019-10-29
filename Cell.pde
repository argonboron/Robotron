public class Cell {
  int type;
  PVector centre;

  PVector getCentre() {
    return centre;
  } 

  boolean isInside(PVector point) {
    if ((point.x < centre.x+10) && (point.x > (centre.x - 10))) {
      if ((point.y < centre.y+10) && (point.y > (centre.y - 10))) {
        return true;
      }
    }
    return false;
  }

  int getType() {
    return this.type;
  }

  void setType(int type) {
    this.type = type;
  }

  public Cell(int type, int x, int y) {
    this.type = type;
    centre = new PVector(x, y);
  }
}
