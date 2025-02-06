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
}
