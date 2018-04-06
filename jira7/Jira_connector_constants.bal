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

package jira7;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                      Configuration Constants                                                       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@final public string WSO2_STAGING_JIRA_BASE_URL = "https://support-staging.wso2.com";
@final public string JIRA_REST_API_RESOURCE = "/jira/rest/api/";
@final public string JIRA_AUTH_RESOURCE = "/jira/rest/auth/1/session/";
@final public string WSO2_STAGING_JIRA_REST_API_URL =  WSO2_STAGING_JIRA_BASE_URL + JIRA_REST_API_RESOURCE;
@final public string JIRA_REST_API_VERSION = "2";
@final public string WSO2_STAGING_JIRA_REST_API_ENDPOINT = WSO2_STAGING_JIRA_REST_API_URL + JIRA_REST_API_VERSION;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          Entity Constants                                                          //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          HTTP Status Codes                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public int STATUS_CODE_OK = 200;
public int STATUS_CODE_CREATED = 201;
public int STATUS_CODE_NO_CONTENT = 204;
public int STATUS_CODE_NOTFOUND = 404;
public int STATUS_CODE_INTERNAL_ERROR = 500;
public int STATUS_CODE_BAD_REQUEST = 400;
public int STATUS_CODE_UNAUTHORIZED = 401;
public int Status_CODE_CONFLICT = 409;

public string STATUS_CREATED = "CREATED";
public string STATUS_NOT_FOUND = "NOT-FOUND";
public string STATUS_BAD_REQUEST = "BAD-REQUEST";
public string STATUS_CONFLICT = "CONFLICT";
public string STATUS_INTERNEL_ERROR = "INTERNEL_ERROR";


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Enums                                                             //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


string ADMINISTRATORS = "10002";
string CSAT_DEVELOPERS = "10030";
string DEVELOPERS = "10001";
string EXTERNAL_CONSULTANTS = "10011";
string NOTIFICATIONS = "10010";
string OBSERVER = "10020";
string USERS = "10000";

type ProjectRoleType ADMINISTRATORS|CSAT_DEVELOPERS|DEVELOPERS|EXTERNAL_CONSULTANTS|NOTIFICATIONS|OBSERVER|USERS;

type ProjectType "software"|"business";

//public enum ProjectRoleType {
//    DEVELOPERS, EXTERNAL_CONSULTANT, OBSERVER, ADMINISTRATORS, USERS, CSAT_ADMINISTRATORS, NOTIFICATIONS
//}
//
//
//
//public enum ProjectType {
//    SOFTWARE, BUSINESS
//}
