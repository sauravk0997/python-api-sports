*** Settings ***
Documentation       Artistic Swimming tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/artistic-swimming-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.ArtisticSwimmingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          artistic-swimming
${ARTISTIC_SWIMMING_NAME}    Artistic Swimming
${ARTISTIC_SWIMMING_SLUG}    ${SPORT}
${ARTISTIC_SWIMMING_ID}        40

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-26967 ###########################
Get Artistic Swimming Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Artistic Swimming
    [Tags]  artistic-swimming  valid   cseauto-26967    cseauto-27199
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for artistic swimming
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ARTISTIC_SWIMMING_ID}", "${ARTISTIC_SWIMMING_NAME}", "${ARTISTIC_SWIMMING_SLUG}"]

Get Artistic Swimming Leagues
    [Documentation]    ESPN core sport API GET call for Artistic Swimming with leagues
    [Tags]  artistic-swimming  valid    league_season    cseauto-26967    cseauto-27200
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for artistic swimming
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ARTISTIC_SWIMMING_ID}", "${ARTISTIC_SWIMMING_NAME}", "${ARTISTIC_SWIMMING_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Artistic Swimming Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Artistic Swimming leagues with filter season
    [Tags]  artistic-swimming  valid    league_season    cseauto-26967    cseauto-27201
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for artistic swimming
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ARTISTIC_SWIMMING_ID}", "${ARTISTIC_SWIMMING_NAME}", "${ARTISTIC_SWIMMING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Artistic Swimming without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Artistic Swimming without leagues in queryparams
    [Tags]  artistic-swimming    valid    league_season    cseauto-26967    cseauto-27202
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for artistic swimming
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${ARTISTIC_SWIMMING_ID}", "${ARTISTIC_SWIMMING_NAME}", "${ARTISTIC_SWIMMING_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Artistic Swimming Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Artistic Swimming leagues with invalid filter
    [Tags]  artistic-swimming    invalid    league_season   cseauto-26967     cseauto-27203
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Artistic Swimming with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Artistic Swimming with empty string in queryparams
    [Tags]  artistic-swimming    invalid    league_season    cseauto-26967    cseauto-27204
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-26967 ###########################