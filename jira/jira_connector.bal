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

package jira;

import ballerina/http;
import ballerina/util;
import ballerina/log;
import ballerina/io;

//Jira Connector Struct
public struct JiraConnector {

    http:ClientEndpointConfiguration jiraHttpClientEPConfig;
    string jira_base_url;
    string jira_rest_api_ep;
    string jira_authentication_ep;

    private:
        string base64EncodedCredentials;
        http:ClientEndpoint jiraHttpClientEP;
}

@Description{value:"Encodes user credentials and assigns to a private field in connector."}
function <JiraConnector jiraConnector> setBase64EncodedCredentials(string username,string password) {
    jiraConnector.base64EncodedCredentials = util:base64Encode(username + ":" + password);
}

@Description {value:"Returns an array of all projects summaries which are visible for the currently logged in user,
who has BROWSE, ADMINISTER or PROJECT_ADMIN project permission.
If no user is logged in, it returns the list of projects that are visible when using anonymous access"}
@Return {value:"ProjectSummary[]: Array of 'ProjectSummary' objects."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getAllProjectSummaries () returns ProjectSummary[]|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    ProjectSummary[] projects = [];
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);

    var httpResponseOut = jiraHttpClientEP -> get("/project?expand=description", request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var jsonResponseArrayOut = <json[]>jsonResponse;
            match jsonResponseArrayOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                json[] jsonResponseArray => {
                    if (jsonResponseArray == null) {
                        error err = {message:"Error: server response doesn't contain any projects."};
                        return errorToJiraConnectorError(err);
                    }

                    int i = 0;
                    foreach (jsonProject in jsonResponseArray) {
                        projects[i] = jsonToProjectSummary(jsonProject);
                        i = i + 1;
                    }
                    return projects;
                }
            }
        }
    }
}

@Description {value:"Returns detailed representation of of the summarized project, if the project exists,the user has
permission to view it and if no any error occured."}
@Param {value:"projectSummary: 'ProjectSummary' object."}
@Return {value:"Project: 'Project' object."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getAllDetailsFromProjectSummary (ProjectSummary projectSummary)
returns Project|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/project/" + projectSummary.key, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ?
                                                                jsonResponse.lead.name : null : null;
            var projectOut = <Project>jsonResponse;
            match projectOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                Project project => {
                    return project;
                }
            }
        }
    }
}

@Description {value:"Creates a new project."}
@Param {value:"newProject: struct which contains the mandatory fields for new project creation"}
@Return {value:"Project: 'Project' object which contains detailed representation of the new project."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> createProject (ProjectRequest newProject)
returns Project|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    var jsonPayloadOut = <json>newProject;
    match jsonPayloadOut {
        error err => {
            return errorToJiraConnectorError(err);
        }

        json jsonPayload => {
            request.setJsonPayload(jsonPayload);

            //Adds Authorization Header
            constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
            var httpResponseOut = jiraHttpClientEP -> post("/project", request);
            //Evaluate http response for connection and server errors
            var jsonResponseOut = getValidatedResponse(httpResponseOut);

            match jsonResponseOut {
                JiraConnectorError e => {
                    return e;
                }
                json jsonResponse => {
                    var projectOut = jiraConnector.getProject(jsonResponse.key.toString());
                    match projectOut {
                        Project project => return project;
                        JiraConnectorError e => return e;
                    }
                }
            }
        }
    }
}

@Description {value:"Updates a project. Only non null values sent in 'ProjectRequest' structure will
    be updated in the project. Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Param {value:"update: structure containing fields which need to be updated"}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> updateProject (string projectIdOrKey, ProjectRequest update)
returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    json jsonPayload;
    jsonPayload = projectRequestToJson(update);
    request.setJsonPayload(jsonPayload);

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> put("/project/" + projectIdOrKey, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"Deletes a project."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> deleteProject (string projectIdOrKey) returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> delete("/project/" + projectIdOrKey, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"Returns detailed representation of a project, if the project exists,the user has permission
to view it and if no any error occured."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Return {value:"Project: 'Project' object."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getProject (string projectIdOrKey) returns Project|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/project/" + projectIdOrKey, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ?
                                                                jsonResponse.lead.name : null : null;
            var projectOut = <Project>jsonResponse;
            match projectOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                Project project => {
                    return project;
                }
            }
        }
    }
}

@Description {value:"Returns jira user details of the project lead"}
@Param {value:"project: 'Project' object."}
@Return {value:"User: 'User' structure containing user details of the project lead."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getLeadUserDetailsOfProject (Project project)
returns User|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/user?username=" + project.leadName, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var userOut = <User>jsonResponse;
            match userOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                User lead => {
                    return lead;
                }
            }
        }
    }
}

@Description {value:"Returns detailed reprensentation of a given project role(ie:Developers,Administrators etc.)"}
@Param {value:"project: 'Project' object."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Return {value:"ProjectRole 'ProjectRole' object containing the details of the requested role."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getRoleDetailsOfProject (Project project, ProjectRoleType projectRoleType)
returns ProjectRole|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/project/" + project.key + "/role/" +
                                                  getProjectRoleIdFromEnum(projectRoleType), request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var projectRoleOut = <ProjectRole>jsonResponse;
            match projectRoleOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                ProjectRole projectRole => {
                    return projectRole;
                }
            }
        }
    }
}

@Description {value:"Assigns a user to a given project role."}
@Param {value:"project: 'Project' object."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"userName: name of the user to be added."}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> addUserToRoleOfProject (Project project, ProjectRoleType projectRoleType,
                                                                      string userName) returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    json jsonPayload = {"user":[userName]};
    request.setJsonPayload(jsonPayload);

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> post("/project/" + project.key + "/role/" +
                                                   getProjectRoleIdFromEnum(projectRoleType), request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"Assigns a group to a given project role."}
@Param {value:"project: 'Project' object."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"groupName: name of the group to be added."}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> addGroupToRoleOfProject (
Project project, ProjectRoleType projectRoleType, string groupName) returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    json jsonPayload = {"group":[groupName]};
    request.setJsonPayload(jsonPayload);

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> post("/project/" + project.key + "/role/" +
                                                   getProjectRoleIdFromEnum(projectRoleType), request);

    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"removes a given user from a given project role."}
@Param {value:"project: 'Project' object."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"userName: name of the user required to be removed"}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> removeUserFromRoleOfProject (
Project project, ProjectRoleType projectRoleType, string userName) returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> delete("/project/" + project.key + "/role/" +
                                                     getProjectRoleIdFromEnum(projectRoleType) + "?user=" + userName, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"removes a given group from a given project role."}
@Param {value:"project: 'Project' object."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"groupName: name of the user required to be removed"}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> removeGroupFromRoleOfProject (
Project project, ProjectRoleType projectRoleType, string groupName) returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> delete("/project/" + project.key + "/role/" +
                                                     getProjectRoleIdFromEnum(projectRoleType) + "?group=" + groupName, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"Gets all issue types with valid status values for a project."}
@Param {value:"project: 'Project' object."}
@Return {value:"ProjectStatus[]: Array of 'ProjectStatus' objects."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getAllIssueTypeStatusesOfProject (Project project)
returns ProjectStatus[]|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};
    ProjectStatus[] statusArray = [];

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/project/" + project.key + "/statuses", request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var jsonResponseArrayOut = <json[]>jsonResponse;
            match jsonResponseArrayOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                json[] jsonResponseArray => {
                    int i = 0;
                    foreach (status in jsonResponseArray) {
                        var statusOut = <ProjectStatus>status;
                        match statusOut {
                            error err => {
                                return errorToJiraConnectorError(err);
                            }
                            ProjectStatus projectStatus => {
                                statusArray[i] = projectStatus;
                                i = i + 1;
                            }
                        }
                    }
                    return statusArray;
                }
            }
        }
    }
}

@Description {value:"Updates the type of a jira project."}
@Param {value:"project: 'Project' object."}
@Param {value:"newProjectType: Enum which provides the possible project types for a jira project"}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> changeTypeOfProject (Project project, ProjectType newProjectType)
returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> put("/project/" + project.key + "/type/" +
                                                  getProjectTypeFromEnum(newProjectType), request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"Creates a new project component."}
@Param {value:"newProjectComponent: struct which contains the mandatory fields for new project component creation"}
@Return {value:"ProjectComponent: 'ProjectComponent' object which contains the created project component."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> createProjectComponent (ProjectComponentRequest newProjectComponent)
returns ProjectComponent|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    var jsonPayloadOut = <json>newProjectComponent;
    match jsonPayloadOut {
        error err => {
            return errorToJiraConnectorError(err);
        }

        json jsonPayload => {
            request.setJsonPayload(jsonPayload);

            //Adds Authorization Header
            constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
            var httpResponseOut = jiraHttpClientEP -> post("/component/", request);
            //Evaluate http response for connection and server errors
            var jsonResponseOut = getValidatedResponse(httpResponseOut);
            match jsonResponseOut {
                JiraConnectorError e => {
                    return e;
                }
                json jsonResponse => {
                    var projectComponentOut = jiraConnector.getProjectComponent(jsonResponse.id.toString());
                    match projectComponentOut {
                        ProjectComponent projectComponent => return projectComponent;
                        JiraConnectorError e => return e;
                    }
                }
            }
        }
    }
}

@Description {value:"Returns detailed representation of project component."}
@Param {value:"componentId: string which contains a unique id for a given component."}
@Return {value:"ProjectComponent: 'ProjectComponent' object containing a full representation of the project component."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getProjectComponent (string componentId)
returns ProjectComponent|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/component/" + componentId, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            ProjectComponent component = jsonToProjectComponent(jsonResponse);
            return component;
        }
    }
}


@Description {value:"Deletes a project component."}
@Param {value:"projectComponentId: String which contains unique id of the project component"}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> deleteProjectComponent (string projectComponentId)
returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> delete("/component/" + projectComponentId, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}


@Description {value:"Returns jira user details of the assignee of the project component."}
@Return {value:"ProjectComponent: 'ProjectComponent' object."}
@Return {value:"User: 'User' object containing user details of the lead."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getAssigneeUserDetailsOfProjectComponent (ProjectComponent projectComponent) returns User|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/user?username=" + projectComponent.assigneeName, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var userOut = <User>jsonResponse;
            match userOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                User assignee => {
                    return assignee;
                }
            }
        }
    }
}

@Description {value:"Returns jira user details of the project component lead."}
@Return {value:"ProjectComponent: 'ProjectComponent' object."}
@Return {value:"User: 'User' object containing user details of the lead."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getLeadUserDetailsOfProjectComponent (ProjectComponent projectComponent)
returns User|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/user?username=" + projectComponent.leadName, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var userOut = <User>jsonResponse;
            match userOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }
                User lead => {
                    return lead;
                }
            }
        }
    }
}

@Description {value:"Returns all existing project categories"}
@Return {value:"Array of 'ProjectCategory' objects."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getAllProjectCategories () returns ProjectCategory[]|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};
    ProjectCategory[] projectCategories = [];

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/projectCategory", request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var jsonResponseArrayOut = <json[]>jsonResponse;
            match jsonResponseArrayOut {
                error err => {
                    return errorToJiraConnectorError(err);
                }

                json[] jsonResponseArray => {
                    int i = 0;
                    foreach (jsonProjectCategory in jsonResponseArray) {
                        var projectCategoryOut = <ProjectCategory>jsonProjectCategory;
                        match projectCategoryOut {
                            error err => return errorToJiraConnectorError(err);

                            ProjectCategory projectCategory => {
                                projectCategories[i] = projectCategory;
                                i = i + 1;
                            }
                        }
                    }
                    return projectCategories;
                }
            }
        }
    }
}

@Description {value:"Returns a detailed representation of a project category."}
@Param {value:"projectCategoryId: Jira id of the project category"}
@Return {value:"ProjectCategory: 'ProjectCategory' object."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> getProjectCategory (string projectCategoryId)
returns ProjectCategory|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> get("/projectCategory/" + projectCategoryId, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            var projectCategoryOut = <ProjectCategory>jsonResponse;
            match projectCategoryOut {
                error err => return errorToJiraConnectorError(err);
                ProjectCategory category => return category;
            }
        }
    }
}

@Description {value:"Create a new project category"}
@Param {value:"newCategory: struct which contains the mandatory fields for new project category creation "}
@Return {value:"ProjectCategory: 'ProjectCategory' object."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> createProjectCategory (ProjectCategoryRequest newCategory)
returns ProjectCategory|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    var jsonPayloadOut = <json>newCategory;
    match jsonPayloadOut {
        error err => {
            return errorToJiraConnectorError(err);
        }
        json jsonPayload => {
            request.setJsonPayload(jsonPayload);

            //Adds Authorization Header
            constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
            var httpResponseOut = jiraHttpClientEP -> post("/projectCategory", request);
            //Evaluate http response for connection and server errors
            var jsonResponseOut = getValidatedResponse(httpResponseOut);

            match jsonResponseOut {
                JiraConnectorError e => {
                    return e;
                }
                json jsonResponse => {
                    var ProjectCategoryOut = jiraConnector.getProjectCategory(jsonResponse.id.toString());
                    match ProjectCategoryOut {
                        ProjectCategory category => return category;
                        JiraConnectorError e => return e;
                    }
                }
            }
        }
    }
}

@Description {value:"Delete a project category."}
@Param {value:"projectCategoryId: Jira id of the project category."}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
public function <JiraConnector jiraConnector> deleteProjectCategory (string projectCategoryId)
returns boolean|JiraConnectorError {

    endpoint http:ClientEndpoint jiraHttpClientEP = jiraConnector.jiraHttpClientEP;
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request, jiraConnector.base64EncodedCredentials);
    var httpResponseOut = jiraHttpClientEP -> delete("/projectCategory/" + projectCategoryId, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            return true;
        }
    }
}
