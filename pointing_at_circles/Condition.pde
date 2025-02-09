//TODO: move more functions to Trial class.
enum ConditionType{
  REGULAR, 
  STICKY, 
  GRAVITY
}

class Condition {
  
    String name;
    String instructions;
    int numTrials;
    int currentTrial;
    int totalTime;
    int totalSuccessfulTrials;
    int totalErrorTrials;
    ArrayList<Trial> trials;
    ConditionType conditionType;
    float strength;
    
    Condition(String cName, String cInstructions, int cNumTrials, ConditionType conditionType, float strength){
      this.name = cName;
      this.instructions = cInstructions;
      this.numTrials = cNumTrials;
      this.currentTrial = 1;
      this.trials = new ArrayList<Trial>(numTrials);
      for(int i=0; i<this.numTrials; i++){ this.trials.add(new Trial()); }
      this.conditionType = conditionType;
      this.strength = strength;
    }
    
    void start_trial_timer(){
      trials.get(currentTrial-1).startTime = millis();
    }
    
    void end_trial_timer(){
      trials.get(currentTrial-1).set_elapsed_time();
    }
    
    void get_trial_elapsed_time(){
      trials.get(currentTrial-1).set_elapsed_time();
    }
    
    void finish_trial(float ID){
      trials.get(currentTrial-1).set_ID(ID);
    }
   
    void update_current_trial(){
      currentTrial+=1;
    }
    
    String getConditionAsString(){
     if(this.conditionType == ConditionType.REGULAR){
       return "REGULAR";
     }else if(this.conditionType == ConditionType.STICKY){
       return "STICKY";
     }
     return "GRAVITY";
    }
    
    void print_results(){
      // ConditionName, TrialNumber, FittsID, CompletionTime, Errors
      String fitts =  nf(trials.get(currentTrial-1).get_ID(), 0, 2);
      String time = str(trials.get(currentTrial-1).get_elapsed_time());
      String errors = str(trials.get(currentTrial-1).get_num_errors());
      String type = getConditionAsString();
      println(this.name + " " + str(currentTrial) + " " + fitts + " " + time + " " + errors + " " + this.strength + " " + type + "\n" );
    }
    
       
    void mark_trial_unsuccessful(){
      trials.get(currentTrial-1).mark_unsuccessful();
    
    }
    
  }
  
