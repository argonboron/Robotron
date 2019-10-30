import java.util.ArrayList; //<>// //<>// //<>//
import java.util.HashMap;
import java.util.Collections;
import java.util.Comparator;

public abstract class Robot extends Being {
  PVector target;
  boolean hunt;
  int id;
  Node goalNode;
  ArrayList<PVector> path = new ArrayList<PVector>();

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
    Node current =null;
    while (!frontier.isEmpty()) {
      Collections.sort(frontier, new sortByFValue());
      current = frontier.remove(0);

      // visit next
      neighbours = getNodeNeighbours(current);
      if (found) {
        break;
      }
      // Visit all children
      for (Node neighbour : neighbours) {
        // If unexplored
        if (!explored.contains(neighbour.getCentre())) {
          if (!(neighbour.getX()==current.getX() && neighbour.getY()==current.getY())) {
            // Checkgoal
            if (neighbour.getCentre().equals(target)) {
              goalNode = neighbour;
              found = true;
            }
            if (!nodeInFrontier(frontier, neighbour)) {
              //Set cost
              neighbour.setCost(calculateCost(current, neighbour));
              //Set heuristic
              neighbour.setHeuristic(target);
              // Tell them their depth
              neighbour.setDepth(current.getDepth() + 1);
              // Map child to parent
              predecessorMap.put(neighbour, current);
              neighbour.setParent(current);
              // Add to frontier
              map.set(neighbour.getCentre(), 6);
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
      // Add to explored
      map.set(current.getCentre(), 5);
      explored.add(current.getCentre().copy());
    }
    return makePath(target, predecessorMap, found);
  }

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
      System.out.println("No findable path somehow");
      return null;
    }
  }

  int calculateCost(Node current, Node neighbour) {
    if (current.getX() == neighbour.getX() || current.getY() == neighbour.getY()) {
      return 20 + current.getCost();
    } else {
      return 28 + current.getCost();
    }
  }

  boolean nodeInFrontier(ArrayList<Node> frontier, Node current) {
    for (Node node : frontier) {
      if (node.getX() == current.getX() && node.getY() == current.getY()) {
        return true;
      }
    }
    return false;
  }

  int indexFromFrontier(ArrayList<Node> frontier, Node current) {
    for (int i = 0; i < frontier.size(); i++) {
      if (frontier.get(i).getX() == current.getX() && frontier.get(i).getY() == current.getY()) {
        return i;
      }
    }
    return -1;
  }

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
}

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
