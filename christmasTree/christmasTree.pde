import java.util.Scanner;
import ddf.minim.*;
// Music (Nouvelle Noel and Jingle Bells) by Kevin MacLeod

Piece[][] pieces = new Piece[9][17];
Clickable getAzula;
Clickable reset;
Clickable scramble;
String[] colors = {"red", "blu", "grn", "prp", "org"};
String[] layout;
Scanner scan;
boolean win = false;
boolean forceWin = false;
PImage[] fires;
PImage[] lightning;
PImage tree;
PImage stars;
Minim minim;
AudioPlayer playMus;
AudioPlayer winMus;
AudioPlayer curMus;

void setup() {
  size(644, 530);
  surface.setTitle("Christmas Tree");
  minim = new Minim(this);
  playMus = minim.loadFile("play music.mp3");
  winMus = minim.loadFile("win music.mp3");
  curMus = playMus;
  layout = loadStrings("treePieceLayout.txt");
  getAzula = new Clickable(50, height-100, 180, 25);
  reset = new Clickable(50, height-70, 215, 25);
  scramble = new Clickable(50, height-40, 125, 25);
  fires = new PImage[2];
  for (int i = 1; i <= fires.length; i++) {
    fires[i-1] = loadImage("fire "+i+".png");
  }
  lightning = new PImage[2];
  lightning[0] = loadImage("lightning 1.png");
  lightning[1] = loadImage("lightning 2.png");
  tree = loadImage("tree plain.png");
  stars = loadImage("stars.png");
  int layoutRow = 1;
  int offset = 0;
  for (int r = pieces.length - 2; r >= 0; r--) {
    scan = new Scanner(layout[layoutRow]);
    for (int c = offset; c < pieces[r].length - offset; c++) {
      String name = getPieceName(scan);
      pieces[r][c] = new Piece(50 + 32*c, 90 + 32*r, 32, 32, name);
      for (int i = 0; i < (int)(Math.random() * 10); i++) {
        pieces[r][c].turn();
      }
    }
    layoutRow++;
    offset++;
  }
  scan = new Scanner(layout[0]);
  for (int i = 0; i < pieces[8].length; i++) {
    String name = getPieceName(scan);
    pieces[8][i] = new Piece(50 + 32*i, 90 + 32*8, 32, 32, name);
    for (int j = 0; j < (int)(Math.random() * 10); j++) {
      pieces[8][i].turn();
    }
  }
  pieces[8][8].turnOn();
}

void draw() {
  background(255);
  text("Light up the tree by connecting the circuits.\nClick each circuit piece to rotate it.", 10, 20);
  fill(#FF9512);
  rect(getAzula.getX(), getAzula.getY(), getAzula.getWidth(), getAzula.getHeight());
  fill(0);
  text("Hire Azula (light all circuits)", getAzula.getX() + 10, getAzula.getY() + 15);
  fill(#12C2FF);
  rect(reset.getX(), reset.getY(), reset.getWidth(), reset.getHeight());
  fill(0);
  text("Hire Katara (make Azula go away)", reset.getX() + 10, reset.getY() + 15);
  fill(#D8F6FF);
  rect(scramble.getX(), scramble.getY(), scramble.getWidth(), scramble.getHeight());
  fill(0);
  text("Scramble circuit", scramble.getX() + 10, scramble.getY() + 15);
  image(tree, 16, 50);
  if (forceWin) {
    tint(255, (int)(Math.random() * 127 + 127));
    image(fires[(int)(Math.random()*fires.length)], 16, 0);
    noTint();
  } else if (win) {
    image(stars, 32, 20);
    textSize(28);
    fill(#1A6C15);
    text("Merry\nChristmas!", width-200, height-75);
    textSize(12);
    playMus.pause();
    if (!winMus.isPlaying()) {
      winMus.rewind();
      winMus.play();
    }
  } else {
    winMus.pause();
    if (!playMus.isPlaying()) {
      playMus.rewind();
      playMus.play();
    }
  }
  for (int r = 0; r < pieces.length; r++) {
    for (int c = 0; c < pieces[r].length; c++) {
      if (pieces[r][c] != null) {
        if (forceWin) {
          for (Piece[] row : pieces) {
            for (Piece p : row) {
              if (p != null) {
                p.turnOn();
              }
            }
          }
        } else {
          if (touchingPower(r, c)) {
            pieces[r][c].turnOn();
          } else {
            pieces[r][c].turnOff();
          }
          for (Piece[] row : pieces) {
            for (Piece p : row) {
              if (p != null) {
                p.resetCheckedSides();
              }
            }
          }
        }
      }
    }
  }
  for (Piece[] row : pieces) {
    for (Piece p : row) {
      if (p != null) {
        pushMatrix();
        translate(p.getX() + 16, p.getY() + 16);
        rotate(p.getRot() * (PI/2));
        translate(-p.getX() - 16, -p.getY() - 16);
        image(p.getSprite(), p.getX(), p.getY());
        popMatrix();
      }
    }
  }
  if (forceWin) {
    if ((int)(Math.random() * 5) == 1) {
      image(lightning[(int)(Math.random()*lightning.length)], 75, 50);
    }
  } else {
    win = true;
    for (Piece[] row : pieces) {
      for (Piece p : row) {
        if (p != null && !p.isLit()) {
          win = false;
        }
      }
    }
  }
}

void mousePressed() {
  if (getAzula.isClicked(mouseX, mouseY)) {
    forceWin = true;
  } else if (reset.isClicked(mouseX, mouseY)) {
    forceWin = false;
  } else if (scramble.isClicked(mouseX, mouseY)) {
    for (Piece[] row : pieces) {
      for (Piece p : row) {
        if (p != null) {
          for (int i = 0; i < (int)(Math.random() * 10); i++) {
            p.turn();
          }
        }
      }
    }
  } else {
    for (Piece[] row : pieces) {
      for (Piece p : row) {
        if (p != null && p.isClicked(mouseX, mouseY)) {
          p.turn();
        }
      }
    }
  }
}

String getPieceName(Scanner scan) {
  String name = "";
  switch(scan.next()) {
  case "1": 
    name = "1 way "+colors[(int)(Math.random()*colors.length)];
    break;
  case "5": 
    name = "2 way L";
    break;
  case "6": 
    name = "2 way I";
    break;
  case "3": 
    name = "3 way";
    break;
  case "4": 
    name = "4 way";
    break;
  default: 
    break;
  }
  return name;
}

boolean touchingPower(int r, int c) {  // depth first search: if the sides are touching, then search down that branch until all branches searched, then true if any branch = power
  if (r == 8 && c == 8) {
    return true;
  }
  if (r < 0 || c < 0) {
    return false;
  }
  if (r >= pieces.length || c >= pieces[0].length) {
    return false;
  }
  boolean upConnection = false;
  boolean rightConnection = false;
  boolean downConnection = false;
  boolean leftConnection = false;
  if (pieces[r][c].getSides()[0]) {  // check the top
    if (r > 0 && pieces[r-1][c] != null) {
      if (pieces[r][c].isConnected(pieces[r-1][c], 0) && !pieces[r-1][c].getCheckedSides()[2]) {
        upConnection = true;
        pieces[r-1][c].markSide(2);
      }
    }
  }
  pieces[r][c].markSide(0);
  if (pieces[r][c].getSides()[1]) {  // check the right
    if (c < pieces[0].length-1 && pieces[r][c+1] != null) {
      if (pieces[r][c].isConnected(pieces[r][c+1], 1) && !pieces[r][c+1].getCheckedSides()[3]) {
        rightConnection = true;
        pieces[r][c+1].markSide(3);
      }
    }
  }
  pieces[r][c].markSide(1);
  if (pieces[r][c].getSides()[2]) {  // check the bottom
    if (r < pieces.length-1 && pieces[r+1][c] != null) {
      if (pieces[r][c].isConnected(pieces[r+1][c], 2) && !pieces[r+1][c].getCheckedSides()[0]) {
        downConnection = true;
        pieces[r+1][c].markSide(0);
      }
    }
  }
  pieces[r][c].markSide(2);
  if (pieces[r][c].getSides()[3]) {  // check the left
    if (c > 0 && pieces[r][c-1] != null) {
      if (pieces[r][c].isConnected(pieces[r][c-1], 3) && !pieces[r][c-1].getCheckedSides()[1]) {
        leftConnection = true;
        pieces[r][c-1].markSide(1);
      }
    }
  }
  pieces[r][c].markSide(3);
  return (upConnection && touchingPower(r-1, c)) || (rightConnection && touchingPower(r, c+1)) || (downConnection && touchingPower(r+1, c)) || (leftConnection && touchingPower(r, c-1));
}