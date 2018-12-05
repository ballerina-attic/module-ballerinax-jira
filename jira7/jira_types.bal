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

# Represents a summary of a Jira project.
# + resource_path - API resource URL
# + id - Project Id
# + key - Project key
# + name - Project name
# + description - Project description
# + category - Project category
# + projectTypeKey - Type of the project(`software/business`)
public type ProjectSummary record {
    string resource_path = "";
    string id = "";
    string key = "";
    string name = "";
    string description = "";
    string category = "";
    string projectTypeKey = "";
};

# Represents a detailed Jira project.
# + resource_path - API resource URL
# + id - Project Id
# + key - Project key
# + name - Project name
# + description - Project description
# + leadName - Jira username of the project lead
# + projectTypeKey - Type of the project(`software` or `business`)
# + avatarUrls - Project avatar URLs
# + projectCategory - Details of project category
# + issueTypes - Support issue types of the project
# + components - Summarized details about components of the project
# + versions - Detatils of project versions
public type Project record {
    string resource_path = "";
    string id = "";
    string key = "";
    string name = "";
    string description = "";
    string leadName = "";
    string projectTypeKey = "";
    AvatarUrls avatarUrls = {};
    ProjectCategory projectCategory = {};
    IssueType[] issueTypes = [];
    ProjectComponentSummary[] components = [];
    ProjectVersion[] versions = [];
};

# Represents Jira project creation/update template.
# + key - Project key
# + name - Project name
# + description - Project description
# + projectTypeKey - Type of the project(`software` or `business`)
# + projectTemplateKey - Template key of the project
# + lead - Jira username of the project lead
# + url - URL for the project
# + assigneeType - Type of assignee of the project (`PROJECT_LEAD` or `UNASSIGNED`)
# + avatarId - Avatar for the new project
# + issueSecurityScheme - Issue security scheme id
# + permissionScheme - Premission scheme id
# + notificationScheme - Notification scheme id
# + categoryId - Project category id
public type ProjectRequest record {
    string key = "";
    string name = "";
    string projectTypeKey = "";
    string projectTemplateKey = "";
    string description = "";
    string lead = "";
    string url = "";
    string assigneeType = "";
    string avatarId = "";
    string issueSecurityScheme = "";
    string permissionScheme = "";
    string notificationScheme = "";
    string categoryId = "";
};

# Represents a summary of a Jira project component.
# + resource_path - API resource URL
# + id - Project component Id
# + name - Project component name
# + description - Project component description
public type ProjectComponentSummary record {
    string resource_path = "";
    string id = "";
    string name = "";
    string description = "";
};

# Represents a detailed Jira project component.
# + resource_path - API resource URL
# + id - Project component Id
# + name - Project component name
# + description - Project component description
# + leadName - Jira username of project component lead
# + assigneeName - Jira username of component assignee
# + assigneeType - Type of assignee (`PROJECT_DEFAULT`, `COMPONENT_LEAD`, `PROJECT_LEAD` or `UNASSIGNED`)
# + realAssigneeName - Jira username of the project component real assignee
# + realAssigneeType - Type of real assignee (`PROJECT_DEFAULT`, `COMPONENT_LEAD`, `PROJECT_LEAD` or `UNASSIGNED`)
# + project - Key of the related project
# + projectId - Id of the related project
public type ProjectComponent record {
    string resource_path = "";
    string id = "";
    string name = "";
    string description = "";
    string leadName = "";
    string assigneeName = "";
    string assigneeType = "";
    string realAssigneeName = "";
    string realAssigneeType = "";
    string project = "";
    string projectId = "";
};

# Represents Jira project component creation template object.
# + name - Project component name
# + description - Project component description
# + leadUserName - Jira username of project component lead
# + assigneeType - Type of assignee (`PROJECT_DEFAULT`, `COMPONENT_LEAD`, `PROJECT_LEAD` or `UNASSIGNED`)
# + project - Key of the related project
# + projectId - Id of the related project
public type ProjectComponentRequest record {
    string name = "";
    string description = "";
    string leadUserName = "";
    string assigneeType = "";
    string project = "";
    string projectId = "";
};

# Represents a detailed Jira project category.
# + resource_path - API resource URL
# + id - Project category Id
# + name - Project category name
# + description - Project category description
public type ProjectCategory record {
    string resource_path = "";
    string id = "";
    string name = "";
    string description = "";
};

# Represents Jira project category creation template object.
# + name - Project category name
# + description - Project category description
public type ProjectCategoryRequest record {
    string name = "";
    string description = "";
};

# Represents a Jira project role (i.e. Developers;Users etc.).
# + resource_path - API resource URL
# + name - Project role name
# + description - Project role description
# + actors - The set of Jira users and groups assigned to the project role
public type ProjectRole record {
    string resource_path = "";
    string name = "";
    string description = "";
    Actor[] actors = [];
};

# Represent an assignee for a given project role (An actor can be either a Jira user or a group).
# + id - Id of the actor(user/group)
# + name - Name of the actor
# + displayName - Display name of the actor
# + type - Type of the actor
public type Actor record {
    string id = "";
    string name = "";
    string displayName = "";
    string ^"type" = "";
};

# Represents a Jira issue type status related to a Jira project.).
# + resource_path - API resource URL
# + name - Related issue type name
# + id - Related issue type id
# + statuses - Project status details related to the issue type
public type ProjectStatus record {
    string resource_path = "";
    string name = "";
    string id = "";
    json statuses = {};
};

# Represents a Jira user.
# + resource_path - API resource URL
# + key - Key of the user
# + name - Name of the user
# + displayName - Display name of the user
# + emailAddress - Email address of the user
# + avatarUrls - Avatar URLs of the user
# + active - boolean field represent whether the user is active
# + timeZone - Time zone related to the user
# + locale - Locale
public type User record {
    string resource_path = "";
    string key = "";
    string name = "";
    string displayName = "";
    string emailAddress = "";
    json avatarUrls = {};
    boolean active = false;
    string timeZone = "";
    string locale = "";
};

# Represents a Jira issue type.
# + resource_path - API resource URL
# + id - Issue type id
# + name - Issue type name
# + description - Issue type description
# + iconUrl - URL of the issue type icon
# + avatarId - Avatar Id
public type IssueType record {
    string resource_path = "";
    string id = "";
    string name = "";
    string description = "";
    string iconUrl = "";
    string avatarId = "";
};

# Represents a Jira project version.
# + resource_path - API resource URL
# + id -Project version id
# + name - Project version name
# + archived - boolean field which indicates whether the version is archived
# + released - boolean field which indicates whether the version is released
# + releaseDate - Release date of the project version
# + overdue - boolean field which indicates whether the version is overdue
# + userReleaseDate - User release date of the project version
# + projectId - Id of the related project
public type ProjectVersion record {
    string resource_path = "";
    string id = "";
    string name = "";
    boolean archived = false;
    boolean released = false;
    string releaseDate = "";
    boolean overdue = false;
    string userReleaseDate = "";
    string projectId = "";
};

# Represents a set of avatar Urls related to a Jira entity.
# + ^"16x16" - Avatar URL icon of size 16x16
# + ^"24x24" - Avatar URL icon of size 24x24
# + ^"32x32" - Avatar URL icon of size 32x32
# + ^"48x48" - Avatar URL icon of size 48x48
public type AvatarUrls record {
    string ^"16x16" = "";
    string ^"24x24" = "";
    string ^"32x32" = "";
    string ^"48x48" = "";
};

# Represents a jira issue.
# + resource_path - API resource URL
# + id - Issue Id
# + key - Issue key
# + summary - Summary of the issue
# + priorityId - Issue priority Id
# + resolutionId - Issue resolution Id
# + statusId - Issue status Id
# + creatorName - Jira username of the issue creator
# + assigneeName - Jira username of the issue assignee
# + reporterName - Jira username of the issue reporter
# + createdDate - Created date of the issue
# + dueDate - Due date of the issue
# + timespent - Assigned time spent for the issue
# + issueType - Type of the jira issue
# + parent - Parent issue of the issue
# + project - Represent summarized details of the project which the issue is related to
# + comments - Issue comments
# + customFields - Customly created fields which contain issue related information
# + resolutionDate -The date of resolution
# + aggregatetimespent - time
public type Issue record {
    string resource_path = "";
    string id = "";
    string key = "";
    string summary = "";
    string priorityId = "";
    string resolutionId = "";
    string statusId = "";
    string creatorName = "";
    string assigneeName = "";
    string reporterName = "";
    string createdDate = "";
    string dueDate = "";
    string timespent = "";
    string resolutionDate = "";
    string aggregatetimespent = "";
    IssueType issueType = {};
    IssueSummary parent = {};
    ProjectSummary project = {};
    IssueComment[] comments = [];
    json[] customFields = [];
};

# Represents record of Jira issue creation template.
# + summary - Summary of the issue
# + issueTypeId - Id of the issue type for the new issue
# + projectId - Id of the project related to the new issue
# + assigneeName - Jira username of the issue assignee
public type IssueRequest record {
    string summary = "";
    string issueTypeId = "";
    string projectId = "";
    string assigneeName = "";
};

# Represents a jira issue.
# + resource_path - API resource URL
# + id - Issue Id
# + key - Issue key
# + priorityId - Issue priority Id
# + statusId - Issue status Id
# + issueType - Type of the jira issue
public type IssueSummary record {
    string resource_path = "";
    string id = "";
    string key = "";
    string priorityId = "";
    string statusId = "";
    IssueType issueType = {};
};

# Represent Jira Connector based errors.
# + type - Type of the error (HTTP error,server error etc.)
# + message - Error message
# + jiraServerErrorLog - Error log returned by the jira server, for "server error" type
public type JiraConnectorError record {
    string message = "";
    string ^"type" = "";
    json jiraServerErrorLog = {};
};

# Represents record of jira issue comment.
# + id - Issue id
# + authorName - Authors name of comment
# + authorKey - Authors key
# + body - Body of comment
# + updatedDate - Date of creation of comment
public type IssueComment record {
    string id = "";
    string authorName = "";
    string authorKey = "";
    string body = "";
    string updatedDate = "";
};
