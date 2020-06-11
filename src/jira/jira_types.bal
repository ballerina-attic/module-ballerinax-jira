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

import ballerinax/jira.commons;

public type ProjectSummary commons:ProjectSummary;
public type Project commons:Project;
public type ProjectRequest commons:ProjectRequest;
public type ProjectComponentSummary commons:ProjectComponentSummary;
public type ProjectComponent commons:ProjectComponent;
public type ProjectComponentRequest commons:ProjectComponentRequest;
public type ProjectCategory commons:ProjectCategory;
public type User commons:User;
public type IssueType commons:IssueType;
public type IssueComment commons:Comment;
public type IssueSummary commons:IssueSummary;
public type Issue commons:Issue;
public type IssueRequest commons:IssueRequest;
public type ProjectVersion commons:ProjectVersion;
public type ProjectStatus commons:ProjectStatus;
public type ProjectCategoryRequest commons:ProjectCategoryRequest;
public type Configuration commons:Configuration;
public type BasicAuthConfiguration commons:BasicAuthConfiguration;

# Represents a Jira project role (i.e. Developers;Users etc.).
# + resourcePath - API resource URL
# + name - Project role name
# + description - Project role description
# + actors - The set of Jira users and groups assigned to the project role
public type ProjectRole record {
    string resourcePath = "";
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
    string 'type = "";
};
