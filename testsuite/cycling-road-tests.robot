*** Settings ***
Documentation       Cycling Road tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/waterpolo-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.CyclingRoadValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                road-cycling
${CYCLING_ROAD_NAME}    Cycling - Road
${CYCLING_ROAD_SLUG}    ${SPORT}
${CYCLING_ROAD_ID}      13

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-25579 ###########################
Get Cycling Road Baseline Responses
    [Tags]  cycling-road  valid   CSEAUTO-26717
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for cycling road
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_ROAD_ID}", "${CYCLING_ROAD_NAME}", "${CYCLING_ROAD_SLUG}"]

Get Cycling Road Leagues
    [Tags]  cycling-road  valid   CSEAUTO-26718   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for cycling road
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_ROAD_ID}", "${CYCLING_ROAD_NAME}", "${CYCLING_ROAD_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Cycling Road Leagues with Filter Season
    [Tags]  cycling-road  valid   CSEAUTO-26719   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for cycling road
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_ROAD_ID}", "${CYCLING_ROAD_NAME}", "${CYCLING_ROAD_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Cycling Road without Leagues in queryParams
    [Tags]  cycling-road    valid     CSEAUTO-26720   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for cycling road
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${CYCLING_ROAD_ID}", "${CYCLING_ROAD_NAME}", "${CYCLING_ROAD_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Cycling Road Leagues with Filter invalid
    [Tags]  cycling-road    invalid   CSEAUTO-26721   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Cycling Road with empty string in queryParams
    [Tags]  cycling-road    invalid     CSEAUTO-26722   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-25578 ###########################