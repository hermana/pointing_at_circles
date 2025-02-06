class Trial {

  int startTime;
  int endTime;
  //boolean successful;
  

   int get_trial_time(){
     return endTime - startTime;
   }
   
   int get_trial_elapsed_time(){
     return millis() - startTime;
   }
 
   Trial(){ 
     startTime = 0;
     endTime = 0;
     //successful = true; //we'll assume unless marked otherwise
   }
}
