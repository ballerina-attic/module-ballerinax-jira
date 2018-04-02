package tests;

import ballerina/log;
import ballerina/test;

@test:Config
function test_authenticate(){
    log:printInfo("CONNECTOR_ACTION - Authenticate()");
    var output = jiraConnectorEP -> authenticate("ashan@wso2.com", "ashan123");
    test:assertEquals(output,true,msg="Failed");
}

@test:Config
function test_getAllProjectSummaries () {
    log:printInfo("CONNECTOR_ACTION - getAllProjectSummaries()");
    var output = jiraConnectorEP -> getAllProjectSummaries();
    test:assertEquals(typeof output,typeof jira:ProjectSummary[],msg="Failed");

}

@test:Config
function test_createProject () {
    log:printInfo("CONNECTOR_ACTION - createProject()");
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
    var output = jiraConnectorEP -> createProject(newProject);
    test:assertEquals(output,true,msg="Failed");
}

function test_updateProject () {
    jira:ProjectRequest projectUpdate =
    {
        lead:"inshaf@wso2.com",
        projectTypeKey:"business"
    };
    io:println("\n\n");
    io:println("BIND FUNCTION: updateProject()");
    var output = jiraConnectorEP -> updateProject("TESTPROJECT", projectUpdate);
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_deleteProject () {
    //Deletes an existing project from jira
    io:println("\n\n");
    io:println("BIND FUNCTION: deleteProject()");
    var output = jiraConnectorEP -> deleteProject("TESTPROJECT");
    match output {
        boolean => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }
}

function test_getProject () {
    //Fetches jira Project details using project id (or project key)
    io:println("\n\n");
    io:println("BIND FUNCTION: getProject()");
    var output = jiraConnectorEP -> getProject("10314");
    match output {
        jira:Project => io:print("success");
        jira:JiraConnectorError e => printTestResponse(e);
    }
}