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
import ballerina/net.http;

@Description {value:"Represents a summary of a jira project."}
public struct ProjectSummary {
    string self;
    string id;
    string key;
    string name;
    string description;
    string category;
    string projectTypeKey;
}

@Description {value:"Represents a detailed jira project."}
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

@Description {value:"Represents a detailed jira project."}
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

@Description {value:"Represents a summary of a jira project component."}
public struct ProjectComponentSummary {
    string self;
    string id;
    string name;
    string description;
}

@Description {value:"Represents a detailed jira project component."}
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
    string project;
    string projectId;
}

@Description {value:"Represents jira project component creation template object."}
public struct ProjectComponentRequest {
    string name;
    string description;
    string leadUserName;
    string assigneeType;
    string project;
    string projectId;
}

@Description {value:"Represents a detailed jira project category."}
public struct ProjectCategory {
    string self;
    string id;
    string name;
    string description;
}

@Description {value:"Represents jira project category creation template object."}
public struct ProjectCategoryRequest {
    string name;
    string description;
}

@Description {value:"Represents a jira project role (i.e. Developers,Users etc.)."}
public struct ProjectRole {
    string self;
    string name;
    string description;
    Actor[] actors;
}

@Description {value:"Represent an assignee for a given project role (An actor can be either a jira user or a group)"}
public struct Actor {
    string id;
    string name;
    string displayName;
    string ^"type";
}

@Description {value:"Represents a jira issue type status related to a jira project."}
public struct ProjectStatus {
    string self;
    string name;
    string id;
    json statuses;
}

@Description {value:"Represents a jira user"}
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

@Description {value:"Represents a jira issue type."}
public struct IssueType {
    string self;
    string id;
    string name;
    string description;
    string iconUrl;
    boolean subtask;
}

@Description {value:"Represents a jira project version."}
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

@Description {value:"Represents a set of avatar Urls related to a jira entity."}
public struct AvatarUrls {
    string ^"16x16";
    string ^"24x24";
    string ^"32x32";
    string ^"48x48";
}

@Description {value:"Represent Jira Connector based errors."}
public struct JiraConnectorError {
    string ^"type";
    string message;
    json jiraServerErrorLog;
    error[] cause;
}
