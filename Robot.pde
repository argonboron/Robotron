public class Robot extends Being {
  boolean flee;

  void setGo() {
    this.go = player.go;
  }

  void forceField(boolean force) {
    flee = force;
  }

  void isHittingPlayer() {
    if (!player.invincible) {
      if (PVector.dist(this.position, player.getPosition()) < (this.size)) {
        player.hit();
      }
    }
  }
}
