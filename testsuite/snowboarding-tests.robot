*** Settings ***
Documentation       Snowboarding tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/snowboarding-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.SnowboardingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          snowboarding
${SNOWBOARDING_ID}      33
${SNOWBOARDING_NAME}    Snowboarding

*** Test Cases ***
Get Snowboarding Baseline Responses
    [Tags]  snowboarding  valid   CSEAUTO-27184
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SNOWBOARDING_ID}", "${SNOWBOARDING_NAME}", "${SPORT}"]

# Tests start for snowboarding_leagues (https://jira.disney.com/browse/CSEAUTO-26935)

Get Snowboarding Leagues
    [Tags]  snowboarding  valid   CSEAUTO-27191   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for snowboarding
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SNOWBOARDING_ID}", "${SNOWBOARDING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Snowboarding Leagues with Filter Season
    [Tags]  snowboarding  valid   CSEAUTO-27192  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for snowboarding
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SNOWBOARDING_ID}", "${SNOWBOARDING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Snowboarding without Leagues in queryParams
    [Tags]  snowboarding    valid     CSEAUTO-27193   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${SNOWBOARDING_ID}", "${SNOWBOARDING_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Snowboarding Leagues with Filter invalid
    [Tags]  snowboarding    invalid   CSEAUTO-27194   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Snowboarding with empty string in queryParams
    [Tags]  snowboarding    invalid     CSEAUTO-27195   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
