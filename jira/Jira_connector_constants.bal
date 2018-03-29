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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                      Configuration Constants                                                       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

string WSO2_STAGING_JIRA_BASE_URL = "https://support-staging.wso2.com";
string JIRA_REST_API_RESOURCE = "/jira/rest/api/";
string JIRA_AUTH_RESOURCE = "/jira/rest/auth/1/session/";
string WSO2_STAGING_JIRA_REST_API_URL =  WSO2_STAGING_JIRA_BASE_URL + JIRA_REST_API_RESOURCE;
string JIRA_REST_API_VERSION = "2";
string WSO2_STAGING_JIRA_REST_API_ENDPOINT = WSO2_STAGING_JIRA_REST_API_URL + JIRA_REST_API_VERSION;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          Entity Constants                                                          //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public const string ROLE_ID_ADMINISTRATORS = "10002";
public const string ROLE_ID_CSAT_DEVELOPERS = "10030";
public const string ROLE_ID_DEVELOPERS = "10001";
public const string ROLE_ID_EXTERNAL_CONSULTANTS = "10011";
public const string ROLE_ID_NOTIFICATIONS = "10010";
public const string ROLE_ID_OBSERVER = "10020";
public const string ROLE_ID_USERS = "10000";


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          HTTP Status Codes                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public const int STATUS_CODE_OK = 200;
public const int STATUS_CODE_CREATED = 201;
public const int STATUS_CODE_NO_CONTENT = 204;
public const int STATUS_CODE_NOTFOUND = 404;
public const int STATUS_CODE_INTERNAL_ERROR = 500;
public const int STATUS_CODE_BAD_REQUEST = 400;
public const int STATUS_CODE_UNAUTHORIZED = 401;
public const int Status_CODE_CONFLICT = 409;

public const string STATUS_CREATED = "CREATED";
public const string STATUS_NOT_FOUND = "NOT-FOUND";
public const string STATUS_BAD_REQUEST = "BAD-REQUEST";
public const string STATUS_CONFLICT = "CONFLICT";
public const string STATUS_INTERNEL_ERROR = "INTERNEL_ERROR";