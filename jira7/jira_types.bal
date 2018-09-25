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

# Represents a summary of a jira project.
# + resource_path - API resource url
# + id - project Id
# + key - project key
# + name - project name
# + description - project description
# + category - project category
# + projectTypeKey - type of the project("software/business")
public type ProjectSummary record {
    string resource_path;
    string id;
    string key;
    string name;
    string description;
    string category;
    string projectTypeKey;
};

# Represents a detailed jira project.
# + resource_path - API resource url
# + id - project Id
# + key - project key
# + name - project name
# + description - project description
# + leadName - jira username of the project lead
# + projectTypeKey - type of the project("software" or "business")
# + avatarUrls - project avatar urls
# + projectCategory - details of project category
# + issueTypes - support issue types of the project
# + components - summarized details about components of the project
# + versions - detatils of project versions
public type Project record {
    string resource_path;
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
};

# Represents jira project creation/update template.
# + key - project key
# + name - project name
# + description - project description
# + projectTypeKey - type of the project("software" or "business")
# + projectTemplateKey - template key of the project
# + lead - jira username of the project lead
# + url - url for the project
# + assigneeType - type of assignee of the project ("PROJECT_LEAD" or "UNASSIGNED")
# + avatarId - avatar for the new project
# + issueSecurityScheme - issue security scheme id
# + permissionScheme - premission scheme id
# + notificationScheme - notification scheme id
# + categoryId - project category id
public type ProjectRequest record {
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
};

# Represents a summary of a jira project component.
# + resource_path - API resource url
# + id - project component Id
# + name - project component name
# + description - project component description
public type ProjectComponentSummary record {
    string resource_path;
    string id;
    string name;
    string description;
};

# Represents a detailed jira project component.
# + resource_path - API resource url
# + id - project component Id
# + name - project component name
# + description - project component description
# + leadName - jira username of project component lead
# + assigneeName - jira username of component assignee
# + assigneeType - type of assignee ("PROJECT_DEFAULT", "COMPONENT_LEAD", "PROJECT_LEAD" or "UNASSIGNED")
# + realAssigneeName - jira username of the project component real assignee
# + realAssigneeType - type of real assignee ("PROJECT_DEFAULT", "COMPONENT_LEAD", "PROJECT_LEAD" or "UNASSIGNED")
# + project - key of the related project
# + projectId - id of the related project
public type ProjectComponent record {
    string resource_path;
    string id;
    string name;
    string description;
    string leadName;
    string assigneeName;
    string assigneeType;
    string realAssigneeName;
    string realAssigneeType;
    string project;
    string projectId;
};

# Represents jira project component creation template object.
# + name - project component name
# + description - project component description
# + leadUserName - jira username of project component lead
# + assigneeType - type of assignee ("PROJECT_DEFAULT", "COMPONENT_LEAD", "PROJECT_LEAD" or "UNASSIGNED")
# + project - key of the related project
# + projectId - id of the related project
public type ProjectComponentRequest record {
    string name;
    string description;
    string leadUserName;
    string assigneeType;
    string project;
    string projectId;
};

# Represents a detailed jira project category.
# + resource_path - API resource url
# + id - project category Id
# + name - project category name
# + description - project category description
public type ProjectCategory record {
    string resource_path;
    string id;
    string name;
    string description;
};

# Represents jira project category creation template object.
# + name - project category name
# + description - project category description
public type ProjectCategoryRequest record {
    string name;
    string description;
};

# Represents a jira project role (i.e. Developers;Users etc.).
# + resource_path - API resource url
# + name - project role name
# + description - project role description
# + actors - the set of jira users and groups assigned to the project role
public type ProjectRole record {
    string resource_path;
    string name;
    string description;
    Actor[] actors;
};

# Represent an assignee for a given project role (An actor can be either a jira user or a group).
# + id - id of the actor(user/group)
# + name - name of the actor
# + displayName - display name of the actor
# + type - type of the actor
public type Actor record {
    string id;
    string name;
    string displayName;
    string ^"type";
};

# Represents a jira issue type status related to a jira project.).
# + resource_path - API resource url
# + name - related issue type name
# + id - related issue type id
# + statuses - project status details related to the issue type
public type ProjectStatus record {
    string resource_path;
    string name;
    string id;
    json statuses;
};

# Represents a jira user.
# + resource_path - API resource url
# + key - key of the user
# + name - name of the user
# + displayName - display name of the user
# + emailAddress - email address of the user
# + avatarUrls - avatar urls of the user
# + active - boolean field represent whether the user is active
# + timeZone - time zone related to the user
# + locale - locale
public type User record {
    string resource_path;
    string key;
    string name;
    string displayName;
    string emailAddress;
    json avatarUrls;
    boolean active;
    string timeZone;
    string locale;
};

# Represents a jira issue type.
# + resource_path - API resource url
# + id - issue type id
# + name - issue type name
# + description - issue type description
# + iconUrl - url of the issue type icon
# + avatarId - Avatar Id
public type IssueType record {
    string resource_path;
    string id;
    string name;
    string description;
    string iconUrl;
    string avatarId;
};

# Represents a jira project version.
# + resource_path - API resource url
# + id - project version id
# + name - project version name
# + archived - boolean field which indicates whether the version is archived
# + released - boolean field which indicates whether the version is released
# + releaseDate - release date of the project version
# + overdue - boolean field which indicates whether the version is overdue
# + userReleaseDate - user release date of the project version
# + projectId - id of the related project
public type ProjectVersion record {
    string resource_path;
    string id;
    string name;
    boolean archived;
    boolean released;
    string releaseDate;
    boolean overdue;
    string userReleaseDate;
    string projectId;
};

# Represents a set of avatar Urls related to a jira entity.
# + ^"16x16" - avatar url icon of size 16x16
# + ^"24x24" - avatar url icon of size 24x24
# + ^"32x32" - avatar url icon of size 32x32
# + ^"48x48" - avatar url icon of size 48x48
public type AvatarUrls record {
    string ^"16x16";
    string ^"24x24";
    string ^"32x32";
    string ^"48x48";
};

# Represents a jira issue.
# + resource_path - API resource url
# + id - issue Id
# + key - issue key
# + summary - summary of the issue
# + priorityId - issue priority Id
# + resolutionId - issue resolution Id
# + statusId - issue status Id
# + creatorName - jira username of the issue creator
# + assigneeName - jira username of the issue assignee
# + reporterName - jira username of the issue reporter
# + createdDate - created date of the issue
# + dueDate - due date of the issue
# + timespent - assigned time spent for the issue
# + issueType - type of the jira issue
# + parent - parent issue of the issue
# + project - represent summarized details of the project which the issue is related to
# + comments - Issue comments
# + customFields - customly created fields which contain issue related information
public type Issue record {
    string resource_path;
    string id;
    string key;
    string summary;
    string priorityId;
    string resolutionId;
    string statusId;
    string creatorName;
    string assigneeName;
    string reporterName;
    string createdDate;
    string dueDate;
    string timespent;
    string resolutionDate;
    string aggregatetimespent;
    IssueType issueType;
    IssueSummary parent;
    ProjectSummary project;
    IssueComment[] comments = [];
    json[] customFields = [];
};

# Represents record of jira issue creation template.
# + summary - summary of the issue
# + issueTypeId - Id of the issue type for the new issue
# + projectId - Id of the project related to the new issue
# + assigneeName - jira username of the issue assignee
public type IssueRequest record {
    string summary;
    string issueTypeId;
    string projectId;
    string assigneeName;
};

# Represents a jira issue.
# + resource_path - API resource url
# + id - issue Id
# + key - issue key
# + priorityId - issue priority Id
# + statusId - issue status Id
# + issueType - type of the jira issue
public type IssueSummary record {
    string resource_path;
    string id;
    string key;
    string priorityId;
    string statusId;
    IssueType issueType;
};

# Represent Jira Connector based errors.
# + type - type of the error (HTTP error,server error etc.)
# + message - error message
# + jiraServerErrorLog - error log returned by the jira server, for "server error" type
# + cause - cause for the error
public type JiraConnectorError record {
    string message;
    error? cause;
    string ^"type";
    json jiraServerErrorLog;
};

# Represents record of jira issue comment.
# + id - issue id
# + authorName - Authors name of comment
# + authorKey - Authors key
# + body - Body of comment
# + updatedDate - Date of creation of comment
public type IssueComment record {
    string id;
    string authorName;
    string authorKey;
    string body;
    string updatedDate;
};

