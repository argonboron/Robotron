Map map;
void setup() {
  size(1000, 1000);
  map = new Map(true);
  //Player player = new Player(map.getSpawnCell());
}
void draw() {
  map.display();
}

void keyPressed() {
  if (key == '1') {
    map = new Map(false);
  } else if (key == '2') {
    for (int i = 0; i < 10; i++) {
      map.step();
    }
  } else if (key =='3') {
    map.mapMasses();
  } else if (key == '4') {
    map.mergeMasses();
  } else {
    map = new Map(true);
  }
}

void mouseReleased() {
}
