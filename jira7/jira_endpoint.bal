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

documentation{ Represents the Jira Client Connector Endpoint configuration.
    F{{httpClientConfig}} Http client endpoint configuration
    F{{url}} jira base url
}
public type JiraConfiguration {
    http:ClientEndpointConfig httpClientConfig;
    string url;
};

documentation{ Represents the Jira Client Connector Endpoint object.
    F{{jiraConfig}} jira client Connector endpoint configuration
    F{{jiraConnector}} jira client connector object
}
public type Client object {
    public {
        JiraConfiguration jiraConfig = {};
        JiraConnector jiraConnector = new;
    }

    documentation{ Jira connector endpoint initialization function.
        P{{userConfig}} Jira connector endpoint configuration
    }
    public function init (JiraConfiguration userConfig) {

        userConfig.httpClientConfig.targets = [{url:userConfig.url + JIRA_REST_API_RESOURCE +
            JIRA_REST_API_VERSION}];
        userConfig.httpClientConfig.chunking = "NEVER";

        jiraConnector.jiraHttpClientEPConfig = userConfig.httpClientConfig;
        jiraConnector.jira_base_url = userConfig.url;
        jiraConnector.jira_rest_api_ep = userConfig.url + JIRA_REST_API_RESOURCE + JIRA_REST_API_VERSION;

        jiraConfig = {url:userConfig.url, httpClientConfig:userConfig.httpClientConfig};
        jiraConnector.jiraHttpClient.init(userConfig.httpClientConfig);
    }

    documentation{Register Jira connector endpoint.
        P{{serviceType}} Accepts types of data (int, float, string, boolean, etc)
    }
    public function register (typedesc serviceType) {}

    documentation{Start Jira connector client endpoint.}
    public function start () {}

    documentation{Stop Jira connector client endpoint.}
    public function stop () {}

    documentation{Returns the Jira connector client.
        R{{JiraConnector}} The Jira connector client
    }
    public function getClient () returns JiraConnector {
        return jiraConnector;
    }
};
