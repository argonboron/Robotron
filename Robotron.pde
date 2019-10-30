import java.util.ArrayList;

Map map;
Player player;
ArrayList<Grunt> grunts;
ArrayList<Bullet> bullets;
ArrayList<Human> humans;
int count;
void setup() {
  size(1000, 1000);
  grunts = new ArrayList<Grunt>();
  bullets = new ArrayList<Bullet>();
  humans = new ArrayList<Human>();
  map = new Map(true);
  spawn(10, 15);
  count = 0;
}
void draw() {
  map.display();
  player.display();
  for (int i = 0; i < grunts.size(); i++) {
    if (!grunts.get(i).display()) {
      grunts.remove(i);
      i--;
    }
  }
  for (int i = 0; i < bullets.size(); i++) {
    bullets.get(i).display();
    if (bulletColliding(bullets.get(i).position)) {
      bullets.remove(i);
      i--;
    }
  }
  count = (count+1)%200;
  for (int i = 0; i < humans.size(); i++) {
    if (humanColliding(humans.get(i))) {
      humans.get(i).die();
    }
    if (!humans.get(i).display()) {
      humans.remove(i);
      i--;
    } else {
      if (count ==100) {
        humans.get(i).checkProgress();
      }
      boolean running = false;
      if (PVector.dist(player.position, humans.get(i).position) < 140) {
        humans.get(i).seek(player.position);
        running = true;
      } else {
        for (Grunt grunt : grunts) {
          if (PVector.dist(grunt.position, humans.get(i).position) < 140) {
            humans.get(i).flee(grunt.position);
            running = true;
            break;
          } else {
            running = false;
          }
        }
      }
      if (!running) {
        humans.get(i).wander();
      }
    }
  }
} 

boolean bulletColliding(PVector pos) {
  if ((pos.x < 0 || pos.x > 1000 || pos.y < 0 || pos.y > 1000) || map.pointToCell(pos).getType() < 3) {
    return true;
  } else {
    for (Grunt grunt : grunts) {
      if (PVector.dist(grunt.position, pos) < (7+grunt.size)) {
        grunt.die();
        return true;
      }
    }
  }
  return false;
}

boolean humanColliding(Human human) {
  if (PVector.dist(player.position, human.position) < (15.5+human.size)) {
    player.gotHuman(human.type);
    return true;
  } else {
    return false;
  }
}

void spawn(int gruntNum, int humanNum) {
  grunts.clear();
  humans.clear();
  player = new Player(map.getSpawnCell());
  for (int i = 0; i < gruntNum; i++) {
    grunts.add(new Grunt(map.getSpawnCell()));
  }  
  for (int i = 0; i < humanNum; i++) {
    humans.add(new Human(map.getSpawnCell()));
  }
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
  } else if (key == 'w') {
    player.move(0);
  } else if (key == 's') {
    player.move(1);
  } else if (key == 'a') {
    player.move(2);
  } else if (key == 'd') {
    player.move(3);
  } else {
    map = new Map(true);
    spawn(1, 10);
  }
}

void keyReleased() {
  if (key == 'w') {
    player.stop(0);
  } else if (key == 's') {
    player.stop(1);
  } else if (key == 'a') {
    player.stop(2);
  } else if (key == 'd') {
    player.stop(3);
  }
}

void mousePressed() {
  bullets.add(new Bullet(player.getPosition(), new PVector(mouseX, mouseY)));
}
