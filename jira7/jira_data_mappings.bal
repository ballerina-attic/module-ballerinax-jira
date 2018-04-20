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

function errorToJiraConnectorError(error source) returns JiraConnectorError {
    JiraConnectorError target = source.message != EMPTY_STRING ? {message:source.message, cause:source.cause} : {};
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

    target.self = source.self.toString() ;
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

    target.self = source.self != null ? source.self.toString()  : EMPTY_STRING;
    target.name = source.name != null ? source.name.toString()  : EMPTY_STRING;
    target.id = source.id != null ? source.id.toString()  : EMPTY_STRING;
    target.description = source.description != null ? source.description.toString()  : EMPTY_STRING;

    return target;
}

function jsonToProjectComponent(json source) returns ProjectComponent {

    ProjectComponent target = {};

    target.self = source.self != null ? source.self.toString()  : EMPTY_STRING;
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
    target.self = source.self.toString() ;
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
    foreach (fieldName in fieldNames) {
        if (fieldName.hasPrefix("customfield")) {
            target.customFields[i] = {(fieldName):source.fields[fieldName]};
            i +=1;
        }
    }

return target;
}

function jsonToIssueSummary(json source) returns IssueSummary {
    IssueSummary target = {};
    target.self = source.self.toString() ;
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

    target.self = source.self != null ? source.self.toString()  : EMPTY_STRING;
    target.id = source.id != null ? source.id.toString()  : EMPTY_STRING;
    target.name = source.name != null ? source.name.toString()  : EMPTY_STRING;
    target.description = source.description != null ? source.description.toString()  : EMPTY_STRING;
    target.iconUrl = source.iconUrl != null ? source.iconUrl.toString()  : EMPTY_STRING;
    target.avatarId = source.avatarId != null ? source.avatarId.toString()  : EMPTY_STRING;

    return target;
}

function issueRequestToJson(IssueRequest source) returns json {

    json target = {fields:{}};

    target.key = source.key != EMPTY_STRING ? source.key : null;
    target.fields.summary = source.summary != EMPTY_STRING ? source.summary : null;
    target.fields.issuetype = source.issueTypeId != EMPTY_STRING ? {id:source.issueTypeId} : null;
    target.fields.project = source.projectId != EMPTY_STRING ? {id:source.projectId} : null;
    target.fields.assignee = source.assigneeName != EMPTY_STRING ? {name:source.assigneeName} : null;

    return target;
}
