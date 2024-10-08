*** Settings ***
Documentation       Sailing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/sailing-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/SailingSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    sailing
${SAILING_ID}  36
${SAILING_NAME}    Sailing


*** Test Cases ***
# Sailing
#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
Get Sailing Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Sailing
    [Tags]  sailing  valid    smoke    		CSEAUTO-26996
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Sailing
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${SAILING_ID}", "${SAILING_NAME}", "${SPORT}"]

Get Sailing Leagues
    [Documentation]    ESPN core sport API GET call for Sailing with leagues
    [Tags]  sailing_league    sailing  valid    smoke       CSEAUTO-26997
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Sailing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SAILING_ID}", "${SAILING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Sailing Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Sailing leagues with filter season
    [Tags]  sailing_league    sailing    valid    smoke       	CSEAUTO-26998
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Sailing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SAILING_ID}", "${SAILING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Sailing without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Sailing without leagues in queryparams
    [Tags]  sailing_league    sailing   valid      		CSEAUTO-26999
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Sailing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SAILING_ID}", "${SAILING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Sailing Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Sailing leagues with invalid filter
    [Tags]  sailing_league    sailing   invalid       		CSEAUTO-27000
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Sailing with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Sailing with empty string in queryparams
    [Tags]  sailing_league    sailing   invalid       		CSEAUTO-27001
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
