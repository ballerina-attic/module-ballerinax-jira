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
import ballerina.config;
import ballerina.mime;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Functions                                                        //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@Description {value:"Add authoriaztion header to the request"}
@Param {value:"authType: Authentication type preferred by the user"}
@Param {value:"request: The http out request object"}
public function constructAuthHeader (http:Request request) {

    //read "authentication_type" field from ballerina.conf
    request.addHeader("Authorization", "Basic " + base64EncodedString);
}

@Description {value:"Checks whether the http response contains any errors "}
@Param {value:"request: The http response object"}
@Param {value:"connectionError: http response error object"}
public function getValidatedResponse (http:Response response, http:HttpConnectorError connectionError) (json, JiraConnectorError) {

    JiraConnectorError e;
    mime:EntityError err;
    json jsonResponse;

    //checks for any http errors
    if (connectionError != null) {
        e={^"type":"HTTP Error", message:connectionError.message, cause:connectionError.cause};
        return null, e;
    } else if (response.statusCode != STATUS_CODE_OK && response.statusCode != STATUS_CODE_CREATED
               && response.statusCode != STATUS_CODE_NO_CONTENT) {//checks for invalid server responses

        e={^"type":"Server Error", message:"status " + <string>response.statusCode + ": " + response.reasonPhrase };

        jsonResponse,err = response.getJsonPayload();
        e.jiraServerErrorLog = jsonResponse;
        return null,e;

    } else {//if there is no any http or server error

        jsonResponse, err = response.getJsonPayload();

        return jsonResponse,e;
    }
}


function validateAuthentication (string username, string password) (boolean, JiraConnectorError) {
    endpoint http:ClientEndpoint jiraLoginHttpClientEP {targets:[ {uri:JIRA_BASE_URL}], chunking:http:Chunking.NEVER,

    followRedirects:{ enabled:true,maxCount:5}};

    http:Response response = {};
    http:Request request = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json jsonPayload;

    jsonPayload = {"username": username,"password":password};
                                                   request.setJsonPayload(jsonPayload);
                                                   response, connectionError = jiraLoginHttpClientEP -> post("/jira/rest/auth/1/session", request);


    if(connectionError!=null) {
       e = {^"type":"HTTP Error", message:connectionError.message, cause:connectionError.cause};
    return false, e;
                  } else if (response.statusCode != STATUS_CODE_OK ) {
    e= { ^"type":"Server Error", message:"status " + <string> response.statusCode + ": " + response.reasonPhrase}; jsonResponse,err = response.getJsonPayload(); e.jiraServerErrorLog = jsonResponse;
                                                                                                    return false, e;
    } else{

    return true,e;}
                }



function getProjectRoleIdFromEnum (ProjectRoleType ^"type") (string) {
    if (^"type" == ProjectRoleType.ADMINISTRATORS) {
        return ROLE_ID_ADMINISTRATORS;
    } else if (^"type" == ProjectRoleType.CSAT_ADMINISTRATORS) {
        return ROLE_ID_CSAT_DEVELOPERS;
    } else if (^"type" == ProjectRoleType.DEVELOPERS) {
        return ROLE_ID_DEVELOPERS;
    } else if (^"type" == ProjectRoleType.EXTERNAL_CONSULTANT) {
        return ROLE_ID_EXTERNAL_CONSULTANTS;
    } else if (^"type" == ProjectRoleType.NOTIFICATIONS) {
        return ROLE_ID_NOTIFICATIONS;
    } else if (^"type" == ProjectRoleType.OBSERVER) {
        return ROLE_ID_OBSERVER;
    } else if (^"type" == ProjectRoleType.USERS) {
        return ROLE_ID_USERS;
    } else{
        return null;
    }
}

function getProjectTypeFromEnum (ProjectType projectType) (string) {
    return (projectType == ProjectType.SOFTWARE ? "software" : "business");
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Transformers                                                      //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


transformer <error source, JiraConnectorError target> toConnectorError() {
    target = source != null ? {message:source.message, cause:source.cause} : null;
}

transformer <ProjectRequest source, json target> createJsonProjectRequest() {
    target.key = source.key != null ? (json)source.key : null;
    target.name = source.name != null ? (json)source.name : null;
    target.projectTypeKey = source.projectTypeKey != null ? (json)source.projectTypeKey : null;
    target.projectTemplateKey = source.projectTemplateKey != null ? (json)source.projectTemplateKey : null;
    target.description = source.description != null ? (json)source.description : null;
    target.lead = source.lead != null ? (json)source.lead : null;
    target.url = source.lead != null ? (json)source.url : null;
    target.assigneeType = source.assigneeType != null ? (json)source.assigneeType : null;
    target.avatarId = source.avatarId != null ? (json)source.avatarId : null;
    target.issueSecurityScheme = source.issueSecurityScheme != null ? (json)source.issueSecurityScheme : null;
    target.permissionScheme = source.permissionScheme != null ? (json)source.permissionScheme : null;
    target.notificationScheme = source.notificationScheme != null ? (json)source.notificationScheme : null;
    target.categoryId = source.categoryId != null ? (json)source.categoryId : null;
}

transformer <json source, ProjectSummary target> createProjectSummary() {
    target.self = source.self.toString();
    target.id = source.id.toString();
    target.key = source.key.toString();
    target.name = source.name.toString();
    target.description = source.description != null ? source.description.toString() : null;
    target.projectTypeKey = source.projectTypeKey.toString();
    target.category = source.projectCategory != null ? source.projectCategory.name.toString() : null;
}

transformer <json source, ProjectCategory target> createProjectCategory() {
    target.self = source.self != null ? source.self.toString() : null;
    target.name = source.name != null ? source.name.toString() : null;
    target.id = source.id != null ? source.id.toString() : null;
    target.description = source.description != null ? source.description.toString() : null;
}



