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
    # + return - An array of `ProjectSummary` records if successful, else returns an error
    public remote function getAllProjectSummaries() returns ProjectSummary[]|error;

    # Returns detailed representation of the summarized project, if the project exists,the user has
    # permission to view it and if no any error occured.
    # + projectSummary - `ProjectSummary` object
    # + return - A `Project` record if successful, else returns an error
    public remote function getAllDetailsFromProjectSummary(ProjectSummary projectSummary) returns Project|error;

    # Creates a new project. Values available for the assigneeType field are: `PROJECT_LEAD` and `UNASSIGNED`.
    # + newProject - Record which contains the mandatory fields for new project creation
    # + return - A `Project` record which contains detailed representation of the new project
    #            if successful, else returns an error
    public remote function createProject(ProjectRequest newProject) returns Project|error;

    # Updates a project. Only non null values sent in `ProjectRequest` structure will be updated in the project.
    # Values available for the assigneeType field are: `PROJECT_LEAD` and `UNASSIGNED`.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + update - Record which contain fields which need to be updated
    # + return - true if the process is successful, else returns an error
    public remote function updateProject(string projectIdOrKey, ProjectRequest update) returns boolean|error;

    # Deletes a project.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + return - true if the process is successful, else returns an error
    public remote function deleteProject(string projectIdOrKey) returns boolean|error;

    # Returns detailed representation of a project, if the project exists,the user has permission
    # to view it and if no any error occured.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + return - A `Project` record if successful, else returns an error
    public remote function getProject(string projectIdOrKey) returns Project|error;

    # Returns Jira user details of the project lead.
    # + project - `Project` type record
    # + return - A `User` record containing user details of the project lead
    #            if successful, else returns an error
    public remote function getLeadUserDetailsOfProject(Project project) returns User|error;

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
    # + return - A `ProjectRole` record containing the details of the requested role if successful, else
    #            returns an error
    public remote function getRoleDetailsOfProject(Project project, string projectRoleId) returns ProjectRole|error;

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
    # + return - true if the process is successful, else returns an error
    public remote function addUserToRoleOfProject(Project project, string projectRoleId, string userName)
                               returns boolean|error;

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
    # + return - true if the process is successful, else returns an error
    public remote function addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
                               returns boolean|error;

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
    # + return - true if the process is successful, else returns an error
    public remote function removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
                               returns boolean|error;

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
    # + return - true if the process is successful, else returns an error
    public remote function removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
                               returns boolean|error;

    # Gets all issue types with valid status values for a project.
    # + project - `Project` type record
    # + return - An Array of `ProjectStatus` record if successful, else returns an error
    public remote function getAllIssueTypeStatusesOfProject(Project project) returns ProjectStatus[]|error;

    # Updates the type of a Jira project.
    # + project - `Project` type record
    # + newProjectType - New project type for the jira project(`PROJECT_TYPE_SOFTWARE` or `PROJECT_TYPE_BUSINESS`)
    # + return - true if the process is successful, else returns an error
    public remote function changeTypeOfProject(Project project, string newProjectType)
                               returns boolean|error;

    # Creates a new project component.
    # + newProjectComponent - Record which contains the mandatory fields for new project component creation
    # + return - A `ProjectComponent` record which contains the created project component if successful,
    #            else returns an error
    public remote function createProjectComponent(ProjectComponentRequest newProjectComponent)
                               returns ProjectComponent|error;

    # Returns detailed representation of project component.
    # + componentId - string which contains a unique id for a given component.
    # + return - A `ProjectComponent` record if successful, else returns an error
    public remote function getProjectComponent(string componentId) returns ProjectComponent|error;

    # Deletes a project component.
    # + componentId - string which contains a unique id for a given component
    # + return - true if the process is successful, else returns an error
    public remote function deleteProjectComponent(string componentId) returns boolean|error;

    # Returns jira user details of the assignee of the project component.
    # + projectComponent - `ProjectComponent` type record
    # + return - A `User` record containing user details of the assignee if successful, else returns an error
    public remote function getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
                               returns User|error;

    # Returns jira user details of the lead of the project component.
    # + projectComponent - `ProjectComponent` type record
    # + return - A `User` record containing user details of the lead if successful, else returns an error
    public remote function getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent) returns User|error;

    # Returns all existing project categories.
    # + return - An Array of `ProjectCategory` objects if successful, else returns an error
    public remote function getAllProjectCategories() returns ProjectCategory[]|error;

    # Returns a detailed representation of a project category.
    # + projectCategoryId - Jira id of the project category
    # + return -  A `ProjectCategory` record if successful, else returns an error
    public remote function getProjectCategory(string projectCategoryId) returns ProjectCategory|error;

    # Create a new project category.
    # + newCategory - Record which contains the mandatory fields for new project category creation
    # + return - A `ProjectCategory` record if successful, else returns an error
    public remote function createProjectCategory(ProjectCategoryRequest newCategory) returns ProjectCategory|error;

    # Delete a project category.
    # + projectCategoryId - Jira id of the project category
    # + return - true if the process is successful, else returns an error
    public remote function deleteProjectCategory(string projectCategoryId) returns boolean|error;

    # Returns a detailed representation of a jira issue.
    # + issueIdOrKey - Id or key of the required issue
    # + return -  A `Issue` record if successful, else returns an error
    public remote function getIssue(string issueIdOrKey) returns Issue|error;

    # Creates a new jira issue.
    # + newIssue - Record which contains the mandatory fields for new issue creation
    # + return - A `Issue` record if successful, else returns an error
    public remote function createIssue(IssueRequest newIssue) returns Issue|error;
    # Deletes a jira issue.
    # + issueIdOrKey - Id or key of the issue
    # + return - true if the process is successful, else returns an error
    public remote function deleteIssue(string issueIdOrKey) returns boolean|error;

    # Adds a comment to a Jira Issue.
    # + issueIdOrKey - Id or key of the issue
    # + comment - The details of the comment to be added
    # + return - true if the process is successful, else returns an error
    public remote function addCommentToIssue(string issueIdOrKey, IssueComment comment) returns boolean|error;
};

# Represents the Jira Client Connector Endpoint configuration.
# + clientConfig - HTTP client endpoint configuration
# + baseUrl - The Jira API URL
public type JiraConfiguration record {
    string baseUrl;
    http:ClientEndpointConfig clientConfig;
};


public remote function Client.getAllProjectSummaries() returns ProjectSummary[]|error {

    ProjectSummary[] projects = [];

    var httpResponseOut = self.jiraClient->get("/project?expand=description");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var jsonResponseArrayOut = <json[]>jsonResponseOut;
        if (jsonResponseArrayOut.length() == 0) {
            error err = error(JIRA_ERROR_CODE, { message: "Error: server response doesn't contain any projects." });
            return err;
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

public remote function Client.getAllDetailsFromProjectSummary(ProjectSummary projectSummary) returns Project|error {

    var httpResponseOut = self.jiraClient->get("/project/" + projectSummary.key);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is json) {
        jsonResponseOut.leadName = jsonResponseOut.lead != null ? jsonResponseOut.lead.name != null ?
        jsonResponseOut.lead.name : null : null;
        return convertJsonToProject(jsonResponseOut);
    } else {
        return jsonResponseOut;
    }
}

public remote function Client.createProject(ProjectRequest newProject) returns Project|error {

    http:Request outRequest = new;

    var jsonPayloadOut = json.convert(newProject);
    if (jsonPayloadOut is error) {
        error err = error(CONVERSION_ERROR_CODE, { cause: jsonPayloadOut,
            message: "Error occurred while doing json conversion." });
        return jsonPayloadOut;
    } else {
        outRequest.setJsonPayload(jsonPayloadOut);

        var httpResponseOut = self.jiraClient->post("/project", outRequest);
        //Evaluate http response for connection and server errors
        var jsonResponseOut = getValidatedResponse(httpResponseOut);

        if (jsonResponseOut is error) {
            return jsonResponseOut;
        } else {
            var projectOut = self->getProject(untaint jsonResponseOut.key.toString());
            return projectOut;
        }
    }
}

public remote function Client.updateProject(string projectIdOrKey, ProjectRequest update) returns boolean|error {

    http:Request outRequest = new;

    json jsonPayload;
    jsonPayload = projectRequestToJson(update);
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->put("/project/" + projectIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.deleteProject(string projectIdOrKey) returns boolean|error {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/project/" + projectIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.getProject(string projectIdOrKey) returns Project|error {

    var httpResponseOut = self.jiraClient->get("/project/" + projectIdOrKey);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        jsonResponseOut.leadName = jsonResponseOut.lead != null ? jsonResponseOut.lead.name != null ?
        jsonResponseOut.lead.name : null : null;
        var projectOut = convertJsonToProject(jsonResponseOut);
        if (projectOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: projectOut,
                message: "Error occurred while doing json conversion." });
            return err;
        } else {
            return projectOut;
        }
    }
}

public remote function Client.getLeadUserDetailsOfProject(Project project) returns User|error {

    var httpResponseOut = self.jiraClient->get("/user?username=" + project.leadName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var userOut = convertJsonToUser(jsonResponseOut);
        if (userOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: userOut,
                message: "Error occurred while doing json conversion." });
            return err;
        } else {
            return userOut;
        }
    }
}

public remote function Client.getRoleDetailsOfProject(Project project, string projectRoleId)
    returns ProjectRole|error {

    var httpResponseOut = self.jiraClient->get("/project/" + project.key + "/role/" + projectRoleId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var projectRoleOut = convertJsonToProjectRole(jsonResponseOut);
        if (projectRoleOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: projectRoleOut,
                message: "Error occurred while doing json conversion." });
            return err;
        } else {
            return projectRoleOut;
        }
    }
}

public remote function Client.addUserToRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|error {

    http:Request outRequest = new;

    json jsonPayload = { "user": [userName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/project/" + project.key + "/role/" + projectRoleId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|error {

    http:Request outRequest = new;

    json jsonPayload = { "group": [groupName] };
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/project/" + project.key + "/role/" + projectRoleId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|error {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/project/" + project.key + "/role/" +
    projectRoleId + "?user=" + userName, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|error {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/project/" + project.key + "/role/" +
    projectRoleId + "?group=" + groupName, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.getAllIssueTypeStatusesOfProject(Project project) returns ProjectStatus[]|error {

    var httpResponseOut = self.jiraClient->get("/project/" + project.key + "/statuses");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var jsonResponseArrayOut = json[].convert(jsonResponseOut);
        if (jsonResponseArrayOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: jsonResponseArrayOut,
                message: "Error occurred while doing json array conversion." });
            return err;
        } else {
            ProjectStatus[] statusArray = [];
            int i = 0;
            foreach var status in jsonResponseArrayOut {
                var statusOut = convertJsonToProjectStatus(status);
                if (statusOut is error) {
                    error err = error(CONVERSION_ERROR_CODE, { cause: statusOut,
                        message: "Error occurred while doing json conversion." });
                    return err;
                } else {
                    statusArray[i] = statusOut;
                    i += 1;
                }
            }
            return statusArray;
        }
    }
}

public remote function Client.changeTypeOfProject(Project project, string newProjectType) returns boolean|error {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->put("/project/" + project.key + "/type/" + newProjectType, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.createProjectComponent(ProjectComponentRequest newProjectComponent)
                                  returns ProjectComponent|error {

    http:Request outRequest = new;

    var jsonPayloadOut = json.convert(newProjectComponent);
    if (jsonPayloadOut is error) {
        error err = error(CONVERSION_ERROR_CODE, { cause: jsonPayloadOut,
            message: "Error occurred while doing json conversion." });
        return err;
    } else {
        outRequest.setJsonPayload(jsonPayloadOut);

        var httpResponseOut = self.jiraClient->post("/component/", outRequest);
        //Evaluate http response for connection and server errors
        var jsonResponseOut = getValidatedResponse(httpResponseOut);
        if (jsonResponseOut is error) {
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

public remote function Client.getProjectComponent(string componentId) returns ProjectComponent|error {

    var httpResponseOut = self.jiraClient->get("/component/" + componentId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        ProjectComponent component = jsonToProjectComponent(jsonResponseOut);
        return component;
    }
}

public remote function Client.deleteProjectComponent(string componentId) returns boolean|error {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/component/" + componentId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|error {

    var httpResponseOut = self.jiraClient->get("/user?username=" + projectComponent.assigneeName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var userOut = convertJsonToUser(jsonResponseOut);
        if (userOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: userOut,
                message: "Error occurred while doing json conversion." });
            return err;
        } else {
            return userOut;
        }
    }
}

public remote function Client.getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|error {

    var httpResponseOut = self.jiraClient->get("/user?username=" + projectComponent.leadName);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var userOut = convertJsonToUser(jsonResponseOut);
        if (userOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: userOut,
                message: "Error occurred while doing json conversion." });
            return err;
        } else {
            return userOut;
        }
    }
}

public remote function Client.getAllProjectCategories() returns ProjectCategory[]|error {

    var httpResponseOut = self.jiraClient->get("/projectCategory");
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var jsonResponseArrayOut = json[].convert(jsonResponseOut);

        if (jsonResponseArrayOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: jsonResponseArrayOut,
                message: "Error occurred while doing json conversion." });
            return err;
        } else {
            ProjectCategory[] projectCategories = [];
            int i = 0;
            foreach json jsonProjectCategory in jsonResponseArrayOut {
                var projectCategoryOut = convertJsonToProjectCategory(jsonProjectCategory);
                if (projectCategoryOut is error) {
                    error err = error(CONVERSION_ERROR_CODE, { cause: projectCategoryOut,
                        message: "Error occurred while doing json conversion." });
                    return err;
                } else {
                    projectCategories[i] = projectCategoryOut;
                    i += 1;
                }
                return projectCategories;
            }
        }
    }
}

public remote function Client.getProjectCategory(string projectCategoryId) returns ProjectCategory|error {
    var httpResponseOut = self.jiraClient->get("/projectCategory/" + projectCategoryId);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var projectCategoryOut = convertJsonToProjectCategory(jsonResponseOut);
        if (projectCategoryOut is error) {
            error err = error(CONVERSION_ERROR_CODE, { cause: projectCategoryOut,
                message: "Error occurred while doing json conversion." });
            return err;
        } else {
            return projectCategoryOut;
        }
    }
}

public remote function Client.createProjectCategory(ProjectCategoryRequest newCategory) returns ProjectCategory|error {

    http:Request outRequest = new;

    var jsonPayloadOut = json.convert(newCategory);
    if (jsonPayloadOut is error) {
        error err = error(CONVERSION_ERROR_CODE, { cause: jsonPayloadOut,
            message: "Error occurred while doing json conversion." });
        return err;
    } else {
        outRequest.setJsonPayload(jsonPayloadOut);

        var httpResponseOut = self.jiraClient->post("/projectCategory", outRequest);
        //Evaluate http response for connection and server errors
        var jsonResponseOut = getValidatedResponse(httpResponseOut);
        if (jsonResponseOut is error) {
            return jsonResponseOut;
        } else {
            var ProjectCategoryOut = self->getProjectCategory(untaint jsonResponseOut.id.toString());
            return ProjectCategoryOut;
        }
    }
}

public remote function Client.deleteProjectCategory(string projectCategoryId) returns boolean|error {

    http:Request outRequest = new;
    var httpResponseOut = self.jiraClient->delete("/projectCategory/" + projectCategoryId, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.getIssue(string issueIdOrKey) returns Issue|error {

    string getParams = "/issue/" + issueIdOrKey;
    log:printDebug("GET : " + getParams);

    var httpResponseOut = self.jiraClient->get(getParams);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return jsonToIssue(jsonResponseOut);
    }
}


public remote function Client.createIssue(IssueRequest newIssue) returns Issue|error {

    http:Request outRequest = new;

    json jsonPayload = issueRequestToJson(newIssue);
    log:printDebug("CreateIssue payload: " + jsonPayload.toString());
    outRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/issue", outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        var issueOut = self->getIssue(untaint jsonResponseOut.key.toString());
        return issueOut;
    }
}

public remote function Client.deleteIssue(string issueIdOrKey) returns boolean|error {

    http:Request outRequest = new;

    var httpResponseOut = self.jiraClient->delete("/issue/" + issueIdOrKey, outRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}

public remote function Client.addCommentToIssue(string issueIdOrKey, IssueComment comment) returns boolean|error {

    http:Request commentRequest = new;

    json jsonPayload = {};
    jsonPayload.body = comment.body;
    commentRequest.setJsonPayload(jsonPayload);

    var httpResponseOut = self.jiraClient->post("/issue/" + issueIdOrKey +"/comment", commentRequest);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    if (jsonResponseOut is error) {
        return jsonResponseOut;
    } else {
        return true;
    }
}