import java.awt.*;



int NUM_CIRCLES = 30;
int MIN_RADIUS = 50;
int MAX_RADIUS = 150;
Circle[] circles = new Circle[NUM_CIRCLES];
PShape experimentMouse;
PVector experimentVector;
Robot robot;


void setup() {
  size(1080, 1080);
   try {
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
  experimentVector = new PVector(mouseX, mouseY);
  experimentMouse = loadShape("./imgs/icons8-mouse.svg");
  generateCircles();
  noCursor();
}

void draw() {
  background(200);
  for(int i=0; i<NUM_CIRCLES;i++){
    circles[i].display();
  }
  shape(experimentMouse, mouseX, mouseY);
  experimentVector.x = mouseX;
  experimentVector.y = mouseY;
  //robot.mouseMove(width/2, height/2);
}

void generateCircles() {
  int count = 0;
  int target = int(random(0, NUM_CIRCLES));
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
      if(count == target){
        circles[count].setAsTarget();
      }
      count++;
    }
  }
}
