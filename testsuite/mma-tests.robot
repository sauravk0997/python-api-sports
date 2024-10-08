*** Settings ***
Documentation       MMA tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/mma-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}       mma
${MMA_ID}      3301
${MMA_UID}     s:${MMA_ID}
${MMA_NAME}    MMA
${MMA_SLUG}    ${SPORT}


*** Test Cases ***
# MMA
Get MMA Baseline Responses
    [Tags]  mma  valid   CSEAUTO-26548
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${MMA_ID}", "${MMA_UID}", "${MMA_NAME}", "${MMA_SLUG}"]

# Tests start for MMA_leagues (https://jira.disney.com/browse/CSEAUTO-26480)

Get MMA Leagues
    [Tags]  mma  valid   CSEAUTO-26549   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${MMA_ID}", "${MMA_UID}", "${MMA_NAME}", "${MMA_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get MMA Leagues with Filter Season
    [Tags]  mma  valid   CSEAUTO-26551   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${MMA_ID}", "${MMA_UID}", "${MMA_NAME}", "${MMA_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get MMA without Leagues in queryParams
    [Tags]  mma    valid     CSEAUTO-26553   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${MMA_ID}", "${MMA_UID}", "${MMA_NAME}", "${MMA_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get MMA Leagues with Filter invalid
    [Tags]  mma    invalid   CSEAUTO-26555   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get MMA with empty string in queryParams
    [Tags]  mma    invalid     CSEAUTO-26556   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
