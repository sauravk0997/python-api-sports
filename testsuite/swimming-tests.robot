*** Settings ***
Documentation       Swimming tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/swimming-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/SwimmingSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    swimming
${SWIMMING_ID}  39
${SWIMMING_NAME}    Swimming

*** Test Cases ***
# Swimming
#--------------------------------CSEAUTO-25581-------------------------------------------------------------------------#
Get Swimming Baseline Responses
    [Documentation]    ESPN core sport base API GET call for swimming
    [Tags]  swimming  valid    smoke    CSEAUTO-26130
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SWIMMING_ID}", "${SWIMMING_NAME}", "${SPORT}"]

Get Swimming Leagues
    [Documentation]    ESPN core sport API GET call for swimming with leagues
    [Tags]  swimming_league    valid      swimming      smoke       CSEAUTO-26132
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Swimming
    Validate the expected and actual values from the response   ${response.json()}
    ...         ["id", "name", "slug"]   ["${SWIMMING_ID}", "${SWIMMING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Swimming Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for swimming leagues with filter season
    [Tags]  swimming_league    swimming    valid    smoke       CSEAUTO-26133
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Swimming
    Validate the expected and actual values from the response   ${response.json()}
    ...         ["id", "name", "slug"]   ["${SWIMMING_ID}", "${SWIMMING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Swimming without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for swimming without leagues in queryparams
    [Tags]  swimming   swimming_league   valid      CSEAUTO-26134
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Swimming
    Validate the expected and actual values from the response   ${response.json()}
        ...         ["id", "name", "slug"]   ["${SWIMMING_ID}", "${SWIMMING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}
    dictionary should not contain key    ${response.json()}     leagues

Get Swimming Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for swimming leagues with invalid filter
    [Tags]  swimming    swimming_league   invalid       CSEAUTO-26135
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Swimming with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for swimming with empty string in queryparams
    [Tags]  swimming    swimming_league   invalid       CSEAUTO-26136
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-25581-------------------------------------------------------------------------#
