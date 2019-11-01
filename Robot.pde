public class Robot extends Being {
  boolean isHittingPlayer(PVector pos) {
    if (PVector.dist(this.position, pos) < (this.size-3+16.5)) {
      player.hit();
      return true;
    } else {
      return false;
    }
  }
}
