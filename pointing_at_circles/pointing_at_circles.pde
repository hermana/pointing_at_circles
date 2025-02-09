
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
Circle[] circles = new Circle[NUM_CIRCLES];
PShape cursor;
PVector experimentVector;
Robot robot;
State state;

ArrayList<Condition> conditions = new ArrayList<Condition>();
Condition currentCondition;
int conditionIndex;


void setup() {
  size(1080, 1080);
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
  conditions.add(new Condition("Fitt's Law", "Please click on the green circle.", 5, ConditionType.REGULAR, 0)); 
  conditions.add(new Condition("Sticky Target: Low", "Please click on the green circle.", 5, ConditionType.STICKY, 1.5)); 
  conditions.add(new Condition("Sticky Target: Medium", "Please click on the green circle.", 5, ConditionType.STICKY, 2)); 
  conditions.add(new Condition("Sticky Target: High", "Please click on the green circle.", 5, ConditionType.STICKY, 4)); 
  currentCondition = conditions.get(conditionIndex);
  
  robot.mouseMove(displayWidth/2, displayHeight/2);
  experimentVector = new PVector(mouseX, mouseY);
  cursor = createCursor();
  generateCircles();
  noCursor();
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
     shape(cursor, experimentVector.x, experimentVector.y);
     //shape(cursor, mouseX, mouseY);
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


void mouseMoved(){
   int dx = mouseX - pmouseX;
   int dy = mouseY - pmouseY;
   experimentVector.add(dx, dy); 
   //robot.mouseMove(displayWidth/2, displayHeight/2);
}


void mouseClicked() {
  switch(state){
    case INSTRUCTIONS:
      state = State.BEFORE_CONDITION;
      break;
    case BEFORE_CONDITION: 
      currentCondition.start_trial_timer();
      state = State.TRIAL;
      break;
    case TRIAL: 
        if(isTargetClicked()){
            currentCondition.end_trial_timer();
            float ID = get_fitts();
            currentCondition.finish_trial(ID);
            currentCondition.print_results();
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
      exit();
      break;
    default:
      break;
  }
}

/////////////////////// TRIAL HELPERS ///////////////////////////

boolean isTargetClicked(){
  for (Circle c : circles){
    if (c.isClicked(float(mouseX), float(mouseY)) && c.isTarget()){
      return true;
    }
  }
  return false;
}

float get_fitts(){
  for (Circle c : circles){
    if (c.isTarget()){
      return c.get_ID(mouseX, mouseY);
    }
  }
  return 0.0;
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
