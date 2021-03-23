public static void scheduleCollectLastAppointmentData() {
    %%%NAMESPACE_DOT%%%AppointmentPredictionSchedulable apptPredictionSchedule = new  %%%NAMESPACE_DOT%%%AppointmentPredictionSchedulable();
    String cronExp = '0 0 0 * * ?';  //Run everyday at 12:00am
    String jobID = System.schedule('Students Not Served', cronExp, apptPredictionSchedule);
}

public static void scheduleRecalculateTaskSummaryCounts() {
    %%%NAMESPACE_DOT%%%SuccessPlanCounterSchedulable spPredictionSchedule = new %%%NAMESPACE_DOT%%%SuccessPlanCounterSchedulable();
    String cronExp = '0 0 0 * * ?';  //Run everyday at 12:00am
    String jobID = System.schedule('Recalculate Success Plan Tasks', cronExp, spPredictionSchedule);
}
