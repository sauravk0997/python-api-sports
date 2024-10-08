*** Settings ***
Documentation       Luge tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/luge-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.LugeValidator 
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          luge
${LUGE_NAME}    Luge
${LUGE_SLUG}    ${SPORT}
${LUGE_ID}        27

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-26967 ###########################
Get Luge Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Luge
    [Tags]  luge  valid   cseauto-26967    cseauto-27217
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for luge
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${LUGE_ID}", "${LUGE_NAME}", "${LUGE_SLUG}"]

Get Luge Leagues
    [Documentation]    ESPN core sport API GET call for Luge with leagues
    [Tags]  luge  valid    league_season    cseauto-26967    cseauto-27218
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for luge
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${LUGE_ID}", "${LUGE_NAME}", "${LUGE_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Luge Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Luge leagues with filter season
    [Tags]  luge  valid    league_season    cseauto-26967    cseauto-27219
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for luge
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${LUGE_ID}", "${LUGE_NAME}", "${LUGE_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Luge without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Luge without leagues in queryparams
    [Tags]  luge    valid    league_season    cseauto-26967    cseauto-27220
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for luge
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${LUGE_ID}", "${LUGE_NAME}", "${LUGE_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Luge Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Luge leagues with invalid filter
    [Tags]  luge    invalid    league_season   cseauto-26967    cseauto-27221
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Luge with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Luge with empty string in queryparams
    [Tags]  luge    invalid    league_season    cseauto-26967    cseauto-27222  
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-26967 ###########################