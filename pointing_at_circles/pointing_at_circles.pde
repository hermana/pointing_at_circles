int NUM_CIRCLES = 30;
int MIN_RADIUS = 50;
int MAX_RADIUS = 150;
Circle[] circles = new Circle[NUM_CIRCLES];

void setup() {
  size(1080, 1080);
  generateCircles();
}

void draw() {
  background(100);
  for(int i=0; i<NUM_CIRCLES;i++){
    circles[i].display();
  }
}

void generateCircles() {
  int count = 0;
  while (count < NUM_CIRCLES) {
    float r = random(MIN_RADIUS, MAX_RADIUS);
    float x = random(r, width - r);
    float y = random(r, height - r);
    
    Circle newCircle = new Circle(x, y, r);
    boolean overlapping = false;
    
    for (int i = 0; i < count; i++) {
      if (newCircle.overlaps(circles[i])) {
        overlapping = true;
        break;
      }
    }
    
    if (!overlapping) {
      circles[count] = newCircle;
      count++;
    }
  }
}

//TODO: move to a seperate class.
class Circle {
  float x, y, r;
  
  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  void display() {
    fill(255);
    ellipse(this.x, this.y, this.r * 2, this.r * 2);
  }
  
  boolean overlaps(Circle other) {
    float d = dist(this.x, this.y, other.x, other.y);
    return d < (this.r + other.r);
  }
}
