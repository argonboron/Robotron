public class Obstacle {
  PVector centre;
  boolean show;
  float topX;
  float topY;
  float bottomLeftX;
  float bottomLeftY;
  float bottomRightX;
  float bottomRightY;
  
  boolean display() {
    fill(240, 90, 79);
    stroke(240, 90, 79);
    triangle(topX, topY, bottomLeftX, bottomLeftY, bottomRightX, bottomRightY);
    fill(255);
    stroke(0);
    return show;
  }

  void destroy() {
    show = false;
  }

  PVector getCentre() {
    return this.centre;
  }

  Obstacle(Cell startCell) {
    show = true;
    centre = startCell.getCentre();
    float centreX = startCell.getCentre().x;
    float centreY = startCell.getCentre().y;
    topX =centreX;
    topY = centreY-6;
    bottomLeftX = centreX-6;
    bottomLeftY = centreY+6;
    bottomRightX = centreX+6;
    bottomRightY = centreY+6
    ;
  }
}
