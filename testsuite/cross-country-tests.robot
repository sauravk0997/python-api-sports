*** Settings ***
Documentation       Cross-Country tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/cross-country-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/CrossCountrySportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    cross-country
${CROSS_COUNTRY_ID}  52
${CROSS_COUNTRY_NAME}    Cross-Country


*** Test Cases ***
# Cross-Country
#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
Get Cross-Country Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Cross-Country
    [Tags]  cross-country  valid    smoke    CSEAUTO-27076
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Cross-Country
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${CROSS_COUNTRY_ID}", "${CROSS_COUNTRY_NAME}", "${SPORT}"]

Get Cross-Country Leagues
    [Documentation]    ESPN core sport API GET call for Cross-Country with leagues
    [Tags]  cross-country_league    cross-country     valid    smoke      CSEAUTO-27077
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Cross-Country
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${CROSS_COUNTRY_ID}", "${CROSS_COUNTRY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Cross-Country Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Cross-Country leagues with filter season
    [Tags]  cross-country_league    cross-country    valid    smoke       	CSEAUTO-27078
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Cross-Country
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${CROSS_COUNTRY_ID}", "${CROSS_COUNTRY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Cross-Country without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Cross-Country without leagues in queryparams
    [Tags]  cross-country_league    cross-country   valid    	CSEAUTO-27079
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Cross-Country
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${CROSS_COUNTRY_ID}", "${CROSS_COUNTRY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Cross-Country Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Cross-Country leagues with invalid filter
    [Tags]  cross-country_league    cross-country   invalid       		CSEAUTO-27080
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Cross-Country with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Cross-Country with empty string in queryparams
    [Tags]  cross-country_league    cross-country        invalid     	CSEAUTO-27082
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-26920-------------------------------------------------------------------------#
