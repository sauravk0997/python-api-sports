*** Settings ***
Documentation       Fencing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/fencing-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/FencingSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    fencing
${FENCING_ID}  20
${FENCING_NAME}    Fencing


*** Test Cases ***
# Fencing
#--------------------------------CSEAUTO-25580-------------------------------------------------------------------------#
Get Fencing Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Fencing
    [Tags]  fencing  valid    smoke    	CSEAUTO-26842
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Fencing
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${FENCING_ID}", "${FENCING_NAME}", "${SPORT}"]

Get Fencing Leagues
    [Documentation]    ESPN core sport API GET call for Fencing with leagues
    [Tags]  fencing_league    fencing  valid    smoke       	CSEAUTO-26843
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Fencing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${FENCING_ID}", "${FENCING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Fencing Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Fencing leagues with filter season
    [Tags]  fencing_league    fencing    valid    smoke       	CSEAUTO-26844
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Fencing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${FENCING_ID}", "${FENCING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Fencing without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Fencing without leagues in queryparams
    [Tags]  fencing_league    fencing     valid     	CSEAUTO-26845
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Fencing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${FENCING_ID}", "${FENCING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Fencing Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Fencing leagues with invalid filter
    [Tags]  fencing_league    fencing      invalid       	CSEAUTO-26898
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Fencing with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Fencing with empty string in queryparams
    [Tags]  fencing_league    fencing      invalid       	CSEAUTO-26899
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-25580-------------------------------------------------------------------------#
