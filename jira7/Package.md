# Ballerina Jira Connector
This Ballerina client Connector allows to connect to [Atlassian JIRA](https://www.jira.com), an online issue-tracking database. It provides bug tracking, 
issue tracking, and project management functions.
The Connector uses the [JIRA REST API version 7.2.2](https://docs.atlassian.com/software/jira/docs/api/REST/7.2.2/) to connect to JIRA, work with JIRA projects, 
view and update issues, work with jira user accounts, and more.

### Compatibility

| Ballerina Version | Jira REST API Version |
|:-------------------:|:-------------------:|
|0.970.0-beta3|7.2.2|

The following sections provide information on how to use Ballerina Jira Connector.

- [Getting started](#getting-started)
- [Authentication](#authentication)
- [Working with Jira Connector Actions](#working-with-jira-connector-actions)


## Getting started

- Refer `https://ballerina.io/learn/getting-started/` to download Ballerina and install tools.

- Create a new Ballerina project by executing the following command.
  
  `<PROJECT_ROOT_DIRECTORY>$ ballerina init`
  
- Import the jira package to your Ballerina program as follows.This will download the jira7 artifacts from the 
`ballerina central` to your local repository.

```ballerina
   import wso2/jira7;
```

## Authentication

> **Note -** 
*JIRA’s REST API is protected by the same restrictions which are provided via JIRAs standard web interface.
This means that if you do not have valid jira credentials, you are accessing JIRA anonymously. Furthermore, 
if you log in and do not have permission to view something in JIRA, you will not be able to view it using the 
Ballerina JIRA Connector as well.*

Ballerina Jira connector currently provides basic authentication as the authentication method.  
Please follow the following steps to authenticate your connector.
     
- Obtain your Jira user account credentials(username and password).
  If you currently dont have a Jira account, you can create a new Jira account from 
  [JIRA Sign-Up Page](https://id.atlassian.com/signup?application=mac&tenant=&continue=https%3A%2F%2Fmy.atlassian.com).

- Provide the credentials to your endpoint in the initialization step, as shown 
in the following sample code.
```Ballerina

      import wso2/jira7;
          
      //Creation of connector endpoint
      endpoint jira7:Client jiraEndpoint {
          url:"https://support-staging.wso2.com",
          httpClientConfig:{
              auth:{
                  scheme:"basic",
                  username:"username",
                  password:"password"
              }
          } 
      };

```

## Working with Jira connector actions

All actions of Jira Connector are **single-return type actions**, which will returns either response or an error.
Response can be either a `ballerina record` or a boolean value,depending on the context.
Error response is also a ballerina record of type`JiraConnectorError`. 

If a action was successfull, then the requested struct object or boolean `true` response will be returned or otherwise 
will returns an Connector error with error message,error type and cause.

### Example
* Request 
```ballerina
   import wso2/jira7;
       
   //Creating the jira endpoint
   endpoint jira7:Client jiraEndpoint {
        url:"https://support-staging.wso2.com",
        httpClientConfig:{
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
    
```

* Response Object
```ballerina
public type Project {
    string self;
    string id;
    string key;
    string name;
    string description;
    string leadName;
    string projectTypeKey;
    AvatarUrls avatarUrls;
    ProjectCategory projectCategory;
    IssueType[] issueTypes;
    ProjectComponentSummary[] components;
    ProjectVersion[] versions;
}
```

* Error Object
```ballerina
public type JiraConnectorError {
    string message;
    error? cause;
    string ^"type";
    json jiraServerErrorLog;   
}
```