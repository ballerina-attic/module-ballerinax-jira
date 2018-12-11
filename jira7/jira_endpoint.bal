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

# Jira Client object.
# + jiraClient - The HTTP Client
public type Client client object {

    http:Client jiraClient;

    public function __init(JiraConfiguration jiraConfig) {
        self.jiraClient = new(jiraConfig.baseUrl, config = jiraConfig.clientConfig);
    }

    # Returns an array of all projects summaries which are visible for the currently logged in user who has
    # `BROWSE`, `ADMINISTER` or `PROJECT_ADMIN` project permission.
    # + return - Array of `ProjectSummary` objects or `JiraConnectorError` record
    public remote function getAllProjectSummaries() returns ProjectSummary[]|JiraConnectorError;

    # Returns detailed representation of the summarized project, if the project exists,the user has
    # permission to view it and if no any error occured.
    # + projectSummary - `ProjectSummary` object
    # + return - `Project` object or `JiraConnectorError` record
    public remote function getAllDetailsFromProjectSummary(ProjectSummary projectSummary) returns Project|JiraConnectorError;

    # Creates a new project. Values available for the assigneeType field are: `PROJECT_LEAD` and `UNASSIGNED`.
    # + newProject - Record which contains the mandatory fields for new project creation
    # + return - `Project` object which contains detailed representation of the new project or `JiraConnectorError` record
    public remote function createProject(ProjectRequest newProject) returns Project|JiraConnectorError;

    # Updates a project. Only non null values sent in `ProjectRequest` structure will be updated in the project.
    # Values available for the assigneeType field are: `PROJECT_LEAD` and `UNASSIGNED`.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + update - Record which contain fields which need to be updated
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function updateProject(string projectIdOrKey, ProjectRequest update) returns boolean|JiraConnectorError;

    # Deletes a project.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function deleteProject(string projectIdOrKey) returns boolean|JiraConnectorError;

    # Returns detailed representation of a project, if the project exists,the user has permission
    # to view it and if no any error occured.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + return - `Project` type object or `JiraConnectorError` record
    public remote function getProject(string projectIdOrKey) returns Project|JiraConnectorError;

    # Returns Jira user details of the project lead.
    # + project - `Project` type record
    # + return - `User` type record containing user details of the project lead. or `JiraConnectorError` record
    public remote function getLeadUserDetailsOfProject(Project project) returns User|JiraConnectorError;

    # Returns detailed reprensentation of a given project role(ie:Developers,Administrators etc.).
    # + project - `Project` type record
    # + projectRoleId - Id of the project role(
    #        `ROLE_ID_ADMINISTRATORS`,
    #        `ROLE_ID_CSAT_DEVELOPERS`,
    #        `ROLE_ID_DEVELOPERS`,
    #        `ROLE_ID_EXTERNAL_CONSULTANTS`,
    #        `ROLE_ID_NOTIFICATIONS`,
    #        `ROLE_ID_OBSERVER`,
    #        `ROLE_ID_USERS`
    #    )
    # + return - `ProjectRole` object containing the details of the requested role or `JiraConnectorError` record
    public remote function getRoleDetailsOfProject(Project project, string projectRoleId)
                               returns ProjectRole|JiraConnectorError;

    # Assigns a user to a given project role.
    # + project - `Project` type record
    # + projectRoleId - Id of the project role(
    #        `ROLE_ID_ADMINISTRATORS`,
    #        `ROLE_ID_CSAT_DEVELOPERS`,
    #        `ROLE_ID_DEVELOPERS`,
    #        `ROLE_ID_EXTERNAL_CONSULTANTS`,
    #        `ROLE_ID_NOTIFICATIONS`,
    #        `ROLE_ID_OBSERVER`,
    #        `ROLE_ID_USERS`
    #    )
    # + userName - Jira account username of the user to be added
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function addUserToRoleOfProject(Project project, string projectRoleId, string userName)
                               returns boolean|JiraConnectorError;

    # Assigns a group to a given project role.
    # + project - `Project` type record
    # + projectRoleId - Id of the project role(
    #        `ROLE_ID_ADMINISTRATORS`,
    #        `ROLE_ID_CSAT_DEVELOPERS`,
    #        `ROLE_ID_DEVELOPERS`,
    #        `ROLE_ID_EXTERNAL_CONSULTANTS`,
    #        `ROLE_ID_NOTIFICATIONS`,
    #        `ROLE_ID_OBSERVER`,
    #        `ROLE_ID_USERS`
    #    )
    # + groupName - Name of the group to be added
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
                               returns boolean|JiraConnectorError;

    # Removes a given user from a given project role.
    # + project - `Project` type record
    # + projectRoleId - Id of the project role(
    #        `ROLE_ID_ADMINISTRATORS`,
    #        `ROLE_ID_CSAT_DEVELOPERS`,
    #        `ROLE_ID_DEVELOPERS`,
    #        `ROLE_ID_EXTERNAL_CONSULTANTS`,
    #        `ROLE_ID_NOTIFICATIONS`,
    #        `ROLE_ID_OBSERVER`,
    #        `ROLE_ID_USERS`
    #    )
    # + userName - Name of the user required to be removed
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
                               returns boolean|JiraConnectorError;

    # Removes a given group from a given project role.
    # + project - `Project` type record
    # + projectRoleId - id of the project role(
    #        `ROLE_ID_ADMINISTRATORS`,
    #        `ROLE_ID_CSAT_DEVELOPERS`,
    #        `ROLE_ID_DEVELOPERS`,
    #        `ROLE_ID_EXTERNAL_CONSULTANTS`,
    #        `ROLE_ID_NOTIFICATIONS`,
    #        `ROLE_ID_OBSERVER`,
    #        `ROLE_ID_USERS`
    #    )
    # + groupName - Name of the group required to be removed
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
                               returns boolean|JiraConnectorError;

    # Gets all issue types with valid status values for a project.
    # + project - `Project` type record
    # + return - Array of `ProjectStatus` type records or `JiraConnectorError` record
    public remote function getAllIssueTypeStatusesOfProject(Project project) returns ProjectStatus[]|JiraConnectorError;

    # Updates the type of a Jira project.
    # + project - `Project` type record
    # + newProjectType - New project type for the jira project(`PROJECT_TYPE_SOFTWARE` or `PROJECT_TYPE_BUSINESS`)
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function changeTypeOfProject(Project project, string newProjectType)
                               returns boolean|JiraConnectorError;

    # Creates a new project component.
    # + newProjectComponent - Record which contains the mandatory fields for new project component creation
    # + return - `ProjectComponent` object which contains the created project component or `JiraConnectorError` record
    public remote function createProjectComponent(ProjectComponentRequest newProjectComponent)
                               returns ProjectComponent|JiraConnectorError;

    # Returns detailed representation of project component.
    # + componentId - string which contains a unique id for a given component.
    # + return - `ProjectComponent` type record or `JiraConnectorError` record
    public remote function getProjectComponent(string componentId) returns ProjectComponent|JiraConnectorError;

    # Deletes a project component.
    # + componentId - string which contains a unique id for a given component
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function deleteProjectComponent(string componentId) returns boolean|JiraConnectorError;

    # Returns jira user details of the assignee of the project component.
    # + projectComponent - `ProjectComponent` type record
    # + return - `User` object containing user details of the assignee. or `JiraConnectorError` record
    public remote function getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
                               returns User|JiraConnectorError;

    # Returns jira user details of the lead of the project component.
    # + projectComponent - `ProjectComponent` type record
    # + return - `User` object containing user details of the lead or `JiraConnectorError` record
    public remote function getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent)
                               returns User|JiraConnectorError;

    # Returns all existing project categories.
    # + return - Array of `ProjectCategory` objects or `JiraConnectorError` record
    public remote function getAllProjectCategories() returns ProjectCategory[]|JiraConnectorError;

    # Returns a detailed representation of a project category.
    # + projectCategoryId - Jira id of the project category
    # + return - `ProjectCategory` type records or `JiraConnectorError` record
    public remote function getProjectCategory(string projectCategoryId) returns ProjectCategory|JiraConnectorError;

    # Create a new project category.
    # + newCategory - Record which contains the mandatory fields for new project category creation
    # + return - `ProjectCategory` type records or `JiraConnectorError` record
    public remote function createProjectCategory(ProjectCategoryRequest newCategory)
                               returns ProjectCategory|JiraConnectorError;

    # Delete a project category.
    # + projectCategoryId - Jira id of the project category
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function deleteProjectCategory(string projectCategoryId) returns boolean|JiraConnectorError;

    # Returns a detailed representation of a jira issue.
    # + issueIdOrKey - Id or key of the required issue
    # + return - `Issue` type record or `JiraConnectorError` record
    public remote function getIssue(string issueIdOrKey) returns Issue|JiraConnectorError;

    # Creates a new jira issue.
    # + newIssue - Record which contains the mandatory fields for new issue creation
    # + return - `Issue` type record or `JiraConnectorError` record
    public remote function createIssue(IssueRequest newIssue) returns Issue|JiraConnectorError;
    # Deletes a jira issue.
    # + issueIdOrKey - Id or key of the issue
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function deleteIssue(string issueIdOrKey) returns boolean|JiraConnectorError;

    # Adds a comment to a Jira Issue.
    # + issueIdOrKey - Id or key of the issue
    # + comment - The details of the comment to be added
    # + return - returns true if the process is successful or `JiraConnectorError` record
    public remote function addCommentToIssue(string issueIdOrKey, IssueComment comment)
                               returns boolean|JiraConnectorError;
};

# Represents the Jira Client Connector Endpoint configuration.
# + clientConfig - HTTP client endpoint configuration
# + baseUrl - The Jira API URL
public type JiraConfiguration record {
    string baseUrl;
    http:ClientEndpointConfig clientConfig;
};


remote function Client.getAllProjectSummaries() returns ProjectSummary[]|JiraConnectorError {

    ProjectSummary[] projects = [];

    var httpResponseOut = self.jiraClient->get("/project?expand=description");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var jsonResponseArrayOut = <json[]>jsonResponseOut;
        if (jsonResponseArrayOut.length() == 0) {
            error err = error(JIRA_ERROR_CODE, { message: "Error: server response doesn't contain any projects." });
            return errorToJiraConnectorError(err);
        } else {
            int i = 0;
            foreach var jsonProject in jsonResponseArrayOut {
            projects[i] = jsonToProjectSummary(jsonProject);
            i += 1;
            }
            return projects;
        }
    }
}

remote function Client.getAllDetailsFromProjectSummary(ProjectSummary projectSummary)
    returns Project|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/project/" + projectSummary.key);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is json) {
    jsonResponseOut.leadName = jsonResponseOut.lead != null ? jsonResponseOut.lead.name != null ?
    jsonResponseOut.lead.name : null : null;
    var projectOut = Project.convert(jsonResponseOut);
    if(projectOut is Project) {
        return projectOut;
    } else {
        return errorToJiraConnectorError(projectOut);
    }
    } else {
        return jsonResponseOut;
    }
}

remote function Client.createProject(ProjectRequest newProject) returns Project|JiraConnectorError {

    http:Request outRequest = new;

    var jsonPayloadOut = json.convert(newProject);
    if (jsonPayloadOut is error) {
        return errorToJiraConnectorError(jsonPayloadOut);
    } else {
        outRequest.setJsonPayload(jsonPayloadOut);

        var httpResponseOut = self.jiraClient->post("/project", outRequest);
        //Evaluate http response for connection and server errors
        var jsonResponseOut = getValidatedResponse(httpResponseOut);

        if (jsonResponseOut is JiraConnectorError) {
            return jsonResponseOut;
        } else {
            var projectOut = self->getProject(untaint jsonResponseOut.key.toString());
            if (projectOut is Project) {
                return projectOut;
            } else {
                return projectOut;
            }
        }
    }
}

remote function Client.updateProject(string projectIdOrKey, ProjectRequest update)
    returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    json jsonPayload;
    jsonPayload = projectRequestToJson(update);
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->put("/project/" + projectIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.deleteProject(string projectIdOrKey) returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/project/" + projectIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.getProject(string projectIdOrKey) returns Project|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/project/" + projectIdOrKey);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        jsonResponseOut.leadName = jsonResponseOut.lead != null ? jsonResponseOut.lead.name != null ?
        jsonResponseOut.lead.name : null : null;
        var projectOut = Project.convert(jsonResponseOut);
        if (projectOut is error) {
            return errorToJiraConnectorError(projectOut);
        } else {
            return projectOut;
        }
    }
}

remote function Client.getLeadUserDetailsOfProject(Project project) returns User|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/user?username=" + project.leadName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var userOut = User.convert(jsonResponseOut);
        if (userOut is error) {
            return errorToJiraConnectorError(userOut);
        } else {
            return userOut;
        }
    }
}

remote function Client.getRoleDetailsOfProject(Project project, string projectRoleId)
    returns ProjectRole|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/project/" + project.key + "/role/" + projectRoleId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var projectRoleOut = ProjectRole.convert(jsonResponseOut);
        if (projectRoleOut is error) {
            return errorToJiraConnectorError(projectRoleOut);
        } else {
            return projectRoleOut;
        }
    }
}

remote function Client.addUserToRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    json jsonPayload = { "user": [userName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/project/" + project.key + "/role/" + projectRoleId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    json jsonPayload = { "group": [groupName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/project/" + project.key + "/role/" + projectRoleId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/project/" + project.key + "/role/" +
    projectRoleId + "?user=" + userName, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/project/" + project.key + "/role/" +
    projectRoleId + "?group=" + groupName, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.getAllIssueTypeStatusesOfProject(Project project)
    returns ProjectStatus[]|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/project/" + project.key + "/statuses");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var jsonResponseArrayOut = json[].convert(jsonResponseOut);
        if (jsonResponseArrayOut is error) {
            return errorToJiraConnectorError(jsonResponseArrayOut);
        } else {
            ProjectStatus[] statusArray = [];
            int i = 0;
            foreach var status in jsonResponseArrayOut {
                var statusOut = ProjectStatus.convert(status);
                if (statusOut is error) {
                    return errorToJiraConnectorError(statusOut);
                } else {
                    statusArray[i] = statusOut;
                    i += 1;
                }
            }
            return statusArray;
        }
    }
}

remote function Client.changeTypeOfProject(Project project, string newProjectType)
    returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->put("/project/" + project.key + "/type/" + newProjectType, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.createProjectComponent(ProjectComponentRequest newProjectComponent)
    returns ProjectComponent|JiraConnectorError {

    http:Request outRequest = new;

    var jsonPayloadOut = json.convert(newProjectComponent);
    if (jsonPayloadOut is error) {
        return errorToJiraConnectorError(jsonPayloadOut);
    } else {
        outRequest.setJsonPayload(jsonPayloadOut);

        var httpResponseOut = self.jiraClient->post("/component/", outRequest);
        //Evaluate http response for connection and server errors
        var jsonResponseOut = getValidatedResponse(httpResponseOut);
        if (jsonResponseOut is JiraConnectorError) {
            return jsonResponseOut;
        } else {
            var projectComponentOut = self->getProjectComponent(untaint jsonResponseOut.id.toString());
            if(projectComponentOut is ProjectComponent) {
                return projectComponentOut;
            } else {
                return projectComponentOut;
            }
        }
    }
}

remote function Client.getProjectComponent(string componentId) returns ProjectComponent|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/component/" + componentId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
    ProjectComponent component = jsonToProjectComponent(jsonResponseOut);
        return component;
    }
}

remote function Client.deleteProjectComponent(string componentId) returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/component/" + componentId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/user?username=" + projectComponent.assigneeName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var userOut = User.convert(jsonResponseOut);
        if (userOut is error) {
            return errorToJiraConnectorError(userOut);
        } else {
            return userOut;
        }
    }
}

remote function Client.getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/user?username=" + projectComponent.leadName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var userOut = User.convert(jsonResponseOut);
        if (userOut is error) {
            return errorToJiraConnectorError(userOut);
        } else {
            return userOut;
        }
    }
}

remote function Client.getAllProjectCategories() returns ProjectCategory[]|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/projectCategory");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var jsonResponseArrayOut = json[].convert(jsonResponseOut);
        if (jsonResponseArrayOut is error) {
            return errorToJiraConnectorError(jsonResponseArrayOut);
        } else {
            ProjectCategory[] projectCategories = [];
            int i = 0;
            foreach var jsonProjectCategory in jsonResponseArrayOut {
                var projectCategoryOut = ProjectCategory.convert(jsonProjectCategory);
                if (projectCategoryOut is error) {
                    return errorToJiraConnectorError(projectCategoryOut);
                } else {
                    projectCategories[i] = projectCategoryOut;
                    i += 1;
                }
                return projectCategories;
            }
        }
    }
}

remote function Client.getProjectCategory(string projectCategoryId) returns ProjectCategory|JiraConnectorError {

    var httpResponseOut = self.jiraClient->get("/projectCategory/" + projectCategoryId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var projectCategoryOut = ProjectCategory.convert(jsonResponseOut);
        if (projectCategoryOut is error) {
            return errorToJiraConnectorError(projectCategoryOut);
        } else {
            return projectCategoryOut;
        }
    }
}

remote function Client.createProjectCategory(ProjectCategoryRequest newCategory)
    returns ProjectCategory|JiraConnectorError {

    http:Request outRequest = new;

    var jsonPayloadOut = json.convert(newCategory);
    if (jsonPayloadOut is error) {
        return errorToJiraConnectorError(jsonPayloadOut);
    } else {
        outRequest.setJsonPayload(jsonPayloadOut);

        var httpResponseOut = self.jiraClient->post("/projectCategory", outRequest);
        //Evaluate http response for connection and server errors
        var jsonResponseOut = getValidatedResponse(httpResponseOut);

        if (jsonResponseOut is JiraConnectorError) {
            return jsonResponseOut;
        } else {
            var ProjectCategoryOut = self->getProjectCategory(untaint jsonResponseOut.id.toString());
            if (ProjectCategoryOut is ProjectCategory) {
                return ProjectCategoryOut;
            } else {
                return ProjectCategoryOut;
            }
        }
    }
}

remote function Client.deleteProjectCategory(string projectCategoryId) returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/projectCategory/" + projectCategoryId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.getIssue(string issueIdOrKey) returns Issue|JiraConnectorError {

    string getParams = "/issue/" + issueIdOrKey;
    log:printDebug("GET : " + getParams);

    var httpResponseOut = self.jiraClient->get(getParams);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return jsonToIssue(jsonResponseOut);
    }
}


remote function Client.createIssue(IssueRequest newIssue) returns Issue|JiraConnectorError {

    http:Request outRequest = new;

    json jsonPayload = issueRequestToJson(newIssue);
    log:printDebug("CreateIssue payload: " + jsonPayload.toString());
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/issue", outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        var issueOut = self->getIssue(untaint jsonResponseOut.key.toString());
        if (issueOut is Issue) {
            return issueOut;
        } else {
            return issueOut;
        }
    }
}

remote function Client.deleteIssue(string issueIdOrKey) returns boolean|JiraConnectorError {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/issue/" + issueIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

remote function Client.addCommentToIssue(string issueIdOrKey, IssueComment comment)
    returns boolean|JiraConnectorError {

    http:Request commentRequest = new;

    json jsonPayload = {};
    jsonPayload.body = comment.body;
    commentRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/issue/" + issueIdOrKey +"/comment", commentRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is JiraConnectorError) {
        return jsonResponseOut;
    } else {
        return true;
    }
}