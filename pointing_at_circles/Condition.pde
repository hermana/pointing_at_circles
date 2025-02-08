//TODO: move more functions to Trial class.
class Condition {
  
    String name;
    String instructions;
    int numTrials;
    int currentTrial;
    int totalTime;
    int totalSuccessfulTrials;
    int totalErrorTrials;
    ArrayList<Trial> trials;
    
    Condition(String cName, String cInstructions, int cNumTrials){
      name = cName;
      instructions = cInstructions;
      numTrials = cNumTrials;
      currentTrial = 1;
      trials = new ArrayList<Trial>(numTrials);
      for(int i=0; i<numTrials; i++){ trials.add(new Trial()); }
    }
    
    void start_trial_timer(){
      trials.get(currentTrial-1).startTime = millis();
    }
    
    void end_trial_timer(){
      trials.get(currentTrial-1).endTime = millis();
    }
    
    void get_trial_elapsed_time(){
      trials.get(currentTrial-1).set_elapsed_time();
    }
    
    //int get_total_completion_time(){
    //  int total_time = 0;
    //  for(int i=0; i<numTrials;i++){
    //    total_time += trials.get(i).get_trial_time();
    //  }
    //  return total_time;
    //}
    
    void finish_trial(float ID){
      trials.get(currentTrial-1).set_ID(ID);
    }
   
    void update_current_trial(){
      currentTrial+=1;
    }
    
    void print_results(){
      println("TODO");
    }
    
  
  }
  
