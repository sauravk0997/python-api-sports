*** Settings ***
Documentation       Table-Tennis tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/table-tennis-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.TableTennisValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                table-tennis
${TABLE_TENNIS_ID}      45
${TABLE_TENNIS_NAME}    Table Tennis
${TABLE_TENNIS_SLUG}    ${SPORT}


*** Test Cases ***
Get Table-tennis Baseline Responses
    [Tags]  table-tennis  valid   CSEAUTO-26448
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TABLE_TENNIS_ID}", "${TABLE_TENNIS_NAME}", "${TABLE_TENNIS_SLUG}"]

# Tests start for table-tennis_leagues (https://jira.disney.com/browse/CSEAUTO-25586)

Get Table-tennis Leagues
    [Tags]  table-tennis  valid   CSEAUTO-26449   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for table-tennis
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TABLE_TENNIS_ID}", "${TABLE_TENNIS_NAME}", "${TABLE_TENNIS_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Table-tennis Leagues with Filter Season
    [Tags]  table-tennis  valid   CSEAUTO-26450   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for table-tennis
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TABLE_TENNIS_ID}", "${TABLE_TENNIS_NAME}", "${TABLE_TENNIS_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Table-tennis without Leagues in queryParams
    [Tags]  table-tennis    valid     CSEAUTO-26451   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for table-tennis
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TABLE_TENNIS_ID}", "${TABLE_TENNIS_NAME}", "${TABLE_TENNIS_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Table-tennis Leagues with Filter invalid
    [Tags]  table-tennis    invalid   CSEAUTO-26452   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Table-tennis with empty string in queryParams
    [Tags]  table-tennis    invalid     CSEAUTO-26453   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
