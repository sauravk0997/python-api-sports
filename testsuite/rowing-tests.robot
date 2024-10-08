*** Settings ***
Documentation       Rowing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/rowing-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.RowingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          rowing
${ROWING_ID}      34
${ROWING_NAME}    Rowing

*** Test Cases ***
Get Rowing Baseline Responses
    [Tags]  rowing  valid   CSEAUTO-27146
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ROWING_ID}", "${ROWING_NAME}", "${SPORT}"]

# Tests start for rowing_leagues (https://jira.disney.com/browse/CSEAUTO-26935)

Get Rowing Leagues
    [Tags]  rowing  valid   CSEAUTO-27151   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for rowing
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ROWING_ID}", "${ROWING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Rowing Leagues with Filter Season
    [Tags]  rowing  valid   CSEAUTO-27153  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for rowing
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ROWING_ID}", "${ROWING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Rowing without Leagues in queryParams
    [Tags]  rowing    valid     CSEAUTO-27154   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ROWING_ID}", "${ROWING_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Rowing Leagues with Filter invalid
    [Tags]  rowing    invalid   CSEAUTO-27155   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Rowing with empty string in queryParams
    [Tags]  rowing    invalid     CSEAUTO-27156   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
