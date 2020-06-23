Connects to JIRA from Ballerina. 

# Module Overview

The JIRA connector allows you to view, create, update, and delete projects, project categories, project components, user 
accounts, and issues through the JIRA REST API. It handles basic authentication.

**JIRA Project Operations**

The `ballerina/jira` module contains operations to create new JIRA projects, update or delete existing projects, and get all 
the information using either the ID or key of the project. It also contains operations for adding or removing users and 
groups related to a project role, viewing user account details of the project lead, viewing assignable issue types for a 
given project, etc.

**JIRA Project Category Operations**

The `ballerina/jira` module contains operations that get all available project categories, delete existing categories, and 
create new project categories.

**JIRA Project Component Operations**

The `ballerina/jira` module contains operations that get all details of a given project component, delete existing 
components, create a new project component related to a specific project, etc.

**JIRA Issue Operations**

The `ballerina/jira` module contains operations that get all the details of a given issue using the issue key, delete existing 
issues, create new issues, etc.

## Compatibility
|                    |            Version          |  
|:------------------:|:---------------------------:|
| Ballerina Language |    Swan Lake Preview1       |
| JIRA REST API      |            7.13.0           |  

## Sample
First, import the `ballerina/jira` module into the Ballerina project and other modules.
```ballerina
import ballerina/jira;
import ballerina/http;
import ballerina/auth;
import ballerina/config;
```
**Obtaining Credentials to Run the Sample**

1. Visit [Atlassian](https://id.atlassian.com/signup) and create an Atlassian Account.
2. Obtain the following credentials and base URL.
    * Username
    * Password  

You can now enter the credentials in the HTTP client config.
```ballerina
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

jira:Client jiraClient = new(jiraConfig);

```

**Executing Sample**
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

The `getAllProjectSummaries` remote function returns the project summary of all the projects if successful or an `error` if unsuccessful.
```ballerina
var response = jiraClient->getAllProjectSummaries();
if (response is jira:ProjectSummary[]) {
    io:println("Project Summary: ", response);
} else {
    io:println("Error: ", response);
}
```

The `createProject` remote function creates a JIRA project with the given name. It returns a `Project` object if successful or an `error` if unsuccessful.
```ballerina
var output = jiraClient->createProject("TST_PROJECT");
if (output is jira:Project) {
    io:println("Project Details: ", output);
} else {
    io:println("Error: ", output.message);
}
```

The `createIssue` remote function creates an issue with the given issue details. `IssueRequest` is an object that contains all
the data that is required to create the issue. It returns an `Issue` object if successful or an `error` if unsuccessful.
```ballerina
jira:IssueRequest newIssue = {
    key: "TEST_ISSUE",
    summary: "This is a test issue created for the Ballerina JIRA Connector",
    issueTypeId: "10002",
    projectId: ”1234”,
    assigneeName: “username”
};
var issueResponse = jiraClient->createIssue(newIssue);
if (issueResponse is jira:Issue) {
    io:println("Issue Details: ", issueResponse);
} else {
    io:println("Error: ", issueResponse.message);
}
```
