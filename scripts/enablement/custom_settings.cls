// When calling this code in a managed context, the string %%%NAMESPACE%%% will be replaced with
// "NAMESPACE__" via a custom cci task defined in tasks/anon_apex.py as AnonymousApexFromFileTask().
// Similarly %%%NAMESPACED_RT%%% will be replaced by "NAMESPACE." for namespaced record type support

// Insert the BASE configuration settings
public static void insertSettings(String adviseeRecordTypeString, String studentIdField) {

    %%%NAMESPACE%%%Sal_Settings__c settings = %%%NAMESPACE%%%Sal_Settings__c.getOrgDefaults();

    // Must insert desired Record Type in Task setting using param1 option.
    settings.put('%%%NAMESPACE%%%Advisee_Record_RecordType__c', '%%%NAMESPACED_RT%%%' + adviseeRecordTypeString + '');

    settings.put('%%%NAMESPACE%%%Advance_Notice__c', 1);
    settings.put('%%%NAMESPACE%%%AdviseeSnapshotHeadlineFields__c', 2);
    settings.put('%%%NAMESPACE%%%Advising_Event_RecordType__c', '%%%NAMESPACED_RT%%%AdvisingEvent');
    settings.put('%%%NAMESPACE%%%Advising_Time_Event_RecordType__c', '%%%NAMESPACED_RT%%%AdvisingTime');
    settings.put('%%%NAMESPACE%%%Enable_Alert_Mass_Status_Update__c', true);
    settings.put('%%%NAMESPACE%%%AppointmentBuffer__c', 10);
    settings.put('%%%NAMESPACE%%%Appointment_Email_Opt_In__c', 7);
    settings.put('%%%NAMESPACE%%%Appointment_Emails__c', true);
    settings.put('%%%NAMESPACE%%%Appointment_Length__c', 50);
    settings.put('%%%NAMESPACE%%%Appointment_Locations__c', 'In person;By phone;Web Meeting');
    settings.put('%%%NAMESPACE%%%ChosenFullNameField__c', 'hed__Chosen_Full_Name__c');
    settings.put('%%%NAMESPACE%%%CustomAppointmentLengthAdvisorOptIn__c', true);
    settings.put('%%%NAMESPACE%%%AdviseeSnapshotUseFieldSet__c', false);
    settings.put('%%%NAMESPACE%%%DisableAdviseeAppointmentRecordLink__c', true);
    settings.put('%%%NAMESPACE%%%DisableEmailAttachmentsforAdvisees__c', false);
    settings.put('%%%NAMESPACE%%%DisableEmailAttachmentsforAdvisors__c', false);
    settings.put('%%%NAMESPACE%%%DisableEnhancedNotes__c', false);
    settings.put('%%%NAMESPACE%%%DisplayStudentIDinEventSubject__c', true);
    settings.put('%%%NAMESPACE%%%EmailIDforAppointmentEmails__c', '');
    settings.put('%%%NAMESPACE%%%EnableCustomAppointmentLength__c', true);
    settings.put('%%%NAMESPACE%%%ScheduledAvailabilityEventType__c', 'Scheduled');
    settings.put('%%%NAMESPACE%%%StudentIDField__c', studentIdField);
    settings.put('%%%NAMESPACE%%%WalkIn_Event_Type__c', 'Walk-In Appointment');
    settings.put('%%%NAMESPACE%%%WalkInAvailabilityEventType__c', 'Walk-In');
    settings.put('%%%NAMESPACE%%%GroupAvailabilityEventType__c', 'Group');

    upsert settings;
}

public static void insertHedSettings() {

    %%%NAMESPACE%%%SALQueuingSettings__c qSettings = %%%NAMESPACE%%%SALQueuingSettings__c.getOrgDefaults();

    qSettings.put('%%%NAMESPACE%%%AdvisingQueueCaseRecordType__c', 'AdvisingQueue');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusAbandoned__c', 'Abandoned');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusFulfilled__c', 'Fulfilled');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusQueued__c', 'Queued');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusReady__c', 'Ready');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusReferred__c', 'Referred');
    qSettings.put('%%%NAMESPACE%%%ShowEmail__c', true);
    qSettings.put('%%%NAMESPACE%%%ShowPhone__c', true);
    qSettings.put('%%%NAMESPACE%%%ShowStudentId__c', true);
    qSettings.put('%%%NAMESPACE%%%WaitingRoomDescription__c', 'hed__Description__c');
    qSettings.put('%%%NAMESPACE%%%WaitingRoomDisplayName__c', 'Name');
    qSettings.put('%%%NAMESPACE%%%WaitingRoomInstructions__c', 'WaitingRoomInstructions__c');

    upsert qSettings;
}

//set the configuration for K-12 Architecture Kit
public static void insertK12KitSettings() {
    initializeK12KitSettings();
    enableCourseConnections();
}

//once K-12 has a managed package, this code should move
private static void initializeK12KitSettings() {
    hed__Hierarchy_Settings__c settings = hed.UTIL_CustomSettings_API.getSettings();
    settings.hed__Account_Processor__c = settings.hed__Household_Addresses_RecType__c;
    update settings;
}

//enables course connections (should be called by trial org flows only from cci)
//and sets the record types for Student and Faculty
private static void enableCourseConnections() {
    Schema.DescribeSObjectResult courseEnrollmentSchema = Schema.SObjectType.hed__Course_Enrollment__c;
    Map<String,Schema.RecordTypeInfo> rtInfosByDeveloperName = courseEnrollmentSchema.getRecordTypeInfosByDeveloperName();

    hed__Hierarchy_Settings__c settings = hed__Hierarchy_Settings__c.getOrgDefaults();

    settings.put('hed__Enable_Course_Connections__c', true);
    settings.put('hed__Student_RecType__c', rtInfosByDeveloperName.get('Student').getRecordTypeId());
    settings.put('hed__Faculty_RecType__c', rtInfosByDeveloperName.get('Faculty').getRecordTypeId());

    upsert settings;

}


// Insert dev config settings. This will be removed soon.
public static void insertDevConfigSettings() {

    // When calling this code in a managed context, the string %%%NAMESPACE%%% will be replaced with
    // "NAMESPACE__" via a custom cci task defined in tasks/anon_apex.py as AnonymousApexFromFileTask().
    // Similarly %%%NAMESPACED_RT%%% will be replaced by "NAMESPACE." for namespaced record type support
    %%%NAMESPACE%%%Sal_Settings__c settings = %%%NAMESPACE%%%Sal_Settings__c.getOrgDefaults();

    settings.put('%%%NAMESPACE%%%Advisee_Record_RecordType__c', '%%%NAMESPACED_RT%%%AdviseeRecord');
    settings.put('%%%NAMESPACE%%%Advising_Event_RecordType__c', '%%%NAMESPACED_RT%%%AdvisingEvent');
    settings.put('%%%NAMESPACE%%%Advising_Time_Event_RecordType__c', '%%%NAMESPACED_RT%%%AdvisingTime');
    settings.put('%%%NAMESPACE%%%AdviseeSnapshotUseFieldSet__c', true);
    settings.put('%%%NAMESPACE%%%DisplayStudentIDinEventSubject__c', true);
    settings.put('%%%NAMESPACE%%%StudentIDField__c', 'Student_ID__c');
    settings.put('%%%NAMESPACE%%%ChosenFullNameField__c', 'hed__Chosen_Full_Name__c');

    upsert settings;

    %%%NAMESPACE%%%SALQueuingSettings__c qSettings = %%%NAMESPACE%%%SALQueuingSettings__c.getOrgDefaults();

    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusQueued__c', 'Queued');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusReady__c', 'Ready');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusAbandoned__c', 'Abandoned');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusFulfilled__c', 'Fulfilled');
    qSettings.put('%%%NAMESPACE%%%AdvisingQueueStatusReferred__c', 'Referred');

    qSettings.put('%%%NAMESPACE%%%ShowEmail__c', true);
    qSettings.put('%%%NAMESPACE%%%ShowPhone__c', false);
    qSettings.put('%%%NAMESPACE%%%ShowStudentId__c', true);
    qSettings.put('%%%NAMESPACE%%%WaitingRoomDescription__c', 'hed__Description__c');
    qSettings.put('%%%NAMESPACE%%%WaitingRoomInstructions__c', 'WaitingRoomInstructions__c');
    qSettings.put('%%%NAMESPACE%%%WaitingRoomDisplayName__c', 'Name');

    upsert qSettings;
}
