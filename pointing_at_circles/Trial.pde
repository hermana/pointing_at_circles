class Trial {

  int startTime;
  int endTime;
  int elapsedTime;
  boolean successful;
   
   void set_elapsed_time(){
     elapsedTime = millis() - startTime;
   }
   
   void mark_successful(){
     successful = true;
   }
 
   Trial(){ 
     startTime = 0;
     endTime = 0;
     elapsedTime = 0;
     successful = false; //we'll assume unless marked otherwise
   }
}
