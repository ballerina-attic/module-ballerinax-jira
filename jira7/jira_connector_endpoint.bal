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

import ballerina/io;
import ballerina/http;

public type JiraConfiguration {
    http:ClientEndpointConfiguration httpClientConfig;
    string url;
    string username;
    string password;
};



public type Client object {
    public {
        JiraConfiguration jiraConfig = {};
        JiraConnector jiraConnector = new;
    }


    @Description {value: "Jira connector endpoint initialization function"}
    @Param {value: "userConfig: Jira connector configuration"}
    public function init (JiraConfiguration userConfig) {

        http:ClientEndpointConfiguration httpConfig = {targets:[{url:userConfig.url + JIRA_REST_API_RESOURCE +
                                                                     JIRA_REST_API_VERSION}],
                                                          chunking:"NEVER"
                                                      };
        userConfig.httpClientConfig = httpConfig;

        jiraConnector.jiraHttpClientEPConfig = userConfig.httpClientConfig;
        jiraConnector.jira_base_url = userConfig.url;
        jiraConnector.jira_rest_api_ep = userConfig.url + JIRA_REST_API_RESOURCE + JIRA_REST_API_VERSION;

        jiraConnector.setBase64EncodedCredentials(userConfig.username, userConfig.password);

        jiraConfig = {url:userConfig.url, httpClientConfig:userConfig.httpClientConfig};
        jiraConnector.jiraHttpClient.init(userConfig.httpClientConfig);
    }

    @Description {value: "Register Jira connector endpoint"}
    @Param {value: "typedesc: Accepts types of data (int, float, string, boolean, etc)"}
    public function register (typedesc serviceType) {}

    @Description {value: "Start Jira connector client endpoint"}
    public function start () {}

    @Description {value: "Stop Jira connector client endpoint"}
    public function stop () {}

    @Description {value:"Returns the Jira connector client"}
    @Return {value:"The Jira connector client"}
    public function getClient () returns JiraConnector {
        return jiraConnector;
    }
};





