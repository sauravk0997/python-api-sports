*** Settings ***
Documentation       Water Polo tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/waterpolo-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.WaterPoloValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}             water-polo
${WATERPOLO_NAME}    Water Polo
${WATERPOLO_SLUG}    ${SPORT}
${WATERPOLO_ID}      1920
${WATERPOLO_UID}     s:${WATERPOLO_ID}


*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-25578 ###########################
Get Water Polo Baseline Responses
    [Tags]  water-polo  valid   CSEAUTO-26650
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for water polo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug", "uid"]   ["${WATERPOLO_ID}", "${WATERPOLO_NAME}", "${WATERPOLO_SLUG}", "${WATERPOLO_UID}"]

Get Water Polo Leagues
    [Tags]  water-polo  valid   CSEAUTO-26651   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for water polo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug", "uid"]   ["${WATERPOLO_ID}", "${WATERPOLO_NAME}", "${WATERPOLO_SLUG}", "${WATERPOLO_UID}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Water Polo Leagues with Filter Season
    [Tags]  water-polo  valid   CSEAUTO-26656   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for water polo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug", "uid"]   ["${WATERPOLO_ID}", "${WATERPOLO_NAME}", "${WATERPOLO_SLUG}", "${WATERPOLO_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Water Polo without Leagues in queryParams
    [Tags]  water-polo    valid     CSEAUTO-26657   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for water polo
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug", "uid"]   ["${WATERPOLO_ID}", "${WATERPOLO_NAME}", "${WATERPOLO_SLUG}", "${WATERPOLO_UID}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Water Polo Leagues with Filter invalid
    [Tags]  water-polo    invalid   CSEAUTO-26658   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Water Polo with empty string in queryParams
    [Tags]  water-polo    invalid     CSEAUTO-26659   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-25578 ###########################