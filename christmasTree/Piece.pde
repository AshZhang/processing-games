public class Piece extends Clickable {
  private PImage sprite;
  private PImage litSprite;
  private PImage offSprite;
  private int curRot;
  private boolean on;
  private boolean[] connectSides;  // 0 = top side, 3 = left side
  private boolean[] checkedSides;
  public Piece(int x, int y, int sWidth, int sHeight, String spriteLoc) {
    super(x, y, sWidth, sHeight);
    litSprite = loadImage(spriteLoc+".png");
    offSprite = loadImage("off/"+spriteLoc+" off.png");
    sprite = offSprite;
    curRot = 0;
    connectSides = new boolean[4];
    checkedSides = new boolean[4];
    switch(spriteLoc.substring(0, 1)) {
    case "4": 
      for (int i = 0; i < 4; i++) {
        connectSides[i] = true;
      }
      break;
    case "3": 
      for (int i = 0; i < 3; i++) {
        connectSides[i] = true;
      }; 
      break;
    case "2": 
      if ((spriteLoc.substring(spriteLoc.length() - 1).equals("I"))) {
        connectSides[0] = true;
        connectSides[2] = true;
      } else {
        connectSides[0] = true;
        connectSides[1] = true;
      }
      break;
    case "1": 
      connectSides[0] = true; 
      break;
    default: 
      break;
    }
  }
  public void turn() {  // rotates clockwise
    curRot++;
    boolean b = connectSides[3];
    for (int i = connectSides.length-1; i > 0; i--) {
      connectSides[i] = connectSides[i-1];
    }
    connectSides[0] = b;
    if (curRot > 3) {
      curRot = 0;
    }
  }

  public boolean isConnected(Piece other, int pos) {
    return other.getSides()[(pos + 2) % 4] && connectSides[pos];
  }

  public int getRot() {
    return curRot;
  }

  public boolean[] getSides() {
    return connectSides;
  }

  public boolean[] getCheckedSides() {
    return checkedSides;
  }

  public PImage getSprite() {
    return sprite;
  }

  public boolean isLit() {
    return on;
  }

  public void turnOff() {
    on = false;
    sprite = offSprite;
  }

  public void turnOn() {
    on = true;
    sprite = litSprite;
  }

  public void markSide(int side) {
    checkedSides[side] = true;
  }

  public void resetCheckedSides() {
    for (int i = 0; i < checkedSides.length; i++) {
      checkedSides[i] = false;
    }
  }
}