# Ballerina Jira Connector

This Ballerina client connector allows to connect to [Atlassian JIRA](https://www.jira.com), an online issue-tracking database. It provides bug tracking, 
issue tracking, and project management functions.
The connector uses the [JIRA REST API version 7.2.2](https://docs.atlassian.com/software/jira/docs/api/REST/7.2.2/) to connect to JIRA, work with JIRA projects, 
view and update issues, work with jira user accounts, and more.
![Overview](Overview.png)

|connector version | Ballerina Version | 
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
    
    //Creating the jira Connector instace
    jira:JiraConnector jiraConnector = {};

    //this is the in-buit connctor action to get the user credentials and check the validity of the provided details.
    var response = jiraConnector.authenticate("ashan@wso2.com", "ashan123");
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
    jira:JiraConnector jiraConnector = {};
    jira:JiraConnectorError jiraError = {};
    jira:Project project = {};
    string projectKey = "RRDEVSPRT";
    
    //Authentication 
    var response = jiraConnector.authenticate("ashan@wso2.com", "ashan123");
    
    //Connector Action
    var result = jiraConnector.getProject(projectKey);
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
    string |type|;
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

- [getAllProjectSummaries()](#getallprojectsummaries--)
- [getProject()](#getproject-string-projectidorkey)
- [createProject()](#createproject-projectrequest-newproject)
- [updateProject()](#updateproject-string-projectidorkey-projectrequest-update)
- [deleteProject()](#deleteproject-string-projectidorkey)
- [getAllProjectCategories()](#getallprojectcategories--)
- [createProjectCategory()](#createprojectcategory-projectcategoryrequest-newcategory)
- [deleteProjectCategory()](#deleteprojectcategory-string-projectcategoryid)

#### Entity-Based Actions

- Project
    - [getLeadUserDetails()](#getleaduserdetails--)
    - [getRoleDetails()](#getroledetails-projectroletype-projectroletype)
    - [addUserToRole()](#addusertorole-projectroletype-projectroletype-string-username)
    - [addGroupToRole()](#addgrouptorole-projectroletype-projectroletype-string-groupname)
    - [removeUserFromRole()](#removeuserfromrole-projectroletype-projectroletype-string-username)
    - [removeGroupFromRole()](#removegroupfromrole-projectroletype-projectroletype-string-groupname)
    - [getAllIssueTypeStatuses()](#getallissuetypestatuses--)
    - [changeProjectType()](#changeprojecttype-projecttype-newprojecttype)
    
- ProjectComponentSummary
    - [getAllDetails()](#getalldetails--)

- ProjectComponent
    - [getLeadUserDetails()](#getleaduserdetails--)
    - [getAssigneeUserDetails()](#getassigneeuserdetails--)

### Connector Actions
*** 
- ### getAllProjectSummaries ( )
 
    Returns all projects which are visible for the currently logged in user.
    If no user is logged in, it returns the list of projects that are visible when using anonymous access. 

    ###### Parameters
    `None`
    
    ###### Returns
    * **ProjectSummary[]:** Array of projects for which the user has the BROWSE, ADMINISTER or PROJECT_ADMIN
        project permission.
    * **JiraConnectorError:** Error Object.


***  
- ### getProject (string projectIdOrKey)
 
    Returns a detailed representation for given a project.
          
    ###### Parameters
    * **projectIdOrKey:** unique string which represents the project id or project key of a jira project
    
    ###### Returns
    * **Project:** Contains a full representation of a project, if the project exists,the user has permission
          to view it and if no any error occured
    * **JiraConnectorError:** Error Object
    
  
***  
- ### createProject (ProjectRequest newProject)
 
    Creates a new project.
        
    ###### Parameters
    * **newProject:** struct which contains the mandatory fields for new project creation
    
    ###### Returns
    * **boolean:** Returns true if the project was created was successfully,otherwise returns false"}
    * **JiraConnectorError:** Error Object


***
- ### updateProject (string projectIdOrKey, ProjectRequest update)

    Updates a project. Only non null values sent in 'ProjectRequest' structure will be updated in the project. 
    Values available for the assigneeType field are: 'PROJECT_LEAD' and 'UNASSIGNED'.
        
    ###### Parameters
    * **projectIdOrKey:** unique string which represents the project id or project key of a jira project.
    * **update:** structure containing fields which need to be updated.
    
    ###### Returns
    * **boolean:** Returns true if project was updated successfully,otherwise return false.
    * **JiraConnectorError:** Error Object.

***
- ### deleteProject (string projectIdOrKey)

    Deletes a project.
         
    ###### Parameters
    *  **projectIdOrKey**: unique string which represents the project id or project key of a jira project.
    
    ###### Returns
    * **boolean:** Returns true if project was deleted successfully,otherwise return false.
    * **JiraConnectorError:** Error Object.

***
- ### getAllProjectCategories ( )

    Returns all existing project categories.
       
    ###### Parameters
    `None`
    
    ###### Returns
    * **ProjectCategory[]:** Array of structures which contain existing project categories.
    * **JiraConnectorError:** Error Object.

***
- ### createProjectCategory (ProjectCategoryRequest newCategory)

    Creates a new project category.
        
    ###### Parameters
    * **ProjectCategoryRequest:** struct which contains the mandatory fields for new project category creation
    
    ###### Returns
    * **boolean:** Returns true if the project category was created successfully,otherwise returns false.
    * **JiraConnectorError:** Error Object.


***
- ### deleteProjectCategory (string projectCategoryId)

    Deletes a given project category.
        
    ###### Parameters
    * **projectCategoryId:** Jira id of the project category.
    
    ###### Returns
    * **boolean:** Returns true if the project category was deleted successfully, otherwise returns false.
    * **JiraConnectorError:** Error Object.


***
### Entity-Based Actions: 
***
### Project

***
- ### getProjectLeadUserDetails ( )

    Returns jira user details of the project lead.
        
    ###### Parameters
    `None`
    
    ###### Returns
    * **User:** structure containing jira user account details of the project lead.
    * **JiraConnectorError:** Error Object.
    
***    
- ### getRoleDetails (ProjectRoleType projectRoleType)
    
    Returns detailed reprensentation of a given project role(ie:Developers,Administrators etc).
        
    ###### Parameters
    * **projectRoleType:** Enum which provides the possible project roles for a jira project.
    
    ###### Returns
    * **ProjectRole:** structure containing the details of the requested role.
    * **JiraConnectorError:** Error Object.

***    
- ### addUserToRole (ProjectRoleType projectRoleType, string userName)   
    
    assigns a user to a given project role(ie:Developers,Administrators etc).
      
    ###### Parameters
    * **projectRoleType:** Enum which provides the possible project roles for a jira project.
    * **userName:** name of the user to be added.
    
    ###### Returns
    * **boolean:** Returns true if process was successfull,otherwise returns false.
    * **JiraConnectorError:** Error Object.
       
***    
- ### addGroupToRole (ProjectRoleType projectRoleType, string groupName)   
    
    assigns a group to a given project role(ie:Developers,Administrators etc).
      
    ###### Parameters
    * **projectRoleType:** Enum which provides the possible project roles for a jira project.
    * **groupName:** name of the group to be added.
    
    ###### Returns
    * **boolean:** Returns true if process was successfull,otherwise returns false.
    * **JiraConnectorError:** Error Object.
       
***
- ### removeUserFromRole (ProjectRoleType projectRoleType, string userName)
    
    Removes a given user from a given project role.
   
    ###### Parameters
    * **projectRoleType:** Enum which provides the possible project roles for a jira project.
    * **userName:**  name of the user required to be removed.
    
    ###### Returns
    * **boolean:** Returns true if process was successfull,otherwise returns false
    * **JiraConnectorError:** Error Object.

***
- ### removeGroupFromRole (ProjectRoleType projectRoleType, string groupName)
    
    Removes a given group from a given project role.
    
    ###### Parameters
    * **projectRoleType:** Enum which provides the possible project roles for a jira project.
    * **groupName:**  name of the group required to be removed.
    
    ###### Returns
    * **boolean:** Returns true if process was successfull,otherwise returns false
    * **JiraConnectorError:** Error Object.

***
- ### getAllIssueTypeStatuses ( )
    
    Gets all issue types with valid status values for a project.
    
    ###### Parameters
    `None`
    
    ###### Returns
    * **ProjectStatus[]:** array of project status structures
    * **JiraConnectorError:** Error Object.

***
- ### changeProjectType (ProjectType newProjectType)
    
    Updates the type of a jira project.
    
    ###### Parameters
    **newProjectType:** Enum which provides possible project types for a jira project.
    
    ###### Returns
    * **boolean:** Returns true if update was successfull,otherwise returns false.
    * **JiraConnectorError:** Error Object.


****
### ProjectCompoentSummary

***
- ### getAllDetails ( )

    Returns a detailed representation for given a project component.
    
    ###### Parameters
    `None`
    
    ###### Returns
    * **ProjectComponent:** structure which contains a full representation of the project component.
    * **JiraConnectorError:** Error Object.
    

****
### ProjectCompoent

***
- ### getLeadUserDetails ( )

    Returns jira user account details of the project component lead
    
    ###### Parameters
    `None`
    
    ###### Returns
    * **User:** structure containing jira user details of the lead.
    * **JiraConnectorError:** Error Object.

***
- ### getAssigneeUserDetails ( )

    Returns jira user account details of the project component assignee.
    
    ###### Parameters
    `None`
    
    ###### Returns
    * **User:** structure containing jira user details of the assignee.
    * **JiraConnectorError:** Error Object.
***
## Working with Issues in JIRA
**[ To be Implemented ]**

## Working with Users in JIRA
**[ To be Implemented ]**

