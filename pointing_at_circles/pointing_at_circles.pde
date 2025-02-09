
import java.awt.*;

enum State{
  INSTRUCTIONS,
  BEFORE_CONDITION, 
  TRIAL, 
  FINISHED
}

int NUM_CIRCLES = 30;
int MIN_RADIUS = 50;
int MAX_RADIUS = 150;
String RESULTS_FILENAME = "./results.csv";

Circle[] circles = new Circle[NUM_CIRCLES];
PShape cursor;
PVector experimentVector;
Robot robot;
float dx;
float dy;

State state;
ArrayList<Condition> conditions = new ArrayList<Condition>();
ArrayList<PVector> gravityVectors = new ArrayList<PVector>();
Condition currentCondition;
int conditionIndex;

Table results;

void setup() {
  //size(1080, 1080);
  fullScreen();
   try {
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
  
  PFont myFont = createFont("Arial", 32, true); 
  textFont(myFont);
  textAlign(CENTER);
  
  state = State.INSTRUCTIONS;
  conditionIndex = 0;
  conditions.add(new Condition("Fitt's Law", "Please click on the green circle.", 1, ConditionType.REGULAR, 0)); 
  
  //conditions.add(new Condition("Sticky Target: Low", "Please click on the green circle.", 1, ConditionType.STICKY, 0.5)); 
  //conditions.add(new Condition("Sticky Target: Medium", "Please click on the green circle.", 1, ConditionType.STICKY, 1));
  //conditions.add(new Condition("Sticky Target: High", "Please click on the green circle.", 1, ConditionType.STICKY, 2));

  conditions.add(new Condition("Target Gravity: Low", "Please click on the green circle", 1, ConditionType.GRAVITY, 2));
  conditions.add(new Condition("Target Gravity: Medium", "Please click on the green circle", 1, ConditionType.GRAVITY, 3));
  conditions.add(new Condition("Target Gravity: High", "Please click on the green circle", 1, ConditionType.GRAVITY, 8));
  currentCondition = conditions.get(conditionIndex);
  
  //robot.mouseMove(displayWidth/2, displayHeight/2); //<>//
  experimentVector = new PVector(mouseX, mouseY); //<>//
  cursor = createCursor();
  dx = 0.0;
  dy = 0.0; 
 // noCursor();
  results = new Table();
  results.addColumn("Condition Name");
  results.addColumn("Trial");
  results.addColumn("ID");
  results.addColumn("Time (ms)");
  results.addColumn("Errors");
  results.addColumn("Strength");
  results.addColumn("Condition Type");
  
  generateCircles();
}

void draw() {
  background(200);
  switch(state){
   case INSTRUCTIONS:
     fill(0);
     text("Instructions", width/2, height/2);
     text("Click to continue.", width/2, (height/2)+50);
     break;
   case BEFORE_CONDITION:
     text(currentCondition.name, width/2, height/2);
     text(currentCondition.instructions, width/2, (height/2)+100);
     text("Click to continue.", width/2, (height/2)+250);
     break;
   case TRIAL:
     for(int i=0; i<NUM_CIRCLES;i++){
        circles[i].display();
     }
     shape(cursor, experimentVector.x, experimentVector.y); //<>//
     if(currentCondition.conditionType == ConditionType.GRAVITY){
       for(PVector v: gravityVectors){
         fill(0);
         line(experimentVector.x, experimentVector.y, experimentVector.x+v.x, experimentVector.y+v.y);
       }
     }
     //robot.mouseMove(displayWidth/2, displayHeight/2);
     break;
   case FINISHED:
      fill(0);
      text("The experiment has finished.", width/2, height/2);
      text("Click to exit.", width/2, (height/2)+50);
   default:
     break;
  }
  
}

void keyPressed(){
  saveTable(results, RESULTS_FILENAME, "csv");  
  exit();
}

void mouseMoved(){
  if(state == State.TRIAL){
     dx = mouseX - pmouseX;
     dy = mouseY - pmouseY;
     switch(currentCondition.conditionType){
       case REGULAR:
          experimentVector = experimentVector.add(dx, dy); //<>//
          break;
       case STICKY:
           //float targetIntersection = getTargetIntersection((float)dx, (float)dy);
           float targetIntersection = getTargetIntersection();
           if(targetIntersection > 0){
             // TODO: Scaling how sticky the target is based on the length of the intersection
             PVector stickyMove = new PVector(dx, dy);
             stickyMove = stickyMove.setMag(1/currentCondition.strength);
             experimentVector =  experimentVector.add(stickyMove);
           }else{
             experimentVector = experimentVector.add(dx, dy); 
           }
           break;
       case GRAVITY: 
           gravityVectors = createGravityVectors(); 
           experimentVector =  experimentVector.add(dx, dy); 
           for(PVector v: gravityVectors){
             experimentVector = experimentVector.add(v);  
           }
           break;
       default:
           break;
     } //<>//
  }
}


void mouseClicked() {
  switch(state){
    case INSTRUCTIONS:
      state = State.BEFORE_CONDITION;
      break;
    case BEFORE_CONDITION: 
      currentCondition.start_trial_timer();
      // mouse position used on experiment vector because of fullscreen
      // robot.mouseMove(displayWidth/2, displayHeight/2);
      experimentVector.set(mouseX, mouseY);
      state = State.TRIAL;
      break;
    case TRIAL: 
        if(isTargetClicked()){
            currentCondition.end_trial_timer();
            float ID = get_fitts();
            currentCondition.finish_trial(ID);
            currentCondition.print_results(results);
            
            // mouse position used on experiment vector because of fullscreen
            // robot.mouseMove(displayWidth/2, displayHeight/2);
            experimentVector.set(mouseX, mouseY);
            generateCircles();          
            if(currentCondition.currentTrial >= currentCondition.numTrials){
              conditionIndex+=1;
              if(conditionIndex < conditions.size()){
                 currentCondition = conditions.get(conditionIndex);
                 state = State.INSTRUCTIONS;
              }else{
                state = State.FINISHED;
              }              
            }else{
               currentCondition.update_current_trial();
               currentCondition.start_trial_timer();
            }
       }else{
         currentCondition.mark_trial_unsuccessful();
       }
      break;
    case FINISHED:
      saveTable(results, RESULTS_FILENAME, "csv");  
      exit();
      break;
    default:
      break;
  }
}

/////////////////////// TRIAL HELPERS ///////////////////////////

boolean isTargetClicked(){
  for (Circle c : circles){
    if (c.isClicked(experimentVector.x, experimentVector.y) && c.isTarget()){
      return true;
    }
  }
  return false;
}

float get_fitts(){
  for (Circle c : circles){
    if (c.isTarget()){
      return c.get_ID(experimentVector.x, experimentVector.y);
    }
  }
  return 0.0;
}


float getTargetIntersection(){
  for (Circle c : circles){
    if (c.isTarget()){
      return c.intersectionLength(experimentVector.x + dx, experimentVector.y + dy, experimentVector.x, experimentVector.y);
    }
  }
  return 0.0; 
}


ArrayList<PVector> createGravityVectors(){
  ArrayList<PVector> vectors = new ArrayList<PVector>();
  for(Circle c: circles){
    float distanceToCircleEdge = dist(experimentVector.x, experimentVector.y, c.x, c.y) - c.r;
    if(distanceToCircleEdge < 500.0){
      // I made this formula up. 
      float gravityX = currentCondition.strength * (dx / (distanceToCircleEdge));
      float gravityY = currentCondition.strength * (dy / (distanceToCircleEdge));
      vectors.add(new PVector(gravityX, gravityY));
    }
  }
  return vectors;
}

/////////////////////// SETUP HELPERS ///////////////////////////

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
