import java.util.Stack; //<>// //<>// //<>// //<>//
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Comparator;
import java.util.Arrays;
import java.util.Collections;

public class Map {
  ArrayList<ArrayList<int[]>> masses = new ArrayList<ArrayList<int[]>>();
  ArrayList<int[]> knownObstacles = new ArrayList<int[]>();
  Cell[][] map;
  int MAP_SIZE = 50;
  int DEATH_NUM = 4;
  int BIRTH_NUM = 4;

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
    for (int i = 0; i < 5; i++) {
      step();
    }
  }

  Cell getSpawnCell() {
    Cell cell = null;
    int x = 0;
    int y = 0;
    while (cell==null) {
      x = (int) random(0, MAP_SIZE);
      y = (int) random(0, MAP_SIZE);
      if (isIn(masses.get(0), new int[]{x, y}) && !isIn(knownObstacles, new int[]{x, y})) {
        cell = map[x][y];
      }
    }
    return cell;
  }

  public boolean isIn(ArrayList<int[]> map, int[] coords) {
    for (int[] coord : map) {
      if (Arrays.equals(coord, coords)) {
        return true;
      }
    }
    return false;
  }

  void step() {
    Cell[][] newMap = new Cell[MAP_SIZE][MAP_SIZE]; 
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        int livingNeighbours = countLivingNeighbours(x, y);
        if (map[x][y].getType()<3) {
          if (livingNeighbours < DEATH_NUM) {
            newMap[x][y] = new Cell(3, ((x*20)+10), ((y*20)+10));
          } else {
            newMap[x][y] = new Cell(1, ((x*20)+10), ((y*20)+10));
          }
        } else {
          if (livingNeighbours > BIRTH_NUM) {
            newMap[x][y] = new Cell(1, ((x*20)+10), ((y*20)+10));
          } else {
            newMap[x][y] = new Cell(3, ((x*20)+10), ((y*20)+10));
          }
        }
      }
    }
    this.map = newMap;
    display();
  }

  void initMap() {
    map = new Cell[MAP_SIZE][MAP_SIZE];
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        if (random(0, 100) < 45.5) {
          map[x][y] = new Cell(1, ((x*20)+10), ((y*20)+10));
        } else {
          map[x][y] = new Cell(3, ((x*20)+10), ((y*20)+10));
        }
      }
    }
  }

  Cell pointToCell(PVector point) {
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        if (map[x][y].isInside(point)) {
          return map[x][y];
        }
      }
    }
    return null;
  }

  int[] pointToIndex(PVector point) {
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        if (map[x][y].isInside(point)) {
          return new int[]{x, y};
        }
      }
    }
    return null;
  }

  boolean isHittingWall(PVector point, String dir) {
    int[] index = pointToIndex(point.copy());
    switch (dir) {
    case "up":
      if (index[1] == 0) {
        return point.y<=9.5;
      } else {
        if (map[index[0]][index[1]-1].getType() < 3) {
          PVector nPoint = point.copy().add(0, -12.5);
          return map[index[0]][index[1]-1].isInside(nPoint);
        }
      }
      break;
    case "down":
      if (index[1] == MAP_SIZE-1) {
        return point.y >= 1000-9.5;
      } else {
        if (map[index[0]][index[1]+1].getType() < 3) {
          PVector sPoint = point.copy().add(0, 12.5);
          return map[index[0]][index[1]+1].isInside(sPoint);
        }
      }
      break;
    case "left":
      if (index[0] == 0) {
        return point.x<=9.5;
      } else {
        if (map[index[0]-1][index[1]].getType() < 3) {
          PVector wPoint = point.copy().add(-12.5, 0);
          return map[index[0]-1][index[1]].isInside(wPoint);
        }
      }
      break;
    case "right":
      if (index[0] == MAP_SIZE-1) {
        return point.x>=1000-9.5;
      } else {
        if (map[index[0]+1][index[1]].getType() < 3) {
          PVector ePoint = point.copy().add(12.5, 0);
          return map[index[0]+1][index[1]].isInside(ePoint);
        }
      }
      break;
    case "topright":
      if (index[0] == MAP_SIZE-1) {
        return point.x>=9.5;
      } else if (index[1] == 0) {
        return point.y<=9.5;
      } else if (map[index[0]+1][index[1]-1].getType() < 3) {
        PVector nPoint = point.copy().add(0, -9.5);
        PVector ePoint = point.copy().add(9.5, 0);
        return (map[index[0]+1][index[1]].isInside(ePoint) && map[index[0]][index[1]-1].isInside(nPoint));
      }
      break;
    case "topleft":
      if (index[0] == 0) {
        return point.x<=9.5;
      } else if (index[1] == 0) {
        return point.y<=9.5;
      } else if (map[index[0]-1][index[1]-1].getType() < 3) {
        PVector nPoint = point.copy().add(0, -9.5);
        PVector wPoint = point.copy().add(-9.5, 0);
        return (map[index[0]-1][index[1]].isInside(wPoint) && map[index[0]][index[1]-1].isInside(nPoint));
      }
      break;
    case "bottomleft":
      if (index[0] == 0) {
        return point.x<=9.5;
      } else if (index[1] == MAP_SIZE-1) {
        return point.y>=1000-9.5;
      } else if (map[index[0]-1][index[1]+1].getType() < 3) {
        PVector sPoint = point.copy().add(0, 9.5);
        PVector wPoint = point.copy().add(-9.5, 0);
        return (map[index[0]-1][index[1]].isInside(wPoint) && map[index[0]][index[1]+1].isInside(sPoint));
      }
      break;      
    case "bottomright":
      if (index[0] == MAP_SIZE-1) {
        return point.x>=1000-9.5;
      } else if (index[1] == MAP_SIZE-1) {
        return point.y>=1000-9.5;
      } else if (map[index[0]+1][index[1]+1].getType() < 3) {
        PVector sPoint = point.copy().add(0, 9.5);
        PVector ePoint = point.copy().add(9.5, 0);
        return (map[index[0]+1][index[1]].isInside(ePoint) && map[index[0]][index[1]+1].isInside(sPoint));
      }
      break;
    }
    return false;
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
          } else if (map[neighbourX][neighbourY].getType()<3) {
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
        if (map[x][y].getType()<3) {
          if (countLivingNeighbours(x, y) !=8) {
            map[x][y].setType(2);
            cell.setFill(120);
          } else {
            cell.setFill(180);
          }
        } else {
          if (map[x][y].getType()==3) {
            cell.setFill(10);
          } else {
            color c = getMassColour(map[x][y].getType());
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
        if (map[x][y].getType()==3) {
          flood(x, y, floodNum);
          floodNum++;
        }
      }
    }
  }

  void clearMasses() {
    for (int x = 0; x < MAP_SIZE; x++) {
      for (int y = 0; y < MAP_SIZE; y++) {
        if (map[x][y].getType()>2) {
          map[x][y].setType(3);
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
          map[coord[0]][coord[1]].setType(1);
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
        if (i != mainMassIndex) {
          connectMasses(masses.get(i), masses.get(mainMassIndex));
          for (int j = 0; j < masses.size(); j++) {
            if (masses.get(j).size() > mainMassSize) {
              mainMassSize = masses.get(j).size();
              mainMassIndex = j;
            }
          }
        }
      }
    }
  }

  void connectMasses(ArrayList<int[]> small, ArrayList<int[]> main) {
    HashMap<String, String> parentMap = new HashMap<String, String>();
    ArrayList<String> neighbours = new ArrayList<String>();
    ArrayList<String> explored = new ArrayList<String>();
    int mainNum = map[main.get(0)[0]][main.get(0)[1]].getType();
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
                if (map[neighbourX][neighbourY].getType()==2 && !neighbours.contains(coordString)) {
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
              if (map[neighbourX][neighbourY].getType()==mainNum) {
                path = true;
                parentMap.put(neighbourString, current);
              } else {
                if (map[neighbourX][neighbourY].getType()<3 && !neighbours.contains(neighbourString) && neighbourString != current && !explored.contains(neighbourString)) {
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
      while (map[currentX][currentY].getType() < 4) {
        map[currentX][currentY].setType(3);
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
              map[neighbourX][neighbourY].setType(3);
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
              if (map[neighbourX][neighbourY].getType()==3 && !unfilled.contains(neighbourString)) {
                unfilled.push(neighbourString);
                map[neighbourX][neighbourY].setType(floodNum);
              }
            }
          }
        }
      }
      map[x][y].setType(floodNum);
      mass.add(new int[]{currentX, currentY});
    }
    masses.add(mass);
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
