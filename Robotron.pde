import java.util.ArrayList;

Map map;
Player player;
ArrayList<Grunt> grunts;
ArrayList<Hulk> hulks;
ArrayList<Bullet> bullets;
ArrayList<Human> humans;
ArrayList<Brain> brains;
ArrayList<Prog> progs;
ArrayList<Obstacle> obstacles;
int count;

void setup() {
  size(1000, 1000);
  grunts = new ArrayList<Grunt>();
  bullets = new ArrayList<Bullet>();
  humans = new ArrayList<Human>();
  hulks = new ArrayList<Hulk>();
  brains = new ArrayList<Brain>();
  progs = new ArrayList<Prog>();
  obstacles = new ArrayList<Obstacle>();
  map = new Map(true);
  spawn(0, 7, 0, 1, 5);
  count = 0;
}

void draw() {
  map.display();
  for (int i = 0; i < obstacles.size(); i++) {
    if (!obstacles.get(i).display()) {
      obstacles.remove(i);
      i--;
    }
  }
  player.display();
  for (int i = 0; i < grunts.size(); i++) {
    if (!grunts.get(i).display()) {
      grunts.remove(i);
      i--;
    }
  }
  for (int i = 0; i < hulks.size(); i++) {
    if (!hulks.get(i).display()) {
      hulks.remove(i);
      i--;
    }
  }
  for (int i = 0; i < bullets.size(); i++) {
    bullets.get(i).display();
    if (bulletColliding(bullets.get(i).getPosition())) {
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
      if (PVector.dist(player.getPosition(), humans.get(i).getPosition()) < 100) {
        humans.get(i).seek(player.getPosition());
        running = true;
      } else {
        for (Hulk hulk : hulks) {
          if (PVector.dist(hulk.getPosition(), humans.get(i).getPosition()) < 100) {
            humans.get(i).flee(hulk.getPosition());
            running = true;
            break;
          } else {
            running = false;
          }
        }
        for (Brain brain : brains) {
          if (PVector.dist(brain.getPosition(), humans.get(i).getPosition()) < 100) {
            humans.get(i).flee(brain.getPosition());
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
  for (int i = 0; i < brains.size(); i++) {
    if (!brains.get(i).display()) {
      brains.remove(i);
      i--;
    } else {
      float minDist = 1000;
      int minIndex = -1;
      boolean close = false;
      for (int j = 0; j < humans.size(); j++) {
        if (PVector.dist(humans.get(j).getPosition(), brains.get(i).getPosition()) < 150) {
          if (PVector.dist(humans.get(j).getPosition(), brains.get(i).getPosition()) < minDist) {
            minDist = PVector.dist(humans.get(j).getPosition(), brains.get(i).getPosition());
            minIndex = j;
            close = true;
          }
        }
      }
      if (close) {
        brains.get(i).setTarget(map.pointToCell(humans.get(minIndex).getPosition()));
      } else {
        brains.get(i).setTarget(null);
      }
    }
  }
  
  for (int i = 0; i < progs.size(); i++) {
    if (!progs.get(i).display()) {
      progs.remove(i);
      i--;
    }
  }
} 

boolean bulletColliding(PVector pos) {
  if ((pos.x < 0 || pos.x > 1000 || pos.y < 0 || pos.y > 1000) || map.pointToCell(pos).getType() < 3) {
    return true;
  } else {
    for (Grunt grunt : grunts) {
      if (PVector.dist(grunt.getPosition(), pos) < (7+grunt.size)) {
        grunt.die();
        return true;
      }
    }
    for (Brain brain : brains) {
      if (PVector.dist(brain.getPosition(), pos) < (7+brain.size)) {
        brain.die();
        return true;
      }
    }
    for (Prog prog : progs) {
      if (PVector.dist(prog.getPosition(), pos) < (7+prog.size)) {
        prog.die();
        return true;
      }
    }
    for (Hulk hulk : hulks) {
      if (PVector.dist(hulk.getPosition(), pos) < (7+hulk.size)) {
        hulk.hit();
        return true;
      }
    }
    for (Obstacle obstacle: obstacles) {
      println(map.pointToCell(pos).getCentre() + " - " + obstacle.getCentre());
      if (map.pointToCell(pos).getCentre()==obstacle.getCentre()) {
        println("hit");
        obstacle.destroy();
        map.removeObstacle(map.pointToIndex(obstacle.getCentre()));
        return true;
      }
    }
  }
  return false;
}

boolean humanColliding(Human human) {
  if (PVector.dist(player.getPosition(), human.getPosition()) < (14.5+human.size)) {
    player.gotHuman(human.type);
    return true;
  } else {
    for (Hulk hulk : hulks) {
      if (PVector.dist(hulk.getPosition(), human.getPosition()) < (hulk.size-1+human.size)) {
        return true;
      }
    }
    for (Brain brain : brains) {
      if (PVector.dist(brain.getPosition(), human.getPosition()) < (brain.size-1+human.size)) {
        convertToProg(human);
        return true;
      }
    }
  }
  return false;
}

void convertToProg(Human human) {
  progs.add(new Prog(map.pointToCell(human.getPosition())));
  human.die();
}

void spawn(int gruntNum, int humanNum, int hulkNum, int brainNum, int obstacleNum) {
  grunts.clear();
  humans.clear();
  hulks.clear();
  brains.clear();
  bullets.clear();
  progs.clear();
  obstacles.clear();
  player = new Player(map.getSpawnCell());
  for (int i = 0; i < gruntNum; i++) {
    grunts.add(new Grunt(map.getSpawnCell()));
  }  
  for (int i = 0; i < humanNum; i++) {
    humans.add(new Human(map.getSpawnCell()));
  }
  for (int i = 0; i < hulkNum; i++) {
    hulks.add(new Hulk(map.getSpawnCell()));
  }
  for (int i = 0; i < brainNum; i++) {
    brains.add(new Brain(map.getSpawnCell(), null));
  }
  for (int i = 0; i < obstacleNum; i++) {
    Cell randomCell = map.getSpawnCell();
    obstacles.add(new Obstacle(randomCell));
    map.addObstacle(map.pointToIndex(randomCell.getCentre()));
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
    spawn(5, 10, 6, 1, 5);
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
