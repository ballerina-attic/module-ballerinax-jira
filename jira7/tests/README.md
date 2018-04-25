
### Compatibility

| Ballerina Version | Jira REST API Version |
|:-------------------:|:-------------------:|
|0.970.0-beta14|7.2.2|

## Running Tests

> **Important -** All the tests inside this package will make HTTP calls to the JIRA REST API. If the HTTP call fails, 
then so will the test case.

In order to run the jira7.tests, the user will need to have a Jira Administration User Account and valid credentials.

You can test all the endpoint actions using the `tests.bal` file, using the following steps.

1. Navigate to the ballerina project directory.
2. Create a `ballerina.conf` file and add following lines to provide your jira url,username and password.
    ```
        test_url="place your url here"
        test_username="place your username here"
        test_password="place your password here"
    ```

3. Navigate to the folder `package-jira` using the terminal.
4. Run the following commands to execute the tests.

    ``` 
        $ ballerina init
        $ ballerina test jira7 -c ballerina.conf
    ```
