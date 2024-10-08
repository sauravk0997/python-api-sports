*** Settings ***
Documentation       Gymnastic - Artistic tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/gymnastic-artistic-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.GymnasticArtisticValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          artistic-gymnastics
${GYMNASTIC_ARTISTIC_ID}      21
${GYMNASTIC_ARTISTIC_NAME}    Gymnastics - Artistic


*** Test Cases ***
Get Gymnastic-Artistic Baseline Responses
    [Tags]  gymnastic-artistic  valid   CSEAUTO-26989
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_ARTISTIC_ID}", "${GYMNASTIC_ARTISTIC_NAME}", "${SPORT}"]

# Tests start for gymnastic-artistic_leagues (https://jira.disney.com/browse/CSEAUTO-26924)

Get Gymnastic-Artistic Leagues
    [Tags]  gymnastic-artistic  valid   CSEAUTO-26990   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for gymnastic-artistic
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_ARTISTIC_ID}", "${GYMNASTIC_ARTISTIC_NAME}", "${SPORT}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Gymnastic-Artistic Leagues with Filter Season
    [Tags]  gymnastic-artistic  valid   CSEAUTO-26991  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for gymnastic-artistic
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_ARTISTIC_ID}", "${GYMNASTIC_ARTISTIC_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Gymnastic-Artistic without Leagues in queryParams
    [Tags]  gymnastic-artistic    valid     CSEAUTO-26992   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${GYMNASTIC_ARTISTIC_ID}", "${GYMNASTIC_ARTISTIC_NAME}", "${SPORT}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Gymnastic-Artistic Leagues with Filter invalid
    [Tags]  gymnastic-artistic    invalid   CSEAUTO-26993   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Gymnastic-Artistic with empty string in queryParams
    [Tags]  gymnastic-artistic    invalid     CSEAUTO-26994   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
