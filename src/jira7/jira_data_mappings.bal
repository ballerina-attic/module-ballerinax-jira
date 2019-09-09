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

import ballerinax/java;

function projectRequestToJson(ProjectRequest request) returns json {

    map<json> target = {};

    target["key"] = request.key != EMPTY_STRING ? request.key : null;
    target["name"] = request.name != EMPTY_STRING ? request.name : null;
    target["projectTypeKey"] = request.projectTypeKey != EMPTY_STRING ? request.projectTypeKey : null;
    target["projectTemplateKey"] = request.projectTemplateKey != EMPTY_STRING ? request.projectTemplateKey : null;
    target["description"] = request.description != EMPTY_STRING ? request.description : null;
    target["lead"] = request.lead != EMPTY_STRING ? request.lead : null;
    target["url"] = request.url != EMPTY_STRING ? request.url : null;
    target["assigneeType"] = request.assigneeType != EMPTY_STRING ? request.assigneeType : null;
    target["avatarId"] = request.avatarId != EMPTY_STRING ? request.avatarId : null;
    target["issueSecurityScheme"] = request.issueSecurityScheme != EMPTY_STRING ? request.issueSecurityScheme : null;
    target["permissionScheme"] = request.permissionScheme != EMPTY_STRING ? request.permissionScheme : null;
    target["notificationScheme"] = request.notificationScheme != EMPTY_STRING ? request.notificationScheme : null;
    target["categoryId"] = request.categoryId != EMPTY_STRING ? request.categoryId : null;

    return target;
}

function jsonToProjectSummary(json request) returns ProjectSummary {

    ProjectSummary target = {};

    target.resource_path = request.self.toString() ;
    target.id = request.id.toString() ;
    target.key = request.key.toString() ;
    target.name = request.name.toString() ;
    target.description = request.description != null ? request.description.toString()  : EMPTY_STRING;
    target.projectTypeKey = request.projectTypeKey.toString() ;
    target.category = request.projectCategory != null ? request.projectCategory.name.toString()  : EMPTY_STRING;

    return target;
}

function jsonToProjectCategory(json request) returns ProjectCategory {

    ProjectCategory target = {};

    target.resource_path = request.self != null ? request.self.toString()  : EMPTY_STRING;
    target.name = request.name != null ? request.name.toString()  : EMPTY_STRING;
    target.id = request.id != null ? request.id.toString()  : EMPTY_STRING;
    target.description = request.description != null ? request.description.toString()  : EMPTY_STRING;

    return target;
}

function jsonToProjectComponent(json request) returns ProjectComponent {

    ProjectComponent target = {};

    target.resource_path = request.self != null ? request.self.toString()  : EMPTY_STRING;
    target.id = request.id != null ? request.id.toString()  : EMPTY_STRING;
    target.name = request.name != null ? request.name.toString()  : EMPTY_STRING;
    target.description = request.description != null ? request.description.toString()  : EMPTY_STRING;
    target.assigneeType = request.assigneeType != null ? request.assigneeType.toString()  : EMPTY_STRING;
    target.realAssigneeType = request.realAssigneeType != null ? request.realAssigneeType.toString()  : EMPTY_STRING;
    target.project = request.project != null ? request.project.toString()  : EMPTY_STRING;
    target.projectId = request.projectId != null ? request.projectId.toString()  : EMPTY_STRING;

    target.leadName = request.lead != null ?
    request.lead.name != null ?
    request.lead.name.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.assigneeName = request.assignee != null ?
    request.assignee.name != null ?
    request.assignee.name.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.realAssigneeName = request.realAssignee != null ?
    request.realAssignee.name != null ?
    request.realAssignee.name.toString()  : EMPTY_STRING : EMPTY_STRING;

    return target;
}

function jsonToIssue(json request) returns Issue|error {
    Issue target = {};
    target.resource_path = request.self.toString() ;
    target.id = request.id.toString() ;
    target.key = request.key.toString() ;

    target.summary = request.fields != null ?
    request.fields.summary != null ?
    request.fields.summary.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.creatorName = request.fields != null ?
    request.fields.creator != null ?
    request.fields.creator.name != null ?
    request.fields.creator.name.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.assigneeName = request.fields != null ?
    request.fields.assignee != null ?
    request.fields.assignee.name != null ?
    request.fields.assignee.name.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.reporterName = request.fields != null ?
    request.fields.reporter != null ?
    request.fields.reporter.name != null ?
    request.fields.reporter.name.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.priorityId = request.fields != null ?
    request.fields.priority != null ?
    request.fields.priority.id != null ?
    request.fields.priority.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.resolutionId = request.fields != null ?
    request.fields.resolution != null ?
    request.fields.resolution.id != null ?
    request.fields.resolution.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.statusId = request.fields != null ?
    request.fields.status != null ?
    request.fields.status.id != null ?
    request.fields.status.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.timespent = request.fields != null ?
    request.fields.timespent != null ?
    request.fields.timespent.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.aggregatetimespent = request.fields != null ?
    request.fields.aggregatetimespent != null ?
    request.fields.aggregatetimespent.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.createdDate = request.fields != null ?
    request.fields.created != null ?
    request.fields.created.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.dueDate = request.fields != null ?
    request.fields.duedate != null ?
    request.fields.duedate.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.resolutionDate = request.fields != null ?
    request.fields.resolutiondate != null ?
    request.fields.resolutiondate.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.project = request.fields != null ?
    request.fields.project != null ?
    jsonToProjectSummary(check request.fields.project) : {}: {};

    target.issueType= request.fields != null ?
    request.fields.issuetype != null ?
    jsonToIssueType(check request.fields.issuetype) : {}: {};

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
    target.resource_path = request.self.toString() ;
    target.id = request.id.toString() ;
    target.key = request.key.toString() ;

    target.priorityId = request.fields != null ?
    request.fields.priority != null ?
    request.fields.priority.id != null ?
    request.fields.priority.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.statusId = request.fields != null ?
    request.fields.status != null ?
    request.fields.status.id != null ?
    request.fields.status.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.issueType = request.fields != null ?
    request.fields.issuetype != null ?
    jsonToIssueType(check request.fields.issuetype) : {} : {};

return target;
}

function jsonToIssueType(json request) returns IssueType {

    IssueType target = {};

    target.resource_path = request.self != null ? request.self.toString()  : EMPTY_STRING;
    target.id = request.id != null ? request.id.toString()  : EMPTY_STRING;
    target.name = request.name != null ? request.name.toString()  : EMPTY_STRING;
    target.description = request.description != null ? request.description.toString()  : EMPTY_STRING;
    target.iconUrl = request.iconUrl != null ? request.iconUrl.toString()  : EMPTY_STRING;
    target.avatarId = request.avatarId != null ? request.avatarId.toString()  : EMPTY_STRING;

    return target;
}

function issueRequestToJson(IssueRequest request) returns json {

    map<json> target = {fields:{}};
    map<json> fieldJson = <map<json>>target["fields"];
    fieldJson["summary"] = request.summary != EMPTY_STRING ? request.summary : null;
    fieldJson["issuetype"] = request.issueTypeId != EMPTY_STRING ? {id:request.issueTypeId} : null;
    fieldJson["project"] = request.projectId != EMPTY_STRING ? {id:request.projectId} : null;
    fieldJson["assignee"] = request.assigneeName != EMPTY_STRING ? {name:request.assigneeName} : null;

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
    targetJsonObjectMap["name"] = <string>sourceGroupStruct.name;
    targetJsonObjectMap["description"] = <string>sourceGroupStruct.description;
    return targetJsonObject;
}

function convertJsonToProjectCategory(json sourceGroupStruct) returns ProjectCategory|error {
    ProjectCategory targetProjectCategory = {};
    targetProjectCategory.resource_path = sourceGroupStruct.self != null ? sourceGroupStruct.self.toString() : "";
    targetProjectCategory.id = sourceGroupStruct.id != null ? sourceGroupStruct.id.toString() : "";
    targetProjectCategory.name = sourceGroupStruct.name != null ? sourceGroupStruct.name.toString() : "";
    targetProjectCategory.description = sourceGroupStruct.description != null
    ? sourceGroupStruct.description.toString() : "";
    return targetProjectCategory;
}

function convertJsonToProject(json sourceGroupStruct) returns Project|error {
    Project targetProject = {};
    targetProject.resource_path = sourceGroupStruct.self != null ? sourceGroupStruct.self.toString() : "";
    targetProject.id = sourceGroupStruct.id != null ? sourceGroupStruct.id.toString() : "";
    targetProject.key = sourceGroupStruct.key != null ? sourceGroupStruct.key.toString() : "";
    targetProject.name = sourceGroupStruct.name != null ? sourceGroupStruct.name.toString() : "";
    targetProject.description = sourceGroupStruct.description != null ? sourceGroupStruct.description.toString() : "";
    targetProject.leadName = sourceGroupStruct.leadName != null ? sourceGroupStruct.leadName.toString() : "";
    targetProject.projectTypeKey = sourceGroupStruct.projectTypeKey != null
    ? sourceGroupStruct.projectTypeKey.toString() : "";
    targetProject.avatarUrls.'48x48 = sourceGroupStruct.avatarUrls.'48x48 != null
    ? sourceGroupStruct.avatarUrls.'48x48.toString() : "";
    targetProject.avatarUrls.'32x32 = sourceGroupStruct.avatarUrls.'32x32 != null
    ? sourceGroupStruct.avatarUrls.'32x32.toString() : "";
    targetProject.avatarUrls.'24x24 = sourceGroupStruct.avatarUrls.'24x24 != null
    ? sourceGroupStruct.avatarUrls.'24x24.toString() : "";
    targetProject.avatarUrls.'16x16 = sourceGroupStruct.avatarUrls.'16x16 != null
    ? sourceGroupStruct.avatarUrls.'16x16.toString() : "";
    targetProject.projectCategory.resource_path = sourceGroupStruct.projectCategory.self != null
    ? sourceGroupStruct.projectCategory.self.toString() : "";
    targetProject.projectCategory.id = sourceGroupStruct.projectCategory.id != null
    ? sourceGroupStruct.projectCategory.id.toString() : "";
    targetProject.projectCategory.name = sourceGroupStruct.self != null ? sourceGroupStruct.self.toString() : "";
    targetProject.projectCategory.description = sourceGroupStruct.projectCategory.description != null
    ? sourceGroupStruct.projectCategory.description.toString() : "";
    targetProject.issueTypes = convertToIssueTypes(<json[]>sourceGroupStruct.issueTypes);
    targetProject.components = convertToComponents(<json[]>sourceGroupStruct.components);
    targetProject.versions = convertToVersions(<json[]>sourceGroupStruct.versions);
    return targetProject;
}

function convertJsonToProjectStatus(json sourceGroupStruct) returns ProjectStatus|error {
    ProjectStatus targetProjectStatus = {};
    targetProjectStatus.resource_path = sourceGroupStruct.self != null ? sourceGroupStruct.self.toString() : "";
    targetProjectStatus.name = sourceGroupStruct.name != null ? sourceGroupStruct.name.toString() : "";
    targetProjectStatus.id = sourceGroupStruct.id != null ? sourceGroupStruct.id.toString() : "";
    targetProjectStatus.statuses = <json[]>sourceGroupStruct.statuses;
    return targetProjectStatus;
}

function convertJsonToUser(json sourceGroupStruct) returns User|error {
    User targetUser = {};
    targetUser.resource_path = sourceGroupStruct.self != null ? sourceGroupStruct.self.toString() : "";
    targetUser.key = sourceGroupStruct.key != null ? sourceGroupStruct.key.toString() : "";
    targetUser.name = sourceGroupStruct.name != null ? sourceGroupStruct.name.toString() : "";
    targetUser.displayName = sourceGroupStruct.displayName != null ? sourceGroupStruct.displayName.toString() : "";
    targetUser.emailAddress = sourceGroupStruct.emailAddress != null ? sourceGroupStruct.emailAddress.toString() : "";
    targetUser.avatarUrls = sourceGroupStruct.avatarUrls != null ? sourceGroupStruct.avatarUrls.toString() : "";
    targetUser.active = sourceGroupStruct.active != null ?  <boolean>sourceGroupStruct.active : false;
    targetUser.timeZone = sourceGroupStruct.timeZone != null ? sourceGroupStruct.timeZone.toString() : "";
    targetUser.locale = sourceGroupStruct.locale != null ? sourceGroupStruct.locale.toString() : "";
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
    issueTypes.resource_path = issueType.self != null ? issueType.self.toString() : "";
    issueTypes.id = issueType.id != null ? issueType.id.toString() : "";
    issueTypes.name = issueType.name != null ? issueType.name.toString() : "";
    issueTypes.description = issueType.description != null ? issueType.description.toString() : "";
    issueTypes.iconUrl = issueType.iconUrl != null ? issueType.iconUrl.toString() : "";
    issueTypes.avatarId = issueType.avatarId != null ? issueType.avatarId.toString() : "";
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
    component.id = components.id != null ? components.id.toString() : "";
    component.name = components.name != null ? components.name.toString() : "";
    component.description = components.description != null ? components.description.toString() : "";
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
    versions.resource_path = value.self != null ? value.self.toString() : "";
    versions.id = value.id != null ? value.id.toString() : "";
    versions.name = value.name != null ? value.name.toString() : "";
    versions.archived = value.archived != null ? <boolean>value.archived : false;
    versions.released = value.released != null ? <boolean>value.released : false;
    versions.releaseDate = value.releaseDate != null ? value.releaseDate.toString() : "";
    versions.overdue = value.overdue != null ? <boolean>value.overdue : false;
    versions.userReleaseDate = value.userReleaseDate != null ? value.userReleaseDate.toString() : "";
    versions.projectId = value.projectId != null ? value.projectId.toString() : "";
    return versions;
}

function convertJsonToProjectRole(json sourceGroupStruct) returns ProjectRole|error {
    ProjectRole targetProjectRole = {};
    targetProjectRole.resource_path = <string>sourceGroupStruct.self;
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
    value.id = actor.id != null ? actor.id.toString() : "";
    value.name = actor.name != null ? actor.name.toString() : "";
    value.displayName = actor.displayName != null ? actor.displayName.toString() : "";
    value.'type = actor.'type != null ? actor.'type.toString() : "";
    return value;
}
