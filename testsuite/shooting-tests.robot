*** Settings ***
Documentation       Shooting tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/shooting-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/ShootingSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    shooting
${SHOOTING_ID}  37
${SHOOTING_NAME}    Shooting


*** Test Cases ***
# Shooting
#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
Get Shooting Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Shooting
    [Tags]  shooting  valid    smoke    	CSEAUTO-27003
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Shooting
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${SHOOTING_ID}", "${SHOOTING_NAME}", "${SPORT}"]

Get Shooting Leagues
    [Documentation]    ESPN core sport API GET call for Shooting with leagues
    [Tags]  shooting_league    shooting       valid    smoke       CSEAUTO-27004
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Shooting
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SHOOTING_ID}", "${SHOOTING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Shooting Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Shooting leagues with filter season
    [Tags]  shooting_league    shooting    valid    smoke       	CSEAUTO-27005
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Shooting
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SHOOTING_ID}", "${SHOOTING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Shooting without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Shooting without leagues in queryparams
    [Tags]  shooting_league    shooting    valid     	CSEAUTO-27006
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Shooting
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SHOOTING_ID}", "${SHOOTING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Shooting Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Shooting leagues with invalid filter
    [Tags]  shooting_league    shooting        invalid      	CSEAUTO-27008
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Shooting with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Shooting with empty string in queryparams
    [Tags]  shooting_league    shooting   invalid 		CSEAUTO-27011
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
