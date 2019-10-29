Map map;
Player player;
void setup() {
  size(1000, 1000);
  map = new Map(true);
  player = new Player(map.getSpawnCell());
}
void draw() {
  map.display();
  player.display();
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
  }else if (key == 'w') {
    player.move(0);
  }else if (key == 's') {
    player.move(1);
  }else if (key == 'a') {
    player.move(2);
  }else if (key == 'd') {
    player.move(3);
  } else {
    map = new Map(true);
    player = new Player(map.getSpawnCell());
  }
}

void keyReleased(){
  if (key == 'w') {
    player.stop(0);
  }else if (key == 's') {
    player.stop(1);
  }else if (key == 'a') {
    player.stop(2);
  }else if (key == 'd') {
    player.stop(3);
  }
}

void mouseReleased() {
}
