*** Settings ***
Documentation       Triathlon tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/triathlon-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.TriathlonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}             triathlon
${TRIATHLON_ID}      44
${TRIATHLON_NAME}    Triathlon
${TRIATHLON_SLUG}    ${SPORT}


*** Test Cases ***
Get Triathlon Baseline Responses
    [Tags]  triathlon  valid   CSEAUTO-26620
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TRIATHLON_ID}", "${TRIATHLON_NAME}", "${TRIATHLON_SLUG}"]

# Tests start for Triathlon_leagues (https://jira.disney.com/browse/CSEAUTO-26481)

Get Triathlon Leagues
    [Tags]  triathlon  valid   CSEAUTO-26621   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for triathlon
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TRIATHLON_ID}", "${TRIATHLON_NAME}", "${TRIATHLON_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Triathlon Leagues with Filter Season
    [Tags]  triathlon  valid   CSEAUTO-26622   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for triathlon
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TRIATHLON_ID}", "${TRIATHLON_NAME}", "${TRIATHLON_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Triathlon without Leagues in queryParams
    [Tags]  triathlon    valid     CSEAUTO-26623   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for triathlon
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${TRIATHLON_ID}", "${TRIATHLON_NAME}", "${TRIATHLON_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Triathlon Leagues with Filter invalid
    [Tags]  triathlon    invalid   CSEAUTO-26625   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Triathlon with empty string in queryParams
    [Tags]  triathlon    invalid     CSEAUTO-26626   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
