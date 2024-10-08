*** Settings ***
Documentation       Tennis tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/Tennis-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          tennis
${TENNIS_ID}      850
${TENNIS_UID}     s:${TENNIS_ID}
${TENNIS_NAME}    Tennis
${TENNIS_SLUG}    ${SPORT}


*** Test Cases ***
# TENNIS
Get Tennis Baseline Responses
    [Tags]  tennis  valid   CSEAUTO-26431
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${TENNIS_ID}", "${TENNIS_UID}", "${TENNIS_NAME}", "${TENNIS_SLUG}"]

# Tests start for tennis_leagues (https://jira.disney.com/browse/CSEAUTO-25585)

Get Tennis Leagues
    [Tags]  tennis  valid   CSEAUTO-26432   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${TENNIS_ID}", "${TENNIS_UID}", "${TENNIS_NAME}", "${TENNIS_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Tennis Leagues with Filter Season
    [Tags]  tennis  valid   CSEAUTO-26433   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${TENNIS_ID}", "${TENNIS_UID}", "${TENNIS_NAME}", "${TENNIS_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Tennis without Leagues in queryParams
    [Tags]  tennis    valid     CSEAUTO-26438   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${TENNIS_ID}", "${TENNIS_UID}", "${TENNIS_NAME}", "${TENNIS_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Tennis Leagues with Filter invalid
    [Tags]  tennis    invalid   CSEAUTO-26439   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Tennis with empty string in queryParams
    [Tags]  tennis    invalid     CSEAUTO-26440   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
