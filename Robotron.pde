import processing.sound.*; //<>// //<>//
import java.util.ArrayList;
Map map;
Player player;
String path;
ArrayList<Grunt> grunts;
ArrayList<Hulk> hulks;
ArrayList<Bullet> bullets;
ArrayList<Human> humans;
ArrayList<Brain> brains;
ArrayList<Prog> progs;
ArrayList<Obstacle> obstacles;
ArrayList<PowerUp> powerups;
Boss boss;
int count, invisibleCount, forceCount, invincibleCount, score, level, deadCount, lives, clickReadyCount, livesRestored;
int gruntNum, hulkNum, humanNum, brainNum, obstacleNum, invisNum, invincibleNum, forceFieldNum;
boolean forceField, gameOver, clickReady;
PFont font, fontLarge;
SoundFile background, shoot, robotdie, spawn, nextlevel, humansave, start, endscreen, prog, powerup, die, bossLoop, humandie;

//Setup all global variables for start of new game
void setup() {
  font = createFont("font.ttf", 28);
  fontLarge = createFont("font.ttf", 50);
  size(1000, 1000);
  frameRate(50);
  clickReadyCount = 0;
  grunts = new ArrayList<Grunt>();
  bullets = new ArrayList<Bullet>();
  humans = new ArrayList<Human>();
  hulks = new ArrayList<Hulk>();
  brains = new ArrayList<Brain>();
  progs = new ArrayList<Prog>();
  obstacles = new ArrayList<Obstacle>();
  powerups = new ArrayList<PowerUp>();
  boss = null;
  map = new Map(true);
  clickReady = false;
  gruntNum = 5;
  hulkNum = 3;
  humanNum = 3;
  lives = 3;
  brainNum = 0;
  obstacleNum = 6;
  forceFieldNum = 1;
  invisNum = 0;
  invincibleNum = 0;
  setupSound();
  spawn(gruntNum, humanNum, hulkNum, brainNum, obstacleNum, invincibleNum, forceFieldNum, invisNum);
  count = 0;
  level = 1;
  score = 0;
  livesRestored = 0;
  gameOver = false;
}

//Draws each entity each frame, checks that they are alive, and checks game over conditions
void draw() {
  //If not boss level, check level is over (all grunts dead)
  if (boss== null && grunts.size()==0) {
    if (background.isPlaying()) {
      background.pause();
      nextlevel.play();
    }
    delay(300);
    nextLevel();
  }
  //counters for powerups
  if (deadCount > 0) {
    deadCount--;
  }
  if (invisibleCount > 0) {
    invisibleCount--;
  }
  if (invincibleCount > 0) {
    invincibleCount--;
  }
  if (forceCount > 0) {
    forceCount--;
  }
  count = (count+1)%200;

  map.display();
  //If boss round, check boss next level conditions
  if (boss !=null) {
    if (!boss.display()) {
      addScore(1500);
      boss = null;
      nextlevel.play();
      delay(300);
      nextLevel();
    } else {
      boss.isHittingPlayer();
    }
  } 
  //Draw obstacles
  for (int i = 0; i < obstacles.size(); i++) {
    if (!obstacles.get(i).display()) {
      obstacles.remove(i);
      i--;
    } else {
      obstacles.get(i).isHittingPlayer();
    }
  }
  //Draw powerups
  for (int i = 0; i < powerups.size(); i++) {
    if (!powerups.get(i).display()) {
      powerups.remove(i);
      i--;
    }
  }
  //Check player collisions with obstacles and powerups
  playerColliding(player.getPosition());
  for (int i = 0; i < grunts.size(); i++) {
    if (!grunts.get(i).display()) {
      grunts.remove(i);
      i--;
    } else {
      grunts.get(i).isHittingPlayer();
    }
  }
  //Draw Hulks
  for (int i = 0; i < hulks.size(); i++) {
    if (!hulks.get(i).display()) {
      hulks.remove(i);
      i--;
    } else {
      hulks.get(i).isHittingPlayer();
    }
  }
  //Draw bullets
  for (int i = 0; i < bullets.size(); i++) {
    bullets.get(i).display();
    if (bulletColliding(bullets.get(i).getPosition(), bullets.get(i).playerSend)) {
      bullets.remove(i);
      i--;
    }
  }
  //Draw Humans and set their behaviour states
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
          if (PVector.dist(hulk.getPosition(), humans.get(i).getPosition()) < 60) {
            humans.get(i).flee(hulk.getPosition());
            running = true;
            break;
          }
        }
        for (Brain brain : brains) {
          if (PVector.dist(brain.getPosition(), humans.get(i).getPosition()) < 100) {
            humans.get(i).flee(brain.getPosition());
            running = true;
            break;
          }
        }
      }
      if (!running) {
        humans.get(i).wander();
      }
    }
  }
  //Draw brains and update their behaviour states
  for (int i = 0; i < brains.size(); i++) {
    if (!brains.get(i).display()) {
      brains.remove(i);
      i--;
    } else {
      brains.get(i).isHittingPlayer();
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
  //Draw progs
  for (int i = 0; i < progs.size(); i++) {
    if (!progs.get(i).display()) {
      progs.remove(i);
      i--;
    } else {
      progs.get(i).isHittingPlayer();
    }
  }
  //Draw player
  player.display();
  //Draw text
  textFont(font);
  fill(20, 53, 163);
  text("Robotron: 4303", 19, 45);
  fill(246, 255, 0);
  text("score: " + Integer.toString(score), 19, 80);
  fill(36, 237, 89);
  text("level: " + Integer.toString(level), 19, 120);
  fill(227, 39, 51);
  text("lives: " + Integer.toString(lives), 19, 157);
  fill(255);
  //Draw boss text if boss level
  if (boss != null) {
    int rgb = (int) random(1, 7);
    if (rgb ==1) {
      fill(color(200, 0, (int)random(0, 256)));
    } else if (rgb == 2) {
      fill(color(200, (int)random(0, 256), 0));
    } else if (rgb == 3) {
      fill(color((int)random(0, 256), 0, 200));
    } else if (rgb == 4) {
      fill(color(0, (int)random(0, 256), 200));
    } else if (rgb == 5) {
      fill(color((int)random(0, 256), 200, 0));
    } else if (rgb == 6) {
      fill(color(0, 200, (int)random(0, 256)));
    }
    textFont(fontLarge);
    text("BOSS", 390, 150);
    fill(255);
  }
  //Draw game over screen if game over
  if (gameOver) {
    frameRate(120);
    lives = 0;
    int rgb = (int) random(1, 7);
    if (rgb ==1) {
      fill(color(200, 0, (int)random(0, 256)));
    } else if (rgb == 2) {
      fill(color(200, (int)random(0, 256), 0));
    } else if (rgb == 3) {
      fill(color((int)random(0, 256), 0, 200));
    } else if (rgb == 4) {
      fill(color(0, (int)random(0, 256), 200));
    } else if (rgb == 5) {
      fill(color((int)random(0, 256), 200, 0));
    } else if (rgb == 6) {
      fill(color(0, 200, (int)random(0, 256)));
    }
    textFont(fontLarge);
    text("GAME OVER", 280, 500);
    textFont(font);
    fill(246, 255, 0);
    text("score: " + Integer.toString(score), 360, 550);
    fill(36, 237, 89);
    text("level: " + Integer.toString(level), 385, 590);
    fill(252, 3, 207);
    text("Press any button to play again!", 70, 630);
    fill(255);
    if (clickReadyCount  == 0) {
      clickReady = true;
    } else {
      clickReadyCount--;
    }
  }
} 

//Update spawn numbers and move to next level
void nextLevel() {
  level++;
  if (level%5==0) {
    map = new Map(false);
    if (background.isPlaying()) {
      background.pause();
    }
    bossLoop.loop();
    spawn(true);
  } else {
    if (bossLoop.isPlaying()) {
      bossLoop.stop();
    }
    map = new Map(true);
    if (sumNums() < 200) {
      gruntNum++;
      obstacleNum++;
      if (level%3==0) {
        hulkNum++;
        invincibleNum++;
      }
      if (level%4==0) {
        forceFieldNum++;
      }
      if (level%6==0) {
        brainNum++;
        humanNum++;
        invisNum++;
      }
    }
    spawn(gruntNum, humanNum, hulkNum, brainNum, obstacleNum, invincibleNum, forceFieldNum, invisNum);
    background.play();
  }
}

//Ensure there arent too many beigns on the map
int sumNums() {
  return gruntNum + humanNum + hulkNum + brainNum + obstacleNum + invincibleNum + forceFieldNum + invisNum;
}

//Reset level if player died - keepign same numbers of NPCs and objects
void resetLevel() {
  delay(300);
  die.stop();
  die.play();
  player.position = new PVector(-30, -30);
  lives--;
  if (lives > 0) {
    spawn(grunts.size(), humans.size(), hulks.size(), brains.size(), obstacles.size(), invincibleNum, forceFieldNum, invisNum);
  } else if (!gameOver) {
    gameOver();
  }
}

//Setup sounds
void setupSound() {
  //https://freesound.org/people/Romariogrande/sounds/452138/
  path = sketchPath("sounds/bg.wav");
  background = new SoundFile(this, path);
  background.amp(0.6);
  //https://freesound.org/people/cablique/sounds/152766/
  path = sketchPath("sounds/shoot.wav");
  shoot = new SoundFile(this, path);
  //https://freesound.org/people/ebcrosby/sounds/333496/
  path = sketchPath("sounds/robotdie.wav");
  robotdie = new SoundFile(this, path);
  robotdie.amp(0.2);
  //https://freesound.org/people/mitchelk/sounds/136765/
  path = sketchPath("sounds/humansave.wav");
  humansave = new SoundFile(this, path);
  //https://freesound.org/people/estlacksensory/sounds/118708/
  path = sketchPath("sounds/nextlevel.wav");
  nextlevel = new SoundFile(this, path);
  //https://freesound.org/people/freedomfightervictor/sounds/390531/
  path = sketchPath("sounds/spawn.wav");
  spawn = new SoundFile(this, path);
  spawn.amp(0.3);
  //https://freesound.org/people/ebcrosby/sounds/333496/
  path = sketchPath("sounds/start.wav");
  start = new SoundFile(this, path);
  start.amp(0.4);
  //https://freesound.org/people/briccio/sounds/318807/
  path = sketchPath("sounds/endscreen.wav");
  endscreen = new SoundFile(this, path);
  endscreen.amp(0.2);
  //freesound.org/people/josepharaoh99/sounds/364929/
  path = sketchPath("sounds/die.mp3");
  die = new SoundFile(this, path);
  //freesound.org/people/ProjectsU012/sounds/360978/
  path = sketchPath("sounds/powerup.wav");
  powerup = new SoundFile(this, path);
  //https://freesound.org/people/ebcrosby/sounds/333496/
  path = sketchPath("sounds/prog.wav");
  prog = new SoundFile(this, path);
  //https://freesound.org/people/Sirkoto51/sounds/352171/
  path = sketchPath("sounds/boss.wav");
  bossLoop= new SoundFile(this, path);
  bossLoop.amp(0.2);
  //https://freesound.org/people/AlineAudio/sounds/416838/
  path = sketchPath("sounds/humandie.wav");
  humandie = new SoundFile(this, path);

  background.rate(1);
  background.loop();
}

//Set gameOver
void gameOver() {
  gameOver = true;
  player.go = false;
  clickReadyCount = 60;
  background.stop();
  endscreen.loop();
}

//Add score
void addScore(int add) {
  if (add < 1000) {
    add = add*getMultiplier();
  }
  score += add;
  if (score > (livesRestored+1)*20000) {
    lives++;
    livesRestored++;
  }
}

//Calc multiplier
int getMultiplier() {
  if (level < 7) {
    if (level%2 !=0) {
      return level/2+1;
    } else {
      return level/2;
    }
  } else {
    return 4;
  }
}

//Check bullet collisions with robots and obstacles
boolean bulletColliding(PVector pos, boolean playerSend) {
  if ((pos.x < 0 || pos.x > 1000 || pos.y < 0 || pos.y > 1000) || map.pointToCell(pos).getType() < 3) {
    return true;
  } else {
    for (Grunt grunt : grunts) {
      if (PVector.dist(grunt.getPosition(), pos) < (7+grunt.size) && playerSend) {
        grunt.die();
        robotdie.play();
        addScore(100);
        return true;
      }
    }
    for (Brain brain : brains) {
      if (PVector.dist(brain.getPosition(), pos) < (7+brain.size) && playerSend) {
        brain.die();
        robotdie.play();
        addScore(200);
        return true;
      }
    }
    for (Prog prog : progs) {
      if (PVector.dist(prog.getPosition(), pos) < (7+prog.size) && playerSend) {
        prog.die();
        robotdie.play();
        addScore(200);
        return true;
      }
    }
    for (Hulk hulk : hulks) {
      if (PVector.dist(hulk.getPosition(), pos) < (7+hulk.size) && playerSend) {
        hulk.hit();
        return true;
      }
    }
    for (Obstacle obstacle : obstacles) {
      if (map.pointToCell(pos).getCentre()==obstacle.getCentre() && playerSend) {
        obstacle.destroy();
        addScore(50);
        map.removeObstacle(map.pointToIndex(obstacle.getCentre()));
        return true;
      }
    }
    if (boss != null) {
      if (playerSend) {
        if (PVector.dist(boss.getPosition(), pos) < (7+40)) {
          boss.hit();
          robotdie.play();
          return true;
        }
      } else {        
        if (PVector.dist(player.getPosition(), pos) < (7+16.5) && !player.forceField) {
          player.hit();
          die.play();
          return false;
        }
      }
    }
  }
  return false;
}

//Check human collisions with human, hulk, and brain
boolean humanColliding(Human human) {
  if (PVector.dist(player.getPosition(), human.getPosition()) < (14.5+human.size)) {
    player.gotHuman(human.type);
    return true;
  } else {
    for (Hulk hulk : hulks) {
      if (PVector.dist(hulk.getPosition(), human.getPosition()) < (hulk.size-1+human.size)) {
        humandie.play();
        return true;
      }
    }
    for (Brain brain : brains) {
      if (PVector.dist(brain.getPosition(), human.getPosition()) < (brain.size-3+human.size)) {
        convertToProg(human);
        return true;
      }
    }
    return false;
  }
}

//Check player collisions with robots, kill player/robot depending on if invincible, setpowerup if collision detected with powerup
void playerColliding(PVector pos) {
  if (invincibleCount == 1) {
    player.invincible(false);
  }
  if (forceCount==1) {
    player.forceField(false);
  }
  if (invisibleCount==1) {
    player.invisible = false;
  }

  for (int i = 0; i < powerups.size(); i++) {
    if (powerups.get(i).getCentre().dist(pos)<18.5+1) {
      powerup.play();
      switch(powerups.get(i).getType()) {
      case 1:
        invincibleCount = 350;
        player.invincible(true);
        player.invisible = false;
        break;
      case 2:
        forceCount = 350;
        player.forceField(true);
        break;
      case 3:
        invisibleCount = 350;
        player.invisible();
        break;
      }

      powerups.remove(i);
      i--;
    }
  }
  for (Grunt grunt : grunts) {
    if (player.hasForceField() && PVector.dist(grunt.getPosition(), pos) < 30+(grunt.size-1+18.5)) {
      grunt.forceField(true);
    } else {
      grunt.forceField(false);
    }
  }
  for (Prog prog : progs) {
    if (player.hasForceField() && PVector.dist(prog.getPosition(), pos) < 30+(prog.size-1+18.5)) {
      prog.forceField(true);
    } else {
      prog.forceField(false);
    }
  }
  for (Hulk hulk : hulks) {
    if (player.hasForceField() && PVector.dist(hulk.getPosition(), pos) < 30+(hulk.size-1+18.5)) {
      hulk.forceField(true);
    } else {
      hulk.forceField(false);
    }
  }
  for (Brain brain : brains) {
    if (player.hasForceField() && PVector.dist(brain.getPosition(), pos) < 30+(brain.size-3+18.5)) {
      brain.forceField(true);
    } else {
      brain.forceField(false);
    }
  }
  if (player.isInvincible()) {
    for (Grunt grunt : grunts) {
      if (PVector.dist(grunt.getPosition(), pos) < (grunt.size-1+18.5)) {
        grunt.die();
        robotdie.play();
        addScore(100);
      }
    }
    for (Prog prog : progs) {
      if (PVector.dist(prog.getPosition(), pos) < (prog.size-1+18.5)) {
        prog.die();
        robotdie.play();
        addScore(200);
      }
    }
    for (Hulk hulk : hulks) {
      if (PVector.dist(hulk.getPosition(), pos) < (hulk.size-1+18.5)) {
        hulk.die();
        robotdie.play();
        addScore(250);
      }
    }
    for (Brain brain : brains) {
      if (PVector.dist(brain.getPosition(), pos) < (brain.size-3+18.5)) {
        brain.die();
        addScore(200);
      }
    }
    for (Obstacle obstacle : obstacles) {
      if (map.pointToCell(pos).getCentre()==obstacle.getCentre()) {
        obstacle.destroy();
        addScore(50);
        map.removeObstacle(map.pointToIndex(obstacle.getCentre()));
      }
    }
  }
}

//Convert human to prog
void convertToProg(Human human) {
  progs.add(new Prog(map.pointToCell(human.getPosition())));
  humandie.play();
  prog.play();
  human.die();
}

//Spawn new beings and objects for boss level
void spawn(boolean bosslevel) {
  grunts.clear();
  humans.clear();
  hulks.clear();
  brains.clear();
  bullets.clear();
  progs.clear();
  obstacles.clear();
  powerups.clear();
  spawn.play();
  player = new Player(map.getSpawnCell(true));
  if (bosslevel) {
    boss = new Boss(level);
  }
}

//Spawn new beings and objects for normallevel
void spawn(int gruntNum, int humanNum, int hulkNum, int brainNum, int obstacleNum, int deathTouch, int forceField, int invisibility) {
  grunts.clear();
  humans.clear();
  hulks.clear();
  brains.clear();
  bullets.clear();
  progs.clear();
  obstacles.clear();
  powerups.clear();
  spawn.play();
  player = new Player(map.getSpawnCell(true));
  int humanType = 0;
  for (int i = 0; i < gruntNum; i++) {
    grunts.add(new Grunt(map.getSpawnCell(false)));
  }  
  for (int i = 0; i < humanNum; i++) {
    humanType = (humanType%3)+1;
    humans.add(new Human(map.getSpawnCell(false), humanType));
  }
  for (int i = 0; i < hulkNum; i++) {
    hulks.add(new Hulk(map.getSpawnCell(false)));
  }
  for (int i = 0; i < brainNum; i++) {
    brains.add(new Brain(map.getSpawnCell(false), null));
  }
  for (int i = 0; i < deathTouch; i++) {
    powerups.add(new PowerUp(map.getSpawnCell(false), 1));
  }
  for (int i = 0; i < forceField; i++) {
    powerups.add(new PowerUp(map.getSpawnCell(false), 2));
  }
  for (int i = 0; i < invisibility; i++) {
    powerups.add(new PowerUp(map.getSpawnCell(false), 3));
  }
  for (int i = 0; i < obstacleNum; i++) {
    Cell randomCell = map.getSpawnCell(false);
    obstacles.add(new Obstacle(randomCell));
    map.addObstacle(map.pointToIndex(randomCell.getCentre()));
  }
}

void keyPressed() {
  if (key == 'w') {
    player.move(0);
  } else if (key == 's') {
    player.move(1);
  } else if (key == 'a') {
    player.move(2);
  } else if (key == 'd') {
    player.move(3);
  }
}

void keyReleased() {
  if (gameOver && clickReady) {
    endscreen.stop();
    setup();
  } else {
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
}

void mousePressed() {
  if (player.go) {
    shoot.play();
    bullets.add(new Bullet(player.getPosition(), new PVector(mouseX, mouseY), true));
  }
  if (gameOver && clickReady) {
    endscreen.stop();
    setup();
  }
}
