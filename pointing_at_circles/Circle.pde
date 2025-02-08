   class Circle {
  float x, y, r;
  boolean target;
  
  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.target=false;
  }
  
  void display() {
    color displayColour = this.target ? color(0, 255, 0): color(255, 255, 255);
    fill(displayColour);
    ellipse(this.x, this.y, this.r * 2, this.r * 2);
  }
  
  boolean overlaps(Circle other) {
    float d = dist(this.x, this.y, other.x, other.y);
    return d < (this.r + other.r);
  }
  
  void setAsTarget(){
    this.target=true;
  }
  
  boolean isClicked(float X, float Y){
    float d = dist(this.x, this.y, X, Y);
    return d <= this.r;
  }
  
  boolean isTarget(){
    return target;
  }
  
  float get_ID(float clickX, float clickY){
     //fitt's law
     float d = dist(this.x, this.y, clickX, clickY);
     return log((d/this.r)+1) / (float)Math.log(2); // log laws
   }

}
