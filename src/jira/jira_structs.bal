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

package src.jira;
import ballerina.net.http;

http:HttpClient jiraHttpClient = create http:HttpClient(JIRA_REST_API_ENDPOINT, getHttpConfigs());
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                               Jira Project                                                         //
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
public function <Project project> getProjectLeadUserDetails () (User, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    json jsonResponse;
    error err;
    User lead;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(request);
    response, connectionError = jiraClient.get("/user?username=" + project.leadName, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    lead, err = <User>jsonResponse;
    e = <JiraConnectorError, toConnectorError()>err;
    return lead, e;

}

@Description {value:"Returns detailed reprensentation of a given project role(ie:Developers,Administrators etc.)"}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Return {value:"ProjectRole: structure containing the details of the requested role"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> getRoleDetails (ProjectRoleType projectRoleType) (ProjectRole, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    json jsonResponse;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(request);
    response, connectionError = jiraClient.get("/project/" + project.key + "/role/" +
                                               getProjectRoleIdFromEnum(projectRoleType), request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    var role, err = <ProjectRole>jsonResponse;
    if (err != null) {
        e = <JiraConnectorError, toConnectorError()>err;
        return null, e;
    }
    return role, e;

}

@Description {value:"assign an user to a project role."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"userName: name of the user to be added"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> addUserToRole (ProjectRoleType projectRoleType,
                                                 string userName) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonPayload;
    json jsonResponse;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure: Project", cause:null};
        return false, e;
    }

    jsonPayload = {user:[userName]};
    request.setJsonPayload(jsonPayload);
    response, connectionError = jiraClient.post("/project/" + project.key + "/role/" +
                                                getProjectRoleIdFromEnum(projectRoleType), request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }

    return true, null;

}

@Description {value:"assign a group to a project role."}
@Param {value:"projectRoleType: Enum which provides the possible project roles for a jira project"}
@Param {value:"groupName: name of the group to be added"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> addGroupToRole (ProjectRoleType projectRoleType,
                                                  string groupName) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonPayload;
    json jsonResponse;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure: Project", cause:null};
        return false, e;
    }

    jsonPayload = {group:[groupName]};
    request.setJsonPayload(jsonPayload);
    response, connectionError = jiraClient.post("/project/" + project.key + "/role/" +
                                                getProjectRoleIdFromEnum(projectRoleType), request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }

    return true, null;


}

@Description {value:"removes a given user from a given project role."}
@Param {value:"projectRoleype: Enum which provides the possible project roles for a jira project"}
@Param {value:"userName: name of the user required to be removed"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> removeUserFromRole (ProjectRoleType projectRoleType, string userName) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonResponse;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure: Project", cause:null};
        return false, e;
    }
    if (projectRoleType == null) {
        e = {message:"Unable to proceed with a null structure: ProjectRoleType", cause:null};
        return false, e;
    }

    constructAuthHeader(request);

    response, connectionError = jiraClient.delete("/project/" + project.key + "/role/" +
                                                  getProjectRoleIdFromEnum(projectRoleType) + "?user=" + userName, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }

    return true, null;

}

@Description {value:"removes a given group from a given project role."}
@Param {value:"projectRoleype: Enum which provides the possible project roles for a jira project"}
@Param {value:"groupName: name of the user required to be removed"}
@Return {value:"Returns true if process was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> removeGroupFromRole (ProjectRoleType projectRoleType, string groupName) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonResponse;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure: Project", cause:null};
        return false, e;
    }
    else if (projectRoleType == null) {
        e = {message:"Unable to proceed with a null structure: ProjectRoleType", cause:null};
        return false, e;
    }

    constructAuthHeader(request);

    response, connectionError = jiraClient.delete("/project/" + project.key + "/role/" +
                                                  getProjectRoleIdFromEnum(projectRoleType) + "?group=" + groupName, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }

    return true, null;

}

@Description {value:"Gets all issue types with valid status values for a project."}
@Return {value:"ProjectStatus[]: array of project status structures"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> getAllIssueTypeStatuses () (ProjectStatus[], JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json[] jsonResponseArray;
    ProjectStatus[] statusArray = [];

    if (project == null) {
        e = {message:"Unable to proceed with a null structure: Project", cause:null};
        return null, e;
    }

    constructAuthHeader(request);
    response, connectionError = jiraClient.get("/project/" + project.key + "/statuses", request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }


    jsonResponseArray, err = (json[])jsonResponse;
    if (err != null) {
        e = <JiraConnectorError, toConnectorError()>err;
        return null, e;
    }

    int i = 0;
    foreach (status in jsonResponseArray) {
        statusArray[i], err = <ProjectStatus>status;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }
        i = i + 1;

    }

    return statusArray, null;



}

@Description {value:"Updates the type of a jira project."}
@Param {value:"newProjectType: Enum which provides the possible project types for a jira project"}
@Return {value:"Returns true if update was successfull,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <Project project> changeProjectType (ProjectType newProjectType) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    json jsonResponse;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure: Project", cause:null};
        return false, e;
    }
    if (newProjectType == null) {
        e = {message:"Unable to proceed with a null structure: ProjectType", cause:null};
        return false, e;
    }

    constructAuthHeader(request);

    response, connectionError = jiraClient.put("/project/" + project.key + "/type/" + getProjectTypeFromEnum(newProjectType), request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }

    return true, null;

}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                           Project Components                                                       //
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
public function <ProjectComponentSummary projectComponentSummary> getAllDetails () (ProjectComponent, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;


    if (projectComponentSummary == null) {
        e = {message:"Unable to proceed with a null structure: ProjectComponentSummary", cause:null};
        return null, e;
    }

    constructAuthHeader(request);
    response, connectionError = jiraClient.get("/component/" + projectComponentSummary.id, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    else {
        try {
            jsonResponse["leadName"] = jsonResponse["lead"]["name"];
            jsonResponse["assigneeName"] = jsonResponse["assignee"]["name"];
            jsonResponse["realAssigneeName"] = jsonResponse["realAssignee"]["name"];
        }
        catch (error er) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }

        var projectComponent, err = <ProjectComponent>jsonResponse;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }
        return projectComponent, e;
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
public function <ProjectComponent projectComponent> getLeadUserDetails () (User, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;

    if (projectComponent == null) {
        e = {message:"Unable to proceed with a null structure: ProjectComponent", cause:null};
        return null, e;
    }

    constructAuthHeader(request);
    response, connectionError = jiraClient.get("/user?username=" + projectComponent.leadName, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    var lead, err = <User>jsonResponse;
    e = <JiraConnectorError, toConnectorError()>err;
    return lead, e;

}

@Description {value:"returns jira user details of the project component assignee"}
@Return {value:"User: structure containing user details of the lead "}
@Return {value:"JiraConnectorError: Error Object"}
public function <ProjectComponent projectComponent> getAssigneeUserDetails () (User, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        jiraHttpClient;
    }
    http:HttpConnectorError connectionError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;

    if (projectComponent == null) {
        e = {message:"Unable to proceed with a null structure: ProjectComponent", cause:null};
        return null, e;
    }

    constructAuthHeader(request);
    response, connectionError = jiraClient.get("/user?username=" + projectComponent.assigneeName, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    var lead, err = <User>jsonResponse;
    e = <JiraConnectorError, toConnectorError()>err;
    return lead, e;

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct Issue{

}

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
    string |type|;
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
    ActorType |type|;
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
    string |16x16|;
    string |24x24|;
    string |32x32|;
    string |48x48|;
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
    string |type|;
    string message;
    json jiraServerErrorLog;
    error cause;
}







