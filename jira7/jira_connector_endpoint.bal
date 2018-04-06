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

//import ballerina/io;
//import ballerina/http;
//
//public struct JiraConfiguration {
//    http:ClientEndpointConfiguration httpClientConfig;
//    string url;
//    string username;
//    string password;
//}
//
//public function <JiraConfiguration jiraConfig> JiraConfiguration () {
//    jiraConfig.httpClientConfig = {};
//}
//
//public struct JiraEndpoint {
//    JiraConfiguration jiraConfig;
//    JiraConnector jiraConnector;
//}
//
//public function <JiraEndpoint jiraEP> init (JiraConfiguration userConfig) {
//
//    http:ClientEndpointConfiguration httpConfig = {targets:[{url:userConfig.url + JIRA_REST_API_RESOURCE +
//                                                                 JIRA_REST_API_VERSION}],
//                                                      chunking:http:Chunking.NEVER
//                                                  };
//    userConfig.httpClientConfig = httpConfig;
//
//    jiraEP.jiraConnector = {
//       jiraHttpClientEPConfig:jiraEP.jiraConfig.httpClientConfig,
//       jira_base_url:userConfig.url,
//       jira_authentication_ep:userConfig.url + JIRA_AUTH_RESOURCE,
//       jira_rest_api_ep:userConfig.url + JIRA_REST_API_RESOURCE + JIRA_REST_API_VERSION
//    };
//
//    jiraEP.jiraConnector.setBase64EncodedCredentials(userConfig.username, userConfig.password);
//
//    jiraEP.jiraConfig = {url:userConfig.url, httpClientConfig:userConfig.httpClientConfig};
//    jiraEP.jiraConnector.jiraHttpClientEP.init(jiraEP.jiraConfig.httpClientConfig);
//}
//
//@Description {value:"Returns the connector that client code uses"}
//@Return {value:"The connector that client code uses"}
//public function <JiraEndpoint jiraConnectorEP> getClient () returns JiraConnector {
//    return jiraConnectorEP.jiraConnector;
//}

