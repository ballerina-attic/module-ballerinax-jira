import ballerina/config;
import ballerina/log;

Project project_test = {};
ProjectSummary[] projectSummaryArray_test = [];
ProjectComponent projectComponent_test = {};
ProjectCategory projectCategory_test = {};

function getUrl() returns string {
    match config:getAsString("test_url"){
        string s => return s;
        () => {
            log:printError("Error: invalid value found for test_url");
            return "";
        }
    }
}

function getUsername() returns string {
    match config:getAsString("test_username"){
        string s => return s;
        () => {
            log:printError("Error: invalid value found for test_username");
            return "";
        }
    }
}

function getPassword() returns string {
    match config:getAsString("test_password"){
        string s => return s;
        () => {
            log:printError("Error: invalid value found for test_password");
            return "";
        }
    }
}