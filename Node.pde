public class Node {
  PVector centre;
  int x, y, cost, heuristic, depth;
  Node parent;

  PVector getCentre() {
    return centre;
  } 

  int getFValue() {
    return cost+heuristic;
  }

  void setCost(int cost) {
    this.cost = cost;
  }
  int getCost() {
    return cost;
  }
  void setDepth(int depth) {
    this.depth = depth;
  }

  int getDepth() {
    return this.depth;
  }

  public int getHeuristic() {
    return this.heuristic;
  }

  int getX() {
    return this.x;
  }  

  int getY() {
    return this.y;
  }
  Node getParent() {
    return this.parent;
  }

  void setParent(Node parent) {
    this.parent = parent;
  }

  void setHeuristic(PVector target) {
    heuristic = (int) centre.dist(target);
  }

  Node(int x, int y, PVector centre, PVector goal) {
    this.x =x;
    this.y=y;
    this.centre=centre;
    this.heuristic = (int) centre.dist(goal);
  }
}
