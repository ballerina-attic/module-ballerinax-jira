package jira;

import ballerina/io;
import ballerina/net.http;

public struct JiraConfiguration {
    http:ClientEndpointConfiguration httpClientConfig;
    string base_url;
}

public function <JiraConfiguration jiraConfig> JiraConfiguration() {
    jiraConfig.httpClientConfig = {};
}

public struct JiraConnectorEndpoint {
    JiraConfiguration jiraConfig;
    JiraConnector jiraConnector;
}

public function <JiraConnectorEndpoint jiraConnectorEP> init (JiraConfiguration jiraConfig) {

    http:ClientEndpointConfiguration httpConfig =  {targets:[{uri:jiraConfig.base_url+JIRA_REST_API_RESOURCE+JIRA_REST_API_VERSION}], chunking:http:Chunking.NEVER};
    jiraConfig.httpClientConfig = httpConfig;

    jiraConnectorEP.jiraConfig = jiraConfig;
    jiraConnectorEP.jiraConnector = {jiraHttpClientEPConfig:jiraConnectorEP.jiraConfig.httpClientConfig,
                                   base_url:jiraConnectorEP.jiraConfig.base_url};

    jira_base_url = jiraConnectorEP.jiraConnector.base_url == "" ?
                    WSO2_STAGING_JIRA_BASE_URL : jiraConnectorEP.jiraConnector.base_url;
    jira_authentication_ep = jira_base_url + JIRA_AUTH_RESOURCE;
    jira_rest_api_uri = jira_base_url + JIRA_REST_API_RESOURCE + JIRA_REST_API_VERSION;

}

public function <JiraConnectorEndpoint jiraConnectorEP> register(typedesc serviceType) {

}

public function <JiraConnectorEndpoint jiraConnectorEP> start() {

}

@Description { value:"Returns the connector that client code uses"}
@Return { value:"The connector that client code uses" }
public function <JiraConnectorEndpoint jiraConnectorEP> getClient() returns JiraConnector {
    return jiraConnectorEP.jiraConnector;
}

@Description { value:"Stops the registered service"}
@Return { value:"Error occured during registration" }
public function <JiraConnectorEndpoint jiraConnectorEP> stop() {

}



