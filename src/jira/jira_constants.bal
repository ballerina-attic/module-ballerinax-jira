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

const string JIRA_REST_API_RESOURCE = "/rest/api/";
const string JIRA_AUTH_RESOURCE = "/rest/auth/1/session/";
const string JIRA_REST_API_VERSION = "2";
const string API_PATH = "/rest/api/2";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          HTTP Status Codes                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

const int STATUS_CODE_OK = 200;
const int STATUS_CODE_CREATED = 201;
const int STATUS_CODE_NO_CONTENT = 204;
const int STATUS_CODE_NOTFOUND = 404;
const int STATUS_CODE_INTERNAL_ERROR = 500;
const int STATUS_CODE_BAD_REQUEST = 400;
const int STATUS_CODE_UNAUTHORIZED = 401;
const int Status_CODE_CONFLICT = 409;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                            Other Jira Constants                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

const string ROLE_ID_ADMINISTRATORS = "10002";
const string ROLE_ID_CSAT_DEVELOPERS = "10030";
const string ROLE_ID_DEVELOPERS = "10001";
const string ROLE_ID_EXTERNAL_CONSULTANTS = "10011";
const string ROLE_ID_NOTIFICATIONS = "10010";
const string ROLE_ID_OBSERVER = "10020";
const string ROLE_ID_USERS = "10000";

const string PROJECT_TYPE_SOFTWARE = "software";
const string PROJECT_TYPE_BUSINESS = "business";

const string EMPTY_STRING = "";

// Error Codes
const string JIRA_ERROR_CODE = "(ballerina/jira)JiraError";
const string CONVERSION_ERROR_CODE = "(ballerina/jira)ConversionError";
const string HTTP_ERROR_CODE = "(ballerina/jira)HTTPError";

