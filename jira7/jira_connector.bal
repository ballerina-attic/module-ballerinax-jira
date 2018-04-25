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

documentation{Represents Jira Client Connector Object}
public type JiraConnector object {

    private {
        http:Client jiraHttpClient = new;
    }

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

};

documentation{Returns an array of all projects summaries which are visible for the currently logged in user who has
BROWSE, ADMINISTER or PROJECT_ADMIN project permission.
    R{{ProjectSummary}} Array of 'ProjectSummary' objects
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getAllProjectSummaries() returns ProjectSummary[]|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    ProjectSummary[] projects = [];
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/project?expand=description", request = outRequest);
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

documentation{Returns detailed representation of the summarized project, if the project exists,the user has
permission to view it and if no any error occured.
    P{{projectSummary}} 'ProjectSummary' object
    R{{Project}} 'Project' object
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getAllDetailsFromProjectSummary(ProjectSummary projectSummary)
    returns Project|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + projectSummary.key, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ?
                                    jsonResponse.lead.name: null: null;
            var projectOut = <Project>jsonResponse;
            match projectOut {
                error err => return errorToJiraConnectorError(err);
                Project project => return project;
            }
        }
    }
}

documentation{Creates a new project.Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'.
    P{{newProject}} record which contains the mandatory fields for new project creation
    R{{Project}} 'Project' object which contains detailed representation of the new project
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::createProject(ProjectRequest newProject) returns Project|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var jsonPayloadOut = <json>newProject;
    match jsonPayloadOut {
        error err => return errorToJiraConnectorError(err);

        json jsonPayload => {
            outRequest.setJsonPayload(jsonPayload);

            var httpResponseOut = jiraHttpClientEP->post("/project", request = outRequest);
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

documentation{Updates a project. Only non null values sent in 'ProjectRequest' structure will
    be updated in the project. Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'.
    P{{projectIdOrKey}} unique string which represents the project id or project key of a jira project
    P{{update}} record which contain fields which need to be updated
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::updateProject(string projectIdOrKey, ProjectRequest update)
    returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload;
    jsonPayload = projectRequestToJson(update);
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->put("/project/" + projectIdOrKey, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{Deletes a project.
    P{{projectIdOrKey}} unique string which represents the project id or project key of a jira project
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::deleteProject(string projectIdOrKey) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/project/" + projectIdOrKey, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{Returns detailed representation of a project, if the project exists,the user has permission
to view it and if no any error occured.
    P{{projectIdOrKey}} unique string which represents the project id or project key of a jira project
    R{{Project}} 'Project' type object
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getProject(string projectIdOrKey) returns Project|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + projectIdOrKey, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;

        json jsonResponse => {
            jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ?
                                    jsonResponse.lead.name: null : null;
            var projectOut = <Project>jsonResponse;
            match projectOut {
                error err => return errorToJiraConnectorError(err);
                Project project => return project;
            }
        }
    }
}

documentation{Returns jira user details of the project lead.
    P{{project}} 'Project' type record
    R{{User}} 'User' type record containing user details of the project lead.
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getLeadUserDetailsOfProject(Project project) returns User|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/user?username=" + project.leadName, request = outRequest);
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

documentation{Returns detailed reprensentation of a given project role(ie:Developers,Administrators etc.)
    P{{project}} 'Project' type record
    P{{projectRoleId}} id of the project role(
        ROLE_ID_ADMINISTRATORS,
        ROLE_ID_CSAT_DEVELOPERS,
        ROLE_ID_DEVELOPERS,
        ROLE_ID_EXTERNAL_CONSULTANTS,
        ROLE_ID_NOTIFICATIONS,
        ROLE_ID_OBSERVER,
        ROLE_ID_USERS
    )
    R{{ProjectRole}} 'ProjectRole' object containing the details of the requested role
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getRoleDetailsOfProject(Project project, string projectRoleId)
    returns ProjectRole|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + project.key + "/role/" + projectRoleId, request =
        outRequest);
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

documentation{Assigns a user to a given project role.
    P{{project}} 'Project' type record
    P{{projectRoleId}} id of the project role(
        ROLE_ID_ADMINISTRATORS,
        ROLE_ID_CSAT_DEVELOPERS,
        ROLE_ID_DEVELOPERS,
        ROLE_ID_EXTERNAL_CONSULTANTS,
        ROLE_ID_NOTIFICATIONS,
        ROLE_ID_OBSERVER,
        ROLE_ID_USERS
    )
    P{{userName}} jira account username of the user to be added
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::addUserToRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload = { "user": [userName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->post("/project/" + project.key + "/role/" + projectRoleId, request =
        outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{Assigns a group to a given project role.
    P{{project}} 'Project' type record
    P{{projectRoleId}} id of the project role(
        ROLE_ID_ADMINISTRATORS,
        ROLE_ID_CSAT_DEVELOPERS,
        ROLE_ID_DEVELOPERS,
        ROLE_ID_EXTERNAL_CONSULTANTS,
        ROLE_ID_NOTIFICATIONS,
        ROLE_ID_OBSERVER,
        ROLE_ID_USERS
    )
    P{{groupName}} name of the group to be added
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload = { "group": [groupName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->post("/project/" + project.key + "/role/" + projectRoleId, request =
        outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{removes a given user from a given project role.
    P{{project}} 'Project' type record
    P{{projectRoleId}} id of the project role(
        ROLE_ID_ADMINISTRATORS,
        ROLE_ID_CSAT_DEVELOPERS,
        ROLE_ID_DEVELOPERS,
        ROLE_ID_EXTERNAL_CONSULTANTS,
        ROLE_ID_NOTIFICATIONS,
        ROLE_ID_OBSERVER,
        ROLE_ID_USERS
    )
    P{{userName}} name of the user required to be removed
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/project/" + project.key + "/role/" +
            projectRoleId + "?user=" + userName, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{removes a given group from a given project role.
    P{{project}} 'Project' type record
    P{{projectRoleId}} id of the project role(
        ROLE_ID_ADMINISTRATORS,
        ROLE_ID_CSAT_DEVELOPERS,
        ROLE_ID_DEVELOPERS,
        ROLE_ID_EXTERNAL_CONSULTANTS,
        ROLE_ID_NOTIFICATIONS,
        ROLE_ID_OBSERVER,
        ROLE_ID_USERS
    )
    P{{groupName}} name of the group required to be removed
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/project/" + project.key + "/role/" +
            projectRoleId + "?group=" + groupName, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{Gets all issue types with valid status values for a project.
    P{{project}} 'Project' type record
    R{{ProjectStatus}} Array of 'ProjectStatus' type records
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getAllIssueTypeStatusesOfProject(Project project)
    returns ProjectStatus[]|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/project/" + project.key + "/statuses", request = outRequest);
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

documentation{Updates the type of a jira project.
    P{{project}} 'Project' type record
    P{{newProjectType}} new project type for the jira project(PROJECT_TYPE_SOFTWARE or PROJECT_TYPE_BUSINESS)
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::changeTypeOfProject(Project project, string newProjectType)
    returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->put("/project/" + project.key + "/type/" + newProjectType, request =
        outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{Creates a new project component.
    P{{newProjectComponent}} record which contains the mandatory fields for new project component creation
    R{{ProjectComponent}} 'ProjectComponent' object which contains the created project component
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::createProjectComponent(ProjectComponentRequest newProjectComponent)
    returns ProjectComponent|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var jsonPayloadOut = <json>newProjectComponent;
    match jsonPayloadOut {
        error err => return errorToJiraConnectorError(err);

        json jsonPayload => {
            outRequest.setJsonPayload(jsonPayload);

            var httpResponseOut = jiraHttpClientEP->post("/component/", request = outRequest);
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

documentation{Returns detailed representation of project component.
    P{{componentId}} string which contains a unique id for a given component.
    R{{ProjectComponent}} 'ProjectComponent' type record
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getProjectComponent(string componentId) returns ProjectComponent|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/component/" + componentId, request = outRequest);
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

documentation{Deletes a project component.
    P{{componentId}} string which contains a unique id for a given component
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::deleteProjectComponent(string componentId) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/component/" + componentId, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}

documentation{Returns jira user details of the assignee of the project component.
    P{{projectComponent}} 'ProjectComponent' type record
    R{{User}} 'User' object containing user details of the assignee.
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/user?username=" + projectComponent.assigneeName, request = outRequest)
    ;
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

documentation{Returns jira user details of the lead of the project component.
    P{{projectComponent}} 'ProjectComponent' type record
    R{{User}} 'User' object containing user details of the lead.
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/user?username=" + projectComponent.leadName, request = outRequest);
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

documentation{Returns all existing project categories.
    R{{ProjectCategory}} Array of 'ProjectCategory' objects
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getAllProjectCategories() returns ProjectCategory[]|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/projectCategory", request = outRequest);
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

documentation{Returns a detailed representation of a project category.
    P{{projectCategoryId}} jira id of the project category
    R{{ProjectCategory}} 'ProjectCategory' type records
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getProjectCategory(string projectCategoryId) returns ProjectCategory|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/projectCategory/" + projectCategoryId, request = outRequest);
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

documentation{Create a new project category.
    P{{newCategory}} record which contains the mandatory fields for new project category creation
    R{{ProjectCategory}} 'ProjectCategory' type records
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::createProjectCategory(ProjectCategoryRequest newCategory)
    returns ProjectCategory|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var jsonPayloadOut = <json>newCategory;
    match jsonPayloadOut {
        error err => return errorToJiraConnectorError(err);

        json jsonPayload => {
            outRequest.setJsonPayload(jsonPayload);

            var httpResponseOut = jiraHttpClientEP->post("/projectCategory", request = outRequest);
            //Evaluate http response for connection and server errors
            var jsonResponseOut = getValidatedResponse(httpResponseOut);

            match jsonResponseOut {
                JiraConnectorError e => return e;

                json jsonResponse => {
                    var ProjectCategoryOut = self.getProjectCategory(jsonResponse.id.toString());
                    match ProjectCategoryOut {
                        ProjectCategory category => return category;
                        JiraConnectorError e => return e;
                    }
                }
            }
        }
    }
}

documentation{Delete a project category.
    P{{projectCategoryId}} jira id of the project category
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::deleteProjectCategory(string projectCategoryId) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/projectCategory/" + projectCategoryId, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}


documentation{Returns a detailed representation of a jira issue.
    P{{issueIdOrKey}} id or key of the required issue
    R{{Issue}} 'Issue' type record
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::getIssue(string issueIdOrKey) returns Issue|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->get("/issue/" + issueIdOrKey, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return jsonToIssue(jsonResponse);
    }
}

documentation{Creates a new jira issue.
    P{{newIssue}} record which contains the mandatory fields for new issue creation
    R{{Issue}} 'Issue' type record
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::createIssue(IssueRequest newIssue) returns Issue|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    json jsonPayload = issueRequestToJson(newIssue);
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = jiraHttpClientEP->post("/issue", request = outRequest);
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

documentation{Deletes a jira issue.
    P{{issueIdOrKey}} id or key of the issue
    R{{^"boolean"}} returns true if the process is successful
    R{{JiraConnectorError}} 'JiraConnectorError' record
}
public function JiraConnector::deleteIssue(string issueIdOrKey) returns boolean|JiraConnectorError {

    endpoint http:Client jiraHttpClientEP = self.jiraHttpClient;
    http:Request outRequest = new;

    var httpResponseOut = jiraHttpClientEP->delete("/issue/" + issueIdOrKey, request = outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => return e;
        json jsonResponse => return true;
    }
}
