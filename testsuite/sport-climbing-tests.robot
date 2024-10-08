*** Settings ***
Documentation       Sport-Climbing tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/sport-climbing-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.SportClimbingValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    sport-climbing
${SPORT_CLIMBING_ID}  108
${SPORT_CLIMBING_SLUG}    ${SPORT}
${SPORT_CLIMBING_NAME}    Sport Climbing

*** Test Cases ***
################## START https://jira.disney.com/browse/CSEAUTO-26922 ###########################
Get Sport Climbing Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Sport-Climbing
    [Tags]  sport-climbing  valid    smoke     cseauto-26922    cseauto-27025
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for sport-climbing
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${SPORT_CLIMBING_ID}", "${SPORT_CLIMBING_NAME}", "${SPORT_CLIMBING_SLUG}"]

Get Sport Climbing Leagues
    [Documentation]    ESPN core sport API GET call for Sport-Climbing with leagues
    [Tags]  sport-climbing_league    sport-climbing     valid    smoke      cseauto-26922    cseauto-27026
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for sport-climbing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SPORT_CLIMBING_ID}", "${SPORT_CLIMBING_NAME}", "${SPORT_CLIMBING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Sport Climbing Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Sport-Climbing leagues with filter season
    [Tags]  sport-climbing_league    sport-climbing    valid    smoke    cseauto-26922    cseauto-27030
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for sport-climbing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SPORT_CLIMBING_ID}", "${SPORT_CLIMBING_NAME}", "${SPORT_CLIMBING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Sport Climbing without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Sport-Climbing without leagues in queryparams
    [Tags]  sport-climbing_league    sport-climbing   valid    cseauto-26922    cseauto-27031
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for sport-climbing
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${SPORT_CLIMBING_ID}", "${SPORT_CLIMBING_NAME}", "${SPORT_CLIMBING_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Sport Climbing Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Sport-Climbing leagues with invalid filter
    [Tags]  sport-climbing_league    sport-climbing   invalid    cseauto-26922    cseauto-27034
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Sport Climbing with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Sport-Climbing with empty string in queryparams
    [Tags]  sport-climbing_league    sport-climbing      invalid    cseauto-26922    cseauto-27036
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
################## END https://jira.disney.com/browse/CSEAUTO-26922 ###########################
