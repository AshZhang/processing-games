public class Clickable {
  int x;
  int y;
  int sWidth;
  int sHeight;
  public Clickable(int x, int y, int sWidth, int sHeight) {
    this.x = x;
    this.y = y;
    this.sWidth = sWidth;
    this.sHeight = sHeight;
  }

  public boolean isClicked(int mX, int mY) {
    if (mX > x && mX < x + sWidth) {
      if (mY > y && mY < y + sHeight) {
        return true;
      }
    }
    return false;
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public int getWidth() {
    return sWidth;
  }
  public int getHeight() {
    return sHeight;
  }
}