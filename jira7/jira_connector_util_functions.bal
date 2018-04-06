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

package jira7;

import ballerina/http;
import ballerina/config;
import ballerina/mime;
import ballerina/io;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Functions                                                         //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    target.self = source.self.toString() ? :"";
    target.id = source.id.toString() ? :"";
    target.key = source.key.toString() ? :"";
    target.name = source.name.toString() ? :"";
    target.description = source.description != null ? source.description.toString() ? :"" : "";
    target.projectTypeKey = source.projectTypeKey.toString() ? :"";
    target.category = source.projectCategory != null ? source.projectCategory.name.toString() ? :"" : "";

    return target;
}

function jsonToProjectCategory (json source) returns ProjectCategory {

    ProjectCategory target = {};

    target.self = source.self != null ? source.self.toString() ? :"" : "";
    target.name = source.name != null ? source.name.toString() ? :"" : "";
    target.id = source.id != null ? source.id.toString() ? :"" : "";
    target.description = source.description != null ? source.description.toString() ? :"" : "";

    return target;
}

function jsonToProjectComponent (json source) returns ProjectComponent {

    ProjectComponent target = {};
    target.self = source.self != null ? source.self.toString() ? : "" : "";
    target.id = source.id != null ? source.id.toString() ? :"" : "";
    target.name = source.name != null ? source.name.toString() ? :"" : "";
    target.description = source.description != null ? source.description.toString() ? :"" : "";
    target.assigneeType = source.assigneeType != null ? source.assigneeType.toString() ? :"" : "";
    target.realAssigneeType = source.realAssigneeType != null ? source.realAssigneeType.toString() ? :"" : "";
    target.project = source.project != null ? source.project.toString() ? :"" : "";
    target.projectId = source.projectId != null ? source.projectId.toString() ? :"" : "";

    target.leadName = source.lead != null ?
                      source.lead.name != null ?
                      source.lead.name.toString() ? :"" : "" : "";

    target.assigneeName = source.assignee != null ?
                          source.assignee.name != null ?
                          source.assignee.name.toString() ? :"" : "" : "";

    target.realAssigneeName = source.realAssignee != null ?
                              source.realAssignee.name != null ?
                              source.realAssignee.name.toString() ? :"" : "" : "";

    return target;
}