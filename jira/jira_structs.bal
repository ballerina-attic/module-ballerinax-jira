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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                               Jira Project                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ProjectSummary {
    string self;
    string id;
    string key;
    string name;
    string description;
    string category;
    string projectTypeKey;
}

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                             Project Components                                                     //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ProjectComponentSummary {
    string self;
    string id;
    string name;
    string description;
}

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

public struct ProjectComponentRequest {
    string name;
    string description;
    string leadUserName;
    string assigneeType;
    string project;
    string projectId;
}

public struct ProjectCategory {
    string self;
    string id;
    string name;
    string description;
}

public struct ProjectRole {
    string self;
    string name;
    string description;
    Actor[] actors;
}

public struct Actor {
    string id;
    string name;
    string displayName;
    string ^"type";
}

public struct ProjectStatus {
    string self;
    string name;
    string id;
    json statuses;
}

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

public struct NewActor {
    ActorType ^"type";
    string name;
}

public struct ProjectCategoryRequest {
    string name;
    string description;
}

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

public struct IssueType {
    string self;
    string id;
    string name;
    string description;
    string iconUrl;
    boolean subtask;
}

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

public struct AvatarUrls {
    string ^"16x16";
    string ^"24x24";
    string ^"32x32";
    string ^"48x48";
}

public struct Avatar {
    string id;
    boolean isSystemAvatar;
    boolean isSelected;
    boolean isDeletable;
    AvatarUrls urls;
    boolean selected;
}

public struct JiraConnectorError {
    string ^"type";
    string message;
    json jiraServerErrorLog;
    error[] cause;
}

