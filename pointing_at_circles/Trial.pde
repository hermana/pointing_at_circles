class Trial {

  int startTime;
  int endTime;
  int elapsedTime;
  float ID;
  boolean successful;
   
   void set_elapsed_time(){
     elapsedTime = millis() - startTime;
   }
   
   void mark_unsuccessful(){
     successful = false;
   }
   
   void set_ID(float ID){
      this.ID = ID;
   }

 
   Trial(){ 
     startTime = 0;
     endTime = 0;
     elapsedTime = 0;
     ID = 0.0;
     successful = true; //we'll assume unless marked otherwise
   }
}
