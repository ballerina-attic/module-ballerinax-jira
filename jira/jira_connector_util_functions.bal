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
import ballerina/config;
import ballerina/mime;
import ballerina/io;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Functions                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@Description {value:"Add authoriaztion header to the request"}
@Param {value:"authType: Authentication type preferred by the user"}
@Param {value:"request: The http out request object"}
function constructAuthHeader (http:Request request, string encodedCredentials) {

    if (encodedCredentials != "") {
        request.addHeader("Authorization", "Basic " + encodedCredentials);
    }
}

@Description {value:"Checks whether the http response contains any errors "}
@Param {value:"httpConnectorResponse: The http response object"}
@Param {value:"connectionError: http response error object"}
@Return {value:"Returns the json Payload of the server response if there is no any http or server error.
Otherwise returns a 'JiraConnecorError'."}
function getValidatedResponse (http:Response|http:HttpConnectorError httpConnectorResponse)
returns json|JiraConnectorError {
    JiraConnectorError e = {};
    mime:EntityError err = {};
    json jsonResponse;
    //checks for any http errors
    match httpConnectorResponse {
        http:HttpConnectorError connectionError => {
            e = {^"type":"Connection Error", message:connectionError.message, cause:connectionError.cause};
            return e;
        }
        http:Response response => {
            if (response.statusCode != STATUS_CODE_OK && response.statusCode != STATUS_CODE_CREATED
                && response.statusCode != STATUS_CODE_NO_CONTENT) {//checks for invalid server responses
                e = {^"type":"Server Error", message:"status " + <string>response.statusCode + ": " +
                                                                         response.reasonPhrase};
                var payloadOutput = response.getJsonPayload();
                match payloadOutput {
                    json jsonOutput => e.jiraServerErrorLog = jsonOutput;
                    mime:EntityError errorOut => err = errorOut;
                }
                return e;

            } else {//if there is no any http or server error
                var payloadOutput = response.getJsonPayload();
                match payloadOutput {
                    json jsonOutput => jsonResponse = jsonOutput;
                    mime:EntityError errorOut => err = errorOut;
                }
                return jsonResponse;
            }
        }
    }
}

@Description {value:" validates jira account credentials given by the by the user and returns an error if the
login fails due to invalid credentials or if the login is denied due to a CAPTCHA requirement, throtting,
or any other reasons."}
@Param {value:"username: jira account username."}
@Param {value:"password:jira account password."}
@Return {value:"boolean: returns true if the process is successful."}
@Return {value:"JiraConnectorError: 'JiraConnectorError' object."}
function validateAuthentication (string username, string password) returns boolean|JiraConnectorError {
    //Initializes jira authentication endpoint
    endpoint http:ClientEndpoint jiraLoginHttpClientEP {
        targets:[{uri:WSO2_STAGING_JIRA_BASE_URL + JIRA_AUTH_RESOURCE}],
        chunking:http:Chunking.NEVER
    };

    JiraConnectorError e = {};
    error err = {};
    mime:EntityError errr = {};
    json jsonResponse;
    json jsonPayload;
    http:Request request = {};

    jsonPayload = {"username":username, "password":password};
    request.setJsonPayload(jsonPayload);

    var output = jiraLoginHttpClientEP -> post("/", request);
    match output {
        http:HttpConnectorError connectionError => {
            e = {^"type":"Connection Error", message:connectionError.message, cause:connectionError.cause};
            return e;
        }

        http:Response response => {
            if (response.statusCode != STATUS_CODE_OK) {
                e = {^"type":"Server Error", message:"status " + <string>response.statusCode +
                                                                         ": " + response.reasonPhrase};
                var payloadOutput = response.getJsonPayload();
                match payloadOutput {
                    json jsonOutput => e.jiraServerErrorLog = jsonOutput;
                    mime:EntityError errorOut => errr = {};
                }
                return e;
            } else {
                return true;
            }
        }
    }
}

@Description {value:"Returns id of a given project role."}
@Param {value:"roleType: Project role type defined by the enum 'ProjectRoleType'."}
@Param {value:"Id of the project role."}
function getProjectRoleIdFromEnum (ProjectRoleType roleType) returns string {
    if (roleType == ProjectRoleType.ADMINISTRATORS) {
        return ROLE_ID_ADMINISTRATORS;
    } else if (roleType == ProjectRoleType.CSAT_ADMINISTRATORS) {
        return ROLE_ID_CSAT_DEVELOPERS;
    } else if (roleType == ProjectRoleType.DEVELOPERS) {
        return ROLE_ID_DEVELOPERS;
    } else if (roleType == ProjectRoleType.EXTERNAL_CONSULTANT) {
        return ROLE_ID_EXTERNAL_CONSULTANTS;
    } else if (roleType == ProjectRoleType.NOTIFICATIONS) {
        return ROLE_ID_NOTIFICATIONS;
    } else if (roleType == ProjectRoleType.OBSERVER) {
        return ROLE_ID_OBSERVER;
    } else if (roleType == ProjectRoleType.USERS) {
        return ROLE_ID_USERS;
    } else {
        return "";
    }
}

@Description {value:"Returns project type as string using the 'ProjectType' enum."}
function getProjectTypeFromEnum (ProjectType projectType) returns string {
    return (projectType == ProjectType.SOFTWARE ? "software" : "business");
}

@Description {value:"Returns whether a given error object is empty."}
public function isEmpty (error|JiraConnectorError e) returns boolean {
    match e {
        error err => return err.message == "";
        JiraConnectorError err => return err.message == "";
    }
}

function errorToJiraConnectorError (error source) returns JiraConnectorError {
    JiraConnectorError target = source.message != "" ? {message:source.message, cause:source.cause} : {};
    return target;
}

function projectRequestToJson (ProjectRequest source) returns json {

    json target = {};

    target.key = source.key != "" ? source.key : null;
    target.name = source.name != "" ? source.name : null;
    target.projectTypeKey = source.projectTypeKey != "" ? source.projectTypeKey : null;
    target.projectTemplateKey = source.projectTemplateKey != "" ? source.projectTemplateKey : null;
    target.description = source.description != "" ? source.description : null;
    target.lead = source.lead != "" ? source.lead : null;
    target.url = source.url != "" ? source.url : null;
    target.assigneeType = source.assigneeType != "" ? source.assigneeType : null;
    target.avatarId = source.avatarId != "" ? source.avatarId : null;
    target.issueSecurityScheme = source.issueSecurityScheme != "" ? source.issueSecurityScheme : null;
    target.permissionScheme = source.permissionScheme != "" ? source.permissionScheme : null;
    target.notificationScheme = source.notificationScheme != "" ? source.notificationScheme : null;
    target.categoryId = source.categoryId != "" ? source.categoryId : null;

    return target;
}

function jsonToProjectSummary (json source) returns ProjectSummary {

    ProjectSummary target = {};

    target.self = source.self.toString();
    target.id = source.id.toString();
    target.key = source.key.toString();
    target.name = source.name.toString();
    target.description = source.description != null ? source.description.toString() : "";
    target.projectTypeKey = source.projectTypeKey.toString();
    target.category = source.projectCategory != null ? source.projectCategory.name.toString() : "";

    return target;
}

function jsonToProjectCategory(json source) returns ProjectCategory{

    ProjectCategory target = {};

    target.self = source.self != null ? source.self.toString() : "";
    target.name = source.name != null ? source.name.toString() : "";
    target.id = source.id != null ? source.id.toString() : "";
    target.description = source.description != null ? source.description.toString() : "";

    return target;
}

function jsonToProjectComponent (json source) returns ProjectComponent {

    ProjectComponent target = {};
    target.self = source.self != null ? source.self.toString() : "";
    target.id = source.id != null ? source.id.toString() : "";
    target.name = source.name != null ? source.name.toString() : "";
    target.description = source.description != null ? source.description.toString() : "";
    target.assigneeType = source.assigneeType != null ? source.assigneeType.toString() : "";
    target.realAssigneeType = source.realAssigneeType != null ? source.realAssigneeType.toString() : "";
    target.project = source.project != null ? source.project.toString() : "";
    target.projectId = source.projectId != null ? source.projectId.toString() : "";

    target.leadName = source.lead != null ?
                      source.lead.name != null ?
                      source.lead.name.toString() : "" : "";

    target.assigneeName = source.assignee != null ?
                          source.assignee.name != null ?
                          source.assignee.name.toString() : "" : "";

    target.realAssigneeName = source.realAssignee != null ?
                              source.realAssignee.name != null ?
                              source.realAssignee.name.toString() : "" : "";

    return target;
}