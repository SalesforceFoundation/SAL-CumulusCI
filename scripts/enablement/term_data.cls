public static void insertTerms() {
    Savepoint sp = Database.setSavepoint();
    try {
        Account connectedCampus = getOrCreateAccount('Connected Campus University');
        String semesterType = 'Semester';

        Integer currentYear = Date.today().year();
        Integer nextYear = Date.today().addYears(1).year();
        Integer yearAfterNext = Date.today().addYears(2).year();

        List<hed__Term__c> terms = new List<hed__Term__c>();

        terms.add(createTerm('Fall', currentYear, connectedCampus, Date.newInstance(currentYear, 9, 1), Date.newInstance(currentYear, 12, 31), semesterType));
        terms.add(createTerm('Spring', nextYear, connectedCampus, Date.newInstance(nextYear, 1, 1), Date.newInstance(nextYear, 4, 30), semesterType));
        terms.add(createTerm('Summer', nextYear, connectedCampus, Date.newInstance(nextYear, 5, 1), Date.newInstance(nextYear, 8, 31), semesterType));
        terms.add(createTerm('Fall', nextYear, connectedCampus, Date.newInstance(nextYear, 9, 1), Date.newInstance(nextYear, 12, 31), semesterType));
        terms.add(createTerm('Spring', yearAfterNext, connectedCampus, Date.newInstance(yearAfterNext, 1, 1), Date.newInstance(yearAfterNext, 4, 30), semesterType));
        terms.add(createTerm('Summer', yearAfterNext, connectedCampus, Date.newInstance(yearAfterNext, 5, 1), Date.newInstance(yearAfterNext, 8, 31), semesterType));

        insert terms;

    } catch (System.DmlException e) {
        Database.rollback(sp);
        throw new System.DmlException(e.getMessage());
    }
}

public static Account getOrCreateAccount(String accountName) {
    List<Account> accounts = [
        SELECT Id
        FROM Account
        WHERE Name = :accountName
    ];
    
    if(accounts.isEmpty()) {
        Account acct = new Account(
            Name = accountName
        );
        insert acct;
        return acct;
    }

    return accounts[0];
}

public static hed__Term__c createTerm(String semester, Integer year, Account acct, Date startDate, Date endDate, String type) {
    hed__Term__c term = new hed__Term__c(
        Name = semester + ' ' + String.valueOf(year),
        hed__Account__c = acct.Id,
        hed__Start_Date__c = startDate,
        hed__End_Date__c = endDate,
        hed__Type__c = type
    );
    return term;
}
