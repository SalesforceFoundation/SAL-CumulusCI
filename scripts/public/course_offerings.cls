public static void insertCourseOfferings() {
    Savepoint sp = Database.setSavepoint();
    try {
        Contact ingrid = getFaculty('Ingrid Instructor');
        Integer currentYear = Date.today().year();

        hed__Term__c fallTerm = getFallTerm(String.valueOf(currentYear));

        List<hed__Course_Offering__c> courseOfferings = new List<hed__Course_Offering__c>();

        courseOfferings.add(createCourseOffering('ENC 2305, Section 2', getCourse('Analytical Writing and Thinking'), fallTerm, ingrid, Date.newInstance(currentYear, 9, 8), Date.newInstance(currentYear, 12, 11), '2'));
        courseOfferings.add(createCourseOffering('ECO 3101, Section 1', getCourse('Intermediate Microeconomics'), fallTerm, ingrid, Date.newInstance(currentYear, 9, 8), Date.newInstance(currentYear, 12, 11), '1'));
        courseOfferings.add(createCourseOffering('CHM 1020, Section 9', getCourse('Chemistry for the Liberal Arts'), fallTerm, ingrid, Date.newInstance(currentYear, 9, 8), Date.newInstance(currentYear, 12, 11), '9'));
        
        insert courseOfferings;

    } catch (System.DmlException e) {
        Database.rollback(sp);
        throw new System.DmlException(e.getMessage());
    }
}

public static hed__Term__c getFallTerm(String year) {
    String termName = 'Fall ' + year;

    hed__Term__c term = [
        SELECT Id
        FROM hed__Term__c
        WHERE Name = :termName
    ];
    return term;
}

public static Contact getFaculty(String name) {
    Contact faculty = [
        SELECT Id
        FROM Contact
        WHERE Name = :name
    ];
    return faculty;
}

public static hed__Course__c getCourse(String courseName) {
    hed__Course__c course = [
        SELECT Id
        FROM hed__Course__c
        WHERE name = :courseName
    ];
    return course;
}

public static hed__Course_Offering__c createCourseOffering(String name, hed__Course__c course, hed__Term__c term, Contact faculty, Date startDate, Date endDate, String sectionId) {
    hed__Course_Offering__c courseOffering = new hed__Course_Offering__c(
        Name = name,
        hed__Course__c = course.Id,
        hed__Term__c = term.Id,
        hed__Faculty__c = faculty.Id,
        hed__Start_Date__c = startDate,
        hed__End_Date__c = endDate,
        hed__Section_ID__c = sectionId
    );
    return courseOffering;
}