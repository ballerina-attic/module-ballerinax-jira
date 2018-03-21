package src.jira;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                      Configuration Constants                                                       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public const string JIRA_BASE_URL = "https://support-staging.wso2.com/";
public const string JIRA_REST_API_URL = "https://support-staging.wso2.com/jira/rest/api/";
const string JIRA_REST_API_VERSION = "2";
public const string JIRA_REST_API_ENDPOINT = JIRA_REST_API_URL + JIRA_REST_API_VERSION;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          Entity Constants                                                          //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public const string ROLE_ID_ADMINISTRATORS = "10002";
public const string ROLE_ID_CSAT_DEVELOPERS = "10030";
public const string ROLE_ID_DEVELOPERS = "10001";
public const string ROLE_ID_EXTERNAL_CONSULTANTS = "10011";
public const string ROLE_ID_NOTIFICATIONS = "10010";
public const string ROLE_ID_OBSERVER = "10020";
public const string ROLE_ID_USERS = "10000";



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          HTTP Status Codes                                                          //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public const int STATUS_CODE_OK = 200;
public const int STATUS_CODE_CREATED = 201;
public const int STATUS_CODE_NO_CONTENT = 204;
public const int STATUS_CODE_NOTFOUND = 404;
public const int STATUS_CODE_INTERNAL_ERROR = 500;
public const int STATUS_CODE_BAD_REQUEST = 400;
public const int STATUS_CODE_UNAUTHORIZED = 401;
public const int Status_CODE_CONFLICT = 409;

public const string STATUS_CREATED = "CREATED";
public const string STATUS_NOT_FOUND = "NOT-FOUND";
public const string STATUS_BAD_REQUEST = "BAD-REQUEST";
public const string STATUS_CONFLICT = "CONFLICT";
public const string STATUS_INTERNEL_ERROR = "INTERNEL_ERROR";