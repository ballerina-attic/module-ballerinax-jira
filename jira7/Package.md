# Ballerina Jira Connector

Allows connecting Atlassian JIRA REST API.

This Ballerina client connector uses the JIRA REST API to connect to JIRA, work with JIRA projects, view and update 
issues, work with jira user accounts, and more. It also handles basic authentication, provides auto completion and 
type conversions.
                                                                        
## Compatibility

| Ballerina Version | Jira REST API Version |
|:-------------------:|:-------------------:|
|0.970.0-beta14|7.2.2|

## Getting started

1. Refer `https://ballerina.io/learn/getting-started/` to download Ballerina and install tools.

2. Ballerina Jira connector currently provides basic authentication as the authentication method. Therefore obtain your 
   Jira user account credentials(username and password).If you currently dont have a Jira account, you can create a new Jira account from 
   [JIRA Sign-Up Page](https://id.atlassian.com/signup?application=mac&tenant=&continue=https%3A%2F%2Fmy.atlassian.com).
   
   *Note -JIRA’s REST API is protected by the same restrictions which are provided via JIRAs standard web interface.
    This means that if you do not have valid jira credentials, you are accessing JIRA anonymously. Furthermore, 
    if you log in and do not have permission to view something in JIRA, you will not be able to view it using the 
    Ballerina JIRA Connector as well.*

3. Create a new Ballerina project by executing the following command.
      ```shell
        <PROJECT_ROOT_DIRECTORY>$ ballerina init`
      ```
  
4. Import the jira package to your Ballerina program as follows.This will download the jira7 artifacts from the 
`ballerina central` to your local repository.

    ```ballerina
       import wso2/jira7;
    ```

5. Provide the credentials to your endpoint in the initialization step, and use as shown 
in the following sample code.

    ```ballerina
       import wso2/jira7 as jira;
       
       function main(string... args) { 
         
           //Creating the jira endpoint
           endpoint jira:Client jiraEndpoint {
                
                httpClientConfig:{
                    url:"https://support-staging.wso2.com/jira",
                    auth:{
                        scheme:"basic",
                        username:"username",
                        password:"password"
                    }
                }
           };
           
           jira:JiraConnectorError jiraError = {};
           jira:Project project = {};
           string projectKey = "RRDEVSPRT";    
           //Endpoint Action
           var result = jiraEndpoint -> getProject(projectKey);
           match result{
               jira:Project p => project = p;
               jira:JiraConnectorError e => jiraError = err;
           }
       }
        
    ```