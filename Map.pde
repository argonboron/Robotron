import java.util.Stack; //<>//
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Comparator;
import java.util.Collections;

public class Map {
  ArrayList<ArrayList<int[]>> masses = new ArrayList<ArrayList<int[]>>();
  int[][] map;
  int WIDTH_NUM = 50;
  int HEIGHT_NUM = 50;
  int DEATH_NUM = 4;
  int BIRTH_NUM = 4;
  boolean massCols;

  void generate() {
    initMap();
  }

  void step() {
    int[][] newMap = new int[WIDTH_NUM][HEIGHT_NUM]; 
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
        int livingNeighbours = countLivingNeighbours(x, y);
        if (map[x][y]<3) {
          if (livingNeighbours < DEATH_NUM) {
            newMap[x][y] = 3;
          } else {
            newMap[x][y] = 1;
          }
        } else {
          if (livingNeighbours > BIRTH_NUM) {
            newMap[x][y] = 1;
          } else {
            newMap[x][y] = 3;
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
          map[x][y] = 1;
        } else {
          map[x][y] = 3;
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
          if ((neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length)) {
            count++;
          } else if (map[neighbourX][neighbourY]<3) {
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
        if (map[x][y]<3) {
          if (countLivingNeighbours(x, y) !=8) {
            map[x][y]=2;
            cell.setFill(120);
          } else {
            cell.setFill(180);
          }
        } else {
          if (map[x][y]==3) {
            cell.setFill(10);
          } else {
            color c = getMassColour(map[x][y]);
            cell.setFill(c);
          }
        }
        shape(cell);
      }
    }
  }

  void mapMasses() {
    masses.clear();
    clearMasses();
    int floodNum = 4;
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
        if (map[x][y]==3) {
          flood(x, y, floodNum);
          floodNum++;
        }
      }
    }
    massCols = true;
  }

  void clearMasses() {
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
        if (map[x][y]>2) {
          map[x][y] =3;
        }
      }
    }
  }

  color getMassColour(int num) {
    switch(num) {
    case 4:
      return color(10, 10, 50);
    case 5:
      return color (50, 10, 10);
    case 6:
      return color(10, 50, 10);
    case 7:
      return color (50, 50, 10);
    case 8:
      return color (50, 10, 50);
    case 9:
      return color (10, 50, 50);
    case 10:
      return color (50, 50, 50);
    default:
      return color(random(10, 60), random(10, 60), random(10, 60));
    }
  }

  void mergeMasses() {
    for (int i = 0; i < masses.size(); i++) {
      if (masses.get(i).size() < 30) {
        for (int[] coord : masses.get(i)) {
          map[coord[0]][coord[1]] = 1;
        }
        masses.remove(i);
        i--;
      }
    }
    if (masses.size() > 1) {
      int mainMassSize = 0;
      int mainMassIndex = 0;
      for (int i = 0; i < masses.size(); i++) {
        if (masses.get(i).size() > mainMassSize) {
          mainMassSize = masses.get(i).size();
          mainMassIndex = i;
        }
      }
      for (int i = 0; i < masses.size(); i++) {
        println ("CONNECT CALLED");
        if (i != mainMassIndex) {
          connectMasses(masses.get(i), masses.get(mainMassIndex));
        }
      }
    }
  }

  void connectMasses(ArrayList<int[]> small, ArrayList<int[]> main) {
    HashMap<String, String> parentMap = new HashMap<String, String>();
    ArrayList<String> neighbours = new ArrayList<String>();
    ArrayList<String> explored = new ArrayList<String>();
    int mainNum = map[main.get(0)[0]][main.get(0)[1]];
    for (int[] coord : small) {
      if (countLivingNeighbours(coord[0], coord[1]) < 8) {
        for (int xMod = -1; xMod < 2; xMod++) {
          for (int yMod = -1; yMod < 2; yMod++) {
            if (!(xMod == 0 && yMod == 0) && (xMod == 0 || yMod == 0)) {
              int neighbourX = coord[0]+xMod;
              int neighbourY = coord[1]+yMod;
              String parentString = Integer.toString(coord[0])+"-"+Integer.toString(coord[1]);
              String coordString = Integer.toString(neighbourX)+"-"+Integer.toString(neighbourY);
              if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length)) {
                if (map[neighbourX][neighbourY]==2 && !neighbours.contains(coordString)) {
                  parentMap.put(coordString, parentString );
                  neighbours.add(coordString);
                }
              }
            }
          }
        }
      }
    }
    boolean path = false;
    String current = "";
    while (!neighbours.isEmpty() && !path) {
      Collections.sort(neighbours, new CustomComparator());
      current = neighbours.get(0);
      explored.add(current);
      int currentX = Integer.parseInt(current.split("-")[0]);
      int currentY = Integer.parseInt(current.split("-")[1]);
      for (int xMod = -1; xMod < 2; xMod++) {
        for (int yMod = -1; yMod < 2; yMod++) {
          if (!(xMod == 0 && yMod == 0) && (xMod == 0 || yMod == 0)) {
            int neighbourX = currentX+xMod;
            int neighbourY = currentY+yMod;
            String neighbourString = Integer.toString(neighbourX) +"-"+ Integer.toString(neighbourY);
            if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length)) {
              if (map[neighbourX][neighbourY]==mainNum) {
                path = true;
                parentMap.put(neighbourString, current);
              } else {
                if (map[neighbourX][neighbourY]<3 && !neighbours.contains(neighbourString) && neighbourString != current && !explored.contains(neighbourString)) {
                  neighbours.add(neighbourString);
                  parentMap.put(neighbourString, current);
                }
              }
            }
          }
        }
      }
    }
    ArrayList<String> pathList = new ArrayList<String>();
    if (path) {
      pathList.add(current);
      int currentX = Integer.parseInt(current.split("-")[0]);
      int currentY = Integer.parseInt(current.split("-")[1]);
      while (map[currentX][currentY] < 4) {
        map[currentX][currentY] = 3;
        current = parentMap.get(current);
        pathList.add(current);
        currentX = Integer.parseInt(current.split("-")[0]);
        currentY = Integer.parseInt(current.split("-")[1]);
      }
    }
    for (String coord : pathList) {
      for (int xMod = -1; xMod < 2; xMod++) {
        for (int yMod = -1; yMod < 2; yMod++) {
          if (!(xMod == 0 && yMod == 0)) {
            int neighbourX = Integer.parseInt(coord.split("-")[0])+xMod;
            int neighbourY = Integer.parseInt(coord.split("-")[1])+yMod;
            if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length)) {
              map[neighbourX][neighbourY]=3;
            }
          }
        }
      }
    }
    mapMasses();
  }

  void flood(int x, int y, int floodNum) {
    ArrayList<int[]> mass = new ArrayList<int[]>();
    Stack<String> unfilled = new Stack<String>();
    unfilled.push(Integer.toString(x) +"-"+ Integer.toString(y));
    while (!unfilled.isEmpty()) {
      String current = unfilled.pop();
      int currentX = Integer.parseInt(current.split("-")[0]);
      int currentY = Integer.parseInt(current.split("-")[1]);
      for (int xMod = -1; xMod < 2; xMod++) {
        for (int yMod = -1; yMod < 2; yMod++) {
          if (!(xMod == 0 && yMod == 0) && (xMod == 0 || yMod == 0)) {
            int neighbourX = currentX+xMod;
            int neighbourY = currentY+yMod;
            String neighbourString = Integer.toString(neighbourX) +"-"+ Integer.toString(neighbourY);
            if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length)) {
              if (map[neighbourX][neighbourY]==3 && !unfilled.contains(neighbourString)) {
                unfilled.push(neighbourString);
                map[neighbourX][neighbourY] = floodNum;
              }
            }
          }
        }
      }
      map[x][y] = floodNum;
      mass.add(new int[]{currentX, currentY});
    }
    masses.add(mass);
  }

  void retract() {
    int[][] newMap = new int[WIDTH_NUM][HEIGHT_NUM]; 
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
        if (map[x][y]<3) {
          if (countLivingNeighbours(x, y) !=8) {
            newMap[x][y] = 3;
          } else {
            newMap[x][y] = 1;
          }
        } else {
          newMap[x][y] = 3;
        }
      }
    }
    this.map = newMap;
  }

  public Map(boolean premake) {
    if (premake) {
      map = new int[WIDTH_NUM][HEIGHT_NUM];
      this.generate();
    } else {
      map = new int[WIDTH_NUM][HEIGHT_NUM];
      this.generate();
    }
  }
}

class CustomComparator implements Comparator<String> {
  @Override
    public int compare(String a, String b) {

    int aX = Integer.parseInt(a.split("-")[0]);
    int aY = Integer.parseInt(a.split("-")[1]);
    int bX = Integer.parseInt(b.split("-")[0]);
    int bY = Integer.parseInt(b.split("-")[1]);

    int aDiff = Math.abs(aX-24)+Math.abs(aY-24);
    int bDiff = Math.abs(bX-24)+Math.abs(bY-24);
    return  aDiff-bDiff;
  }
}
