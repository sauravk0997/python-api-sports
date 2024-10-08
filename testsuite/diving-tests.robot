*** Settings ***
Documentation       Diving tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/Diving-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.DivingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          diving
${DIVING_ID}      16
${DIVING_NAME}    Diving

*** Test Cases ***
Get Diving Baseline Responses
    [Tags]  diving  valid   CSEAUTO-27174
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${DIVING_ID}", "${DIVING_NAME}", "${SPORT}"]

# Tests start for diving_leagues (https://jira.disney.com/browse/CSEAUTO-26935)

Get Diving Leagues
    [Tags]  diving  valid   CSEAUTO-27175   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for diving
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${DIVING_ID}", "${DIVING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Diving Leagues with Filter Season
    [Tags]  diving  valid   CSEAUTO-27176  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for diving
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${DIVING_ID}", "${DIVING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Diving without Leagues in queryParams
    [Tags]  diving    valid     CSEAUTO-27177   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${DIVING_ID}", "${DIVING_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Diving Leagues with Filter invalid
    [Tags]  diving    invalid   CSEAUTO-27178   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Diving with empty string in queryParams
    [Tags]  diving    invalid     CSEAUTO-27180   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
