package tests;

import ballerina/io;
import jira;

jira:JiraConnectorError e = {};
boolean result;
boolean isValid;
jira:JiraConnector jiraConnector = {};

public function main (string[] args) {
    if (args[0]=="Run All Tests"){
        runAllTests();
    }
    else{
        io:println("Invalid Argument");
    }
}

function runAllTests(){
    io:println("\n\n");
    io:println("started running tests..\n");

    test_authenticate();

    test_getAllProjectSummaries();
    test_ProjectSummary_getAllDetails();

    test_createProject();
    test_updateProject();
    test_deleteProject();

    test_getProject();

    test_Project_getLeadUserDetails();
    test_Project_getRoleDetails();
    test_Project_addUserToRole();
    test_Project_addGroupToRole();
    test_Project_removeUserFromRole();
    test_Project_removeGroupFromRole();
    test_Project_getAllIssueTypeStatuses();
    test_Project_changeProjectType();

    test_ProjectComponentSummary_getAllDetails();
    test_ProjectComponent_getLeadUserDetails();
    test_ProjectComponent_getassigneeUserDetails();

    test_getAllProjectCategories();
    test_createProjectCategory();
    test_deleteProjectCategory();

}

function test_authenticate () {
    //**************************************************************************************************************
    //Validates provided user credentials
    io:println("\n\n");
    io:println("validating user credentials..");
    var output = jiraConnector.authenticate("ashan@wso2.com", "ashan123");
    match output {
        boolean => io:println("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }


}

function test_getAllProjectSummaries () {
    //**************************************************************************************************************
    //Gets descriptions of all the existing jira projects
    io:println("\n\n");
    io:println("BIND FUNCTION: getAllProjectSummaries()");
    var output = jiraConnector.getAllProjectSummaries();
    match output {
        jira:ProjectSummary[] => io:println("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }

}

function test_ProjectSummary_getAllDetails () {

    //Gets detailed representation using a project summary object.
    io:println("\n\n");
    io:println("BIND FUNCTION: projectSummary.getAllDetails()");
    var output = jiraConnector.getAllProjectSummaries();
    match output {
        jira:ProjectSummary[] ps => {
            var out = ps[0].getAllDetails();
            match out {
                jira:Project => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_createProject () {
    //**************************************************************************************************************
    //Creates new a project named "Test Project - Production Support"

    jira:ProjectRequest newProject =
    {
        key:"TESTPROJECT",
        name:"Test Project - Production Support",
        projectTypeKey:"software",
        projectTemplateKey:"com.pyxis.greenhopper.jira:basic-software-development-template",
        description:"Example Project description",
        lead:"pasan@wso2.com",
        url:"http://atlassian.com",
        assigneeType:"PROJECT_LEAD",
        avatarId:"10005",
        issueSecurityScheme:"10000",
        permissionScheme:"10075",
        notificationScheme:"10086",
        categoryId:"10000"
    };
    io:println("\n\n");
    io:println("BIND FUNCTION: createProject()");
    var output = jiraConnector.createProject(newProject);
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }

}

function test_updateProject () {
    //**************************************************************************************************************
    //Partially updates details of an existing project
    jira:ProjectRequest projectUpdate =
    {
        lead:"inshaf@wso2.com",
        projectTypeKey:"business"

    };
    io:println("\n\n");
    io:println("BIND FUNCTION: updateProject()");
    var output = jiraConnector.updateProject("TESTPROJECT", projectUpdate);
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }

}

function test_deleteProject () {
    //**************************************************************************************************************
    //Deletes an existing project from jira
    io:println("\n\n");
    io:println("BIND FUNCTION: deleteProject()");
    var output = jiraConnector.deleteProject("TESTPROJECT");
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }

}

function test_getProject () {
    //**************************************************************************************************************
    //Fetches jira Project details using project id (or project key)
    io:println("\n\n");
    io:println("BIND FUNCTION: getProject()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_getLeadUserDetails () {
    //**************************************************************************************************************
    //Get jira user details of project lead
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getLeadUserDetails()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.getLeadUserDetails();
            match out {
                jira:User => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_getRoleDetails () {
    //View Current Developers assigned to a project.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getRoleDetails()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.getRoleDetails(jira:ProjectRoleType.DEVELOPERS);
            match out {
                jira:ProjectRole => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_addUserToRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addUserToRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.addUserToRole(jira:ProjectRoleType.DEVELOPERS, "pasan@wso2.com");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_addGroupToRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addGroupToRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.addGroupToRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_removeUserFromRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeUserFromRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.removeUserFromRole(jira:ProjectRoleType.DEVELOPERS, "pasan@wso2.com");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_removeGroupFromRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeGroupFromRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.removeGroupFromRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_getAllIssueTypeStatuses () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getAllIssueTypeStatuses()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.getAllIssueTypeStatuses();
            match out {
                jira:ProjectStatus[] => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_Project_changeProjectType () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getAllIssueTypeStatuses()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.changeProjectType(jira:ProjectType.SOFTWARE);
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_ProjectComponentSummary_getAllDetails () {
    io:println("\n\n");
    io:println("BIND FUNCTION: prjectComponentSummary.getAllDetails()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.components[0].getAllDetails();
            match out {
                jira:ProjectComponent => io:print("success");
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_ProjectComponent_getLeadUserDetails () {
    io:println("\n\n");
    io:println("BIND FUNCTION: projectComponent.getLeadUserDetails()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.components[0].getAllDetails();
            match out {
                jira:ProjectComponent projectComponent => {
                    var out2 = projectComponent.getLeadUserDetails();
                    match out2 {
                        jira:User => io:print("success");
                        jira:JiraConnectorError => printTestResponse(e);
                    }
                }
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_ProjectComponent_getassigneeUserDetails () {
    io:println("\n\n");
    io:println("BIND FUNCTION: projectComponent.getAssigneeUserDetails()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.components[0].getAllDetails();
            match out {
                jira:ProjectComponent projectComponent => {
                    var out2 = projectComponent.getAssigneeUserDetails();
                    match out2 {
                        jira:User => io:print("success");
                        jira:JiraConnectorError => printTestResponse(e);
                    }
                }
                jira:JiraConnectorError e => printTestResponse(e);
            }
        }
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_getAllProjectCategories () {
    //**************************************************************************************************************
    //gets information of all existing project categories
    io:println("\n\n");
    io:println("BIND FUNCTION: getAllProjectCategories()");
    var output = jiraConnector.getAllProjectCategories();
    match output {
        jira:ProjectCategory[] => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_createProjectCategory () {
    //creates new jira project category
    io:println("\n\n");
    io:println("BIND FUNCTION: createProjectCategory()");
    jira:ProjectCategoryRequest newCategory = {name:"test-new category", description:"newCategory"};
    var output = jiraConnector.createProjectCategory(newCategory);
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_deleteProjectCategory () {
    //deletes jira project category
    io:println("\n\n");
    io:println("BIND FUNCTION: deleteProjectCategory()");
    var output = jiraConnector.deleteProjectCategory("10571");
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function printTestResponse (jira:JiraConnectorError e) {
    if (jira:isEmpty(e)) {
        io:println("Success");
    }
    else {
        io:println("failed");
        io:println(e);
    }
}

