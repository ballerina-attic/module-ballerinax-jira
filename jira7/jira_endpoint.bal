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
# + jiraConnector - JiraConnector Connector object
public type Client client object {

    public JiraConnector jiraConnector;

    public function __init(JiraConfiguration jiraConfig) {
        string url = <string>jiraConfig.baseUrl + <string>JIRA_REST_API_RESOURCE + <string>JIRA_REST_API_VERSION;
        jiraConfig.chunking = "NEVER";
        self.jiraConnector = new(url, jiraConfig);
    }

    # Returns an array of all projects summaries which are visible for the currently logged in user who has
    # `BROWSE`, `ADMINISTER` or `PROJECT_ADMIN` project permission.
    # + return - Array of `ProjectSummary` objects or `JiraConnectorError` record
    remote function getAllProjectSummaries() returns ProjectSummary[]|JiraConnectorError {
        return self.jiraConnector->getAllProjectSummaries();
    }

    # Returns detailed representation of the summarized project, if the project exists,the user has
    # permission to view it and if no any error occured.
    # + projectSummary - `ProjectSummary` object
    # + return - `Project` object or `JiraConnectorError` record
    remote function getAllDetailsFromProjectSummary(ProjectSummary projectSummary) returns Project|JiraConnectorError {
        return self.jiraConnector->getAllDetailsFromProjectSummary(projectSummary);
    }

    # Creates a new project. Values available for the assigneeType field are: `PROJECT_LEAD` and `UNASSIGNED`.
    # + newProject - Record which contains the mandatory fields for new project creation
    # + return - `Project` object which contains detailed representation of the new project or `JiraConnectorError` record
    remote function createProject(ProjectRequest newProject) returns Project|JiraConnectorError {
        return self.jiraConnector->createProject(newProject);
    }

    # Updates a project. Only non null values sent in `ProjectRequest` structure will be updated in the project.
    # Values available for the assigneeType field are: `PROJECT_LEAD` and `UNASSIGNED`.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + update - Record which contain fields which need to be updated
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function updateProject(string projectIdOrKey, ProjectRequest update) returns boolean|JiraConnectorError {
        return self.jiraConnector->updateProject(projectIdOrKey, update);
    }

    # Deletes a project.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function deleteProject(string projectIdOrKey) returns boolean|JiraConnectorError {
        return self.jiraConnector->deleteProject(projectIdOrKey);
    }

    # Returns detailed representation of a project, if the project exists,the user has permission
    # to view it and if no any error occured.
    # + projectIdOrKey - Unique string which represents the project id or project key of a Jira project
    # + return - `Project` type object or `JiraConnectorError` record
    remote function getProject(string projectIdOrKey) returns Project|JiraConnectorError {
        return self.jiraConnector->getProject(projectIdOrKey);
    }

    # Returns Jira user details of the project lead.
    # + project - `Project` type record
    # + return - `User` type record containing user details of the project lead. or `JiraConnectorError` record
    remote function getLeadUserDetailsOfProject(Project project) returns User|JiraConnectorError {
        return self.jiraConnector->getLeadUserDetailsOfProject(project);
    }

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
    # + return - `ProjectRole` object containing the details of the requested role or `JiraConnectorError` record
    remote function getRoleDetailsOfProject(Project project, string projectRoleId)
    returns ProjectRole|JiraConnectorError {
        return self.jiraConnector->getRoleDetailsOfProject(project, projectRoleId);
    }

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
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function addUserToRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|JiraConnectorError {
        return self.jiraConnector->addUserToRoleOfProject(project, projectRoleId, userName);
    }

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
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function addGroupToRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|JiraConnectorError {
        return self.jiraConnector->addGroupToRoleOfProject(project, projectRoleId, groupName);
    }

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
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function removeUserFromRoleOfProject(Project project, string projectRoleId, string userName)
    returns boolean|JiraConnectorError {
        return self.jiraConnector->removeUserFromRoleOfProject(project, projectRoleId, userName);
    }

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
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function removeGroupFromRoleOfProject(Project project, string projectRoleId, string groupName)
    returns boolean|JiraConnectorError {
        return self.jiraConnector->removeGroupFromRoleOfProject(project, projectRoleId, groupName);
    }

    # Gets all issue types with valid status values for a project.
    # + project - `Project` type record
    # + return - Array of `ProjectStatus` type records or `JiraConnectorError` record
    remote function getAllIssueTypeStatusesOfProject(Project project) returns ProjectStatus[]|JiraConnectorError {
        return self.jiraConnector->getAllIssueTypeStatusesOfProject(project);
    }

    # Updates the type of a Jira project.
    # + project - `Project` type record
    # + newProjectType - New project type for the jira project(`PROJECT_TYPE_SOFTWARE` or `PROJECT_TYPE_BUSINESS`)
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function changeTypeOfProject(Project project, string newProjectType) returns boolean|JiraConnectorError {
        return self.jiraConnector->changeTypeOfProject(project, newProjectType);
    }

    # Creates a new project component.
    # + newProjectComponent - Record which contains the mandatory fields for new project component creation
    # + return - `ProjectComponent` object which contains the created project component or `JiraConnectorError` record
    remote function createProjectComponent(ProjectComponentRequest newProjectComponent)
    returns ProjectComponent|JiraConnectorError {
        return self.jiraConnector->createProjectComponent(newProjectComponent);
    }

    # Returns detailed representation of project component.
    # + componentId - string which contains a unique id for a given component.
    # + return - `ProjectComponent` type record or `JiraConnectorError` record
    remote function getProjectComponent(string componentId) returns ProjectComponent|JiraConnectorError {
        return self.jiraConnector->getProjectComponent(componentId);
    }

    # Deletes a project component.
    # + componentId - string which contains a unique id for a given component
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function deleteProjectComponent(string componentId) returns boolean|JiraConnectorError {
        return self.jiraConnector->deleteProjectComponent(componentId);
    }

    # Returns jira user details of the assignee of the project component.
    # + projectComponent - `ProjectComponent` type record
    # + return - `User` object containing user details of the assignee. or `JiraConnectorError` record
    remote function getAssigneeUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|JiraConnectorError {
        return self.jiraConnector->getAssigneeUserDetailsOfProjectComponent(projectComponent);
    }

    # Returns jira user details of the lead of the project component.
    # + projectComponent - `ProjectComponent` type record
    # + return - `User` object containing user details of the lead or `JiraConnectorError` record
    remote function getLeadUserDetailsOfProjectComponent(ProjectComponent projectComponent)
    returns User|JiraConnectorError {
        return self.jiraConnector->getLeadUserDetailsOfProjectComponent(projectComponent);
    }

    # Returns all existing project categories.
    # + return - Array of `ProjectCategory` objects or `JiraConnectorError` record
    remote function getAllProjectCategories() returns ProjectCategory[]|JiraConnectorError {
        return self.jiraConnector->getAllProjectCategories();
    }

    # Returns a detailed representation of a project category.
    # + projectCategoryId - Jira id of the project category
    # + return - `ProjectCategory` type records or `JiraConnectorError` record
    remote function getProjectCategory(string projectCategoryId) returns ProjectCategory|JiraConnectorError {
        return self.jiraConnector->getProjectCategory(projectCategoryId);
    }

    # Create a new project category.
    # + newCategory - Record which contains the mandatory fields for new project category creation
    # + return - `ProjectCategory` type records or `JiraConnectorError` record
    remote function createProjectCategory(ProjectCategoryRequest newCategory)
    returns ProjectCategory|JiraConnectorError {
        return self.jiraConnector->createProjectCategory(newCategory);
    }

    # Delete a project category.
    # + projectCategoryId - Jira id of the project category
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function deleteProjectCategory(string projectCategoryId) returns boolean|JiraConnectorError {
        return self.jiraConnector->deleteProjectCategory(projectCategoryId);
    }

    # Returns a detailed representation of a jira issue.
    # + issueIdOrKey - Id or key of the required issue
    # + return - `Issue` type record or `JiraConnectorError` record
    remote function getIssue(string issueIdOrKey) returns Issue|JiraConnectorError {
        return self.jiraConnector->getIssue(issueIdOrKey);
    }

    # Creates a new jira issue.
    # + newIssue - Record which contains the mandatory fields for new issue creation
    # + return - `Issue` type record or `JiraConnectorError` record
    remote function createIssue(IssueRequest newIssue) returns Issue|JiraConnectorError {
        return self.jiraConnector->createIssue(newIssue);
    }

    # Deletes a jira issue.
    # + issueIdOrKey - Id or key of the issue
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function deleteIssue(string issueIdOrKey) returns boolean|JiraConnectorError {
        return self.jiraConnector->deleteIssue(issueIdOrKey);
    }

    # Adds a comment to a Jira Issue.
    # + issueIdOrKey - Id or key of the issue
    # + comment - The details of the comment to be added
    # + return - returns true if the process is successful or `JiraConnectorError` record
    remote function addCommentToIssue(string issueIdOrKey, IssueComment comment)
    returns boolean|JiraConnectorError {
        return self.jiraConnector->addCommentToIssue(issueIdOrKey, comment);
    }
};

# Represents the Jira Client Connector Endpoint configuration.
# + clientConfig - HTTP client endpoint configuration
public type JiraConfiguration record {
    http:ClientEndpointConfig clientConfig;
};
