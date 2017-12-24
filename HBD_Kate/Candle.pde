public class Candle{
  float x;
  float y;
  boolean isLit;
  
  public Candle(float x, float y){
    this.x = x;
    this.y = y;
    isLit = false;
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  public boolean isLit(){
    return isLit;
  }
  public void toggleLight(){
    isLit = !isLit;
  }
}