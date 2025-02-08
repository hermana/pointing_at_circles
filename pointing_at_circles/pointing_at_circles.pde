import java.awt.*;



int NUM_CIRCLES = 30;
int MIN_RADIUS = 50;
int MAX_RADIUS = 150;
Circle[] circles = new Circle[NUM_CIRCLES];
//PShape experimentMouse;
PShape cursor;
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
  cursor = createCursor();
  generateCircles();
  noCursor();
}

void draw() {
  background(200);
  for(int i=0; i<NUM_CIRCLES;i++){
    circles[i].display();
  }
  //shape(experimentMouse, experimentVector.x, experimentVector.y);
  shape(cursor, mouseX, mouseY);
}


void mouseMoved(){
  experimentVector.add(pmouseX, pmouseY);
  //robot.mouseMove(displayWidth/2, displayHeight/2);
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



PShape createCursor() {
  PShape c = createShape(GROUP);
  // cursor shape
  PShape arrow = createShape();
  arrow.beginShape();
  arrow.vertex(0, 0);
  arrow.vertex(0, 40);
  arrow.vertex(10, 30);
  arrow.vertex(18, 48); //35, 95
  arrow.vertex(23, 45); //45, 90
  arrow.vertex(15, 28); 
  arrow.vertex(28, 28);
  arrow.endShape(CLOSE);
  arrow.setFill(color(255, 204, 0)); // Black color

  c.addChild(arrow);
  return c;
}
