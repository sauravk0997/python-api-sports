*** Settings ***
Documentation       Gymnastic - Trampoline tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/gymnastic-trampoline-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.GymnasticTrampolineValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          trampoline
${GYMNASTIC_TRAMPOLINE_ID}      23
${GYMNASTIC_TRAMPOLINE_NAME}    Gymnastics - Trampoline

*** Test Cases ***
Get Gymnastic-Trampoline Baseline Responses
    [Tags]  gymnastic-trampoline  valid   CSEAUTO-27033
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_TRAMPOLINE_ID}", "${GYMNASTIC_TRAMPOLINE_NAME}", "${SPORT}"]

# Tests start for gymnastic-trampoline_leagues (https://jira.disney.com/browse/CSEAUTO-26924)

Get Gymnastic-Trampoline Leagues
    [Tags]  gymnastic-trampoline  valid   CSEAUTO-27037   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for gymnastic-trampoline
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_TRAMPOLINE_ID}", "${GYMNASTIC_TRAMPOLINE_NAME}", "${SPORT}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Gymnastic-Trampoline Leagues with Filter Season
    [Tags]  gymnastic-trampoline  valid   CSEAUTO-27040  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for gymnastic-trampoline
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_TRAMPOLINE_ID}", "${GYMNASTIC_TRAMPOLINE_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Gymnastic-Trampoline without Leagues in queryParams
    [Tags]  gymnastic-trampoline    valid     CSEAUTO-27041   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_TRAMPOLINE_ID}", "${GYMNASTIC_TRAMPOLINE_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Gymnastic-Trampoline Leagues with Filter invalid
    [Tags]  gymnastic-trampoline    invalid   CSEAUTO-27042   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Gymnastic-Trampoline with empty string in queryParams
    [Tags]  gymnastic-trampoline    invalid     CSEAUTO-27043   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
