Map map;
void setup() {
  size(1000, 1000);
  map = new Map(false);
}
void draw() {
  map.display();
}

void keyPressed(){
  if (key == '1') {
    map.mapMasses();
  } else if (key == '2') {
    map.mergeMasses();
  } else {
    for (int i = 0; i < 10; i++){
      map.step();
    }
  }
 }

void mouseReleased() {
    map = new Map(true);
  //map.retract();
}
