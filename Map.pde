import java.util.Stack; //<>// //<>//
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Comparator;
import java.util.Collections;

public class Map {
  ArrayList<ArrayList<int[]>> masses = new ArrayList<ArrayList<int[]>>();
  ArrayList<ArrayList<Cell>> map;
  int MAP_SIZE = 50;
  int DEATH_NUM = 4;
  int BIRTH_NUM = 4;
  boolean massCols;

  void generate() {
    initMap();
    for (int i = 0; i < 10; i++) {
      step();
    }
    mapMasses();
    while (masses.size()>1) {
      mergeMasses();
    }
    clearMasses();
  }

  void step() {
    ArrayList<ArrayList<Cell>> newMap = new ArrayList<ArrayList<Cell>>(); 
    for (int x = 0; x < MAP_SIZE; x++) {
      ArrayList<Cell> row = new ArrayList<Cell>();
      for (int y = 0; y < MAP_SIZE; y++) {
        int livingNeighbours = countLivingNeighbours(x, y);
        if (map.get(x).get(y).getType()<3) {
          if (livingNeighbours < DEATH_NUM) {
            row.add(new Cell(3));
          } else {
            row.add(new Cell(1));
          }
        } else {
          if (livingNeighbours > BIRTH_NUM) {
            row.add(new Cell(1));
          } else {
            row.add(new Cell(3));
          }
        }
      }
      newMap.add(row);
    }
    this.map = newMap;
    display();
  }

  void initMap() {
    map = new ArrayList<ArrayList<Cell>>();
    for (int x = 0; x < MAP_SIZE; x++) {
      ArrayList<Cell> row = new ArrayList<Cell>();
      for (int y = 0; y < MAP_SIZE; y++) {
        if (random(0, 100) < 45.5) {
          row.add(new Cell(1));
        } else {
          row.add(new Cell(3));
        }
      }
      map.add(row);
    }
  }

  int countLivingNeighbours(int x, int y) {
    int count = 0;
    for (int xMod = -1; xMod < 2; xMod++) {
      for (int yMod = -1; yMod < 2; yMod++) {
        if (!(xMod == 0 && yMod == 0)) {
          int neighbourX = x+xMod;
          int neighbourY = y+yMod;
          if ((neighbourX < 0 || neighbourY < 0 || neighbourX >= MAP_SIZE || neighbourY >= MAP_SIZE)) {
            count++;
          } else if (map.get(neighbourX).get(neighbourY).getType()<3) {
            count++;
          }
        }
      }
    }
    return count;
  }

  void display() {
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        PShape cell = createShape(RECT, x*20, y*20, MAP_SIZE, MAP_SIZE);
        if (map.get(x).get(y).getType()<3) {
          if (countLivingNeighbours(x, y) !=8) {
            map.get(x).get(y).setType(2);
            cell.setFill(120);
          } else {
            cell.setFill(180);
          }
        } else {
          if (map.get(x).get(y).getType()==3) {
            cell.setFill(10);
          } else {
            color c = getMassColour(map.get(x).get(y).getType());
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
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        if (map.get(x).get(y).getType()==3) {
          flood(x, y, floodNum);
          floodNum++;
        }
      }
    }
    massCols = true;
  }

  void clearMasses() {
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        if (map.get(x).get(y).getType()>2) {
          map.get(x).get(y).setType(3);
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
          map.get(coord[0]).get(coord[1]).setType(1);
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
        //  println ("CONNECT CALLED: " + i);
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
    int mainNum = map.get(main.get(0)[0]).get(main.get(0)[1]).getType();
    for (int[] coord : small) {
      if (countLivingNeighbours(coord[0], coord[1]) < 8) {
        for (int xMod = -1; xMod < 2; xMod++) {
          for (int yMod = -1; yMod < 2; yMod++) {
            if (!(xMod == 0 && yMod == 0) && (xMod == 0 || yMod == 0)) {
              int neighbourX = coord[0]+xMod;
              int neighbourY = coord[1]+yMod;
              String parentString = Integer.toString(coord[0])+"-"+Integer.toString(coord[1]);
              String coordString = Integer.toString(neighbourX)+"-"+Integer.toString(neighbourY);
              if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= MAP_SIZE || neighbourY >= MAP_SIZE)) {
                if (map.get(neighbourX).get(neighbourY).getType()==2 && !neighbours.contains(coordString)) {
                  parentMap.put(coordString, parentString );
                  neighbours.add(coordString);
                }
              }
            }
          }
        }
      }
    }
    Collections.sort(neighbours, new CustomComparator());
    boolean path = false;
    String current = "";
    while (!neighbours.isEmpty() && !path) {
      Collections.sort(neighbours, new CustomComparator());
      current = neighbours.get(0);
      neighbours.remove(0);
      explored.add(current);
      int currentX = Integer.parseInt(current.split("-")[0]);
      int currentY = Integer.parseInt(current.split("-")[1]);
      for (int xMod = -1; xMod < 2; xMod++) {
        for (int yMod = -1; yMod < 2; yMod++) {
          if (!(xMod == 0 && yMod == 0)) {
            int neighbourX = currentX+xMod;
            int neighbourY = currentY+yMod;
            String neighbourString = Integer.toString(neighbourX) +"-"+ Integer.toString(neighbourY);
            if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= MAP_SIZE || neighbourY >= MAP_SIZE)) {
              if (map.get(neighbourX).get(neighbourY).getType()==mainNum) {
                path = true;
                parentMap.put(neighbourString, current);
              } else {
                if (map.get(neighbourX).get(neighbourY).getType()<3 && !neighbours.contains(neighbourString) && neighbourString != current && !explored.contains(neighbourString)) {
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
      while (map.get(currentX).get(currentY).getType() < 4) {
        map.get(currentX).get(currentY).setType(3);
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
            if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= MAP_SIZE || neighbourY >= MAP_SIZE)) {
              map.get(neighbourX).get(neighbourY).setType(3);
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
            if (!(neighbourX < 0 || neighbourY < 0 || neighbourX >= MAP_SIZE || neighbourY >= MAP_SIZE)) {
              if (map.get(neighbourX).get(neighbourY).getType()==3 && !unfilled.contains(neighbourString)) {
                unfilled.push(neighbourString);
                map.get(neighbourX).get(neighbourY).setType(floodNum);
              }
            }
          }
        }
      }
      map.get(x).get(y).setType(floodNum);
      mass.add(new int[]{currentX, currentY});
    }
    masses.add(mass);
  }

  void retract() {
    ArrayList<ArrayList<Cell>> newMap = new ArrayList<ArrayList<Cell>>(); 
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        if (map.get(x).get(y).getType()<3) {
          if (countLivingNeighbours(x, y) !=8) {
            newMap.get(x).get(y).setType(3);
          } else {
            newMap.get(x).get(y).setType(1);
          }
        } else {
          newMap.get(x).get(y).setType(3);
        }
      }
    }
    this.map = newMap;
  }

  public Map(boolean premake) {
    if (premake) {
      this.generate();
    } else {
      this.initMap();
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
