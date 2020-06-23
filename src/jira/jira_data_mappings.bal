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

import ballerina/java;

function projectRequestToJson(ProjectRequest request) returns json {
    map<json> target = {};
    target["key"] = validateStringValue(request?.key);
    target["name"] = validateStringValue(request?.name);
    target["projectTypeKey"] = validateStringValue(request?.projectTypeKey);
    target["projectTemplateKey"] = validateStringValue(request?.projectTemplateKey);
    target["description"] = validateStringValue(request?.description);
    target["lead"] = validateStringValue(request?.lead);
    target["url"] = validateStringValue(request?.url);
    target["assigneeType"] = validateStringValue(request?.assigneeType);
    target["avatarId"] = validateStringValue(request?.avatarId);
    target["issueSecurityScheme"] = validateStringValue(request?.issueSecurityScheme);
    target["permissionScheme"] = validateStringValue(request?.permissionScheme);
    target["notificationScheme"] = validateStringValue(request?.notificationScheme);
    target["categoryId"] = validateStringValue(request?.categoryId);
    return target;
}

function jsonToProjectSummary(json request) returns ProjectSummary {
    ProjectSummary target = {};
    target.resourcePath = request.self.toString() ;
    target.id = request.id.toString() ;
    target.key = request.key.toString() ;
    target.name = request.name.toString() ;
    target.description = validateJsonValue(request.description);
    target.projectTypeKey = request.projectTypeKey.toString() ;
    if (request.projectCategory != ()) {
        target.category = request.projectCategory.name.toString();
    } else {
        target.category = EMPTY_STRING;
    }

    return target;
}

function jsonToProjectCategory(json request) returns ProjectCategory {
    ProjectCategory target = {};
    target.resourcePath = validateJsonValue(request.self);
    target.name = validateJsonValue(request.name);
    target.id = validateJsonValue(request.id);
    target.description = validateJsonValue(request.description);
    return target;
}

function jsonToProjectComponent(json request) returns ProjectComponent {
    ProjectComponent target = {};
    target.resourcePath = validateJsonValue(request.self);
    target.id = validateJsonValue(request.id);
    target.name = validateJsonValue(request.name);
    target.description = validateJsonValue(request.description);
    target.assigneeType = validateJsonValue(request.assigneeType);
    target.realAssigneeType = validateJsonValue(request.realAssigneeType);
    target.project = validateJsonValue(request.project);
    target.projectId = validateJsonValue(request.projectId);

    if (request.lead != ()) {
        target.leadName = validateJsonValue(request.lead.name);
    } else {
        target.leadName = EMPTY_STRING;
    }

    if (request.assignee != ()) {
        target.assigneeName = validateJsonValue(request.assignee.name);
    } else {
        target.assigneeName = EMPTY_STRING;
    }

    if (request.realAssignee != ()) {
        target.realAssigneeName = validateJsonValue(request.realAssignee.name);
    } else {
        target.realAssigneeName = EMPTY_STRING;
    }
    return target;
}

function jsonToIssue(json request) returns Issue|error {
    Issue target = {};
    target.resourcePath = request.self.toString() ;
    target.id = request.id.toString() ;
    target.key = request.key.toString() ;

    if (request.fields != ()) {
        target.summary = validateJsonValue(request.fields.summary);
        if (request.fields.creator != ()) {
            target.creatorName = validateJsonValue(request.fields.creator.name);
        } else {
            target.creatorName = EMPTY_STRING;
        }
        if (request.fields.assignee != ()) {
            target.assigneeName = validateJsonValue(request.fields.assignee.name);
        } else {
            target.assigneeName = EMPTY_STRING;
        }
        if (request.fields.reporter != ()) {
            target.reporterName = validateJsonValue(request.fields.reporter.name);
        } else {
            target.reporterName = EMPTY_STRING;
        }
        if (request.fields.priority != ()) {
            target.priorityId = validateJsonValue(request.fields.priority.id);
        } else {
            target.priorityId = EMPTY_STRING;
        }
        if (request.fields.resolution != ()) {
            target.resolutionId = validateJsonValue(request.fields.resolution.id);
        } else {
            target.resolutionId = EMPTY_STRING;
        }
        if (request.fields.status != ()) {
            target.statusId = validateJsonValue(request.fields.status.id);
        } else {
            target.statusId = EMPTY_STRING;
        }
        target.timespent = validateJsonValue(request.fields.timespent);
        target.aggregatetimespent = validateJsonValue(request.fields.aggregatetimespent);
        target.createdDate = validateJsonValue(request.fields.created);
        target.dueDate = validateJsonValue(request.fields.duedate);
        target.resolutionDate = validateJsonValue(request.fields.resolutiondate);
        if (request.fields.project != ()) {
            target.project = jsonToProjectSummary(check request.fields.project);
        } else {
            target.project = {};
        }
        if (request.fields.issuetype != ()) {
            target.issueType = jsonToIssueType(check request.fields.issuetype);
        } else {
            target.issueType = {};
        }
    } else {
        target.summary = EMPTY_STRING;
        target.creatorName = EMPTY_STRING;
        target.assigneeName = EMPTY_STRING;
        target.reporterName = EMPTY_STRING;
        target.priorityId = EMPTY_STRING;
        target.resolutionId = EMPTY_STRING;
        target.statusId = EMPTY_STRING;
        target.timespent = EMPTY_STRING;
        target.aggregatetimespent = EMPTY_STRING;
        target.createdDate = EMPTY_STRING;
        target.dueDate = EMPTY_STRING;
        target.resolutionDate = EMPTY_STRING;
        target.project = {};
        target.issueType = {};
    }

    int i = 0;

    map<json> requestMap = <map<json>>request;
    map<json> fieldsMap = <map<json>>requestMap["fields"];
    string[] fieldNames = fieldsMap.keys();
    foreach var fieldName in fieldNames {
        string fldname = fieldName.toString();
        if (getStartsWith(fieldName,"customfield")) {
            target.customFields[i] = {fldname:requestMap["fields[fieldName"]};
            i +=1;
        }
    }
    target.comments = jsonToIssueComments(<json[]>request.fields.comment.comments);
    return target;
}

function getStartsWith(string originalText, string str) returns boolean {
    handle originalTextHandle = java:fromString(originalText);
    handle strHandle = java:fromString(str);
    return startsWith(originalTextHandle, strHandle);
}

function startsWith(handle originalText, handle str) returns boolean = @java:Method {
    name: "startsWith",
    class: "java.lang.String",
    paramTypes: ["java.lang.String"]
}external;

function jsonToIssueSummary(json request) returns IssueSummary|error {
    IssueSummary target = {};
    target.resourcePath = request.self.toString() ;
    target.id = request.id.toString() ;
    target.key = request.key.toString() ;

    if (request.fields != ()) {
        if (request.fields.priority != ()) {
            target.priorityId = validateJsonValue(request.fields.priority.id);
        } else {
            target.priorityId = EMPTY_STRING;
        }
        if (request.fields.status != ()) {

        } else {
            target.statusId = validateJsonValue(request.fields.status.id);
        }
        if (request.fields.issuetype != ()) {
            target.issueType = jsonToIssueType(check request.fields.issuetype);
        } else {
            target.issueType = {};
        }
    } else {
        target.priorityId = EMPTY_STRING;
        target.statusId = EMPTY_STRING;
        target.issueType = {};
    }
    return target;
}

function jsonToIssueType(json request) returns IssueType {
    IssueType target = {};
    target.resourcePath = validateJsonValue(request.self);
    target.id = validateJsonValue(request.id);
    target.name = validateJsonValue(request.name);
    target.description = validateJsonValue(request.description);
    target.iconUrl = validateJsonValue(request.iconUrl);
    target.avatarId = validateJsonValue(request.avatarId);
    return target;
}

function issueRequestToJson(IssueRequest request) returns json {

    map<json> target = {fields:{}};
    map<json> fieldJson = <map<json>>target["fields"];
    fieldJson["summary"] = validateStringValue(request?.summary);
    fieldJson["issuetype"] = {id: validateStringValue(request?.issueTypeId)};
    fieldJson["project"] = {id: validateStringValue(request?.projectId)};
    fieldJson["assignee"] = {name: validateStringValue(request?.assigneeName)};

    return target;
}

function jsonToIssueComments(json[] jcomments) returns IssueComment[] {

    IssueComment[] comments = [];
    int l = jcomments.length();
    foreach json jcomment in jcomments {
        comments[comments.length()] = jsonToIssueComment(jcomment);
    }
    return comments;
}

function jsonToIssueComment(json jcomment) returns IssueComment {

    IssueComment comment = {};

    comment.id = jcomment.id.toString();
    comment.authorName = jcomment.author.name.toString();
    comment.authorKey = jcomment.author.key.toString();
    comment.body = jcomment.body.toString();
    comment.updatedDate = jcomment.updated.toString();

    return comment;
}

function convertProjectCategoryRequestToJson(ProjectCategoryRequest sourceGroupStruct) returns json|error {
    json targetJsonObject = {};
    map<json> targetJsonObjectMap = <map<json>> targetJsonObject;
    targetJsonObjectMap["name"] = <string>sourceGroupStruct?.name;
    targetJsonObjectMap["description"] = <string>sourceGroupStruct?.description;
    return targetJsonObject;
}

function convertJsonToProjectCategory(json sourceGroupStruct) returns ProjectCategory|error {
    ProjectCategory targetProjectCategory = {};
    targetProjectCategory.resourcePath = validateJsonValue(sourceGroupStruct.self);
    targetProjectCategory.id = validateJsonValue(sourceGroupStruct.id);
    targetProjectCategory.name = validateJsonValue(sourceGroupStruct.name);
    targetProjectCategory.description = validateJsonValue(sourceGroupStruct.description);
    return targetProjectCategory;
}

function convertJsonToProject(json sourceGroupStruct) returns Project|error {
    Project targetProject = {};
    targetProject.resourcePath = validateJsonValue(sourceGroupStruct.self);
    targetProject.id = validateJsonValue(sourceGroupStruct.id);
    targetProject.key = validateJsonValue(sourceGroupStruct.key);
    targetProject.name = validateJsonValue(sourceGroupStruct.name);
    targetProject.description = validateJsonValue(sourceGroupStruct.description);
    targetProject.leadName = validateJsonValue(sourceGroupStruct.leadName);
    targetProject.projectTypeKey = validateJsonValue(sourceGroupStruct.projectTypeKey);
    targetProject.avatarUrls.'48x48 = validateJsonValue(sourceGroupStruct.avatarUrls.'48x48);
    targetProject.avatarUrls.'32x32 = validateJsonValue(sourceGroupStruct.avatarUrls.'32x32);
    targetProject.avatarUrls.'24x24 = validateJsonValue(sourceGroupStruct.avatarUrls.'24x24);
    targetProject.avatarUrls.'16x16 = validateJsonValue(sourceGroupStruct.avatarUrls.'16x16);
    targetProject.projectCategory.resourcePath = validateJsonValue(sourceGroupStruct.projectCategory.self);
    targetProject.projectCategory.id = validateJsonValue(sourceGroupStruct.projectCategory.id);
    targetProject.projectCategory.name = validateJsonValue(sourceGroupStruct.self);
    targetProject.projectCategory.description = validateJsonValue(sourceGroupStruct.projectCategory.description);
    targetProject.issueTypes = convertToIssueTypes(<json[]>sourceGroupStruct.issueTypes);
    targetProject.components = convertToComponents(<json[]>sourceGroupStruct.components);
    targetProject.versions = convertToVersions(<json[]>sourceGroupStruct.versions);
    return targetProject;
}

function convertJsonToProjectStatus(json sourceGroupStruct) returns ProjectStatus|error {
    ProjectStatus targetProjectStatus = {};
    targetProjectStatus.resourcePath = validateJsonValue(sourceGroupStruct.self);
    targetProjectStatus.name = validateJsonValue(sourceGroupStruct.name);
    targetProjectStatus.id = validateJsonValue(sourceGroupStruct.id);
    targetProjectStatus.statuses = <json[]>sourceGroupStruct.statuses;
    return targetProjectStatus;
}

function convertJsonToUser(json sourceGroupStruct) returns User|error {
    User targetUser = {};
    targetUser.resourcePath = validateJsonValue(sourceGroupStruct.self);
    targetUser.key = validateJsonValue(sourceGroupStruct.key);
    targetUser.name = validateJsonValue(sourceGroupStruct.name);
    targetUser.displayName = validateJsonValue(sourceGroupStruct.displayName);
    targetUser.emailAddress = validateJsonValue(sourceGroupStruct.emailAddress);
    targetUser.avatarUrls = validateJsonValue(sourceGroupStruct.avatarUrls);
    targetUser.active = validateBooleanValue(sourceGroupStruct.active);
    targetUser.timeZone = validateJsonValue(sourceGroupStruct.timeZone);
    targetUser.locale = validateJsonValue(sourceGroupStruct.locale);
    return targetUser;
}

function convertToIssueTypes(json[] issueTypes) returns IssueType[] {
    IssueType[] issues = [];
    int i = 0;
    foreach json issueType in issueTypes {
        issues[i] = convertToIssueType(issueType);
        i = i + 1;
    }
    return issues;
}

function convertToIssueType(json issueType) returns IssueType {
    IssueType issueTypes = {};
    issueTypes.resourcePath = validateJsonValue(issueType.self);
    issueTypes.id = validateJsonValue(issueType.id);
    issueTypes.name = validateJsonValue(issueType.name);
    issueTypes.description = validateJsonValue(issueType.description);
    issueTypes.iconUrl = validateJsonValue(issueType.iconUrl);
    issueTypes.avatarId = validateJsonValue(issueType.avatarId);
    return issueTypes;
}

function convertToComponents(json[] components) returns ProjectComponentSummary[] {
    ProjectComponentSummary[] data = [];
    int i = 0;
    foreach json component in components {
        data[i] = convertToComponent(component);
        i = i + 1;
    }
    return data;
}

function convertToComponent(json components) returns ProjectComponentSummary {
    ProjectComponentSummary component = {};
    component.id = validateJsonValue(components.id);
    component.name = validateJsonValue(components.name);
    component.description = validateJsonValue(components.description);
    return component;
}

function convertToVersions(json[] versions) returns ProjectVersion[] {
    ProjectVersion[] data = [];
    int i = 0;
    foreach json value in versions {
        data[i] = convertToVersion(value);
        i = i + 1;
    }
    return data;
}

function convertToVersion(json value) returns ProjectVersion {
    ProjectVersion versions = {};
    versions.resourcePath = validateJsonValue(value.self);
    versions.id = validateJsonValue(value.id);
    versions.name = validateJsonValue(value.name);
    versions.archived = validateBooleanValue(value.archived);
    versions.released = validateBooleanValue(value.released);
    versions.releaseDate = validateJsonValue(value.releaseDate);
    versions.overdue = validateBooleanValue(value.overdue);
    versions.userReleaseDate = validateJsonValue(value.userReleaseDate);
    versions.projectId = validateJsonValue(value.projectId);
    return versions;
}

function convertJsonToProjectRole(json sourceGroupStruct) returns ProjectRole|error {
    ProjectRole targetProjectRole = {};
    targetProjectRole.resourcePath = <string>sourceGroupStruct.self;
    targetProjectRole.name = <string>sourceGroupStruct.name;
    targetProjectRole.description = <string>sourceGroupStruct.description;
    targetProjectRole.actors = convertToActors(<json[]>sourceGroupStruct.actors);
    return targetProjectRole;
}

function convertToActors(json[] actors) returns Actor[] {
    Actor[] data = [];
    int i = 0;
    foreach json actor in actors {
        data[i] = convertToActor(actor);
        i = i + 1;
    }
    return data;
}

function convertToActor(json actor) returns Actor {
    Actor value = {};
    value.id = validateJsonValue(actor.id);
    value.name = validateJsonValue(actor.name);
    value.displayName = validateJsonValue(actor.displayName);
    value.'type = validateJsonValue(actor.'type);
    return value;
}

function validateJsonValue(json|error value) returns string {
    if (value != null) {
        return value.toString();
    }
    return EMPTY_STRING;
}

function validateStringValue(string? value) returns json {
    if (value != ()) {
        return value;
    }
    return null;
}

function validateBooleanValue(json|error value) returns boolean {
    if (value != null) {
        return <boolean>value;
    }
    return false;
}
