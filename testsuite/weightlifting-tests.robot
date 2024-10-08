*** Settings ***
Documentation       Weightlifting tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/weightlifting-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.WeightliftingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                 weightlifting
${WEIGHTLIFTING_NAME}    Weightlifting
${WEIGHTLIFTING_SLUG}    ${SPORT}
${WEIGHTLIFTING_ID}      48


*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-25579 ###########################
Get Weightlifting Baseline Responses
    [Tags]  weightlifting  valid   CSEAUTO-26724
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid for weightlifting
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${WEIGHTLIFTING_ID}", "${WEIGHTLIFTING_NAME}", "${WEIGHTLIFTING_SLUG}"]

Get Weightlifting Leagues
    [Tags]  weightlifting  valid   CSEAUTO-26725   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for weightlifting
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${WEIGHTLIFTING_ID}", "${WEIGHTLIFTING_NAME}", "${WEIGHTLIFTING_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Weightlifting Leagues with Filter Season
    [Tags]  weightlifting  valid   CSEAUTO-26726   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for weightlifting
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${WEIGHTLIFTING_ID}", "${WEIGHTLIFTING_NAME}", "${WEIGHTLIFTING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Weightlifting without Leagues in queryParams
    [Tags]  weightlifting    valid     CSEAUTO-26727   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for weightlifting
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${WEIGHTLIFTING_ID}", "${WEIGHTLIFTING_NAME}", "${WEIGHTLIFTING_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Weightlifting Leagues with Filter invalid
    [Tags]  weightlifting    invalid   CSEAUTO-26728   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Weightlifting with empty string in queryParams
    [Tags]  weightlifting    invalid     CSEAUTO-26729   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

################## END https://jira.disney.com/browse/CSEAUTO-25578 ###########################