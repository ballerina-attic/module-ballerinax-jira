package src.jira;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                 Enums                                                              //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public enum AuthenticationType {
    BASIC
}

public enum ActorType {
    GROUP, USER
}

public enum AssigneeType {
    PROJECTLEAD, UNASSIGNED
}

public enum ProjectRoleType {
    DEVELOPERS, EXTERNAL_CONSULTANT, OBSERVER, ADMINISTRATORS, USERS, CSAT_ADMINISTRATORS, NOTIFICATIONS
}

public enum ProjectType {
    SOFTWARE, BUSINESS
}

//