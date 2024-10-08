*** Settings ***
Documentation       Judo tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/judo-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.JudoValidator 
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          judo
${JUDO_NAME}    Judo
${JUDO_SLUG}    ${SPORT}
${JUDO_ID}        26

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-26967 ###########################
Get Judo Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Judo
    [Tags]  judo  valid   cseauto-26967    cseauto-27211
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for judo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${JUDO_ID}", "${JUDO_NAME}", "${JUDO_SLUG}"]

Get Judo Leagues
    [Documentation]    ESPN core sport API GET call for Judo with leagues
    [Tags]  judo  valid    league_season    cseauto-26967    cseauto-27212
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for judo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${JUDO_ID}", "${JUDO_NAME}", "${JUDO_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Judo Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Judo leagues with filter season
    [Tags]  judo  valid    league_season    cseauto-26967    cseauto-27213
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for judo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${JUDO_ID}", "${JUDO_NAME}", "${JUDO_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Judo without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Judo without leagues in queryparams
    [Tags]  judo    valid    league_season    cseauto-26967    cseauto-27214
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for judo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${JUDO_ID}", "${JUDO_NAME}", "${JUDO_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Judo Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Judo leagues with invalid filter
    [Tags]  judo    invalid    league_season   cseauto-26967    cseauto-27215
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Judo with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Judo with empty string in queryparams
    [Tags]  judo    invalid    league_season    cseauto-26967    cseauto-27216
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-26967 ###########################