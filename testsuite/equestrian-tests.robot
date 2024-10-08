*** Settings ***
Documentation       Equestrian tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/equestrian-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.EquestrianValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          equestrian
${EQUESTRIAN_ID}      17
${EQUESTRIAN_NAME}    Equestrian

*** Test Cases ***
Get Equestrian Baseline Responses
    [Tags]  equestrian  valid   CSEAUTO-27181
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${EQUESTRIAN_ID}", "${EQUESTRIAN_NAME}", "${SPORT}"]

# Tests start for equestrian_leagues (https://jira.disney.com/browse/CSEAUTO-26935)

Get Equestrian Leagues
    [Tags]  equestrian  valid   CSEAUTO-27182   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for equestrian
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${EQUESTRIAN_ID}", "${EQUESTRIAN_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Equestrian Leagues with Filter Season
    [Tags]  equestrian  valid   CSEAUTO-27183  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for equestrian
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${EQUESTRIAN_ID}", "${EQUESTRIAN_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Equestrian without Leagues in queryParams
    [Tags]  equestrian    valid     CSEAUTO-27185   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${EQUESTRIAN_ID}", "${EQUESTRIAN_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Equestrian Leagues with Filter invalid
    [Tags]  equestrian    invalid   CSEAUTO-27187   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Equestrian with empty string in queryParams
    [Tags]  equestrian    invalid     CSEAUTO-27188   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
