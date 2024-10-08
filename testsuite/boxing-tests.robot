*** Settings ***
Documentation       Boxing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/boxing-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/BoxingSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    boxing
${BOXING_ID}  9
${BOXING_NAME}    Boxing


*** Test Cases ***
# Boxing
#--------------------------------CSEAUTO-25583-------------------------------------------------------------------------#
Get Boxing Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Boxing
    [Tags]  boxing  valid    smoke    	CSEAUTO-26740
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Boxing
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${BOXING_ID}", "${BOXING_NAME}", "${SPORT}"]

Get Boxing Leagues
    [Documentation]    ESPN core sport API GET call for Boxing with leagues
    [Tags]  boxing_league    boxing  valid    smoke       CSEAUTO-26741
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Boxing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${BOXING_ID}", "${BOXING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Boxing Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Boxing leagues with filter season
    [Tags]  boxing_league    boxing    valid    smoke       	CSEAUTO-26742
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Boxing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${BOXING_ID}", "${BOXING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Boxing without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Boxing without leagues in queryparams
    [Tags]  boxing_league    boxing   valid      	CSEAUTO-26743
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Boxing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${BOXING_ID}", "${BOXING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Boxing Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Boxing leagues with invalid filter
    [Tags]  boxing_league    boxing   invalid       	CSEAUTO-26744
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Boxing with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Boxing with empty string in queryparams
    [Tags]  boxing_league    boxing   invalid       	CSEAUTO-26745
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-25583-------------------------------------------------------------------------#
