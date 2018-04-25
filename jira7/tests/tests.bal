import ballerina/http;
import ballerina/log;
import ballerina/test;

Project project_test = {};
ProjectSummary[] projectSummaryArray_test = [];
ProjectComponent projectComponent_test = {};
ProjectCategory projectCategory_test = {};
Issue issue_test = {};

endpoint Client jiraConnectorEP {
    clientConfig:{
        url:config:getAsString("test_url"),
        auth:{
            scheme:"basic",
            username:config:getAsString("test_username"),
            password:config:getAsString("test_password")
        }
    }
};

@test:BeforeSuite
function connector_init() {
    //To avoid test failure of 'test_createProject()', if a project already exists with the same name.
    _ = jiraConnectorEP -> deleteProject("TSTPROJECT");
}

@test:Config
function test_getAllProjectSummaries() {
    log:printInfo("ACTION : getAllProjectSummaries()");

    var output = jiraConnectorEP -> getAllProjectSummaries();
    match output {
        ProjectSummary[] projectSummaryArray => {
            projectSummaryArray_test = projectSummaryArray;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getAllProjectSummaries"]
}
function test_getAllDetailsFromProjectSummary() {
    log:printInfo("ACTION : getAllDetailsFromProjectSummary()");

    var output = jiraConnectorEP -> getAllDetailsFromProjectSummary(projectSummaryArray_test[0]);
    match output {
        Project => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config{
    dependsOn:["test_createProjectCategory"]
}
function test_createProject() {
    log:printInfo("ACTION : createProject()");

    ProjectRequest newProject =
    {
        key:"TSTPROJECT",
        name:"Test Project - Production Support",
        projectTypeKey:"software",
        projectTemplateKey:"com.pyxis.greenhopper.jira:basic-software-development-template",
        description:"Example Project description",
        lead:config:getAsString("test_username"),
        url:"http://atlassian.com",
        assigneeType:"PROJECT_LEAD",
        avatarId:"10000",
        permissionScheme:"10000",
        notificationScheme:"10000",
        categoryId:projectCategory_test.id
    };

    var output = jiraConnectorEP -> createProject(newProject);
    match output {
        Project p => {
            project_test = p;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_updateProject() {
    log:printInfo("ACTION : updateProject()");

    ProjectRequest projectUpdate = {
        lead:config:getAsString("test_username"),
        projectTypeKey:"business"
    };

    var output = jiraConnectorEP -> updateProject("TSTPROJECT", projectUpdate);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
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
    "test_getAssigneeUserDetailsOfProjectComponent",
    "test_deleteIssue"
    ]
}
function test_deleteProject() {
    log:printInfo("ACTION : deleteProject()");

    var output = jiraConnectorEP -> deleteProject("TSTPROJECT");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}


@test:Config {
    dependsOn:["test_createProject"]
}
function test_getProject() {
    log:printInfo("ACTION : getProject()");

    var output = jiraConnectorEP -> getProject("TSTPROJECT");
    match output {
        Project p => {
            project_test = p;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_getLeadUserDetailsOfProject() {
    log:printInfo("ACTION : getLeadUserDetailsOfProject()");

    var output = jiraConnectorEP -> getLeadUserDetailsOfProject(project_test);
    match output {
        User => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_getRoleDetailsOfProject() {
    log:printInfo("ACTION : getRoleDetailsOfProject()");

    var output = jiraConnectorEP -> getRoleDetailsOfProject(project_test, "10002");
    match output {
        ProjectRole => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_addUserToRoleOfProject() {
    log:printInfo("ACTION : addUserToRoleOfProject()");

    var output = jiraConnectorEP -> addUserToRoleOfProject(project_test, "10002",
        config:getAsString("test_username"));
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject", "test_removeGroupFromRoleOfProject"]
}
function test_addGroupToRoleOfProject() {
    log:printInfo("ACTION : addGroupToRoleOfProject()");

    var output = jiraConnectorEP -> addGroupToRoleOfProject(project_test, "10002",
            "jira-administrators");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject", "test_addUserToRoleOfProject"]
}
function test_removeUserFromRoleOfProject() {
    log:printInfo("ACTION : removeUserFromRoleOfProject()");

    var output = jiraConnectorEP -> removeUserFromRoleOfProject(project_test, "10002",
        config:getAsString("test_username"));
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}


@test:Config {
    dependsOn:["test_getProject"]
}
function test_removeGroupFromRoleOfProject() {
    log:printInfo("ACTION : removeGroupFromRoleOfProject()");

    var output = jiraConnectorEP -> removeGroupFromRoleOfProject(project_test, "10002",
        "jira-administrators");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_getAllIssueTypeStatusesOfProject() {
    log:printInfo("ACTION : getAllIssueTypeStatusesOfProject()");

    var output = jiraConnectorEP -> getAllIssueTypeStatusesOfProject(project_test);
    match output {
        ProjectStatus[] => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_changeTypeOfProject() {
    log:printInfo("ACTION : changeTypeOfProject()");

    var output = jiraConnectorEP -> changeTypeOfProject(project_test, "software");
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProject"]
}
function test_createProjectComponent() {
    log:printInfo("ACTION : createProjectComponent()");

    ProjectComponentRequest newProjectComponent =
    {
        name:"Test-ProjectComponent",
        description:"Test component created by ballerina jira connector.",
        leadUserName:config:getAsString("test_username"),
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
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_createProjectComponent"]
}
function test_getProjectComponent() {
    log:printInfo("ACTION : getProjectComponent()");

    ProjectComponentSummary sampleComponentSummary = {id:"10001"};

    project_test.components[0] = sampleComponentSummary;
    var output = jiraConnectorEP -> getProjectComponent(projectComponent_test.id);
    match output {
        ProjectComponent component => {
            projectComponent_test = component;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProjectComponent"]
}
function test_getAssigneeUserDetailsOfProjectComponent() {
    log:printInfo("ACTION : getAssigneeUserDetailsOfProjectComponent()");

    var output = jiraConnectorEP -> getAssigneeUserDetailsOfProjectComponent(projectComponent_test);
    match output {
        User => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProjectComponent"]
}
function test_getLeadUserDetailsOfProjectComponent() {
    log:printInfo("ACTION : getLeadUserDetailsOfProjectComponent()");

    var output = jiraConnectorEP -> getLeadUserDetailsOfProjectComponent(projectComponent_test);
    match output {
        User => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
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
    log:printInfo("ACTION : deleteProjectComponent()");

    var output = jiraConnectorEP -> deleteProjectComponent(projectComponent_test.id);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config
function test_getAllProjectCategories() {
    log:printInfo("ACTION : getAllProjectCategories()");

    var output = jiraConnectorEP -> getAllProjectCategories();
    match output {
        ProjectCategory[] => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config
function test_createProjectCategory() {
    log:printInfo("ACTION : createProjectCategory()");

    ProjectCategoryRequest newCategory = {name:"Test-Project Category",
        description:"new category created from balleirna jira connector"};

    var output = jiraConnectorEP -> createProjectCategory(newCategory);
    match output {
        ProjectCategory category => {
            projectCategory_test = category;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_createProjectCategory"]
}
function test_getProjectCategory() {
    log:printInfo("ACTION : getProjectCategory()");

    var output = jiraConnectorEP -> getProjectCategory(projectCategory_test.id);
    match output {
        ProjectCategory category => {
            projectCategory_test = category;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getProjectCategory","test_deleteProject"]
}
function test_deleteProjectCategory() {
    log:printInfo("ACTION : deleteProjectCategory()");

    var output = jiraConnectorEP -> deleteProjectCategory(projectCategory_test.id);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

///////////////////////////////

@test:Config{
    dependsOn:["test_getProject"]
}
function test_createIssue() {
    log:printInfo("ACTION : createIssue()");

    IssueRequest newIssue = {
        key:"TESTISSUE",
        summary:"This is a test issue created for Ballerina Jira Connector",
        issueTypeId:"10002",
        projectId:project_test.id,
        assigneeName:config:getAsString("test_username")
    };

    var output = jiraConnectorEP -> createIssue(newIssue);
    match output {
        Issue issue => {
            issue_test = issue;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_createIssue"]
}
function test_getIssue() {
    log:printInfo("ACTION : getIssue()");

    var output = jiraConnectorEP -> getIssue(issue_test.key);
    match output {
        Issue issue => {
            issue_test = issue;
            test:assertTrue(true);
        }
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["test_getIssue"]
}
function test_deleteIssue() {
    log:printInfo("ACTION : deleteIssue()");

    var output = jiraConnectorEP -> deleteIssue(issue_test.key);
    match output {
        boolean => test:assertTrue(true);
        JiraConnectorError e => test:assertFail(msg = e.message);
    }
}


@test:AfterSuite
function afterSuite() {
    //To avoid test failure of 'test_createProject()', if a project already exists with the same name.
    _ = jiraConnectorEP -> deleteProject("TSTPROJECT");
    _ = jiraConnectorEP -> deleteProjectCategory(projectCategory_test.id);
}