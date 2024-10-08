*** Settings ***
Documentation       Cycling Bmx tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/cycling-bmx-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.CyclingBmxValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          bmx
${CYCLING_BMX_NAME}    Cycling - BMX
${CYCLING_BMX_SLUG}    ${SPORT}
${CYCLING_BMX_ID}        97

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-26967 ###########################
Get Cycling BMX Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Cycling Bmx
    [Tags]  cycling-bmx  valid   cseauto-26967    cseauto-27205
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for cycling bmx
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_BMX_ID}", "${CYCLING_BMX_NAME}", "${CYCLING_BMX_SLUG}"]

Get Cycling BMX Leagues
    [Documentation]    ESPN core sport API GET call for Cycling Bmx with leagues
    [Tags]  cycling-bmx  valid    league_season    cseauto-26967    cseauto-27206
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for cycling bmx
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_BMX_ID}", "${CYCLING_BMX_NAME}", "${CYCLING_BMX_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Cycling BMX Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Cycling Bmx leagues with filter season
    [Tags]  cycling-bmx  valid    league_season    cseauto-26967    cseauto-27207
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for cycling bmx
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_BMX_ID}", "${CYCLING_BMX_NAME}", "${CYCLING_BMX_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Cycling BMX without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Cycling Bmx without leagues in queryparams
    [Tags]  cycling-bmx    valid    league_season    cseauto-26967    cseauto-27208
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for cycling bmx
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_BMX_ID}", "${CYCLING_BMX_NAME}", "${CYCLING_BMX_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Cycling BMX Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Cycling Bmx leagues with invalid filter
    [Tags]  cycling-bmx    invalid    league_season   cseauto-26967    cseauto-27209
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Cycling BMX with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Cycling Bmx with empty string in queryparams
    [Tags]  artistic-swimming    invalid    league_season    cseauto-26967    cseauto-27210
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-26967 ###########################