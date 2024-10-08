*** Settings ***
Documentation       Softball tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/Softball-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/SoftballSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    softball
${SOFTBALL_ID}  100
${SOFTBALL_UID}  s:${SOFTBALL_ID}
${SOFTBALL_NAME}    Softball


*** Test Cases ***
# Softball
#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
Get Softball Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Softball
    [Tags]  softball  valid    smoke  	CSEAUTO-27029
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Softball
    Validate the expected and actual values from the response         ${response.json()}
    ...        ["id", "uid", "name", "slug"]       ["${SOFTBALL_ID}", "${SOFTBALL_UID}", "${SOFTBALL_NAME}", "${SPORT}"]

Get Softball Leagues
    [Documentation]    ESPN core sport API GET call for Softball with leagues
    [Tags]  softball_league    softball  valid    smoke     CSEAUTO-27032
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Softball
    Validate the expected and actual values from the response    ${response.json()}
    ...        ["id", "uid", "name", "slug"]       ["${SOFTBALL_ID}", "${SOFTBALL_UID}", "${SOFTBALL_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Softball Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Softball leagues with filter season
    [Tags]  softball_league    softball    valid    smoke       	CSEAUTO-27083
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Softball
    Validate the expected and actual values from the response    ${response.json()}
    ...        ["id", "uid", "name", "slug"]       ["${SOFTBALL_ID}", "${SOFTBALL_UID}", "${SOFTBALL_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Softball without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Softball without leagues in queryparams
    [Tags]  softball_league    softball   valid      	CSEAUTO-27035
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Softball
    Validate the expected and actual values from the response    ${response.json()}
    ...        ["id", "uid", "name", "slug"]       ["${SOFTBALL_ID}", "${SOFTBALL_UID}", "${SOFTBALL_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Softball Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Softball leagues with invalid filter
    [Tags]  softball_league    softball   invalid       	CSEAUTO-27038
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Softball with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Softball with empty string in queryparams
    [Tags]  softball_league    softball   invalid   	CSEAUTO-27039
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
