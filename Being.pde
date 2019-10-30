public abstract class Being {
  PVector position;
  boolean alive;
  int speed;
  PVector velocity;
  PVector acceleration;
  
  
  void move(){}
  
  boolean isAlive(){
    return this.alive;
  }
  
  void display(){
    
  }
}
