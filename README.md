[![Build Status](https://travis-ci.org/ballerina-platform/module-jira.svg?branch=master)](https://travis-ci.org/ballerina-platform/module-jira)

# Ballerina JIRA Connector
This Ballerina client connector allows to connect to Atlassian JIRA, which provides bug tracking, issue tracking, 
and project management functions. It uses the JIRA REST API to connect to JIRA, work with JIRA 
projects, view and update issues, work with jira user accounts, and more. It also handles basic authentication, 
provides auto completion and type conversions.

![Overview](docs/resources/Overview.png)

### Compatibility

| Ballerina Version      | JIRA REST API Version |
|:----------------------:|:---------------------:|
|  Swan Lake Preview1    |       7.13.0          |


### Why do you need the REST API for JIRA

The JIRA REST API is an ideal solution for the developers who want to integrate JIRA with other standalone or web applications, 
and administrators who want to script interactions with the JIRA server. Because the JIRA REST API is based on open 
standards, you can use any web development language to access the API.


The following sections provide information on how to use Ballerina JIRA Connector.

- [Getting started](#getting-started)
- [Authentication](#authentication)
- [Working with JIRA Connector Actions](#working-with-jira-connector-actions)


## Getting started

- Refer `https://ballerina.io/learn/getting-started/` to download Ballerina and install tools.

- Create a new Ballerina project by executing the following command.
  
  `<PROJECT_ROOT_DIRECTORY>$ ballerina init`
  
- Import the jira module to your Ballerina program as follows.This will download the jira artifacts from the 
`ballerina central` to your local repository.

```ballerina
   import ballerina/jira;
```

## Authentication

> **Note -** 
*JIRA’s REST API is protected by the same restrictions which are provided via JIRAs standard web interface.
This means that if you do not have valid jira credentials, you are accessing JIRA anonymously. Furthermore, 
if you log in and do not have permission to view something in JIRA, you will not be able to view it using the 
Ballerina JIRA Connector as well.*

Ballerina JIRA connector currently provides basic authentication as the authentication method.  
Please follow the following steps to authenticate your connector.
     
- Obtain your JIRA user account credentials(username and password).
  If you currently dont have a JIRA account, you can create a new JIRA account from 
  [JIRA Sign-Up Page](https://id.atlassian.com/signup?application=mac&tenant=&continue=https%3A%2F%2Fmy.atlassian.com).

- Provide the credentials to your endpoint in the initialization step, as shown 
in the following sample code. A sample JIRA_URL would be "http://localhost:8080/rest/api/2"

```ballerina
import ballerina/http;
import ballerina/jira;
import ballerina/auth;
import ballerina/config;

string USERNAME = config:getAsString("USERNAME");
string API_TOKEN = config:getAsString("JIRA_API_TOKEN");
string BASE_URL = config:getAsString("BASE_URL");

jira:BasicAuthConfiguration basicAuth = {
    username: USERNAME,
    apiToken: API_TOKEN
};

jira:Configuration jiraConfig = {
    baseUrl: BASE_URL,
    authConfig: basicAuth
};

jira:Client jiraConnectorEP = new(jiraConfig);

```

## Working with JIRA connector actions

All actions of the JIRA connector return either the response or an error.

If a action was successfull, then the requested struct object or boolean `true` response will be returned or otherwise 
will returns an Connector error with error message,error type and cause.

### Example
* Request 

```ballerina
import ballerina/http;
import ballerina/jira;
import ballerina/auth;
import ballerina/config;
import ballerina/io;

string USERNAME = config:getAsString("USERNAME");
string API_TOKEN = config:getAsString("JIRA_API_TOKEN");
string BASE_URL = config:getAsString("BASE_URL");

jira:BasicAuthConfiguration basicAuth = {
    username: USERNAME,
    apiToken: API_TOKEN
};

jira:Configuration jiraConfig = {
    baseUrl: BASE_URL,
    authConfig: basicAuth
};

jira:Client jiraConnectorEP = new(jiraConfig);

public function main(string... args) {

    jira:ProjectCategoryRequest newCategory = { name: "Test-Project Category", description: "new category created from balleirna jira connector" };
    var output = jiraConnectorEP->createProjectCategory(newCategory);

    io:println(output.toString());

}
```

* Response Object

```ballerina
{
  "self": "http://localhost:8080/rest/api/2/projectCategory/10010",
  "id": "10010",
  "description": "new category created from balleirna jira connector",
  "name": "Test-Project Category"
}
```

Now that you have basic knowledge about to how Ballerina JIRA endpoint works, 
use the information in the following sections to perform various operations with the endpoint.

- [Working with Projects in JIRA](#working-with-projects-in-jira)

- [Working with Project Categories in JIRA](#working-with-project-categories-in-jira)

- [Working with Project Components in JIRA](#working-with-project-components-in-jira)

- [Working with Issues in JIRA](#working-with-issues-in-jira)


***
### Working with Projects in JIRA
***
#### API Reference
- getAllProjectSummaries()
- getAllDetailsFromProjectSummary()
- getProject()
- createProject()
- updateProject()
- deleteProject()
- getLeadUserDetailsOfProject()
- getRoleDetailsOfProject()
- addUserToRoleOfProject()
- addGroupToRoleOfProject()
- removeUserFromRoleOfProject()
- removeGroupFromRoleOfProject()
- getAllIssueTypeStatusesOfProject()
- changeTypeOfProject()

***
### Working with Project Categories in JIRA
***
#### API Reference
- getAllProjectCategories()
- createProjectCategory()
- getProjectCategory()
- deleteProjectCategory()

***
### Working with Project Components in JIRA
***
#### API Reference
- createProjectComponent()
- getProjectComponent()
- deleteProjectComponent()
- getAssigneeUserDetailsOfProjectComponent()
- getLeadUserDetailsOfProjectComponent()

***
### Working with Issues in JIRA
***
#### API Reference
- createIssue()
- updateIssue()
- deleteIssue()
