*** Settings ***
Documentation       Wrestling tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/wrestling-tests.robot

Library             RequestsLibrary
Library             lib.validators/ESPNSportsCoreValidator
Library             lib.validators.WrestlingSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    wrestling
${WRESTLING_ID}  50
${WRESTLING_NAME}    Wrestling


*** Test Cases ***
# Wrestling
#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
Get Wrestling Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Wrestling
    [Tags]  wrestling  valid    smoke    	CSEAUTO-27069
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Wrestling
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${WRESTLING_ID}", "${WRESTLING_NAME}", "${SPORT}"]

Get Wrestling Leagues
    [Documentation]    ESPN core sport API GET call for Wrestling with leagues
    [Tags]  wrestling_league    wrestling    valid    smoke   	CSEAUTO-27070
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Wrestling
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${WRESTLING_ID}", "${WRESTLING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Wrestling Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Wrestling leagues with filter season
    [Tags]  wrestling_league    wrestling    valid    smoke       	CSEAUTO-27071
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Wrestling
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${WRESTLING_ID}", "${WRESTLING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Wrestling without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Wrestling without leagues in queryparams
    [Tags]  wrestling_league    wrestling      valid      	CSEAUTO-27072
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Wrestling
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${WRESTLING_ID}", "${WRESTLING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Wrestling Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Wrestling leagues with invalid filter
    [Tags]  wrestling_league    wrestling   invalid   	CSEAUTO-27073
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Wrestling with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Wrestling with empty string in queryparams
    [Tags]  wrestling_league    wrestling      invalid   	CSEAUTO-27074
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
