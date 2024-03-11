global class NotWorkingDayUserUpdate_SCHED implements Schedulable {
   global void execute(SchedulableContext sc) {
      NotWorkingDayUserUpdate_BATCH b = new NotWorkingDayUserUpdate_BATCH(); 
      database.executebatch(b);
   }
}