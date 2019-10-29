public abstract class Being {
  PVector position;
  boolean alive;
  int speed;
  
  
  void move(){}
  
  boolean isAlive(){
    return this.alive;
  }
  
  boolean isTouching(PVector pos, int size) {
    return false;
  }
  void display(){
    
  }
}
