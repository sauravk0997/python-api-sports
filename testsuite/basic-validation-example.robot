*** Settings ***
Documentation       Sample suite showing a simple endpoint validation example as well as a more indepth test configuration with more assertions.
...                 to run: robot --pythonpath $PWD ./testsuite/basic-validation-example.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             OperatingSystem

*** Variables ***
${API_BASE}=        https://sports.core.api.espnsb.com/v3/sports  # tests default to the sandbox environment
${cleanup}=         ${False}  # False is a built-in RF variable

*** Keywords ***
A GET request to ${endpoint} should respond with ${status}
    [Documentation]     Custom GET keyword with status validation.
    ${api_response}=    GET  url=${endpoint}  expected_status=${status}
    [Return]    ${api_response}

Dump ${response} text to ${path}
    [Documentation]     Quick keyword to output a file from response object.
    create file    ${path}    ${response.text}

Cleanup ${path} ${recursively}
    [Documentation]     shortcut to rm -rf directory and contents as long as they aren't specifically the primary
    ...                 directories for the suite.
    @{path_list}=       Create List     lib  resources  testsuite  lib/  resources/  testsuite/
    should not contain  ${path_list}    ${path}  Uh oh! Your delete path includes a required directory.  ignore_case=True
    Remove Directory    ${path}         ${recursively}

*** Test Cases ***
Get Base Sports Endpoint API Response
    [Documentation]     Simple validation of the base level schema url.
    [Tags]  valid
    ${response}=    A GET request to ${API_BASE} should respond with 200
    Sports Schema from ${response} should be valid


# BASEBALL
Get Baseball Baseline Responses
    [Documentation]     This test case contains additional keyword references as well as assertion examples.
    [Tags]  baseball    valid    example
    set test variable   ${request_url}  ${API_BASE}/baseball
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid

    # sample testcase assertions and keyword interactions:
    set test variable   ${file_dir}   response_output                 # directory output file will be uploaded
    set test variable   ${sport}      Baseball                        # Sport being tested
    set test variable   ${file_path}  ${file_dir}/${sport}.json       # path to output file

    should be equal as strings  ${response.json()["name"]}  ${sport}  # Example of how to compare a field value in the return results.

    log to console      ${request_url}                                # Example of how to write output to console
    Dump ${response} text to ${file_path}                             # Example of how to write response output to text file

    # Example of how to delete a directory containing content (recursively) if a global variable (cleanup) is set to true.
    # e.g.: robot --pythonpath $PWD -i example -v cleanup:True testsuite/validation-demo.robot
    run keyword if    ${cleanup} == ${True}  Cleanup ${file_dir} ${True}  # if ${cleanup} is True, run equiv of: rm -rf ./response_output/
