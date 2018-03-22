import ballerina.io;
import src.jira;

jira:JiraConnectorError e = {};
boolean result;
boolean isValid;
jira:JiraConnector jiraConnector = {};


public function main (string[] args) {


    io:println("started running samples..\n");

    sample_authenticate();

    sample_getAllProjectSummaries();
    sample_ProjectSummary_getAllDetails();

    sample_createProject();
    sample_updateProject();
    sample_deleteProject();

    sample_getProject();

    sample_Project_getLeadUserDetails();
    sample_Project_getRoleDetails();
    sample_Project_addUserToRole();
    sample_Project_addGroupToRole();
    sample_Project_removeUserFromRole();
    sample_Project_removeGroupFromRole();
    sample_Project_getAllIssueTypeStatuses();
    sample_Project_changeProjectType();

    sample_getAllProjectCategories();
    sample_createProjectCategory();
    sample_deleteProjectCategory();

}

function sample_authenticate () {
    //**************************************************************************************************************
    //Validates provided user credentials
    io:println("\n\n");
    io:println("validating user credentials..");
    var output = jiraConnector.authenticate("ashan@wso2.com", "ashan123");
    match output {
        boolean => io:println("success");
        jira:JiraConnectorError e => printSampleResponse(e);
    }


}

function sample_getAllProjectSummaries () {
    //**************************************************************************************************************
    //Gets descriptions of all the existing jira projects
    io:println("\n\n");
    io:println("BIND FUNCTION: getAllProjectSummaries()");
    var output = jiraConnector.getAllProjectSummaries();
    match output {
        jira:ProjectSummary[] => io:println("success");
        jira:JiraConnectorError e => printSampleResponse(e);
    }

}

function sample_ProjectSummary_getAllDetails () {

    //Gets detailed representation using a project summary object.
    io:println("\n\n");
    io:println("BIND FUNCTION: projectSummary.getAllDetails()");
    var output = jiraConnector.getAllProjectSummaries();
    match output {
        jira:ProjectSummary[] ps => {
            var out = ps[0].getAllDetails();
            match out {
                jira:Project => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}


function sample_createProject () {
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
        jira:JiraConnectorError e => printSampleResponse(e);
    }

}

function sample_updateProject () {
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
        jira:JiraConnectorError e => printSampleResponse(e);
    }

}

function sample_deleteProject () {
    //**************************************************************************************************************
    //Deletes an existing project from jira
    io:println("\n\n");
    io:println("BIND FUNCTION: deleteProject()");
    var output = jiraConnector.deleteProject("TESTPROJECT");
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printSampleResponse(e);
    }

}

function sample_getProject () {
    //**************************************************************************************************************
    //Fetches jira Project details using project id (or project key)
    io:println("\n\n");
    io:println("BIND FUNCTION: getProject()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project => io:print("success");
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_getLeadUserDetails () {
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
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_getRoleDetails () {
    //View Current Developers assigned to a project.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getRoleDetails()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.getRoleDetails(jira:ProjectRoleType.DEVELOPERS);
            match out {
                jira:ProjectRole => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_addUserToRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addUserToRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.addUserToRole(jira:ProjectRoleType.DEVELOPERS, "pasan@wso2.com");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_addGroupToRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addGroupToRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.addGroupToRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_removeUserFromRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeUserFromRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.removeUserFromRole(jira:ProjectRoleType.DEVELOPERS, "pasan@wso2.com");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_removeGroupFromRole () {
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeGroupFromRole()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.removeGroupFromRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user");
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_getAllIssueTypeStatuses(){
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getAllIssueTypeStatuses()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.getAllIssueTypeStatuses();
            match out {
                jira:ProjectStatus[] => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_Project_changeProjectType(){
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getAllIssueTypeStatuses()");
    var output = jiraConnector.getProject("10314");
    match output {
        jira:Project project => {
            var out = project.changeProjectType(jira:ProjectType.SOFTWARE);
            match out {
                boolean => io:print("success");
                jira:JiraConnectorError e => printSampleResponse(e);
            }
        }
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_ProjectCategorySummary_getAllDetails(){

}

function sample_ProjectCategory_getLeadUserDetails(){

}

function sample_ProjectCategory_getassigneeUserDetails(){

}

function sample_getAllProjectCategories () {
    //**************************************************************************************************************
    //gets information of all existing project categories
    io:println("\n\n");
    io:println("BIND FUNCTION: getAllProjectCategories()");
    var output = jiraConnector.getAllProjectCategories();
    match output {
        jira:ProjectCategory[] => io:print("success");
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_createProjectCategory () {
    //creates new jira project category
    io:println("\n\n");
    io:println("BIND FUNCTION: createProjectCategory()");
    jira:ProjectCategoryRequest newCategory = {name:"test-new category", description:"newCategory"};
    var output = jiraConnector.createProjectCategory(newCategory);
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function sample_deleteProjectCategory () {
    //deletes jira project category
    io:println("\n\n");
    io:println("BIND FUNCTION: deleteProjectCategory()");
    var output = jiraConnector.deleteProjectCategory("10571");
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printSampleResponse(e);
    }
}

function printSampleResponse (jira:JiraConnectorError e) {
    if (jira:isEmpty(e)) {
        io:println("Success");
    }
    else {
        io:println("failed");
        io:println(e);
    }
}

