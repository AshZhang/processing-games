import processing.sound.*;
// Music: "Happy Birthday" by Kermit Ruffins & Rebirth Brass Band

Candle[] candles = new Candle[18];
SoundFile music;
boolean musicPlaying = false;
int lastStarted = 0;
PImage candle;
PImage flame;
PImage cake;
boolean allLit = false;

void setup() {
  size(600, 600);
  music = new SoundFile(this, "Happy Birthday song.mp3");
  candle = loadImage("candle.png");
  flame = loadImage("candle flame.png");
  cake = loadImage("birthday cake.png");
  for (int i = 0; i < candles.length; i++) {
    candles[i] = new Candle(width/2 + 175*cos(2*PI*i/18), height/2 + 150*sin(2*PI*i/18) - 85);
  }
  surface.setTitle("For Kate");
}
void draw() {
  if (allLit) {
    background(255);
  } else {
    background(0);
  }
  noTint();


  allLit = true;
  for (Candle c : candles) {
    if (!c.isLit()) {
      allLit = false;
    }
  }

  if (allLit) {
    imageMode(CENTER);
    image(cake, width/2 + 15, height/2 + 10);
    fill(#2A831F);
    textAlign(CENTER);
    textSize(24);
    text("Happy 18th birthday!", width/2 + 15, height/2 - 35);
    if (!musicPlaying) {
      music.play();
      musicPlaying = true;
      lastStarted = millis();
    }
  } else {
    music.stop();
    musicPlaying = false;
  }

  if (millis() - lastStarted > 37500) {
    musicPlaying = false;
  }

  imageMode(CORNER);
  for (Candle c : candles) {
    image(candle, c.getX(), c.getY());
  }

  for (Candle c : candles) {
    if (c.isLit()) {
      tint(255, (int)(Math.random()*(128)+127));
      image(flame, c.getX(), c.getY() - 15);
    }
  }

  textAlign(LEFT);
  fill(#9DD1E5);
  rect(50, height-75, 205, 50);
  fill(0);
  textSize(12);
  text("Make a wish (put out all candles)", 60, height-45);
  fill(#FF8031);
  rect(50, height-150, 175, 50);
  fill(255);
  text("Hire Zuko (light all candles)", 60, height-120);
}
void mousePressed() {

  for (int i = 0; i < candles.length; i++) {
    if (mouseX > candles[i].getX() && mouseX < candles[i].getX() + 30 && mouseY > candles[i].getY() && mouseY < candles[i].getY() + 60) {
      candles[i].toggleLight();
      candles[(i+1)%candles.length].toggleLight();
      candles[(i+2)%candles.length].toggleLight();

      if (i <= 1) {
        candles[17].toggleLight();
        if (i == 0) {
          candles[16].toggleLight();
        } else {
          candles[i-1].toggleLight();
        }
      } else {
        candles[i-1].toggleLight();
        candles[i-2].toggleLight();
      }
    }
  }

  // Extinguish all candles

  if (mouseX > 50 && mouseX < 50+205 && mouseY > height-75 && mouseY < height-75+50) {
    for (int i = 0; i < candles.length; i++) {
      if (candles[i].isLit()) {
        candles[i].toggleLight();
      }
    }
  }

  // Light all candles

  if (mouseX > 50 && mouseX < 50+205 && mouseY > height-150 && mouseY < height-150+50) {
    for (int i = 0; i < candles.length; i++) {
      if (!candles[i].isLit()) {
        candles[i].toggleLight();
      }
    }
  }
}