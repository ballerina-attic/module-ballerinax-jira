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
import ballerina/net.http;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                               Jira Project                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ProjectSummary {
    string self;
    string id;
    string key;
    string name;
    string description;
    string category;
    string projectTypeKey;
}

@Description {value:"Returns detailed representation of of the summarized project."}
@Return {value:"Project: Contains a full representation of a project, if the project exists,the user has permission
    to view it and if no any error occured"}
@Return {value:"JiraConnectorError: Error Object"}
public function <ProjectSummary projectSummary> getAllDetails () returns Project|JiraConnectorError {

    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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
                    return <JiraConnectorError, toConnectorError()>err;
                }
                Project project => {
                    return project;
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct Project {
    string self;
    string id;
    string key;
    string name;
    string description;
    string leadName;
    string projectTypeKey;
    AvatarUrls avatarUrls;
    ProjectCategory projectCategory;
    IssueType[] issueTypes;
    ProjectComponentSummary[] components;
    ProjectVersion[] versions;
}

@Description {value:"Returns jira user details of the project lead"}
@Return {value:"User: structure containing user details of the project lead "}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> getLeadUserDetails () returns User|JiraConnectorError {

    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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
                    return <JiraConnectorError, toConnectorError()>err;
                }
                User lead => {
                    return lead;
                }
            }
        }
    }
}

@Description {value:"Returns detailed reprensentation of a given project role(ie:Developers,Administrators etc.)"}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Return {value:"ProjectRole: structure containing the details of the requested role"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> getRoleDetails (ProjectRoleType projectRoleType)
                                                                            returns ProjectRole|JiraConnectorError {
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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
                    return <JiraConnectorError, toConnectorError()>err;
                }
                ProjectRole projectRole => {
                    return projectRole;
                }
            }
        }
    }
}

@Description {value:"assign an user to a project role."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"userName: name of the user to be added"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> addUserToRole (ProjectRoleType projectRoleType, string userName)
                                                                                returns boolean|JiraConnectorError {
    http:Request request = {};

    json jsonPayload = {"user":[userName]};
    request.setJsonPayload(jsonPayload);

    //Adds Authorization Header
    constructAuthHeader(request);
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

@Description {value:"assign a group to a project role."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"groupName: name of the group to be added"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> addGroupToRole (ProjectRoleType projectRoleType,
                                                  string groupName) returns boolean|JiraConnectorError {
    http:Request request = {};

    json jsonPayload = {"group":[groupName]};
    request.setJsonPayload(jsonPayload);

    //Adds Authorization Header
    constructAuthHeader(request);
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
@Param {value:"projectRoleype: Enum which provides the possible project roles for a jira project"}
@Param {value:"userName: name of the user required to be removed"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> removeUserFromRole (ProjectRoleType projectRoleType, string userName)
                                                                                returns boolean|JiraConnectorError {
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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
@Param {value:"projectRoleype: Enum which provides the possible project roles for a jira project"}
@Param {value:"groupName: name of the user required to be removed"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> removeGroupFromRole (ProjectRoleType projectRoleType, string groupName)
                                                                                returns boolean|JiraConnectorError {
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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
@Return {value:"ProjectStatus[]: array of project status structures"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> getAllIssueTypeStatuses () returns ProjectStatus[]|JiraConnectorError {

    http:Request request = {};
    ProjectStatus[] statusArray = [];

    //Adds Authorization Header
    constructAuthHeader(request);
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
                    return <JiraConnectorError, toConnectorError()>err;
                }
                json[] jsonResponseArray => {
                    int i = 0;
                    foreach (status in jsonResponseArray) {
                        var statusOut = <ProjectStatus>status;
                        match statusOut {
                            error err => {
                                return <JiraConnectorError, toConnectorError()>err;
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
@Param {value:"newProjectType: Enum which provides the possible project types for a jira project"}
@Return {value:"Returns true if update was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> changeProjectType (ProjectType newProjectType) returns boolean|JiraConnectorError {

    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                             Project Components                                                     //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ProjectComponentSummary {
    string self;
    string id;
    string name;
    string description;
}

@Description {value:"fetches detailed entity using a given project component summary"}
@Return {value:"ProjectComponent: structure which contains a full representation of the project component"}
@Return {value:"JiraConnectorError: Error Object"}
public function <ProjectComponentSummary projectComponentSummary> getAllDetails ()
                                                                        returns ProjectComponent|JiraConnectorError {
    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> get("/component/" + projectComponentSummary.id, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError e => {
            return e;
        }
        json jsonResponse => {
            jsonResponse["leadName"] = jsonResponse["lead"]["name"];
            jsonResponse["assigneeName"] = jsonResponse["assignee"]["name"];
            jsonResponse["realAssigneeName"] = jsonResponse["realAssignee"]["name"];
            var projectComponentOut = <ProjectComponent>jsonResponse;
            match projectComponentOut {
                error er => {
                    return <JiraConnectorError, toConnectorError()>er;
                }
                ProjectComponent projectComponent => {
                    return projectComponent;
                }
            }
        }
    }
}

public struct ProjectComponent {
    string self;
    string id;
    string name;
    string description;
    string leadName;
    string assigneeName;
    string assigneeType;
    string realAssigneeName;
    string realAssigneeType;
    boolean isAssigneeTypeValid;
    string project;
    string projectId;
}

@Description {value:"returns jira user details of the project component lead"}
@Return {value:"User: structure containing user details of the lead "}
@Return {value:"JiraConnectorError: Error Object"}
public function <ProjectComponent projectComponent> getLeadUserDetails () returns User|JiraConnectorError {

    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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
                    return <JiraConnectorError, toConnectorError()>err;
                }
                User lead => {
                    return lead;
                }
            }
        }
    }
}

@Description {value:"returns jira user details of the project component assignee"}
@Return {value:"User: structure containing user details of the lead "}
@Return {value:"JiraConnectorError: Error Object"}
public function <ProjectComponent projectComponent> getAssigneeUserDetails () returns User|JiraConnectorError {

    http:Request request = {};

    //Adds Authorization Header
    constructAuthHeader(request);
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
                    return <JiraConnectorError, toConnectorError()>err;
                }
                User assignee => {
                    return assignee;
                }
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public struct ProjectCategory {
    string self;
    string id;
    string name;
    string description;
}

public struct ProjectRole {
    string self;
    string name;
    string description;
    Actor[] actors;
}

public struct Actor {
    string id;
    string name;
    string displayName;
    string ^"type";
}

public struct ProjectStatus {
    string self;
    string name;
    string id;
    json statuses;
}

public struct User {
    string self;
    string key;
    string name;
    string displayName;
    string emailAddress;
    json avatarUrls;
    boolean active;
    string timeZone;
    string locale;
}

public struct NewActor {
    ActorType ^"type";
    string name;
}

public struct ProjectCategoryRequest {
    string name;
    string description;
}

public struct ProjectRequest {
    string key;
    string name;
    string projectTypeKey;
    string projectTemplateKey;
    string description;
    string lead;
    string url;
    string assigneeType;
    string avatarId;
    string issueSecurityScheme;
    string permissionScheme;
    string notificationScheme;
    string categoryId;
}

public struct IssueType {
    string self;
    string id;
    string name;
    string description;
    string iconUrl;
    boolean subtask;
}

public struct ProjectVersion {
    string self;
    string id;
    string name;
    boolean archived;
    boolean released;
    string releaseDate;
    boolean overdue;
    string userReleaseDate;
    string projectId;
}

public struct AvatarUrls {
    string ^"16x16";
    string ^"24x24";
    string ^"32x32";
    string ^"48x48";
}

public struct Avatar {
    string id;
    boolean isSystemAvatar;
    boolean isSelected;
    boolean isDeletable;
    AvatarUrls urls;
    boolean selected;
}

public struct JiraConnectorError {
    string ^"type";
    string message;
    json jiraServerErrorLog;
    error[] cause;
}
