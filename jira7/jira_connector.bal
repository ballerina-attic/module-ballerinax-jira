//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import ballerina/http;
import ballerina/log;

# Represents Jira Client Connector Object
public type JiraConnector object {

    http:Client jiraHttpClient = new;

    public function getAllProjectSummaries()
                        returns ProjectSummary[]|JiraConnectorError;

    public function getAllDetailsFromProjectSummary(ProjectSummary projectSummary)
                        returns Project|JiraConnectorError;

    public function createProject(ProjectRequest newProject)
                        returns Project|JiraConnectorError;

    public function updateProject(string projectIdOrKey, ProjectRequest update)
                        returns boolean|JiraConnectorError;

    public function deleteProject(string projectIdOrKey)
                        returns boolean|JiraConnectorError;

    public function getProject(string projectIdOrKey)
                        returns Project|JiraConnectorError;

    public function getLeadUserDetailsOfProject(Project project)
                        returns User|JiraConnectorError;

    public function getRoleDetailsOfProject(Project project, string projectRoleId)
                        returns ProjectRole|JiraConnectorError;

    public function addUserToRoleOfProject(Project project, string projectRoleId, string userName)
                        returns boolean|JiraConnectorError;

    public function addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
                        returns boolean|JiraConnectorError;

    public function removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
                        returns boolean|JiraConnectorError;

    public function removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
                        returns boolean|JiraConnectorError;

    public function getAllIssueTypeStatusesOfProject(Project project)
                        returns ProjectStatus[]|JiraConnectorError;

    public function changeTypeOfProject(Project project, string newProjectType)
                        returns boolean|JiraConnectorError;

    public function createProjectComponent(ProjectComponentRequest newProjectComponent)
                        returns ProjectComponent|JiraConnectorError;

    public function getProjectComponent(string componentId)
                        returns ProjectComponent|JiraConnectorError;

    public function deleteProjectComponent(string componentId)
                        returns boolean|JiraConnectorError;

    public function getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
                        returns User|JiraConnectorError;

    public function getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent)
                        returns User|JiraConnectorError;

    public function getAllProjectCategories() returns ProjectCategory[]|JiraConnectorError;

    public function getProjectCategory(string projectCategoryId)
                        returns ProjectCategory|JiraConnectorError;

    public function createProjectCategory(ProjectCategoryRequest newCategory)
                        returns ProjectCategory|JiraConnectorError;

    public function deleteProjectCategory(string projectCategoryId)
                        returns boolean|JiraConnectorError;

    public function getIssue(string issueIdOrKey)
                        returns Issue|JiraConnectorError;

    public function createIssue(IssueRequest newIssue)
                        returns Issue|JiraConnectorError;

    public function deleteIssue(string issueIdOrKey)
                        returns boolean|JiraConnectorError;

    public function addCommentToIssue(string issueIdOrKey, IssueComment comment)
                        returns boolean|JiraConnectorError;
};

# Returns an array of all projects summaries which are visible for the currently logged in user who has
# BROWSE, ADMINISTER or PROJECT_ADMIN project permission.
# + return - Array of 'ProjectSummary' objects or 'JiraConnectorError' record
function JiraConnector::getAllProjectSummaries() returns ProjectSummary[]|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    ProjectSummary[] projects = [];

    var httpResponseOut = jiraHttpClientEP->get("/project?expand=description");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var jsonResponseArrayOut = <json[]>jsonResponse;
            match jsonResponseArrayOut {
                error err => return errorToJiraConnectorError(err);

                json[] jsonResponseArray => {
                    if (jsonResponseArray == null) {
                        error err = { message: "Error: server response doesn't contain any projects." };
                        return errorToJiraConnectorError(err);
                    }

                    int i = 0;
                    foreach (jsonProject in jsonResponseArray) {
                        projects[i] = jsonToProjectSummary(jsonProject);
                        i += 1;
                    }
                    return projects;
                }
            }
        }
    }
}

# Returns detailed representation of the summarized project, if the project exists,the user has
# permission to view it and if no any error occured.
# + projectSummary - 'ProjectSummary' object
# + return - 'Project' object or 'JiraConnectorError' record
function JiraConnector::getAllDetailsFromProjectSummary(ProjectSummary projectSummary)
                                   returns Project|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + projectSummary.key);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ?
            jsonResponse.lead.name                                                             : null:
            null;
            var projectOut = <Project>jsonResponse;
            match projectOut {
                error err => return errorToJiraConnectorError(err);
                Project project => return project;
            }
        }
    }
}

# Creates a new project.Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'.
# + newProject - record which contains the mandatory fields for new project creation
# + return - 'Project' object which contains detailed representation of the new project or 'JiraConnectorError' record
function JiraConnector::createProject(ProjectRequest newProject) returns Project|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var jsonPayloadOut = <json>newProject;
    match jsonPayloadOut {
        error err => return errorToJiraConnectorError(err);

        json jsonPayload => {
            outRequest.setJsonPayload(jsonPayload);

            var httpResponseOut = jiraHttpClientEP->post("/project", outRequest);
            //Evaluate http response for connection and server errors
            var jsonResponseOut = getValidatedResponse(httpResponseOut);

            match jsonResponseOut {
                JiraConnectorError e => return e;

                json jsonResponse => {
                    var projectOut = self.getProject(jsonResponse.key.toString());
                    match projectOut {
                        Project project => return project;
                        JiraConnectorError e => return e;
                    }
                }
            }
        }
    }
}

# Updates a project. Only non null values sent in 'ProjectRequest' structure will
#    be updated in the project. Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'.
# + projectIdOrKey - unique string which represents the project id or project key of a jira project
# + update - record which contain fields which need to be updated
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::updateProject(string projectIdOrKey, ProjectRequest update)
                                   returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload;
    jsonPayload = projectRequestToJson(update);
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->put("/project/" + projectIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# Deletes a project.
# + projectIdOrKey - unique string which represents the project id or project key of a jira project
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::deleteProject(string projectIdOrKey) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/project/" + projectIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# Returns detailed representation of a project, if the project exists,the user has permission
# to view it and if no any error occured.
# + projectIdOrKey - unique string which represents the project id or project key of a jira project
# + return - 'Project' type object or 'JiraConnectorError' record
function JiraConnector::getProject(string projectIdOrKey) returns Project|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + projectIdOrKey);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ?
            jsonResponse.lead.name                                                             : null :
            null;
            var projectOut = <Project>jsonResponse;
            match projectOut {
                error err => return errorToJiraConnectorError(err);
                Project project => return project;
            }
        }
    }
}

# Returns jira user details of the project lead.
# + project - 'Project' type record
# + return - 'User' type record containing user details of the project lead. or 'JiraConnectorError' record
function JiraConnector::getLeadUserDetailsOfProject(Project project) returns User|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/user?username=" + project.leadName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var userOut = <User>jsonResponse;
            match userOut {
                error err => return errorToJiraConnectorError(err);
                User lead => return lead;
            }
        }
    }
}

# Returns detailed reprensentation of a given project role(ie:Developers,Administrators etc.)
# + project - 'Project' type record
# + projectRoleId - id of the project role(
#        ROLE_ID_ADMINISTRATORS,
#        ROLE_ID_CSAT_DEVELOPERS,
#        ROLE_ID_DEVELOPERS,
#        ROLE_ID_EXTERNAL_CONSULTANTS,
#        ROLE_ID_NOTIFICATIONS,
#        ROLE_ID_OBSERVER,
#        ROLE_ID_USERS
#    )
# + return - 'ProjectRole' object containing the details of the requested role or 'JiraConnectorError' record
function JiraConnector::getRoleDetailsOfProject(Project project, string projectRoleId)
                                   returns ProjectRole|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + project.key + "/role/" + projectRoleId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var projectRoleOut = <ProjectRole>jsonResponse;
            match projectRoleOut {
                error err => return errorToJiraConnectorError(err);
                ProjectRole projectRole => return projectRole;
            }
        }
    }
}

# Assigns a user to a given project role.
# + project - 'Project' type record
# + projectRoleId - id of the project role(
#        ROLE_ID_ADMINISTRATORS,
#        ROLE_ID_CSAT_DEVELOPERS,
#        ROLE_ID_DEVELOPERS,
#        ROLE_ID_EXTERNAL_CONSULTANTS,
#        ROLE_ID_NOTIFICATIONS,
#        ROLE_ID_OBSERVER,
#        ROLE_ID_USERS
#    )
# + userName - jira account username of the user to be added
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::addUserToRoleOfProject(Project project, string projectRoleId, string userName)
                                   returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload = { "user": [userName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->post("/project/" + project.key + "/role/" + projectRoleId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# Assigns a group to a given project role.
# + project - 'Project' type record
# + projectRoleId - id of the project role(
#        ROLE_ID_ADMINISTRATORS,
#        ROLE_ID_CSAT_DEVELOPERS,
#        ROLE_ID_DEVELOPERS,
#        ROLE_ID_EXTERNAL_CONSULTANTS,
#        ROLE_ID_NOTIFICATIONS,
#        ROLE_ID_OBSERVER,
#        ROLE_ID_USERS
#    )
# + groupName - name of the group to be added
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
                                   returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload = { "group": [groupName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->post("/project/" + project.key + "/role/" + projectRoleId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# removes a given user from a given project role.
# + project - 'Project' type record
# + projectRoleId - id of the project role(
#        ROLE_ID_ADMINISTRATORS,
#        ROLE_ID_CSAT_DEVELOPERS,
#        ROLE_ID_DEVELOPERS,
#        ROLE_ID_EXTERNAL_CONSULTANTS,
#        ROLE_ID_NOTIFICATIONS,
#        ROLE_ID_OBSERVER,
#        ROLE_ID_USERS
#    )
# + userName - name of the user required to be removed
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
                                   returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/project/" + project.key + "/role/" +
            projectRoleId + "?user=" + userName, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# removes a given group from a given project role.
# + project - 'Project' type record
# + projectRoleId - id of the project role(
#        ROLE_ID_ADMINISTRATORS,
#        ROLE_ID_CSAT_DEVELOPERS,
#        ROLE_ID_DEVELOPERS,
#        ROLE_ID_EXTERNAL_CONSULTANTS,
#        ROLE_ID_NOTIFICATIONS,
#        ROLE_ID_OBSERVER,
#        ROLE_ID_USERS
#    )
# + groupName - name of the group required to be removed
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
                                   returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/project/" + project.key + "/role/" +
            projectRoleId + "?group=" + groupName, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# Gets all issue types with valid status values for a project.
# + project - 'Project' type record
# + return - Array of 'ProjectStatus' type records or 'JiraConnectorError' record
function JiraConnector::getAllIssueTypeStatusesOfProject(Project project)
                                   returns ProjectStatus[]|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + project.key + "/statuses");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var jsonResponseArrayOut = <json[]>jsonResponse;
            match jsonResponseArrayOut {
                error err => return errorToJiraConnectorError(err);

                json[] jsonResponseArray => {
                    ProjectStatus[] statusArray = [];
                    int i = 0;
                    foreach (status in jsonResponseArray) {
                        var statusOut = <ProjectStatus>status;
                        match statusOut {
                            error err => return errorToJiraConnectorError(err);

                            ProjectStatus projectStatus => {
                                statusArray[i] = projectStatus;
                                i += 1;
                            }
                        }
                    }
                    return statusArray;
                }
            }
        }
    }
}

# Updates the type of a jira project.
# + project - 'Project' type record
# + newProjectType - new project type for the jira project(PROJECT_TYPE_SOFTWARE or PROJECT_TYPE_BUSINESS)
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::changeTypeOfProject(Project project, string newProjectType)
                                   returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->put("/project/" + project.key + "/type/" + newProjectType, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# Creates a new project component.
# + newProjectComponent - record which contains the mandatory fields for new project component creation
# + return - 'ProjectComponent' object which contains the created project component or 'JiraConnectorError' record
function JiraConnector::createProjectComponent(ProjectComponentRequest newProjectComponent)
                                   returns ProjectComponent|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var jsonPayloadOut = <json>newProjectComponent;
    match jsonPayloadOut {
        error err => return errorToJiraConnectorError(err);

        json jsonPayload => {
            outRequest.setJsonPayload(jsonPayload);

            var httpResponseOut = jiraHttpClientEP->post("/component/", outRequest);
            //Evaluate http response for connection and server errors
            var jsonResponseOut = getValidatedResponse(httpResponseOut);
            match jsonResponseOut {
                JiraConnectorError e => return e;

                json jsonResponse => {
                    var projectComponentOut = self.getProjectComponent(jsonResponse.id.toString());
                    match projectComponentOut {
                        ProjectComponent projectComponent => return projectComponent;
                        JiraConnectorError e => return e;
                    }
                }
            }
        }
    }
}

# Returns detailed representation of project component.
# + componentId - string which contains a unique id for a given component.
# + return - 'ProjectComponent' type record or 'JiraConnectorError' record
function JiraConnector::getProjectComponent(string componentId) returns ProjectComponent|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/component/" + componentId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            ProjectComponent component = jsonToProjectComponent(jsonResponse);
            return component;
        }
    }
}

# Deletes a project component.
# + componentId - string which contains a unique id for a given component
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::deleteProjectComponent(string componentId) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/component/" + componentId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# Returns jira user details of the assignee of the project component.
# + projectComponent - 'ProjectComponent' type record
# + return - 'User' object containing user details of the assignee. or 'JiraConnectorError' record
function JiraConnector::getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
                                   returns User|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;


    var httpResponseOut = jiraHttpClientEP->get("/user?username=" + projectComponent.assigneeName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var userOut = <User>jsonResponse;
            match userOut {
                error err => return errorToJiraConnectorError(err);
                User assignee => return assignee;
            }
        }
    }
}

# Returns jira user details of the lead of the project component.
# + projectComponent - 'ProjectComponent' type record
# + return - 'User' object containing user details of the lead. or 'JiraConnectorError' record
function JiraConnector::getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent)
                                   returns User|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/user?username=" + projectComponent.leadName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var userOut = <User>jsonResponse;
            match userOut {
                error err => return errorToJiraConnectorError(err);
                User lead => return lead;
            }
        }
    }
}

# Returns all existing project categories.
# + return - Array of 'ProjectCategory' objects or 'JiraConnectorError' record
function JiraConnector::getAllProjectCategories() returns ProjectCategory[]|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/projectCategory");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var jsonResponseArrayOut = <json[]>jsonResponse;
            match jsonResponseArrayOut {
                error err => return errorToJiraConnectorError(err);

                json[] jsonResponseArray => {
                    ProjectCategory[] projectCategories = [];
                    int i = 0;
                    foreach (jsonProjectCategory in jsonResponseArray) {
                        var projectCategoryOut = <ProjectCategory>jsonProjectCategory;
                        match projectCategoryOut {
                            error err => return errorToJiraConnectorError(err);

                            ProjectCategory projectCategory => {
                                projectCategories[i] = projectCategory;
                                i += 1;
                            }
                        }
                    }
                    return projectCategories;
                }
            }
        }
    }
}

# Returns a detailed representation of a project category.
# + projectCategoryId - jira id of the project category
# + return - 'ProjectCategory' type records or 'JiraConnectorError' record
function JiraConnector::getProjectCategory(string projectCategoryId) returns ProjectCategory|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    var httpResponseOut = jiraHttpClientEP->get("/projectCategory/" + projectCategoryId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var projectCategoryOut = <ProjectCategory>jsonResponse;
            match projectCategoryOut {
                error err => return errorToJiraConnectorError(err);
                ProjectCategory category => return category;
            }
        }
    }
}

# Create a new project category.
# + newCategory - record which contains the mandatory fields for new project category creation
# + return - 'ProjectCategory' type records or 'JiraConnectorError' record
function JiraConnector::createProjectCategory(ProjectCategoryRequest newCategory)
                                   returns ProjectCategory|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var jsonPayloadOut = <json>newCategory;
    match jsonPayloadOut {
        error err => return errorToJiraConnectorError(err);

        json jsonPayload => {
            outRequest.setJsonPayload(jsonPayload);

            var httpResponseOut = jiraHttpClientEP->post("/projectCategory", outRequest);
            //Evaluate http response for connection and server errors
            var jsonResponseOut = getValidatedResponse(httpResponseOut);

            match jsonResponseOut {
                JiraConnectorError e => return e;

                json jsonResponse => {
                    var ProjectCategoryOut = self.getProjectCategory(untaint jsonResponse.id.toString());
                    match ProjectCategoryOut {
                        ProjectCategory category => return category;
                        JiraConnectorError e => return e;
                    }
                }
            }
        }
    }
}

# Delete a project category.
# + projectCategoryId - jira id of the project category
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::deleteProjectCategory(string projectCategoryId) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/projectCategory/" + projectCategoryId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}


# Returns a detailed representation of a jira issue.
# + issueIdOrKey - id or key of the required issue
# + return - 'Issue' type record or 'JiraConnectorError' record
function JiraConnector::getIssue(string issueIdOrKey) returns Issue|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;

    string getParams = "/issue/" + issueIdOrKey;
    log:printDebug("GET : " + getParams);

    var httpResponseOut = jiraHttpClientEP->get(getParams);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return jsonToIssue(jsonResponse);
    }
}

# Creates a new jira issue.
# + newIssue - record which contains the mandatory fields for new issue creation
# + return - 'Issue' type record or 'JiraConnectorError' record
function JiraConnector::createIssue(IssueRequest newIssue) returns Issue|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload = issueRequestToJson(newIssue);
    log:printDebug("CreateIssue payload: " + jsonPayload.toString());
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->post("/issue", outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            var issueOut = self.getIssue(jsonResponse.key.toString());
            match issueOut {
                Issue issue => return issue;
                JiraConnectorError e => return e;
            }
        }
    }
}

# Deletes a jira issue.
# + issueIdOrKey - id or key of the issue
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::deleteIssue(string issueIdOrKey) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/issue/" + issueIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

# Adds a comment to a Jira Issue.
# + issueIdOrKey - id or key of the issue
# + comment - the details of the comment to be added
# + return - returns true if the process is successful or 'JiraConnectorError' record
function JiraConnector::addCommentToIssue(string issueIdOrKey, IssueComment comment)
            returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request commentRequest = new;

    json jsonPayload = {};
    jsonPayload.body = comment.body;
    commentRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->post("/issue/" + issueIdOrKey +"/comment", commentRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

