*** Settings ***
Documentation       Gymnastics Rhythmic tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/gymnastics-rhythmic-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/GymnasticRhythmicSportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    rhythmic-gymnastics
${GYMNASTICRHYTMIC_ID}  22
${GYMNASTICRHYTMIC_NAME}    Gymnastics - Rhythmic


*** Test Cases ***
# Gymnastics Rhythmic
#--------------------------------CSEAUTO-25580-------------------------------------------------------------------------#
Get Gymnastics Rhythmic Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Gymnastics Rhythmic
    [Tags]  rhythmic-gymnastics  valid    smoke     CSEAUTO-26901
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Gymnastic Rhythmic
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${GYMNASTICRHYTMIC_ID}", "${GYMNASTICRHYTMIC_NAME}", "${SPORT}"]

Get Gymnastics Rhythmic Leagues
    [Documentation]    ESPN core sport API GET call for Gymnastics Rhythmic with leagues
    [Tags]  rhythmic-gymnastics_league    rhythmic-gymnastics     valid    smoke      CSEAUTO-26902
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Gymnastic Rhythmic
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${GYMNASTICRHYTMIC_ID}", "${GYMNASTICRHYTMIC_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Gymnastics Rhythmic Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Gymnastics Rhythmic leagues with filter season
    [Tags]  rhythmic-gymnastics_league    rhythmic-gymnastics    valid    smoke       	CSEAUTO-26903
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Gymnastic Rhythmic
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${GYMNASTICRHYTMIC_ID}", "${GYMNASTICRHYTMIC_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Gymnastics Rhythmic without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Gymnastics Rhythmic without leagues in queryparams
    [Tags]  rhythmic-gymnastics_league    rhythmic-gymnastics   valid      	CSEAUTO-26904
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Gymnastic Rhythmic
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${GYMNASTICRHYTMIC_ID}", "${GYMNASTICRHYTMIC_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Gymnastics Rhythmic Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Gymnastics Rhythmic leagues with invalid filter
    [Tags]  rhythmic-gymnastics_league    rhythmic-gymnastics   invalid    		CSEAUTO-26905
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Gymnastics Rhythmic with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Gymnastics Rhythmic with empty string in queryparams
    [Tags]  rhythmic-gymnastics_league    rhythmic-gymnastics      invalid       	CSEAUTO-26906
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-25580-------------------------------------------------------------------------#
