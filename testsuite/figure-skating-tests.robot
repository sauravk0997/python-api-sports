*** Settings ***
Documentation       Figure Skating tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/figure-skating-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.FigureSkatingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          figure-skating
${FIGURE_SKATING_ID}      18
${FIGURE_SKATING_NAME}    Figure Skating

*** Test Cases ***
Get Figure-Skating Baseline Responses
    [Tags]  figure-skating  valid   CSEAUTO-26965
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FIGURE_SKATING_ID}", "${FIGURE_SKATING_NAME}", "${SPORT}"]

# Tests start for figure-skating_leagues (https://jira.disney.com/browse/CSEAUTO-26924)

Get Figure-Skating Leagues
    [Tags]  figure-skating  valid   CSEAUTO-26968   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for figure-skating
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FIGURE_SKATING_ID}", "${FIGURE_SKATING_NAME}", "${SPORT}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Figure-Skating Leagues with Filter Season
    [Tags]  figure-skating  valid   CSEAUTO-26969  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for figure-skating
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FIGURE_SKATING_ID}", "${FIGURE_SKATING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Figure-Skating without Leagues in queryParams
    [Tags]  figure-skating    valid     CSEAUTO-26970   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FIGURE_SKATING_ID}", "${FIGURE_SKATING_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Figure-Skating Leagues with Filter invalid
    [Tags]  figure-skating    invalid   CSEAUTO-26972   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Figure-Skating with empty string in queryParams
    [Tags]  figure-skating    invalid     CSEAUTO-26973   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
