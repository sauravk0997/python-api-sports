*** Settings ***
Documentation       Skateboarding tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/skateboarding-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.SkateboardingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          skateboarding
${SKATEBOARDING_ID}      110
${SKATEBOARDING_NAME}    Skateboarding

*** Test Cases ***
Get Skateboarding Baseline Responses
    [Tags]  skateboarding  valid   CSEAUTO-27146
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SKATEBOARDING_ID}", "${SKATEBOARDING_NAME}", "${SPORT}"]

# Tests start for skateboarding_leagues (https://jira.disney.com/browse/CSEAUTO-26935)

Get Skateboarding Leagues
    [Tags]  skateboarding  valid   CSEAUTO-27151   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for skateboarding
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SKATEBOARDING_ID}", "${SKATEBOARDING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Skateboarding Leagues with Filter Season
    [Tags]  skateboarding  valid   CSEAUTO-27153  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for skateboarding
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SKATEBOARDING_ID}", "${SKATEBOARDING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Skateboarding without Leagues in queryParams
    [Tags]  skateboarding    valid     CSEAUTO-27154   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SKATEBOARDING_ID}", "${SKATEBOARDING_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Skateboarding Leagues with Filter invalid
    [Tags]  skateboarding    invalid   CSEAUTO-27155   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Skateboarding with empty string in queryParams
    [Tags]  skateboarding    invalid     CSEAUTO-27156   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
