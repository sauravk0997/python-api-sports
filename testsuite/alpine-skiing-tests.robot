*** Settings ***
Documentation       Alpine Skiing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/alpine-skiing-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.AlpineSkiingValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          alpine-skiing
${ALPINE_SKIING_ID}      1
${ALPINE_SKIING_NAME}    Alpine Skiing

*** Test Cases ***
Get Alpine-Skiing Baseline Responses
    [Tags]  alpine-skiing  valid   CSEAUTO-26956
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ALPINE_SKIING_ID}", "${ALPINE_SKIING_NAME}", "${SPORT}"]

# Tests start for alpine-skiing_leagues (https://jira.disney.com/browse/CSEAUTO-26924)

Get Alpine-Skiing Leagues
    [Tags]  alpine-skiing  valid   CSEAUTO-26958   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for alpine-skiing
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ALPINE_SKIING_ID}", "${ALPINE_SKIING_NAME}", "${SPORT}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Alpine-Skiing Leagues with Filter Season
    [Tags]  alpine-skiing  valid   CSEAUTO-26959  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for alpine-skiing
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ALPINE_SKIING_ID}", "${ALPINE_SKIING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Alpine-Skiing without Leagues in queryParams
    [Tags]  alpine-skiing    valid     CSEAUTO-26960   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ALPINE_SKIING_ID}", "${ALPINE_SKIING_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Alpine-Skiing Leagues with Filter invalid
    [Tags]  alpine-skiing    invalid   CSEAUTO-26961   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Alpine-Skiing with empty string in queryParams
    [Tags]  alpine-skiing    invalid     CSEAUTO-26962   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
