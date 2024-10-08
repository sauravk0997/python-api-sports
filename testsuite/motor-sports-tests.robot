*** Settings ***
Documentation       Motor-Sports tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/Motor-sports-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.MotorSportsValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                racing
${MOTOR_SPORTS_ID}      2000
${MOTOR_SPORTS_UID}     s:${MOTOR_SPORTS_ID}
${MOTOR_SPORTS_GUID}    a5f9ac6b-82e3-3891-a17a-ea2d693b8331
${MOTOR_SPORTS_NAME}    Motor Sports
${MOTOR_SPORTS_SLUG}    ${SPORT}


*** Test Cases ***
# MOTOR_SPORTS
Get motor-sports Baseline Responses
    [Tags]  motor-sports  valid   CSEAUTO-26544
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]   ["${MOTOR_SPORTS_ID}", "${MOTOR_SPORTS_UID}", "${MOTOR_SPORTS_GUID}", "${MOTOR_SPORTS_NAME}", "${MOTOR_SPORTS_SLUG}"]

# Tests start for MOTOR_SPORTS_leagues (https://jira.disney.com/browse/CSEAUTO-26480)

Get motor-sports Leagues
    [Tags]  motor-sports  valid   CSEAUTO-26546   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for motor-sports
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]   ["${MOTOR_SPORTS_ID}", "${MOTOR_SPORTS_UID}", "${MOTOR_SPORTS_GUID}", "${MOTOR_SPORTS_NAME}", "${MOTOR_SPORTS_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get motor-sports Leagues with Filter Season
    [Tags]  motor-sports  valid   CSEAUTO-26570   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for motor-sports
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]   ["${MOTOR_SPORTS_ID}", "${MOTOR_SPORTS_UID}", "${MOTOR_SPORTS_GUID}", "${MOTOR_SPORTS_NAME}", "${MOTOR_SPORTS_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}
    set test message    Expected the 'season' key exist in the JSON response, but not found; So validating the same key does not exist

Get motor-sports without Leagues in queryParams
    [Tags]  motor-sports    valid     CSEAUTO-26550   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]   ["${MOTOR_SPORTS_ID}", "${MOTOR_SPORTS_UID}", "${MOTOR_SPORTS_GUID}", "${MOTOR_SPORTS_NAME}", "${MOTOR_SPORTS_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get motor-sports Leagues with Filter invalid
    [Tags]  motor-sports    invalid   CSEAUTO-26552   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get motor-sports with empty string in queryParams
    [Tags]  motor-sports    invalid     CSEAUTO-26554   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

