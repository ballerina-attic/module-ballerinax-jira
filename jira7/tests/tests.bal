import ballerina/http;
import ballerina/log;
import ballerina/test;
import ballerina/io;

endpoint Client jiraConnectorEP {
    httpClientConfig:{
        auth:{
            scheme:"basic",
            username:getUsername(),
            password:getPassword()
        }
    },
    url:getUrl()
};

@test:BeforeSuite
function connector_init() {
    //To avoid test failure of 'test_createProject()', if a project already exists with the same name.
    _ = jiraConnectorEP -> deleteProject("TESTPROJECT2");
}

@test:Config
function test_getAllProjectSummaries() {
    log:printInfo("CONNECTOR_ACTION - getAllProjectSummaries()");

    var output = jiraConnectorEP -> getAllProjectSummaries();
    match output {
        ProjectSummary[] projectSummaryArray => {
            projectSummaryArray_test = projectSummaryArray;
            test:assertTrue(true);
        }

        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getAllProjectSummaries"]
}
function test_getAllDetailsFromProjectSummary() {
    log:printInfo("CONNECTOR_ACTION - getAllDetailsFromProjectSummary()");

    var output = jiraConnectorEP -> getAllDetailsFromProjectSummary(projectSummaryArray_test[0]);
    match output {
        Project => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config
function test_createProject() {
    log:printInfo("CONNECTOR_ACTION - createProject()");

    ProjectRequest newProject =
    {
        key:"TESTPROJECT2",
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
        Project p => {
            project_test = p;
            test:assertTrue(true);
        }
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_updateProject() {
    log:printInfo("CONNECTOR_ACTION - updateProject()");

    ProjectRequest projectUpdate = {
        lead:"inshaf@wso2.com",
        projectTypeKey:"business"
    };

    var output = jiraConnectorEP -> updateProject("TESTPROJECT2", projectUpdate);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
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

function test_deleteProject() {
    log:printInfo("CONNECTOR_ACTION - deleteProject()");

    var output = jiraConnectorEP -> deleteProject("TESTPROJECT2");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}


@test:Config {
    dependsOn:["test_createProject"]
}
function test_getProject() {
    log:printInfo("CONNECTOR_ACTION - getProject()");

    var output = jiraConnectorEP -> getProject("TESTPROJECT2");
    match output {
        Project p => {
            project_test = p;
            test:assertTrue(true);
        }
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_getLeadUserDetailsOfProject() {
    log:printInfo("CONNECTOR_ACTION - getLeadUserDetailsOfProject()");

    var output = jiraConnectorEP -> getLeadUserDetailsOfProject(project_test);
    match output {
        User => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_getRoleDetailsOfProject() {
    log:printInfo("CONNECTOR_ACTION - getRoleDetailsOfProject()");

    var output = jiraConnectorEP -> getRoleDetailsOfProject(project_test, "10001");
    match output {
        ProjectRole => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_addUserToRoleOfProject() {
    log:printInfo("CONNECTOR_ACTION - addUserToRoleOfProject()");

    var output = jiraConnectorEP -> addUserToRoleOfProject(project_test, "10001",
        "pasan@wso2.com");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_addGroupToRoleOfProject() {
    log:printInfo("CONNECTOR_ACTION - addGroupToRoleOfProject()");

    var output = jiraConnectorEP -> addGroupToRoleOfProject(project_test, "10001",
        "support.client.AAALIFEDEV.user");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject", "test_addUserToRoleOfProject"]
}
function test_removeUserFromRoleOfProject() {
    log:printInfo("CONNECTOR_ACTION - removeUserFromRoleOfProject()");

    var output = jiraConnectorEP -> removeUserFromRoleOfProject(project_test, "10001",
        "pasan@wso2.com");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}


@test:Config {
    dependsOn:["test_getProject", "test_addGroupToRoleOfProject"]
}
function test_removeGroupFromRoleOfProject() {
    log:printInfo("CONNECTOR_ACTION - removeGroupFromRoleOfProject()");

    var output = jiraConnectorEP -> removeGroupFromRoleOfProject(project_test, "10001",
        "support.client.AAALIFEDEV.user");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_getAllIssueTypeStatusesOfProject() {
    log:printInfo("CONNECTOR_ACTION - getAllIssueTypeStatusesOfProject()");

    var output = jiraConnectorEP -> getAllIssueTypeStatusesOfProject(project_test);
    match output {
        ProjectStatus[] => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_changeTypeOfProject() {
    log:printInfo("CONNECTOR_ACTION - changeTypeOfProject()");

    var output = jiraConnectorEP -> changeTypeOfProject(project_test, "software");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_createProjectComponent() {
    log:printInfo("CONNECTOR_ACTION - createProjectComponent()");

    ProjectComponentRequest newProjectComponent =
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
        ProjectComponent component => {
            projectComponent_test = component;
            test:assertTrue(true);
        }
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectComponent"]
}
function test_getProjectComponent() {
    log:printInfo("CONNECTOR_ACTION - getProjectComponent()");

    ProjectComponentSummary sampleComponentSummary = {id:"10001"};

    project_test.components[0] = sampleComponentSummary;
    var output = jiraConnectorEP -> getProjectComponent(projectComponent_test.id);
    match output {
        ProjectComponent component => {
            projectComponent_test = component;
            test:assertTrue(true);
        }
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProjectComponent"]
}
function test_getAssigneeUserDetailsOfProjectComponent() {
    log:printInfo("CONNECTOR_ACTION - getAssigneeUserDetailsOfProjectComponent()");

    var output = jiraConnectorEP -> getAssigneeUserDetailsOfProjectComponent(projectComponent_test);
    match output {
        User => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProjectComponent"]
}
function test_getLeadUserDetailsOfProjectComponent() {
    log:printInfo("CONNECTOR_ACTION - getLeadUserDetailsOfProjectComponent()");

    var output = jiraConnectorEP -> getLeadUserDetailsOfProjectComponent(projectComponent_test);
    match output {
        User => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectComponent",
    "test_getProjectComponent",
    "test_getAssigneeUserDetailsOfProjectComponent",
    "test_getLeadUserDetailsOfProjectComponent"
    ]
}
function test_deleteProjectComponent() {
    log:printInfo("CONNECTOR_ACTION - deleteProjectComponent()");

    var output = jiraConnectorEP -> deleteProjectComponent(projectComponent_test.id);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config
function test_getAllProjectCategories() {
    log:printInfo("CONNECTOR_ACTION - getAllProjectCategories()");

    var output = jiraConnectorEP -> getAllProjectCategories();
    match output {
        ProjectCategory[] => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config
function test_createProjectCategory() {
    log:printInfo("CONNECTOR_ACTION - createProjectCategory()");

    ProjectCategoryRequest newCategory = {name:"Test-Project Category",
        description:"new category created from balleirna jira connector"};

    var output = jiraConnectorEP -> createProjectCategory(newCategory);
    match output {
        ProjectCategory category => {
            projectCategory_test = category;
            test:assertTrue(true);
        }
        JiraConnectorError err => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createProjectCategory"]
}
function test_getProjectCategory() {
    log:printInfo("CONNECTOR_ACTION - getProjectCategory()");

    var output = jiraConnectorEP -> getProjectCategory(projectCategory_test.id);
    match output {
        ProjectCategory category => {
            projectCategory_test = category;
            test:assertTrue(true);
        }
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getProjectCategory"]
}
function test_deleteProjectCategory() {
    log:printInfo("CONNECTOR_ACTION - deleteProjectCategory()");

    var output = jiraConnectorEP -> deleteProjectCategory(projectCategory_test.id);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

///////////////////////////////

@test:Config{
    dependsOn:["test_getProject"]
}
function test_createIssue() {
    log:printInfo("CONNECTOR_ACTION - createIssue()");

    IssueRequest newIssue = {
        key:"TESTISSUE",
        summary:"This is a test issue created for Ballerina Jira Connector",
        issueTypeId:"4",
        projectId:project_test.id,
        assigneeName:"inshaf@wso2.com"
    };

    var output = jiraConnectorEP -> createIssue(newIssue);
    match output {
        Issue issue => {
            issue_test = issue;
            test:assertTrue(true);
        }
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_createIssue"]
}
function test_getIssue() {
    log:printInfo("CONNECTOR_ACTION - getIssue()");

    var output = jiraConnectorEP -> getIssue(issue_test.key);
    match output {
        Issue issue => {
            issue_test = issue;
            test:assertTrue(true);
        }
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}

@test:Config {
    dependsOn:["test_getIssue"]
}
function test_deleteIssue() {
    log:printInfo("CONNECTOR_ACTION - deleteIssue()");

    var output = jiraConnectorEP -> deleteIssue(issue_test.key);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError => test:assertFail(msg = "Failed");
    }
}
