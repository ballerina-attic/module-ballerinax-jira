package tests;

import ballerina/net.http;
import ballerina/log;
import ballerina/test;
import ballerina/io;
import jira;

jira:Project project_test = {};
jira:ProjectSummary[] projectSummaryArray_test = [];
jira:ProjectComponent projectComponent_test = {};
jira:ProjectCategory projectCategory_test = {};

endpoint jira:JiraEndpoint jiraConnectorEP {
    uri:"https://support-staging.wso2.com"
};

@test:BeforeSuite
function connector_init () {
    log:printInfo("Init");

    //To avoid test failure of 'test_createProject()', if a project already exists with the same name.
    _ = jiraConnectorEP -> deleteProject("TESTPROJECT");
}

@test:Config
function test_authenticate () {
    log:printInfo("CONNECTOR_ACTION - Authenticate()");
    var output = jiraConnectorEP -> authenticate("ashan@wso2.com", "ashan123");
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_authenticate"]
}
function test_getAllProjectSummaries () {
    log:printInfo("CONNECTOR_ACTION - getAllProjectSummaries()");

    var output = jiraConnectorEP -> getAllProjectSummaries();
    match output {
        jira:ProjectSummary[] projectSummaryArray => {
            projectSummaryArray_test = projectSummaryArray;
            test:assertTrue(true);
        }

        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getAllProjectSummaries"]
}
function test_getAllDetailsFromProjectSummary () {
    log:printInfo("CONNECTOR_ACTION - getAllDetailsFromProjectSummary()");

    var output = jiraConnectorEP -> getAllDetailsFromProjectSummary(projectSummaryArray_test[0]);
    match output {
        jira:Project => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_authenticate"]
}
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
    match output {
        jira:Project => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProject"]
}
function test_updateProject () {
    log:printInfo("CONNECTOR_ACTION - updateProject()");

    jira:ProjectRequest projectUpdate = {
                                            lead:"inshaf@wso2.com",
                                            projectTypeKey:"business"
                                        };

    var output = jiraConnectorEP -> updateProject("TESTPROJECT", projectUpdate);
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }

}

@test:Config {
    dependsOn:["test_createProject",
               "test_updateProject",
               "test_getLeadUserDetailsOfProject",
               "test_getRoleDetailsOfProject",
               "test_addUserToRoleOfProject",
               "test_addGroupToRoleOfProject",
               "test_removeUserFromRoleOfProject",
               "test_removeGroupFromRoleOfProject",
               "test_getAllIssueTypeStatusesOfProject",
               "test_changeTypeOfProject",
               "test_getProjectComponent",
               "test_createProjectComponent",
               "test_deleteProjectComponent",
               "test_getLeadUserDetailsOfProjectComponent",
               "test_getAssigneeUserDetailsOfProjectComponent"
              ]
}

function test_deleteProject () {
    log:printInfo("CONNECTOR_ACTION - deleteProject()");

    var output = jiraConnectorEP -> deleteProject("TESTPROJECT");
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}


@test:Config {
    dependsOn:["test_createProject"]
}

function test_getProject () {
    log:printInfo("CONNECTOR_ACTION - getProject()");

    var output = jiraConnectorEP -> getProject("TESTPROJECT");
    match output {
        jira:Project p => {
            project_test = p;
            test:assertTrue(true);
        }
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}


@test:Config {
    dependsOn:["test_getProject"]
}

function test_getLeadUserDetailsOfProject () {
    log:printInfo("CONNECTOR_ACTION - getLeadUserDetailsOfProject()");

    var output = jiraConnectorEP -> getLeadUserDetailsOfProject(project_test);
    match output {
        jira:User => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_getRoleDetailsOfProject () {
    log:printInfo("CONNECTOR_ACTION - getRoleDetailsOfProject()");

    var output = jiraConnectorEP -> getRoleDetailsOfProject(project_test, jira:ProjectRoleType.DEVELOPERS);
    match output {
        jira:ProjectRole => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_addUserToRoleOfProject () {
    log:printInfo("CONNECTOR_ACTION - addUserToRoleOfProject()");

    var output = jiraConnectorEP -> addUserToRoleOfProject(project_test, jira:ProjectRoleType.DEVELOPERS,
                                                           "pasan@wso2.com");
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_addGroupToRoleOfProject () {
    log:printInfo("CONNECTOR_ACTION - addGroupToRoleOfProject()");

    var output = jiraConnectorEP -> addGroupToRoleOfProject(project_test, jira:ProjectRoleType.DEVELOPERS,
                                                            "support.client.AAALIFEDEV.user");
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject", "test_addUserToRoleOfProject"]
}
function test_removeUserFromRoleOfProject () {
    log:printInfo("CONNECTOR_ACTION - removeUserFromRoleOfProject()");

    var output = jiraConnectorEP -> removeUserFromRoleOfProject(project_test, jira:ProjectRoleType.DEVELOPERS,
                                                                "pasan@wso2.com");
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}


@test:Config {
    dependsOn:["test_getProject", "test_addGroupToRoleOfProject"]
}
function test_removeGroupFromRoleOfProject () {
    log:printInfo("CONNECTOR_ACTION - removeGroupFromRoleOfProject()");

    var output = jiraConnectorEP -> removeGroupFromRoleOfProject(project_test, jira:ProjectRoleType.DEVELOPERS,
                                                                 "support.client.AAALIFEDEV.user");
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}


@test:Config {
    dependsOn:["test_getProject"]
}
function test_getAllIssueTypeStatusesOfProject () {
    log:printInfo("CONNECTOR_ACTION - getAllIssueTypeStatusesOfProject()");

    var output = jiraConnectorEP -> getAllIssueTypeStatusesOfProject(project_test);
    match output {
        jira:ProjectStatus[] => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_changeTypeOfProject () {
    log:printInfo("CONNECTOR_ACTION - changeTypeOfProject()");

    var output = jiraConnectorEP -> changeTypeOfProject(project_test, jira:ProjectType.SOFTWARE);
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



@test:Config {
    dependsOn:["test_getProject"]
}
function test_createProjectComponent () {
    log:printInfo("CONNECTOR_ACTION - createProjectComponent()");

    jira:ProjectComponentRequest newProjectComponent =
    {
        name:"Test-ProjectComponent",
        description:"Test component created by ballerina jira connector.",
        leadUserName:"pasan@wso2.com",
        assigneeType:"PROJECT_LEAD",
        project:project_test.key,
        projectId:project_test.id
    };

    var output = jiraConnectorEP -> createProjectComponent(newProjectComponent);
    match output {
        jira:ProjectComponent component => {
            projectComponent_test = component;
            test:assertTrue(true);
        }
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectComponent"]
}
function test_getProjectComponent () {
    log:printInfo("CONNECTOR_ACTION - getProjectComponent()");

    jira:ProjectComponentSummary sampleComponentSummary = {id:"10001"};

    project_test.components[0] = sampleComponentSummary;
    var output = jiraConnectorEP -> getProjectComponent(projectComponent_test.id);
    match output {
        jira:ProjectComponent component => {
            test:assertTrue(true);
        }
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectComponent"]
}
function test_getAssigneeUserDetailsOfProjectComponent () {
    log:printInfo("CONNECTOR_ACTION - getAssigneeUserDetailsOfProjectComponent()");

    var output = jiraConnectorEP -> getAssigneeUserDetailsOfProjectComponent(projectComponent_test);
    match output {
        jira:User => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectComponent"]
}
function test_getLeadUserDetailsOfProjectComponent () {
    log:printInfo("CONNECTOR_ACTION - getLeadUserDetailsOfProjectComponent()");

    var output = jiraConnectorEP -> getLeadUserDetailsOfProjectComponent(projectComponent_test);
    match output {
        jira:User => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectComponent",
               "test_getProjectComponent",
               "test_getAssigneeUserDetailsOfProjectComponent",
               "test_getLeadUserDetailsOfProjectComponent"
              ]
}
function test_deleteProjectComponent () {
    log:printInfo("CONNECTOR_ACTION - deleteProjectComponent()");

    var output = jiraConnectorEP -> deleteProjectComponent(projectComponent_test.id);
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_authenticate"]
}
function test_getAllProjectCategories () {
    log:printInfo("CONNECTOR_ACTION - getAllProjectCategories()");

    var output = jiraConnectorEP -> getAllProjectCategories();
    match output {
        jira:ProjectCategory[] => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_authenticate"]
}
function test_createProjectCategory () {
    log:printInfo("CONNECTOR_ACTION - createProjectCategory()");

    jira:ProjectCategoryRequest newCategory = {name:"Test-Porject Category",
                                                  description:"new category created from balleirna jira connector"};

    var output = jiraConnectorEP -> createProjectCategory(newCategory);
    match output {
        jira:ProjectCategory category => {
            projectCategory_test = category;
            test:assertTrue(true);
        }
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectCategory"]
}
function test_getProjectCategory () {
    log:printInfo("CONNECTOR_ACTION - getProjectCategory()");

    var output = jiraConnectorEP -> getProjectCategory(projectCategory_test.id);
    match output {
        jira:ProjectCategory => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectCategory", "test_getProjectCategory"]
}
function test_deleteProjectCategory () {
    log:printInfo("CONNECTOR_ACTION - deleteProjectCategory()");

    var output = jiraConnectorEP -> deleteProjectCategory(projectCategory_test.id);
    match output {
        boolean => test:assertTrue(true);
        jira:JiraConnectorError => test:assertFail(msg = "Failed");
    }
}