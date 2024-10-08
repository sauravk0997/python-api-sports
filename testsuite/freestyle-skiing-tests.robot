*** Settings ***
Documentation       FreeStyle Skiing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/freestyle-skiing-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.FreestyleSkiingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                    freestyle-skiing
${FREESTYLE-SKIING_NAME}    Freestyle Skiing
${FREESTYLE-SKIING_SLUG}    ${SPORT}
${FREESTYLE-SKIING_ID}      41


*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-25578 ###########################
Get Freestyle Skiing Baseline Responses
    [Tags]  freestyle-skiing  valid   CSEAUTO-26642
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FREESTYLE-SKIING_ID}", "${FREESTYLE-SKIING_NAME}", "${FREESTYLE-SKIING_SLUG}"]

Get Freestyle Skiing Leagues
    [Tags]  freestyle-skiing  valid   CSEAUTO-26643   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for freestyle skiing
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FREESTYLE-SKIING_ID}", "${FREESTYLE-SKIING_NAME}", "${FREESTYLE-SKIING_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Freestyle Skiing Leagues with Filter Season
    [Tags]  freestyle-skiing  valid   CSEAUTO-26644   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for freestyle skiing
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FREESTYLE-SKIING_ID}", "${FREESTYLE-SKIING_NAME}", "${FREESTYLE-SKIING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}
    Set Test Message    Season details are not consistent for all league objects

Get Free Skiing without Leagues in queryParams
    [Tags]  freestyle-skiing    valid     CSEAUTO-26645  league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${FREESTYLE-SKIING_ID}", "${FREESTYLE-SKIING_NAME}", "${FREESTYLE-SKIING_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Free Skiing Leagues with Filter invalid
    [Tags]  freestyle-skiing    invalid   CSEAUTO-26646   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Free Skiing with empty string in queryParams
    [Tags]  freestyle-skiing    invalid     CSEAUTO-26647   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-25578 ###########################