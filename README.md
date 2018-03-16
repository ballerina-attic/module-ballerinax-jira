# Ballerina Jira Connector

This Ballerina client connector allows to connect to [Atlassian JIRA](https://www.jira.com), an online issue-tracking database. It provides bug tracking, 
issue tracking, and project management functions.
The connector uses the [JIRA REST API version 7.2.2](https://docs.atlassian.com/software/jira/docs/api/REST/7.2.2/) to connect to JIRA, work with JIRA projects, 
view and update issues, work with jira user accounts, and more.
![Overview](Overview.png)

|Ballerina Version | Connector Version | 
|------------------|-------------------|
|0.964.0 | 0.1 |
### Why do you need the REST API for Jira

The Jira REST API is an ideal solution for the developers who want to integrate JIRA with other standalone or web applications, 
and administrators who want to script interactions with the JIRA server. Because the Jira REST API is based on open 
standards, you can use any web development language to access the API.


The following sections provide information on how to use Ballerina Jira connector.

- [Getting started](#getting-started)
- [Running Samples](#running-samples)
- [Working with Jira Connector](#working-with-jira-connector-actions)



### Getting started


- Install the ballerina version 0.964.0 distribution from [Ballerina Download Page](https://ballerinalang.org/downloads/).

- Clone the repository by running the following command
 ```
    git clone https://github.com/NipunaRanasinghe/connector-jira
 ```
 
- Import the package as a ballerina project.



- Provide your Jira user account credentials using the following steps.(If you currently dont have a Jira account, 
    you can create a new Jira account from [JIRA Sign-Up Page](https://id.atlassian.com/signup?application=mac&tenant=&continue=https%3A%2F%2Fmy.atlassian.com).)
    1. Build a string of the form "username:password"
    2. Base64 encode the string
    3. Navigate to the "Package_Jira/ballerina.conf" configuration file and place the encoded string under the "base64_encoded_string" field
        
        i.e: `base64_encoded_string=YXNoYW5Ad3NvMi5jb206YXNoYW`



## Running Samples

You can easily test the following actions using the `sample.bal` file.

1. Navigate to the folder `Package_Jira/samples/jira/ ` .
2. Run the following commands to execute the sample.

    ```$ ballerina run sample.bal "Run All Samples"```

## Working with Jira connector actions

All the actions return two values: result and error. Results can be either`ballerina struct objects` or boolean values,depends on the context. Error response is also a ballerina struct object of type`JiraConnectorError`. If the actions was successfull, then the requested struct object or boolean `TRUE` response will be returned while the `JiraConnectorError` will be **null** and vice-versa.

##### Example
* Request 
```ballerina
    endpoint<jira:JiraConnector> jiraConnector {
        create jira:JiraConnector();
    }
    string projectKey = "RRDEVSPRT";
    
    jira:Project project;
    jira:JiraConnectorError e;
    
    project, e = jiraConnector.getProject(projectKey);
    
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
    string |type|;
    string message;
    json jiraServerErrorLog;
    error cause;
}
```


Ballerina Jira connector API basically provides two types of functionalities which are, Connector-based
and entity-based actions

##### **Connector-Based Actions**

   Connector-based actions provide generic functionalities related to jira, with the following format.

   syntax: `connectorName.actionName(arguments)`


 ##### **Entity-Based Actions**
 
   Entity-based actions are special set of actions which are defined on a Jira Entity (Eg: Jira Project,Jira Issue etc.),
   which are also called struct-bound functions. Ballerina Jira connector API design allows users to retrieve the jira 
   basic entities using connector-bound actions and then use entity-bound actions directly on the obtained structured          entities

   syntax: `entityName.actionName(arguments)`
 

 
##### Example - Connector based actions and Entity based Actions

 ```ballerina
     endpoint<jira:JiraConnector> jiraConnector {
         create jira:JiraConnector();
     }
     jira:Project project;
     jira:JiraConnectorError e;
     string projectKey = "TESTKEY";
     
     //connector-bound action
     project, e = jiraConnector.getProject(projectKey);
     
     if (e==null){
        User lead;
        
        //entity-bound action
        lead,e = project.getLeadUserDetails();
     }
     
 ```

Now that you have basic knowledge about to how Ballerina Jira connector works, 
use the information in the following sections to perform various operations with the connector.

- [Working with Projects in JIRA](#working-with-projects-in-jira)

- [Working with Issues in JIRA](#working-with-issues-in-jira)

- [Working with Users in JIRA](#working-with-users-in-jira)



## Working with Projects in JIRA

### API Reference

#### Connector Actions

- [getAllProjectSummaries()](#getallprojectsummaries-)
- [getProject()](#getproject-)
- [createProject()](#createproject-)
- [updateProject()](#updateproject-)
- [deleteProject()](#deleteproject-)
- [getAllProjectCategories()](#getallprojetcategories-)
- [createProjectCategory()](#createprojectcategory-)
- [deleteProjectCategory()](#deleteprojectcategory-)

#### Entity-Based Actions

- Project
    - [getLeadUserDetials()](#getleaduserdetails-)
    - [getRoleDetails()](#getroledetails-)
    - [addUserToRole()](#addusertorole-)
    - [addGroupToRole()](#addgrouptorole-)
    - [removeUserFromRole()](#removeuserfromrole-)
    - [removeGroupFromRole()](#removegroupfromrole-)
    - [getAllIssueTypeStatuses()](#getallissuetypestatuses-)
    - [changeProjectType()](#changeprojecttype-)
    
- ProjectComponentSummary
    - [getAllDetails()](#getalldetails-)

- ProjectComponent
    - [getLeadUserDetails()](#getleaduserdetails-)
    - [getAssigneeUserDetails()](#getassigneeuserdetails-)

***  
#### getAllProjectSummaries ( )
 
  Returns all projects which are visible for the currently logged in user.
    If no user is logged in, it returns the list of projects that are visible when using anonymous access. 

###### Parameters
   `None`

###### Returns

* Project[]: Array of projects for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN
    project permission.
* JiraConnectorError: Error Object.


***  
#### getProject (string projectIdOrKey)
 
Returns a detailed representation for given a project.
      
###### Parameters
* projectIdOrKey: unique string which represents the project id or project key of a jira project


###### Returns

* Project: Contains a full representation of a project, if the project exists,the user has permission
      to view it and if no any error occured
* JiraConnectorError: Error Object


***  
#### createProject (ProjectRequest newProject)
 
Creates a new project.
    
###### Parameters
* newProject: struct which contains the mandatory fields for new project creation

###### Returns


* boolean: Returns true if the project was created was successfully,otherwise returns false"}
* JiraConnectorError: Error Object



***
#### updateProject (string projectIdOrKey, ProjectRequest update)

Updates a project. Only non null values sent in 'ProjectRequest' structure will be updated in the project. 
Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'.
    
###### Parameters
* projectIdOrKey: unique string which represents the project id or project key of a jira project.
* update: structure containing fields which need to be updated.

###### Returns
* boolean: Returns true if project was updated successfully,otherwise return false.
* JiraConnectorError: Error Object.

***
#### deleteProject (string projectIdOrKey)

Deletes a project.
     
###### Parameters
*  projectIdOrKey: unique string which represents the project id or project key of a jira project.

###### Returns
* boolean: Returns true if project was deleted successfully,otherwise return false.
* JiraConnectorError: Error Object.

***
#### getAllProjectCategories ( )

Returns all existing project categories.
   
###### Parameters
*  projectIdOrKey: unique string which represents the project id or project key of a jira project.

###### Returns
* ProjectCategory[]: Array of structures which contain existing project categories.
* JiraConnectorError: Error Object.

***
#### createProjectCategory (NewProjectCategory newCategory)

Create a new project category.
    
###### Parameters
* newCategory: struct which contains the mandatory fields for new project category creation

###### Returns
* boolean: Returns true if the project category was created successfully,otherwise returns false.
* JiraConnectorError: Error Object.


***
#### deleteProjectCategory (string projectCategoryId)

Deletes a given project category.
    
###### Parameters
* projectCategoryId: Jira id of the project category.

###### Returns
* boolean: Returns true if the project category was deleted successfully, otherwise returns false.
* JiraConnectorError: Error Object.



## Working with Issues in JIRA
**[ To be Implemented ]**

## Working with Users in JIRA
**[ To be Implemented ]**




