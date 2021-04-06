/** @description: Creates identical recurring availability, group availability,
 * and availability topics for all retrieved HED users.
*/
public static void insertEvents() {
    Savepoint sp = Database.setSavepoint();
    try {
        List<String> advisorList = new List<String>{'Adam Advisor'};
        List<String> topicList = new List<String>{'Registrar', 'Academic', 'Study Abroad'};

        User[] advisorUsers = [
            SELECT Id
            FROM User
            WHERE Name IN : advisorList
        ];

        RecordType advisingRecordType = [
            SELECT Id
            FROM RecordType
            WHERE Name = 'Advising Time'
        ];

        List<%%%NAMESPACE%%%Topic__c> topics = [
            SELECT Id
            FROM %%%NAMESPACE%%%Topic__c
            WHERE Name IN : topicList
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

            %%%NAMESPACE%%%Availability__c groupAvailability1 = new %%%NAMESPACE%%%Availability__c(
                %%%NAMESPACE%%%AppointmentType__c = 'Group',
                %%%NAMESPACE%%%AttendeeLimit__c = 5,
                OwnerId = u.Id
            );

            insert groupAvailability1;

            insert new Event(
                    RecordTypeId = advisingRecordType.Id,
                    OwnerId = u.Id,
                    Subject = 'Group Availability - Resume Writing',
                    IsRecurrence = true,
                    RecurrenceStartDateTime = DateTime.newInstance(todayY, todayM, todayD, 18, 0, 0),
                    RecurrenceEndDateOnly = Date.today().addDays(30),
                    RecurrenceDayOfWeekMask = 32,
                    RecurrenceInterval = 2,
                    RecurrenceType = 'RecursWeekly',
                    StartDateTime = DateTime.newInstance(todayY, todayM, todayD, 18, 0, 0),
                    EndDateTime = DateTime.newInstance(todayY, todayM, todayD, 20, 0, 0),
                    Type = 'Group',
                    Location = 'In person',
                    WhatId = groupAvailability1.Id
            );

            if (!topicList.isEmpty()) {
                %%%NAMESPACE%%%Availability__c groupAvailabilityTopics = new %%%NAMESPACE%%%Availability__c(
                    %%%NAMESPACE%%%AppointmentType__c = 'Group',
                    %%%NAMESPACE%%%AttendeeLimit__c = 15,
                    OwnerId = u.Id
                );
                insert groupAvailabilityTopics;

                List<%%%NAMESPACE%%%AvailabilityTopic__c> availabilityTopics = new List<%%%NAMESPACE%%%AvailabilityTopic__c>();
                for (%%%NAMESPACE%%%Topic__c topic : topics) {
                    availabilityTopics.add(new %%%NAMESPACE%%%AvailabilityTopic__c(
                        %%%NAMESPACE%%%Topic__c = topic.Id,
                        %%%NAMESPACE%%%Availability__c = groupAvailabilityTopics.Id,
                        OwnerId = u.Id
                    ));
                }
                insert availabilityTopics;

                insert new Event(
                        RecordTypeId = advisingRecordType.Id,
                        OwnerId = u.Id,
                        Subject = 'Registrar and Study Abroad',
                        IsRecurrence = true,
                        RecurrenceStartDateTime = DateTime.newInstance(todayY, todayM, todayD, 16, 0, 0),
                        RecurrenceEndDateOnly = Date.today().addDays(30),
                        RecurrenceDayOfWeekMask = 2,
                        RecurrenceInterval = 2,
                        RecurrenceType = 'RecursWeekly',
                        StartDateTime = DateTime.newInstance(todayY, todayM, todayD, 16, 0, 0),
                        EndDateTime = DateTime.newInstance(todayY, todayM, todayD, 17, 0, 0),
                        Type = 'Group',
                        Location = 'Virtual',
                        WhatId = groupAvailabilityTopics.Id
                );
            }
        }

    } catch (System.DmlException e) {
        Database.rollback(sp);
        throw new System.DmlException(e.getMessage());
    }
}