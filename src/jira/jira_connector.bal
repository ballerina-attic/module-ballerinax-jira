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
import ballerina.io;


@Description {value:"Jira client connector"}
public connector JiraConnector () {

    //creates HttpClient Endpoint
    endpoint<http:HttpClient> jiraEndpoint {
        create http:HttpClient(JIRA_REST_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError connectionError;

    @Description {value:"Returns all projects which are visible for the currently logged in user.
    If no user is logged in, it returns the list of projects that are visible when using anonymous access"}
    @Return {value:"Project[]: Array of projects for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN
    project permission."}
    @Return {value:"JiraConnectorError: Error Object"}
    action getAllProjectSummaries () (Project[], JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        Project[] projects = [];
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json[] jsonResponseArray;

        //Adds Authorization Header
        constructAuthHeader(request);
        response, connectionError = jiraEndpoint.get("/project", request);
        //Evaluate http response for connection error and server errors
        jsonResponse, e = getValidatedResponse(response, connectionError);

        if (e != null) {
            return null, e;
        }

        jsonResponseArray, err = (json[])jsonResponse;
        io:println(jsonResponseArray);
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }else if(jsonResponseArray==null){
            err = {message:"Error: server response doesn't contain any projects."};
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }

        int i = 0;
        foreach (jsonProject in jsonResponseArray) {
            projects[i] = <Project, createProjectSummary()>jsonProject;
            i = i + 1;
        }
        return projects, e;
    }

    @Description {value:"Returns detailed representation of a project."}
    @Param {value:"projectIdOrKey: unique string which represents the project id or project key of a jira project"}
    @Return {value:"Project: Contains a full representation of a project, if the project exists,the user has permission
    to view it and if no any error occured"}
    @Return {value:"JiraConnectorError: Error Object"}
    action getProject (string projectIdOrKey) (Project, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        Project project;
        JiraConnectorError e;
        error err;
        json jsonResponse;

        constructAuthHeader(request);

        response, connectionError = jiraEndpoint.get("/project/" + projectIdOrKey, request);
        jsonResponse, e = getValidatedResponse(response, connectionError);

        if (e != null) {
            return null, e;
        }

        jsonResponse.leadName = jsonResponse.lead != null ? jsonResponse.lead.name != null ? jsonResponse.lead.name : "" : "";
        project, err = <Project>jsonResponse;
        e = <JiraConnectorError, toConnectorError()>err;
        return project, e;

    }

    @Description {value:"Creates a new project."}
    @Param {value:"newProject: struct which contains the mandatory fields for new project creation"}
    @Return {value:"Returns true if the project was created was successfully,otherwise returns false"}
    @Return {value:"JiraConnectorError: Error Object"}
    action createProject (ProjectRequest newProject) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json jsonPayload;
        constructAuthHeader(request);

        jsonPayload, err = <json>newProject;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return false, e;
        }

        request.setJsonPayload(jsonPayload);


        response, connectionError = jiraEndpoint.post("/project", request);
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
    action updateProject (string projectIdOrKey, ProjectRequest update) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json jsonPayload;
        constructAuthHeader(request);

        jsonPayload = <json, createJsonProjectRequest()>update;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return false, e;
        }

        request.setJsonPayload(jsonPayload);

        response, connectionError = jiraEndpoint.put("/project/" + projectIdOrKey, request);
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
    action deleteProject (string projectIdOrKey) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e;
        json jsonResponse;
        constructAuthHeader(request);

        response, connectionError = jiraEndpoint.delete("/project/" + projectIdOrKey, request);
        jsonResponse, e = getValidatedResponse(response, connectionError);

        if (e != null) {
            return false, e;
        }
        return true, e;
    }

    @Description {value:"Returns all existing project categories"}
    @Return {value:"ProjectCategory[]: Array of structures which contain existing categories"}
    @Return {value:"JiraConnectorError: Error Object"}
    action getAllProjectCategories () (ProjectCategory[], JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectCategory[] projectCategories = [];
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json[] jsonResponseArray;
        constructAuthHeader(request);
        response, connectionError = jiraEndpoint.get("/projectCategory", request);
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
    action createProjectCategory (ProjectCategoryRequest newCategory) (boolean, JiraConnectorError) {

        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e = null;
        error err;
        json jsonResponse;
        json jsonPayload;

        constructAuthHeader(request);

        jsonPayload, err = <json>newCategory;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return false, e;
        }

        request.setJsonPayload(jsonPayload);

        response, connectionError = jiraEndpoint.post("/projectCategory", request);
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
    action deleteProjectCategory (string projectCategoryId) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e = null;
        json jsonResponse;

        constructAuthHeader(request);

        response, connectionError = jiraEndpoint.delete("/projectCategory/" + projectCategoryId, request);
        jsonResponse, e = getValidatedResponse(response, connectionError);
        if (e != null) {
            return false, e;
        }
        return true, null;
    }
}







