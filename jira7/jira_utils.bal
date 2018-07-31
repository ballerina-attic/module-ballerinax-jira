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
import ballerina/mime;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Functions                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

documentation{Checks whether the http response contains any errors.
    P{{httpConnectorResponse}} response of the ballerina standard http client
    R{{^"json"}} json payload of the server response
    R{{JiraConnectorError}} 'JiraConnectorError' type record
}
function getValidatedResponse(http:Response|error httpConnectorResponse) returns json|JiraConnectorError {

    //checks for any http errors
    match httpConnectorResponse {
        error err => {
            JiraConnectorError e = {
                ^"type": "Http Connector Error",
                message: err.message,
                cause: err.cause
            };
            return e;
        }
        http:Response response => {

            if (hasValidStatusCode(response)) { //if there is no any http connector error or jira server error
                var payloadOutput = response.getJsonPayload();
                match payloadOutput {
                    json jsonOut => return jsonOut;
                    error e => {
                        return null;
                    }
                }
            } else {
                JiraConnectorError e = {
                    ^"type": "Jira Server Error",
                    message: string `status {{<string>response.statusCode}}: {{response.reasonPhrase}}`
                };

                //Extracting the error response from the JSON payload of the Jira server response
                match response.getJsonPayload() {
                    json jsonPayload => e.jiraServerErrorLog = jsonPayload;
                    error => e.jiraServerErrorLog = null;
                }
                return e;
            }
        }
    }
}

function hasValidStatusCode(http:Response response) returns boolean {
    int statusCode = response.statusCode;
    return statusCode == STATUS_CODE_OK || statusCode == STATUS_CODE_CREATED || statusCode == STATUS_CODE_NO_CONTENT;
}
