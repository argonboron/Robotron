public class Map {
  boolean[][] map;
  int WIDTH_NUM = 50;
  int HEIGHT_NUM = 50;
  int DEATH_NUM = 4;
  int BIRTH_NUM = 4;
  
  void generate() {
    //procedural generation
    initMap();
  }
  void step() {
    boolean[][] newMap = new boolean[WIDTH_NUM][HEIGHT_NUM]; 
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
        int livingNeighbours = countLivingNeighbours(x, y);
        if (map[x][y]) {
          if (livingNeighbours < DEATH_NUM) {
            newMap[x][y] = false;
          } else {
            newMap[x][y] = true;
          }
        } else {
          if (livingNeighbours > BIRTH_NUM) {
            newMap[x][y] = true;
          } else {
            newMap[x][y] = false;
          }
        }
      }
    }
    this.map = newMap;
    display();
  }
  
  void initMap() {
    for (int x = 0; x < WIDTH_NUM; x++) {
      for (int y = 0; y < HEIGHT_NUM; y++) {
        if (random(0, 100) < 45.5) {
          map[x][y] = true;
        }else {
          map[x][y] = false;
        }
        //map[x][y] = (random(0, 100) < 48) ? true : false;
      }
    }
  }

  int countLivingNeighbours(int x, int y) {
    int count = 0;
    for (int xMod = -1; xMod < 2; xMod++) {
      for (int yMod = -1; yMod < 2; yMod++) {
        if (!(xMod == 0 && yMod == 0)) {
          int neighbourX = x+xMod;
          int neighbourY = y+yMod;
          if ((neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length)){
            count++;
          } else if (map[neighbourX][neighbourY]) {
            count++;
          }
        }
      }
    }
    return count;
  }
  
  void display() {
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
         PShape cell = createShape(RECT, x*20, y*20, WIDTH_NUM, HEIGHT_NUM);
         if (map[x][y]) {
           if(countLivingNeighbours(x, y) !=8) {
             cell.setFill(120);
           } else {
             cell.setFill(10);
           }
         } else {
           cell.setFill(240);
         }
         shape(cell);
      }
    }
  }
  
  void retract() {
    boolean[][] newMap = new boolean[WIDTH_NUM][HEIGHT_NUM]; 
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
         if (map[x][y]) {
           if(countLivingNeighbours(x, y) !=8) {
             newMap[x][y] = false;
           } else {
             newMap[x][y] = true;
           }
         } else {
             newMap[x][y] = false;
         }
      }
    }
    this.map = newMap;
  }

  public Map() {
    map = new boolean[WIDTH_NUM][HEIGHT_NUM];
    this.generate();
  }
}
