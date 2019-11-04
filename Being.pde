public abstract class Being {
  ArrayList<PVector> path = new ArrayList<PVector>();
  PVector position, target, velocity, acceleration, targetVel, randomTarget;
  Node goalNode;
  boolean alive, hunt, go;
  float orientation, speed, size;
  final float ORIENTATION_INCREMENT = PI/32 ;

  //Integrate function to update position, velocity and orientation of all beings per frame
  void integrate(PVector targetVel) {
    if (go) {
      velocity = targetVel;
      velocity.normalize() ;
      velocity.mult(speed) ;
      collisionCheck(false);
      position.add(velocity) ;
      if ((position.x < 0) || (position.x > 1000)) {
        velocity.x = -velocity.x;
      }
      if ((position.y < 0) || (position.y > 1000)) {
        velocity.y = -velocity.y;
      }
      float targetOrientation = atan2(velocity.y, velocity.x) ;
      if (abs(targetOrientation - orientation) <= ORIENTATION_INCREMENT) {
        orientation = targetOrientation ;
        return ;
      }
      if (targetOrientation < orientation) {
        if (orientation - targetOrientation < PI) {
          orientation -= ORIENTATION_INCREMENT;
        } else {
          orientation += ORIENTATION_INCREMENT;
        }
      } else {
        if (targetOrientation - orientation < PI) {
          orientation += ORIENTATION_INCREMENT;
        } else {
          orientation -= ORIENTATION_INCREMENT;
        }
      }
      if (orientation > PI) {
        orientation -= 2*PI;
      } else if (orientation < -PI) {
        orientation += 2*PI ;
      }
    }
  }

  //Implementation of A* algortithm
  ArrayList<PVector> getPath(PVector target) {
    this.target = target;
    ArrayList<PVector> explored = new ArrayList<PVector>();
    ArrayList<Node> frontier = new ArrayList<Node>();
    HashMap<Node, Node> predecessorMap = new HashMap<Node, Node>();
    ArrayList<Node> neighbours = new ArrayList<Node>();
    boolean found = false;
    Node start = new Node(map.pointToIndex(position)[0], map.pointToIndex(position)[1], map.pointToCell(position).getCentre(), target);
    frontier.add(start);
    start.setDepth(0);
    if (map.pointToCell(position).getCentre() == map.pointToCell(target).getCentre()) {
      return null;
    }
    Node current =null;
    while (!frontier.isEmpty()) {
      Collections.sort(frontier, new sortByFValue());
      current = frontier.remove(0);
      // visit next
      neighbours = getNodeNeighbours(current);
      if (found) {
        break;
      }
      // Visit all neighbours
      for (Node neighbour : neighbours) {
        // If unexplored
        if (!explored.contains(neighbour.getCentre())) {
          if (!(neighbour.getX()==current.getX() && neighbour.getY()==current.getY())) {
            // Check goal condition
            if (neighbour.getCentre().equals(map.pointToCell(target).getCentre())) {
              goalNode = neighbour;
              found = true;
            }
            if (!nodeInFrontier(frontier, neighbour)) {
              //Set cost for node
              neighbour.setCost(calculateCost(current, neighbour));
              //Set heuristic for node
              neighbour.setHeuristic(target);
              // Set depth for Node
              neighbour.setDepth(current.getDepth() + 1);
              // link child to parent
              predecessorMap.put(neighbour, current);
              neighbour.setParent(current);
              // Add to frontier
              frontier.add(neighbour);
            } else {
              if (calculateCost(current, neighbour) < frontier.get(indexFromFrontier(frontier, neighbour)).getCost()) {
                frontier.remove(indexFromFrontier(frontier, neighbour));
                //Set cost
                int newCost = calculateCost(current, neighbour);
                neighbour.setCost(newCost);
                //Set heuristic
                neighbour.setHeuristic(target);
                // Tell them their depth
                neighbour.setDepth(current.getDepth() + 1);
                // Map child to parent
                predecessorMap.put(neighbour, current);
                neighbour.setParent(current);
                // Add to frontier
                frontier.add(neighbour);
              }
            }
          }
        }
      }
      // Add to explored (closed set)
      explored.add(current.getCentre().copy());
    }
    return makePath(target, predecessorMap, found);
  }

  //Check for collisions with wall
  void collisionCheck(boolean player) {
    int[] index = map.pointToIndex(position.copy());
    int neighbours = map.countLivingNeighbours(index[0], index[1]);
    boolean hit = false;

    if (neighbours > 0) {
      if (map.isHittingWall(position.copy(), "up", player)) {
        hit = true;
        if (velocity.y < 0) {
          velocity.y=0;
        }
      }
      if (map.isHittingWall(position.copy(), "down", player)) {
        hit = true;
        if (velocity.y > 0) {
          velocity.y=0;
          hit = true;
        }
      }
      if (map.isHittingWall(position.copy(), "left", player)) {
        hit = true;
        if (velocity.x < 0) {
          velocity.x=0;
        }
      }
      if (map.isHittingWall(position.copy(), "right", player)) {
        hit = true;
        if (velocity.x > 0) {
          velocity.x=0;
        }
      }
      if (!hit) {
        if (map.isHittingWall(position.copy(), "topright", player)) {
          if (velocity.x > 0) {
            velocity.x=0;
          }
          if (velocity.y < 0) {
            velocity.y=0;
          }
        }
        if (map.isHittingWall(position.copy(), "bottomright", player)) {
          if (velocity.x > 0) {
            velocity.x=0;
          }        
          if (velocity.y > 0) {
            velocity.y=0;
          }
        }
        if (map.isHittingWall(position.copy(), "topleft", player)) {
          if (velocity.y < 0) {
            velocity.y=0;
          }
          if (velocity.x < 0) {
            velocity.x=0;
          }
        }
        if (map.isHittingWall(position.copy(), "bottomleft", player)) {
          if (velocity.y > 0) {
            velocity.y=0;
          }
          if (velocity.x < 0) {
            velocity.x=0;
          }
        }
      }
      hit = false;
    }
  }

  //Take output of A* and build arraylsit of PVectors for being to travel down
  ArrayList<PVector> makePath(PVector target, HashMap<Node, Node> predecessorMap, boolean found) {
    path = new ArrayList<PVector>();
    if (found) {
      PVector currentPath = target;
      Node currentNode = goalNode;
      path.add(currentPath.copy());
      for (int i = 0; i < goalNode.getDepth()-1; i++) {
        path.add(predecessorMap.get(currentNode).getCentre());
        currentNode = predecessorMap.get(currentNode);
      }
      Collections.reverse(path);
      return path;
    } else {
      return null;
    }
  }

  //Set cost of node
  int calculateCost(Node current, Node neighbour) {
    if (current.getX() == neighbour.getX() || current.getY() == neighbour.getY()) {
      return 20 + current.getCost();
    } else {
      return 28 + current.getCost();
    }
  }

  //Give being next point of path to follow if it has reached its previous goal
  PVector followPath() {
    if (map.pointToCell(position) != null) {
      if (map.pointToCell(position).getCentre() == map.pointToCell(path.get(0)).getCentre()) {
        path.remove(0);
      }
    }
    return path.get(0);
  }

  //Check if node is in frontier
  boolean nodeInFrontier(ArrayList<Node> frontier, Node current) {
    for (Node node : frontier) {
      if (node.getX() == current.getX() && node.getY() == current.getY()) {
        return true;
      }
    }
    return false;
  }

  //Get the index that a node is at in the frontier
  int indexFromFrontier(ArrayList<Node> frontier, Node current) {
    for (int i = 0; i < frontier.size(); i++) {
      if (frontier.get(i).getX() == current.getX() && frontier.get(i).getY() == current.getY()) {
        return i;
      }
    }
    return -1;
  }

  //Given a node return it's neighbours
  ArrayList<Node> getNodeNeighbours(Node node) {
    ArrayList<Node> neighbours = new ArrayList<Node>();
    ArrayList<Cell> neighbourCells = map.getNeighbours(map.pointToIndex(node.getCentre()));
    for (Cell cell : neighbourCells) {
      Node newNode = new Node(map.pointToIndex(cell.getCentre())[0], map.pointToIndex(cell.getCentre())[1], cell.getCentre(), target);
      newNode.setCost(calculateCost(node, newNode));
      neighbours.add(newNode);
    }
    return neighbours;
  } 

  boolean display() {
    return alive;
  }

  void die() {
    alive = false;
  }

  PVector getPosition() {
    return this.position.copy();
  }
}
//Comparator to sort nodes by F Value for A*
class sortByFValue implements Comparator<Node> {
  public int compare(Node a, Node b) {
    int f1 = a.getFValue();
    int f2 = b.getFValue();
    int fComp = f1-f2;
    if (fComp!=0) {
      return fComp;
    }
    int h1 = a.getHeuristic();
    int h2 = b.getHeuristic();
    return  h1-h2;
  }
}
