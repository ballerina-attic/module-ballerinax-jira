import ballerina/config;
import ballerina/log;

Project project_test = {};
ProjectSummary[] projectSummaryArray_test = [];
ProjectComponent projectComponent_test = {};
ProjectCategory projectCategory_test = {};

function getUrl() returns string {
    return config:getAsString("test_url");
}

function getUsername() returns string {
   return  config:getAsString("test_username");
}

function getPassword() returns string {
    return config:getAsString("test_password");
}