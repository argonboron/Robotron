public class PowerUp {
  int type;
  PVector centre;
  boolean show;
  float shapeX, shapeY;

  boolean display() {
    switch (type) {
    case 1:
      fill(252, 198, 3);
      stroke(252, 198, 3);
      rect(shapeX, shapeY, 10, 10, 3);
      fill(255);
      stroke(0);
      break;
    case 2: 
      fill(103, 3, 252);
      stroke(103, 3, 252);
      rect(shapeX, shapeY, 10, 10, 3);
      fill(255);
      stroke(0);
      break;
     case 3:
      fill(255);
      stroke(255);
      rect(shapeX, shapeY, 10, 10, 3);
      fill(255);
      stroke(0);
      break;
    
    }
    return show;
  }

  void destroy() {
    show = false;
  }

  PVector getCentre() {
    return this.centre;
  }
  
  int getType() {
    return this.type;
  }

  PowerUp(Cell startCell, int type) {
    this.type = type;
    show = true;
    centre = startCell.getCentre();
    float centreX = startCell.getCentre().x;
    float centreY = startCell.getCentre().y;
    shapeX =centreX-5;
    shapeY = centreY-5;
    ;
  }
}
