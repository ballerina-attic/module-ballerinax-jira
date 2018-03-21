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

//Creates package-global Http client endpoint for jira REST API
endpoint http:ClientEndpoint jiraHttpClientEP {targets:[ {uri:JIRA_REST_API_ENDPOINT}], chunking:http:Chunking. NEVER};
http:HttpConnectorError connectionError;

//package-global to store encoded user credentials
string base64EncodedString;

//Jira Connector Struct
public struct JiraConnector {
    boolean hasVaildCredentials = false;
}

@Description {value:"stores and validates jira account credentials given by the by the user"}
@Param {value:"username: jira account username"}
@Param {value:"password:jira account password"}
@Return {value:"Returns false if the login fails due to invalid credentials or if the login is denied due to a CAPTCHA requirement, throtting, or any other reason.Otherwise returns true"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> authenticate (string username, string password) (boolean, JiraConnectorError) {
    JiraConnectorError e;
    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return false,e;
    }
    jiraConnector.hasVaildCredentials, e = validateAuthentication(username, password);
    if (e == null) {
        base64EncodedString = util:base64Encode(username + ":" + password);
    }
    return jiraConnector.hasVaildCredentials, e;
}

@Description {value:"Returns all projects which are visible for the currently logged in user.
    If no user is logged in, it returns the list of projects that are visible when using anonymous access"}
@Return {value:"ProjectSumary[]: Array of projects summaries for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN
    project permission."}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> getAllProjectSummaries () (ProjectSummary[], JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    ProjectSummary[] projects = [];
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json[] jsonResponseArray;

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return null,e;
    }
    //Adds Authorization Header
    constructAuthHeader(request);
    response, connectionError = jiraHttpClientEP -> get("/project?expand=description", request);
    //Evaluate http response for connection error and server errors
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    jsonResponseArray, err = (json[])jsonResponse;
    if (err != null) {
        e = <JiraConnectorError, toConnectorError()>err;
        return null, e;
    } else if (jsonResponseArray == null) {
        err = {message:"Error: server response doesn't contain any projects."};
        e = <JiraConnectorError, toConnectorError()>err;
        return null, e;
    }

    int i = 0;
    foreach (jsonProject in jsonResponseArray) {
        projects[i] = <ProjectSummary, createProjectSummary()>jsonProject;
        i = i + 1;
    }
    return projects, e;
}

@Description {value:"Returns detailed representation of a project."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Return {value:"Project: Contains a full representation of a project, if the project exists,the user has permission
    to view it and if no any error occured"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> getProject (string projectIdOrKey) (Project, JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    Project project;
    JiraConnectorError e;
    error err;
    json jsonResponse;

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return null,e;
    }

    constructAuthHeader(request);

    response, connectionError = jiraHttpClientEP-> get("/project/" + projectIdOrKey, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ? jsonResponse.lead.name : null : null;
    project, err = <Project>jsonResponse;
    e = <JiraConnectorError, toConnectorError()>err;
    return project, e;

}

@Description {value:"Creates a new project."}
@Param {value:"newProject: struct which contains the mandatory fields for new project creation"}
@Return {value:"Returns true if the project was created was successfully,otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> createProject (ProjectRequest newProject) (boolean, JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json jsonPayload;
    constructAuthHeader(request);

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return false,e;
    }

    jsonPayload, err = <json>newProject;
    if (err != null) {
        e = <JiraConnectorError, toConnectorError()>err;
        return false, e;
    }

    request.setJsonPayload(jsonPayload);


    response, connectionError = jiraHttpClientEP-> post("/project", request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }

    return true, e;
}

@Description {value:"Updates a project. Only non null values sent in 'ProjectRequest' structure will
    be updated in the project. Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Param {value:"update: structure containing fields which need to be updated"}
@Return {value:"Returns true if project was updated successfully,otherwise return false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> updateProject (string projectIdOrKey, ProjectRequest update) (boolean, JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json jsonPayload;

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return false,e;
    }

    constructAuthHeader(request);

    jsonPayload = <json, createJsonProjectRequest()>update;
    if (err != null) {
        e = <JiraConnectorError, toConnectorError()>err;
        return false, e;
    }

    request.setJsonPayload(jsonPayload);

    response, connectionError = jiraHttpClientEP-> put("/project/" + projectIdOrKey, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }

    return true, e;
}

@Description {value:"Deletes a project."}
@Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
@Return {value:"Returns true if project was deleted successfully,otherwise return false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> deleteProject (string projectIdOrKey) (boolean, JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e;
    json jsonResponse;

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return false,e;
    }

    constructAuthHeader(request);

    response, connectionError = jiraHttpClientEP-> delete("/project/" + projectIdOrKey, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return false, e;
    }
    return true, e;
}

@Description {value:"Returns all existing project categories"}
@Return {value:"ProjectCategory[]: Array of structures which contain existing categories"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> getAllProjectCategories () (ProjectCategory[], JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    ProjectCategory[] projectCategories = [];
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json[] jsonResponseArray;

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return null,e;
    }

    constructAuthHeader(request);
    response, connectionError = jiraHttpClientEP-> get("/projectCategory", request);
    jsonResponse, e = getValidatedResponse(response, connectionError);

    if (e != null) {
        return null, e;
    }

    jsonResponseArray, err = (json[])jsonResponse;
    int i = 0;
    foreach (jsonProjectCategory in jsonResponseArray) {
        projectCategories[i], err = <ProjectCategory>jsonProjectCategory;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }
        i = i + 1;
    }
    return projectCategories, e;

}

@Description {value:"Create a new project category"}
@Param {value:"newCategory: struct which contains the mandatory fields for new project category creation "}
@Return {value:"Returns true if project category was created successfully,otherwise return false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> createProjectCategory (ProjectCategoryRequest newCategory) (boolean, JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e = null;
    error err;
    json jsonResponse;
    json jsonPayload;

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return false,e;
    }

    constructAuthHeader(request);

    jsonPayload, err = <json>newCategory;
    if (err != null) {
        e = <JiraConnectorError, toConnectorError()>err;
        return false, e;
    }

    request.setJsonPayload(jsonPayload);

    response, connectionError = jiraHttpClientEP-> post("/projectCategory", request);
    jsonResponse, e = getValidatedResponse(response, connectionError);
    if (e != null) {
        return false, e;
    }

    return true, null;
}

@Description {value:"Delete a project category."}
@Param {value:"projectCategoryId: Jira id of the project category"}
@Return {value:"Returns true if the project category was deleted successfully, otherwise returns false"}
@Return {value:"JiraConnectorError: Error Object"}
public function <JiraConnector jiraConnector> deleteProjectCategory (string projectCategoryId) (boolean, JiraConnectorError) {
    http:Request request = {};
    http:Response response = {};
    JiraConnectorError e = null;
    json jsonResponse;

    if(jiraConnector==null){
        e = {message:"Unable to proceed with a null structure: jiraConnector"};
        return false,e;
    }

    constructAuthHeader(request);

    response, connectionError = jiraHttpClientEP-> delete("/projectCategory/" + projectCategoryId, request);
    jsonResponse, e = getValidatedResponse(response, connectionError);
    if (e != null) {
        return false, e;
    }
    return true, null;
}







