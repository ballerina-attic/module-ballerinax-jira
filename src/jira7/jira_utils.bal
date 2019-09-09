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
import ballerina/io;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Functions                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# Checks whether the HTTP response contains any errors.
# + httpConnectorResponse - Response of the ballerina standard HTTP client
# + return - `json` payload of the server response when successful, else returns an error
function getValidatedResponse(http:Response|error httpConnectorResponse) returns @tainted json|error {

    //checks for any http errors
    if (httpConnectorResponse is error) {
        error err = error(HTTP_ERROR_CODE, cause = httpConnectorResponse,
            message = "Error occurred while invoking the JIRA REST API" );
        return err;
    } else {
        if (hasValidStatusCode(httpConnectorResponse)) { //if there is no any http connector error or jira server error
            var payloadOutput = httpConnectorResponse.getJsonPayload();
            if (payloadOutput is json) {
                return payloadOutput;
            } else {
                return null;

            }
        } else {
            
            error err = error(JIRA_ERROR_CODE, 
                message = "Status code " + io:sprintf("%s", httpConnectorResponse.statusCode) + ":"
                    + httpConnectorResponse.reasonPhrase );

            return err;
        }
    }
}

function hasValidStatusCode(http:Response response) returns boolean {
    int statusCode = response.statusCode;
    return statusCode == STATUS_CODE_OK || statusCode == STATUS_CODE_CREATED || statusCode == STATUS_CODE_NO_CONTENT;
}
