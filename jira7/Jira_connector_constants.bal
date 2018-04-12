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
//                                          HTTP Status Codes                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@final public int STATUS_CODE_OK = 200;
@final public int STATUS_CODE_CREATED = 201;
@final public int STATUS_CODE_NO_CONTENT = 204;
@final public int STATUS_CODE_NOTFOUND = 404;
@final public int STATUS_CODE_INTERNAL_ERROR = 500;
@final public int STATUS_CODE_BAD_REQUEST = 400;
@final public int STATUS_CODE_UNAUTHORIZED = 401;
@final public int Status_CODE_CONFLICT = 409;

@final public string STATUS_CREATED = "CREATED";
@final public string STATUS_NOT_FOUND = "NOT-FOUND";
@final public string STATUS_BAD_REQUEST = "BAD-REQUEST";
@final public string STATUS_CONFLICT = "CONFLICT";
@final public string STATUS_INTERNEL_ERROR = "INTERNEL_ERROR";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Enums                                                             //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

type ProjectRoleType "10002"|"10030"|"10001"|"10011"|"10010"|"10020"|"10000";
@final ProjectRoleType ADMINISTRATORS = "10002";
@final ProjectRoleType CSAT_DEVELOPERS =  "10030";
@final ProjectRoleType DEVELOPERS = "10001";
@final ProjectRoleType EXTERNAL_CONSULTANTS = "10011";
@final ProjectRoleType NOTIFICATIONS = "10010";
@final ProjectRoleType OBSERVER = "10020";
@final ProjectRoleType USERS = "10000";

type ProjectType "software"|"business";
@final ProjectType SOFTWARE = "software";
@final ProjectType BUSINESS = "business";
