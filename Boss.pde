public class Boss extends Robot {
  int health, bulletCount, spawnProg, spawnGrunt, difficulty;
  boolean display() {
    setGo(); //<>//
    float xe = position.x, ye = position.y ;
    int redVal = 0, greenVal = 0;
    if (health >= 5 ) {
      greenVal = 255;
      redVal = 255-(51*(health-5));
    } else {
      redVal = 255;
      greenVal = 51*health;
    }
    color healthCol = color(redVal, greenVal, 28);
    fill(healthCol);
    ellipse(position.x, position.y, size, size);
    fill(255);
    targetVel.x = target.x - xe ;
    targetVel.y = target.y - ye ;
    integrate(targetVel) ;
    if (path != null) {
      if (path.size()>1) {
        target = followPath();
      } else {
        while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
          randomTarget = map.getSpawnCell(false).getCentre().copy();
        }
        target = randomTarget;
        path = getPath(target);
      }
    }

    if (bulletCount == 0) { 
      bullets.add(new Bullet(this.position.copy(), player.getPosition(), false));
      bulletCount = (int) random (10, 100);
    } else if (go) {
      bulletCount--;
    }

    if (spawnProg==0) {
      for (int i = 0; i < (difficulty/5)+1; i++) {
        progs.add(new Prog(map.pointToCell(this.position)));
      }
      spawnProg = 390;
    } else {
      spawnProg--;
    }

    if (spawnGrunt==0) {
      for (int i = 0; i < (difficulty/5)+2; i++) {
        grunts.add(new Grunt(map.pointToCell(this.position)));
      }
      spawnGrunt = 200;
    } else {
      spawnGrunt--;
    }
    return health >0;
  }

  void hit() {
    health--;
  }

  Boss(int level) {
    speed = 1.9f;
    size = 80;
    go = false;
    alive = true;
    this.difficulty = level;
    bulletCount = (int) random (10, 110-(level*2));
    spawnGrunt = 200;
    spawnProg = 550;
    health = 10;
    velocity = new PVector(0, 0);
    position = map.getSpawnCell(false).getCentre().copy();
    randomTarget = map.getSpawnCell(false).getCentre().copy();
    while (map.pointToCell(randomTarget).getCentre() == map.pointToCell(position).getCentre()) {
      randomTarget = map.getSpawnCell(false).getCentre().copy();
    }
    acceleration = new PVector(0, 0);
    target = randomTarget;
    path = getPath(target);
    if (path!=null) {
      target = path.get(0);
    } else {
      path = getPath(map.getSpawnCell(false).getCentre());
      target = path.get(0);
    }
    targetVel = new PVector(0, 0) ;
  }
}
