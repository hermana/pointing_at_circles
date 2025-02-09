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
  
  void setAsNotTarget(){
    this.target=false;
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
   
   float intersectionLength(float x1, float y1, float x2, float y2) {
      // x and y (centre) and r (radius) are instance variables
      float dx = x2 - x1;
      float dy = y2 - y1;
      float fx = x1 - x;
      float fy = y1 - y;
      float a = dx * dx + dy * dy;
      float b = 2 * (fx * dx + fy * dy);
      float c = (fx * fx + fy * fy) - r * r;
      float discriminant = b * b - 4 * a * c;
      if (discriminant < 0) {
        return 0; // No intersection
      } else {
        discriminant = sqrt(discriminant);
        float t1 = (-b - discriminant) / (2 * a);
        float t2 = (-b + discriminant) / (2 * a);
        if ((t1 < 0 && t2 < 0) || (t1 > 1 && t2 > 1)) return 0;
        // Clamp the intersection points to the segment limits
        t1 = max(0, min(t1, 1));
        t2 = max(0, min(t2, 1));
        // Calculate the intersection points
        float inX1 = x1 + t1 * dx;
        float inY1 = y1 + t1 * dy;
        float inX2 = x1 + t2 * dx;
        float inY2 = y1 + t2 * dy;
        return dist(inX1, inY1, inX2, inY2);
  }
}

}
