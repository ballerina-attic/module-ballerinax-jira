

## Running Tests

You can easily test all the connector actions using the `tests.bal` file, using the following steps.

1. Navigate to the `package-jira` directory.
2. Create a `ballerina.conf` file and add folloing lines to provide your jira url,username and password.
    ```
        test_url="place your url here"
        test_username="place your username here"
        test_password="place your password here"
    ```
 
2. Navigate to the folder `package-jira` using terminal.
3. Run the following commands to execute the tests.

    ```$ ballerina test jira7"```
