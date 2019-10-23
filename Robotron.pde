Map map;
void setup() {

  size(1000, 1000);
  map = new Map();
}
void draw() {
  map.display();
}

void mouseReleased() {
  print("click");
  for (int i =0; i < 10; i++) {
    map.step();
  }
  map.retract();
}
