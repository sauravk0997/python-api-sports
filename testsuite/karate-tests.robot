*** Settings ***
Documentation       Karate tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/karate-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.KarateValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    karate
${KARATE_ID}  107
${KARATE_SLUG}    ${SPORT}
${KARATE_NAME}    Karate

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-26922 ###########################
Get Karate Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Karate
    [Tags]  karate  valid    smoke     cseauto-26922    cseauto-27012
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for karate
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${KARATE_ID}", "${KARATE_NAME}", "${KARATE_SLUG}"]

Get Karate Leagues
    [Documentation]    ESPN core sport API GET call for Karate with leagues
    [Tags]  karate_league    karate     valid    smoke    cseauto-26922    cseauto-27013
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for karate
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${KARATE_ID}", "${KARATE_NAME}", "${KARATE_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Karate Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for karate leagues with filter season
    [Tags]  karate_league    karate    valid    smoke    cseauto-26922    cseauto-27014
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for karate
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${KARATE_ID}", "${KARATE_NAME}", "${KARATE_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Karate without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for karate without leagues in queryparams
    [Tags]  karate_league    karate   valid    cseauto-26922    cseauto-27015
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for karate
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${KARATE_ID}", "${KARATE_NAME}", "${KARATE_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Karate Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for karate leagues with invalid filter
    [Tags]  karate_league    karate   invalid    cseauto-26922    cseauto-27016
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Karate with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for karate with empty string in queryparams
    [Tags]  karate_league    karate      invalid    cseauto-26922    cseauto-27017
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
################## END https://jira.disney.com/browse/CSEAUTO-26922 ###########################
