# Ballerina Jira Connector

This Ballerina client connector allows to connect to [Atlassian JIRA](https://www.jira.com), an online issue-tracking database. It provides bug tracking, 
issue tracking, and project management functions.
The connector uses the [JIRA REST API version 7.2.2](https://docs.atlassian.com/software/jira/docs/api/REST/7.2.2/) to connect to JIRA, work with JIRA projects, 
view and update issues, work with jira user accounts, and more.
![Overview](Overview.png)

|Connector Version | Ballerina Version | 
|:------------------:|:-------------------:|
|0.1|0.964.0|
|0.2|0.970.0-alpha0|

### Why do you need the REST API for Jira

The Jira REST API is an ideal solution for the developers who want to integrate JIRA with other standalone or web applications, 
and administrators who want to script interactions with the JIRA server. Because the Jira REST API is based on open 
standards, you can use any web development language to access the API.


The following sections provide information on how to use Ballerina Jira connector.

- [Getting started](#getting-started)
- [Authentication](#authentication)
- [Running Samples](#running-samples)
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

- Provide the credentials which are obtained in the above step to your connector as shown 
in the following sample code.(Connector will check for an existing jira user account with the given credentials and 
will return an error if the credentials are invalid.)
```Ballerina

    jira:JiraConnectorError jiraConnectorError;
    boolean isValid;
    
    //Creating the jira Connector as an endpoint
    endpoint jira:JiraConnectorEndpoint jiraConnectorEP {
        base_url:"https://support-staging.wso2.com"
    };
    
    //this is the in-buit connctor action to get the user credentials and check the validity of the provided details.
    var response = jiraConnector -> authenticate("ashan@wso2.com", "ashan123");
    match response{
        boolean success => io:println(success);
        jira:JiraConnectorError error => io:println(e);
    }

```

## Running Samples

You can easily test all the connector actions using the `test.bal` file, using the following steps.

1. Navigate to the folder `package-jira`.
2. Run the following commands to execute the sample.

    ```$ ballerina run tests "Run All Tests"```


## Working with Jira connector actions

All the actions return two values: result and error. Results can be either`ballerina struct objects` or boolean values,depends on the context. Error response is also a ballerina struct object of type`JiraConnectorError`. If the actions was successfull, then the requested struct object or boolean `TRUE` response will be returned while the `JiraConnectorError` will be **null** and vice-versa.

##### Example
* Request 
```ballerina
    
    jira:JiraConnectorError jiraError = {};
    jira:Project project = {};
    string projectKey = "RRDEVSPRT";
    
    //Creating the jira Connector as an endpoint
    endpoint jira:JiraConnectorEndpoint jiraConnectorEP {
        base_url:"https://support-staging.wso2.com"
    };
    
    //Authentication 
    var response = jiraConnector -> authenticate("ashan@wso2.com", "ashan123");
    
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

Ballerina Jira connector API basically provides two types of functionalities, which are
- **Connector-based actions**
- **Entity-based actions**

#### Connector-Based Actions

   Connector-based actions provide generic functionalities related to jira, with the following format.

   syntax: `connectorName.actionName(arguments)`


#### Entity-Based Actions
 
   Entity-based actions are special set of actions which are defined on a Jira Entity (Eg: Jira Project,Jira Issue etc.),
   which are also called struct-bound functions. Ballerina Jira connector API design allows users to retrieve the jira 
   basic entities using connector-bound actions and then use entity-bound actions directly on the obtained structured          entities

   syntax: `entityName.actionName(arguments)`
 
Now that you have basic knowledge about to how Ballerina Jira connector works, 
use the information in the following sections to perform various operations with the connector.

- [Working with Projects in JIRA](#working-with-projects-in-jira)

- [Working with Issues in JIRA](#working-with-issues-in-jira)

- [Working with Users in JIRA](#working-with-users-in-jira)



## Working with Projects in JIRA

### API Reference

#### Connector-Based Actions

- getAllProjectSummaries()
- getProject()
- createProject()
- updateProject()
- deleteProject()
- getAllProjectCategories()
- createProjectCategory()
- deleteProjectCategory()

#### Entity-Based Actions

- ProjectSummary 
    - getAllDetails()
- Project
    - getLeadUserDetails()
    - getRoleDetails()
    - addUserToRole()
    - addGroupToRole()
    - removeUserFromRole()
    - removeGroupFromRole()
    - getAllIssueTypeStatuses()
    - changeProjectType()
    
- ProjectComponentSummary
    - getAllDetails()

- ProjectComponent
    - getLeadUserDetails()
    - getAssigneeUserDetails()


***
## Working with Issues in JIRA
**[ To be Implemented ]**

## Working with Users in JIRA
**[ To be Implemented ]**

