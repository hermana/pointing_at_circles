
int NUM_CIRCLES = 30;
int MIN_RADIUS = 50;
int MAX_RADIUS = 150;

ArrayList<Circle> circles = new ArrayList<Circle>();

void setup() {
  size(1080, 1080); 
  fill(0);    
  PFont myFont = createFont("Arial", 32, true); 
  textFont(myFont);
  textAlign(CENTER);

  for (int i = 0; i < NUM_CIRCLES; i++) {
    int x = int(random(width));
    int y = int(random(height));
    int r = int(random(MIN_RADIUS, MAX_RADIUS));
    circles.add(new Circle(x, y, r, 255));
  }
}

// add draw
// add intersect

void draw(){
  for (int i =0; i<NUM_CIRCLES; i++) {
    circles.get(i).drawCircle();
    boolean overlapping = false;
    for (int j=0; j<NUM_CIRCLES;j++) {
      if (i!=j && circles.get(i).intersects(circles.get(j))) {
        overlapping = true;
      }
    }
    if (overlapping) {
      circles.get(i).changeColor(255);
    } else {
      circles.get(i).changeColor(0);
    }
  }
}

void mouseClicked(){
  println("mouse clicked");
}





//TODO: move to another file
class Circle {
  int x;
  int y;
  int r;
  int brightness;
  
  Circle(int X, int Y, int R, int bright) {
    this.x = X;
    this.y = Y;
    this.r = R;
    this.brightness = bright;
  }

  boolean intersects(Circle c) {
    float d = dist(this.x, this.y, c.x, c.y);
    return int(d) < this.r + c.r;
  }

  void changeColor(int bright) {
    this.brightness = bright;
  }

  boolean isClicked(int px, int py) {
    float d = dist(px, py, this.x, this.y);
    return d < this.r ? true:false;
  }
  
  void drawCircle() {
    stroke(255);
    strokeWeight(4);
    fill(this.brightness, 125);
    circle(this.x, this.y, this.r * 2);
  }
}
