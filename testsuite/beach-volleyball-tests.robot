*** Settings ***
Documentation       Beach Volleyball tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/beach-volleyball-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.BeachVolleyballValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                    beach-volleyball
${BEACH_VOLLEYBALL_NAME}    Beach Volleyball
${BEACH_VOLLEYBALL_SLUG}    ${SPORT}
${BEACH_VOLLLEYBALL_ID}     8

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-25579 ###########################
Get Beach Volleyball Baseline Responses
    [Tags]  beach-volleyball  valid   CSEAUTO-26711
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for beach volleyball
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${BEACH_VOLLLEYBALL_ID}", "${BEACH_VOLLEYBALL_NAME}", "${BEACH_VOLLEYBALL_SLUG}"]

Get Beach Volleyball Leagues
    [Tags]  beach-volleyball  valid   CSEAUTO-26712   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for beach volleyball
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${BEACH_VOLLLEYBALL_ID}", "${BEACH_VOLLEYBALL_NAME}", "${BEACH_VOLLEYBALL_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Beach Volleyball Leagues with Filter Season
    [Tags]  beach-volleyball  valid   CSEAUTO-26713   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for beach volleyball
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${BEACH_VOLLLEYBALL_ID}", "${BEACH_VOLLEYBALL_NAME}", "${BEACH_VOLLEYBALL_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Beach Volleyball without Leagues in queryParams
    [Tags]  beach-volleyball    valid     CSEAUTO-26714   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for beach volleyball
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${BEACH_VOLLLEYBALL_ID}", "${BEACH_VOLLEYBALL_NAME}", "${BEACH_VOLLEYBALL_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Beach Volleyball Leagues with Filter invalid
    [Tags]  beach-volleyball    invalid   CSEAUTO-26715   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Beach Volleyball with empty string in queryParams
    [Tags]  beach-volleyball    invalid     CSEAUTO-26716   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-25578 ###########################