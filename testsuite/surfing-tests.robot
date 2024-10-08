*** Settings ***
Documentation       Surfing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/surfing-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.SurfingValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    surfing
${SURFING_ID}  109
${SURFING_SLUG}    ${SPORT}
${SURFING_NAME}    Surfing

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-26922 ###########################
Get Surfing Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Surfing
    [Tags]  surfing  valid    smoke     cseauto-26922    cseauto-27018
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for surfing
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${SURFING_ID}", "${SURFING_NAME}", "${SURFING_SLUG}"]

Get Surfing Leagues
    [Documentation]    ESPN core sport API GET call for Surfing with leagues
    [Tags]  surfing_league    surfing     valid    smoke      cseauto-26922    cseauto-27019
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for surfing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SURFING_ID}", "${SURFING_NAME}", "${SURFING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Surfing Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Surfing leagues with filter season
    [Tags]  surfing_league    surfing    valid    smoke    cseauto-26922    cseauto-27020
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for surfing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SURFING_ID}", "${SURFING_NAME}", "${SURFING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Surfing without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Surfing without leagues in queryparams
    [Tags]  surfing_league    surfing   valid    cseauto-26922    cseauto-27021
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for surfing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SURFING_ID}", "${SURFING_NAME}", "${SURFING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Surfing Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Surfing leagues with invalid filter
    [Tags]  surfing_league    surfing   invalid    cseauto-26922    cseauto-27022
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Surfing with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Surfing with empty string in queryparams
    [Tags]  surfing_league    surfing      invalid    cseauto-26922    cseauto-27024
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
################## END https://jira.disney.com/browse/CSEAUTO-26922 ###########################
