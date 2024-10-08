*** Settings ***
Documentation       Cycling-Track tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/cycling-track-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/CyclingTrackSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    track-cycling
${CYCLING_TRACK_ID}  15
${CYCLING_TRACK_NAME}    Cycling - Track

*** Test Cases ***
# Cycling-Track
#--------------------------------CSEAUTO-25584-------------------------------------------------------------------------#

Get Cycling Track Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Cycling-Track
    [Tags]  cycling-track  valid    smoke    CSEAUTO-26464
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${CYCLING_TRACK_ID}", "${CYCLING_TRACK_NAME}", "${SPORT}"]

Get Cycling Track Leagues
    [Documentation]    ESPN core sport API GET call for Cycling Track with leagues
    [Tags]  cycling-track_league    cycling-track  valid    smoke     	CSEAUTO-26465
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Cycling Track
    Validate the expected and actual values from the response   ${response.json()}
    ...         ["id", "name", "slug"]   ["${CYCLING_TRACK_ID}", "${CYCLING_TRACK_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Cycling Track Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Cycling Track leagues with filter season
    [Tags]  cycling-track_league    cycling-track  valid    smoke     	CSEAUTO-26466
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Cycling Track
    Validate the expected and actual values from the response   ${response.json()}
    ...         ["id", "name", "slug"]   ["${CYCLING_TRACK_ID}", "${CYCLING_TRACK_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Cycling Track without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Cycling Track without leagues in queryparams
    [Tags]  cycling-track_league    cycling-track  valid        CSEAUTO-26467
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Cycling Track
    Validate the expected and actual values from the response   ${response.json()}
        ...         ["id", "name", "slug"]   ["${CYCLING_TRACK_ID}", "${CYCLING_TRACK_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}
    dictionary should not contain key    ${response.json()}     leagues

Get Cycling Track Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Cycling Track leagues with invalid filter
    [Tags]  cycling-track_league    cycling-track        invalid       CSEAUTO-26468
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Cycling Track with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Cycling Track with empty string in queryparams
    [Tags]  cycling-track_league    cycling-track    invalid       CSEAUTO-26469
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-25584-------------------------------------------------------------------------#
