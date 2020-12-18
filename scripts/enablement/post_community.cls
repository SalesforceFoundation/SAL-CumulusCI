/*** This is meant to be called after the community is setup ***/
public static void guestPermissionSetAssignment() {
    Savepoint sp = Database.setSavepoint();
    try {

        User guestUser = [
            SELECT Id,
                   Name
            FROM User
            WHERE FirstName = 'Advisor Link Portal'
            AND LastName = 'Site Guest User'
        ];

        PermissionSet guestPermissionSet = [
                SELECT Id
                FROM PermissionSet
                WHERE Name = 'SAL_Guest'
        ];

        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>{
                new PermissionSetAssignment(AssigneeId = guestUser.Id, PermissionSetId = guestPermissionSet.Id)
        };

        insert permissionSetAssignments;

    } catch (System.DmlException e) {
        Database.rollback(sp);
        throw new System.DmlException(e.getMessage());
    }
}
