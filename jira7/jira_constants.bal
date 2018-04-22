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

@final public string JIRA_REST_API_RESOURCE = "/rest/api/";
@final public string JIRA_AUTH_RESOURCE = "/rest/auth/1/session/";
@final public string JIRA_REST_API_VERSION = "2";

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                            Other Jira Constants                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@final string ROLE_ID_ADMINISTRATORS = "10002";
@final string ROLE_ID_CSAT_DEVELOPERS = "10030";
@final string ROLE_ID_DEVELOPERS = "10001";
@final string ROLE_ID_EXTERNAL_CONSULTANTS = "10011";
@final string ROLE_ID_NOTIFICATIONS = "10010";
@final string ROLE_ID_OBSERVER = "10020";
@final string ROLE_ID_USERS = "10000";

@final string PROJECT_TYPE_SOFTWARE = "software";
@final string PROJECT_TYPE_BUSINESS = "business";

@final string EMPTY_STRING = "";