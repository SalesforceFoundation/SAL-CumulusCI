public static void insertEvents() {
    Savepoint sp = Database.setSavepoint();
    try {
        List<String> nameList = new List<String>{'Adam Advisor'};

        User[] advisorUsers = [
            SELECT Id
            FROM User
            WHERE Name IN : nameList
        ];

        RecordType advisingRecordType = [
            SELECT Id
            FROM RecordType
            WHERE Name = 'Advising Time'
        ];

        Date today = Date.today();
        Integer todayY = today.year();
        Integer todayM = today.month();
        Integer todayD = today.day();

        for (User u : advisorUsers) {

            insert new Event(
                RecordTypeId = advisingRecordType.Id,
                OwnerId = u.Id,
                Subject = 'Student Appointments',
                IsRecurrence = true,
                RecurrenceStartDateTime = DateTime.newInstance(todayY, todayM, todayD, 9, 30, 0),
                RecurrenceEndDateOnly = Date.today().addDays(60),
                RecurrenceDayOfWeekMask = 62,
                RecurrenceInterval = 1,
                RecurrenceType = 'RecursWeekly',
                StartDateTime = DateTime.newInstance(todayY, todayM, todayD, 9, 30, 0),
                EndDateTime = DateTime.newInstance(todayY, todayM, todayD, 13, 0, 0),
                Type = 'Scheduled'
            );

            insert new Event(
                RecordTypeId = advisingRecordType.Id,
                OwnerId = u.Id,
                Subject = 'Walk-In Hours',
                IsRecurrence = true,
                RecurrenceStartDateTime = DateTime.newInstance(todayY, todayM, todayD, 14, 0, 0),
                RecurrenceEndDateOnly = Date.today().addDays(60),
                RecurrenceDayOfWeekMask = 40,
                RecurrenceInterval = 1,
                RecurrenceType = 'RecursWeekly',
                StartDateTime = DateTime.newInstance(todayY, todayM, todayD, 14, 0, 0),
                EndDateTime = DateTime.newInstance(todayY, todayM, todayD, 16, 0, 0),
                Type = 'Walk-In',
                Location = 'In person'
            );
        }

    } catch (System.DmlException e) {
        Database.rollback(sp);
        throw new System.DmlException(e.getMessage());
    }
}