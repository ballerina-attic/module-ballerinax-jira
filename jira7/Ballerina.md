# Ballerina Jira Connector

This Ballerina client connector allows to connect to [Atlassian JIRA](https://www.jira.com), an online issue-tracking database. It provides bug tracking, 
issue tracking, and project management functions.
The connector uses the [JIRA REST API version 7.2.2](https://docs.atlassian.com/software/jira/docs/api/REST/7.2.2/) to connect to JIRA, work with JIRA projects, 
view and update issues, work with jira user accounts, and more.
![Overview](Overview.png)

|Connector Version | Ballerina Version | API Version |
|:------------------:|:-------------------:|:-------------------:|
|0.8|0.970.0-alpha1|7.2.2|

### Why do you need the REST API for Jira

The Jira REST API is an ideal solution for the developers who want to integrate JIRA with other standalone or web applications, 
and administrators who want to script interactions with the JIRA server. Because the Jira REST API is based on open 
standards, you can use any web development language to access the API.


The following sections provide information on how to use Ballerina Jira connector.

- [Getting started](#getting-started)
- [Authentication](#authentication)
- [Working with Jira Connector](#working-with-jira-connector-actions)



## Getting started


- Install the ballerina distribution from [Ballerina Download Page](https://ballerinalang.org/downloads/).

- Clone the repository by running the following command
 ```
    git clone https://github.com/wso2-ballerina/package-jira
 ```
 
- Import the package as a ballerina project.

- Provide the Ballerina directory as project SDK

## Authentication

**Note -** 
*JIRA’s REST API is protected by the same restrictions which are provided via JIRAs standard web interface.
This means that if you do not have valid jira credentials, you are accessing JIRA anonymously. Furthermore, 
if you log in and do not have permission to view something in JIRA, you will not be able to view it using the 
Ballerina JIRA Connector as well.*

Ballerina Jira connector currently provides basic authentication as the authentication method.  
Please follow the following steps to authenticate your connector.
     
- Obtain your Jira user account credentials(username and password).
  If you currently dont have a Jira account, you can create a new Jira account from 
  [JIRA Sign-Up Page](https://id.atlassian.com/signup?application=mac&tenant=&continue=https%3A%2F%2Fmy.atlassian.com).

- Provide the credentials to your connector in the initialization step, as shown 
in the following sample code.
```Ballerina

     //Creation of connector endpoint
     endpoint jira:JiraEndpoint jiraConnectorEP {
            base_url:"https://support-staging.wso2.com",
            username:"username",
            password:"password"
     };

```


## Working with Jira connector actions

All actions of Jira Connector return two values: result and error. Results can be either`ballerina struct objects` or `boolean` values,depends on the context. Error response is also a ballerina struct object of type`JiraConnectorError`. If the actions was successfull, then the requested struct object or boolean `TRUE` response will be returned while the `JiraConnectorError` will be **null** and vice-versa.

##### Example
* Request 
```ballerina
    
    jira:JiraConnectorError jiraError = {};
    jira:Project project = {};
    string projectKey = "RRDEVSPRT";
    
    //Creating the jira Connector as an endpoint
    endpoint jira:JiraEndpoint jiraConnectorEP {
        base_url:"https://support-staging.wso2.com",
        username:"username",
        password:"password"
    };
         
    //Connector Action
    var result = jiraConnector -> getProject(projectKey);
    match result{
        jira:Project p => project = p;
        jira:JoraConnectorError e => jiraError = err;
    }
    
```

* Response struct
```ballerina
public struct Project {
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

* Error Struct
```ballerina
public struct JiraConnectorError {
    string ^"type";
    string message;
    json jiraServerErrorLog;
    error cause;
}
```

Now that you have basic knowledge about to how Ballerina Jira connector works, 
use the information in the following sections to perform various operations with the connector.

- [Working with Projects in JIRA](#working-with-projects-in-jira)

- [Working with Issues in JIRA](#working-with-issues-in-jira)

- [Working with Users in JIRA](#working-with-users-in-jira)



## Working with Projects in JIRA

### API Reference

#### Project
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

#### Project Category
- getAllProjectCategories()
- createProjectCategory()
- getProjectCategory()
- deleteProjectCategory()

#### Project Component
- createProjectComponent()
- getProjectComponent()
- deleteProjectComponent()
- getAssigneeUserDetailsOfProjectComponent()
- getLeadUserDetailsOfProjectComponent()


***
## Working with Issues in JIRA
**[ To be Implemented ]**

## Working with Users in JIRA
**[ To be Implemented ]**

