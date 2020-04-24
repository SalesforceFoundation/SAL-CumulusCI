public static void insertSettings() {

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

