*** Settings ***
Documentation       Athletes - track and field tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/athletes-track-and-field-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.AthletesTrackFieldValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          track-and-field
${ATHLETICS_ID}      3
${ATHLETICS_NAME}    Athletics

*** Test Cases ***
Get Athletes - track and field Baseline Responses
    [Tags]  track-and-field  valid   CSEAUTO-26982
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ATHLETICS_ID}", "${ATHLETICS_NAME}", "${SPORT}"]

# Tests start for Athletes - track and field_leagues (https://jira.disney.com/browse/CSEAUTO-26924)

Get Athletes - track and field Leagues
    [Tags]  track-and-field  valid   CSEAUTO-26983   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for track-and-field
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ATHLETICS_ID}", "${ATHLETICS_NAME}", "${SPORT}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Athletes - track and field Leagues with Filter Season
    [Tags]  track-and-field  valid   CSEAUTO-26984  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for track-and-field
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ATHLETICS_ID}", "${ATHLETICS_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Athletes - track and field without Leagues in queryParams
    [Tags]  track-and-field    valid     CSEAUTO-26985   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ATHLETICS_ID}", "${ATHLETICS_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Athletes - track and field Leagues with Filter invalid
    [Tags]  track-and-field    invalid   CSEAUTO-26986   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Athletes - track and field with empty string in queryParams
    [Tags]  track-and-field    invalid     CSEAUTO-26987   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
