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
import ballerina/config;
import ballerina/mime;
import ballerina/log;

function errorToJiraConnectorError(error source) returns JiraConnectorError {
    JiraConnectorError target = {
        message: <string>source.detail().message
    };
    return target;
}

function projectRequestToJson(ProjectRequest source) returns json {

    json target = {};

    target.key = source.key != EMPTY_STRING ? source.key : null;
    target.name = source.name != EMPTY_STRING ? source.name : null;
    target.projectTypeKey = source.projectTypeKey != EMPTY_STRING ? source.projectTypeKey : null;
    target.projectTemplateKey = source.projectTemplateKey != EMPTY_STRING ? source.projectTemplateKey : null;
    target.description = source.description != EMPTY_STRING ? source.description : null;
    target.lead = source.lead != EMPTY_STRING ? source.lead : null;
    target.url = source.url != EMPTY_STRING ? source.url : null;
    target.assigneeType = source.assigneeType != EMPTY_STRING ? source.assigneeType : null;
    target.avatarId = source.avatarId != EMPTY_STRING ? source.avatarId : null;
    target.issueSecurityScheme = source.issueSecurityScheme != EMPTY_STRING ? source.issueSecurityScheme : null;
    target.permissionScheme = source.permissionScheme != EMPTY_STRING ? source.permissionScheme : null;
    target.notificationScheme = source.notificationScheme != EMPTY_STRING ? source.notificationScheme : null;
    target.categoryId = source.categoryId != EMPTY_STRING ? source.categoryId : null;

    return target;
}

function jsonToProjectSummary(json source) returns ProjectSummary {

    ProjectSummary target = {};

    target.resource_path = source.self.toString() ;
    target.id = source.id.toString() ;
    target.key = source.key.toString() ;
    target.name = source.name.toString() ;
    target.description = source.description != null ? source.description.toString()  : EMPTY_STRING;
    target.projectTypeKey = source.projectTypeKey.toString() ;
    target.category = source.projectCategory != null ? source.projectCategory.name.toString()  : EMPTY_STRING;

    return target;
}

function jsonToProjectCategory(json source) returns ProjectCategory {

    ProjectCategory target = {};

    target.resource_path = source.self != null ? source.self.toString()  : EMPTY_STRING;
    target.name = source.name != null ? source.name.toString()  : EMPTY_STRING;
    target.id = source.id != null ? source.id.toString()  : EMPTY_STRING;
    target.description = source.description != null ? source.description.toString()  : EMPTY_STRING;

    return target;
}

function jsonToProjectComponent(json source) returns ProjectComponent {

    ProjectComponent target = {};

    target.resource_path = source.self != null ? source.self.toString()  : EMPTY_STRING;
    target.id = source.id != null ? source.id.toString()  : EMPTY_STRING;
    target.name = source.name != null ? source.name.toString()  : EMPTY_STRING;
    target.description = source.description != null ? source.description.toString()  : EMPTY_STRING;
    target.assigneeType = source.assigneeType != null ? source.assigneeType.toString()  : EMPTY_STRING;
    target.realAssigneeType = source.realAssigneeType != null ? source.realAssigneeType.toString()  : EMPTY_STRING;
    target.project = source.project != null ? source.project.toString()  : EMPTY_STRING;
    target.projectId = source.projectId != null ? source.projectId.toString()  : EMPTY_STRING;

    target.leadName = source.lead != null ?
    source.lead.name != null ?
    source.lead.name.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.assigneeName = source.assignee != null ?
    source.assignee.name != null ?
    source.assignee.name.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.realAssigneeName = source.realAssignee != null ?
    source.realAssignee.name != null ?
    source.realAssignee.name.toString()  : EMPTY_STRING : EMPTY_STRING;

    return target;
}

function jsonToIssue(json source) returns Issue {
    Issue target = {};
    target.resource_path = source.self.toString() ;
    target.id = source.id.toString() ;
    target.key = source.key.toString() ;

    target.summary = source.fields != null ?
    source.fields.summary != null ?
    source.fields.summary.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.creatorName = source.fields != null ?
    source.fields.creator != null ?
    source.fields.creator.name != null ?
    source.fields.creator.name.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.assigneeName = source.fields != null ?
    source.fields.assignee != null ?
    source.fields.assignee.name != null ?
    source.fields.assignee.name.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.reporterName = source.fields != null ?
    source.fields.reporter != null ?
    source.fields.reporter.name != null ?
    source.fields.reporter.name.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.priorityId = source.fields != null ?
    source.fields.priority != null ?
    source.fields.priority.id != null ?
    source.fields.priority.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.resolutionId = source.fields != null ?
    source.fields.resolution != null ?
    source.fields.resolution.id != null ?
    source.fields.resolution.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.statusId = source.fields != null ?
    source.fields.status != null ?
    source.fields.status.id != null ?
    source.fields.status.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.timespent = source.fields != null ?
    source.fields.timespent != null ?
    source.fields.timespent.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.aggregatetimespent = source.fields != null ?
    source.fields.aggregatetimespent != null ?
    source.fields.aggregatetimespent.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.createdDate = source.fields != null ?
    source.fields.created != null ?
    source.fields.created.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.dueDate = source.fields != null ?
    source.fields.duedate != null ?
    source.fields.duedate.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.resolutionDate = source.fields != null ?
    source.fields.resolutiondate != null ?
    source.fields.resolutiondate.toString()  : EMPTY_STRING : EMPTY_STRING;

    target.project = source.fields != null ?
    source.fields.project != null ?
    jsonToProjectSummary(source.fields.project) : {}: {};

    target.parent= source.fields != null ?
    source.fields.parent != null ?
    jsonToIssueSummary(source.fields.parent): {}: {};

    target.issueType= source.fields != null ?
    source.fields.issuetype != null ?
    jsonToIssueType(source.fields.issuetype) : {}: {};

    int i = 0;
    string[] fieldNames = source.fields.getKeys();
    foreach var fieldName in fieldNames {
        if (fieldName.hasPrefix("customfield")) {
            target.customFields[i] = {(fieldName):source.fields[fieldName]};
            i +=1;
        }
    }
    target.comments = jsonToIssueComments(<json[]>source.fields.comment.comments);
    return target;
}

function jsonToIssueSummary(json source) returns IssueSummary {
    IssueSummary target = {};
    target.resource_path = source.self.toString() ;
    target.id = source.id.toString() ;
    target.key = source.key.toString() ;

    target.priorityId = source.fields != null ?
    source.fields.priority != null ?
    source.fields.priority.id != null ?
    source.fields.priority.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.statusId = source.fields != null ?
    source.fields.status != null ?
    source.fields.status.id != null ?
    source.fields.status.id.toString()  : EMPTY_STRING : EMPTY_STRING : EMPTY_STRING;

    target.issueType = source.fields != null ?
    source.fields.issuetype != null ?
    jsonToIssueType(source.fields.issuetype) : {} : {};

return target;
}

function jsonToIssueType(json source) returns IssueType {

    IssueType target = {};

    target.resource_path = source.self != null ? source.self.toString()  : EMPTY_STRING;
    target.id = source.id != null ? source.id.toString()  : EMPTY_STRING;
    target.name = source.name != null ? source.name.toString()  : EMPTY_STRING;
    target.description = source.description != null ? source.description.toString()  : EMPTY_STRING;
    target.iconUrl = source.iconUrl != null ? source.iconUrl.toString()  : EMPTY_STRING;
    target.avatarId = source.avatarId != null ? source.avatarId.toString()  : EMPTY_STRING;

    return target;
}

function issueRequestToJson(IssueRequest source) returns json {

    json target = {fields:{}};
    target.fields.summary = source.summary != EMPTY_STRING ? source.summary : null;
    target.fields.issuetype = source.issueTypeId != EMPTY_STRING ? {id:source.issueTypeId} : null;
    target.fields.project = source.projectId != EMPTY_STRING ? {id:source.projectId} : null;
    target.fields.assignee = source.assigneeName != EMPTY_STRING ? {name:source.assigneeName} : null;

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
    targetJsonObject.name = <string>sourceGroupStruct.name;
    targetJsonObject.description = <string>sourceGroupStruct.description;
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
    targetProject.avatarUrls.^"48x48" = sourceGroupStruct.avatarUrls.^"48x48" != null
    ? sourceGroupStruct.avatarUrls.^"48x48".toString() : "";
    targetProject.avatarUrls.^"32x32" = sourceGroupStruct.avatarUrls.^"32x32" != null
    ? sourceGroupStruct.avatarUrls.^"32x32".toString() : "";
    targetProject.avatarUrls.^"24x24" = sourceGroupStruct.avatarUrls.^"24x24" != null
    ? sourceGroupStruct.avatarUrls.^"24x24".toString() : "";
    targetProject.avatarUrls.^"16x16" = sourceGroupStruct.avatarUrls.^"16x16" != null
    ? sourceGroupStruct.avatarUrls.^"16x16".toString() : "";
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
    value.^"type" = actor.^"type" != null ? actor.^"type".toString() : "";
    return value;
}
