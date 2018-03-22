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
import ballerina.util;
import ballerina.log;
import ballerina.io;

//Creates package-global Http client endpoint for jira REST API
endpoint http:ClientEndpoint jiraHttpClientEP {targets:[{uri:JIRA_REST_API_ENDPOINT}], chunking:http:Chunking.NEVER};
public http:HttpConnectorError connectionError;

//package-global to store encoded user credentials
string base64EncodedString = "";

//Jira Connector Struct
public struct JiraConnector {
    boolean hasVaildCredentials = false;
}

@Description {value:"stores and validates jira account credentials given by the by the user"}
@Param {value:"username: jira account username"}
@Param {value:"password:jira account password"}
@Return {value:"Returns false if the login fails due to invalid credentials or if the login is denied due to a CAPTCHA requirement, throtting, or any other reason.Otherwise returns true"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> authenticate (string username, string password) returns boolean|JiraConnectorError {
    JiraConnectorError e = {};

    boolean|JiraConnectorError response = validateAuthentication(username, password);
    match response {
        boolean => base64EncodedString = util:base64Encode(username + ":" + password);
        JiraConnectorError => base64EncodedString = "";
    }
    return response;
}

@Description {value:"Returns all projects which are visible for the currently logged in user.
    If no user is logged in, it returns the list of projects that are visible when using anonymous access"}
@Return {value:"ProjectSumary[]: Array of projects summaries for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN
    project permission."}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> getAllProjectSummaries () returns ProjectSummary[]|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    ProjectSummary[] projects = [];
    JiraConnectorError e = {};
    error err = {};
    json[] jsonResponseArray;

    //Adds Authorization Header
    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> get("/project?expand=description", request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {
            jsonResponseArray, err = (json[]) jsonResponse;
            if (err != null) {
                e = <JiraConnectorError, toConnectorError()>err;
                return e;
            } else if (jsonResponseArray == null) {
                err = {message:"Error: server response doesn't contain any projects."};
                e = <JiraConnectorError, toConnectorError()>err;
                return e;
            }

            int i = 0;
            foreach (jsonProject in jsonResponseArray) {
                projects[i] = <ProjectSummary, createProjectSummary()>jsonProject;
                i = i + 1;
            }
            return projects;
        }
    }
}

@Description {value:"Returns detailed representation of a project."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Return {value:"Project: Contains a full representation of a project, if the project exists,the user has permission
    to view it and if no any error occured"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> getProject (string projectIdOrKey) returns Project|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    Project project = {};
    JiraConnectorError e = {};
    error err = {};

    //Adds Authorization Header
    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> get("/project/" + projectIdOrKey, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {
            jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ? jsonResponse.lead.name : null : null;
            project, err = <Project>jsonResponse;
            if (err != null) {
                e = <JiraConnectorError, toConnectorError()>err;
                return e;
            }
            return project;
        }
    }
}

@Description {value:"Creates a new project."}
@Param {value:"newProject: struct which contains the mandatory fields for new project creation"}
@Return {value:"Returns true if the project was created was successfully,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> createProject (ProjectRequest newProject) returns boolean|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e = {};
    error err = {};
    json jsonPayload;


    jsonPayload, err = <json>newProject;

    if (!isEmpty(err)) {
        e = <JiraConnectorError, toConnectorError()>err;
        return e;
    }
    request.setJsonPayload(jsonPayload);

    //Adds Authorization Header
    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> post("/project", request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {
            return true;
        }
    }
}


@Description {value:"Updates a project. Only non null values sent in 'ProjectRequest' structure will
    be updated in the project. Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Param {value:"update: structure containing fields which need to be updated"}
@Return {value:"Returns true if project was updated successfully,otherwise return false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> updateProject (string projectIdOrKey, ProjectRequest update) returns boolean|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e = {};
    error err = {};
    json jsonPayload;

    jsonPayload = <json, createJsonProjectRequest()>update;
    if (!isEmpty(err)) {
        e = <JiraConnectorError, toConnectorError()>err;
        return e;
    }
    request.setJsonPayload(jsonPayload);

    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> put("/project/" + projectIdOrKey, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"Deletes a project."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Return {value:"Returns true if project was deleted successfully,otherwise return false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> deleteProject (string projectIdOrKey) returns boolean|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e = {};

    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> delete("/project/" + projectIdOrKey, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {
            return true;
        }
    }
}

@Description {value:"Returns all existing project categories"}
@Return {value:"ProjectCategory[]: Array of structures which contain existing categories"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> getAllProjectCategories () returns ProjectCategory[]|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    ProjectCategory[] projectCategories = [];
    JiraConnectorError e = {};
    error err = {};
    json[] jsonResponseArray;

    //Adds Authorization Header
    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> get("/projectCategory", request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);
    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {

            jsonResponseArray, err = (json[])jsonResponse;
            int i = 0;
            foreach (jsonProjectCategory in jsonResponseArray) {
                projectCategories[i], err = <ProjectCategory>jsonProjectCategory;
                if (err != null) {
                    e = <JiraConnectorError, toConnectorError()>err;
                    return e;
                }
                i = i + 1;
            }
            return projectCategories;
        }
    }
}

@Description {value:"Create a new project category"}
@Param {value:"newCategory: struct which contains the mandatory fields for new project category creation "}
@Return {value:"Returns true if project category was created successfully,otherwise return false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> createProjectCategory (ProjectCategoryRequest newCategory) returns boolean|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e = {};
    error err = {};
    json jsonPayload;

    jsonPayload, err = <json>newCategory;
    if (err != null) {
        e = <JiraConnectorError, toConnectorError()>err;
        return e;
    }
    request.setJsonPayload(jsonPayload);

    //Adds Authorization Header
    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> post("/projectCategory", request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {
            return true;
        }
    }
}


@Description {value:"Delete a project category."}
@Param {value:"projectCategoryId: Jira id of the project category"}
@Return {value:"Returns true if the project category was deleted successfully, otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> deleteProjectCategory (string projectCategoryId) returns boolean|JiraConnectorError {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e = {};

    //Adds Authorization Header
    constructAuthHeader(request);
    var httpResponseOut = jiraHttpClientEP -> delete("/projectCategory/" + projectCategoryId, request);
    //Evaluate http response for connection and server errors
    var jsonResponseOut = getValidatedResponse(httpResponseOut);

    match jsonResponseOut {
        JiraConnectorError errorOut => {
            return errorOut;
        }
        json jsonResponse => {
            return true;
        }
    }
}







