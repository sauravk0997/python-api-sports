*** Settings ***
Documentation       Australian Rules Football tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/australian-rules-football-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.AustraliaRulesFootballValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          australian-football
${AUST_FOOTBALL_ID}      34
${AUST_FOOTBALL_UID}     s:${AUST_FOOTBALL_ID}
${AUST_FOOTBALL_GUID}    db10f653-d684-377e-91b6-8ce2911c1e3b
${AUST_FOOTBALL_NAME}    Australian Rules Football
${AUST_FOOTBALL_SLUG}    australian-football
${LEAGUES_FLAG_TRUE}     True
${LEAGUES_FLAG_FALSE}    False
${SEASONS_FLAG_TRUE}     True
${SEASONS_FLAG_FALSE}    False

*** Test Cases ***
Get Australian Rules Football Baseline Responses
    [Tags]  australian-football  valid   CSEAUTO-26630
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${AUST_FOOTBALL_ID}", "${AUST_FOOTBALL_UID}", "${AUST_FOOTBALL_GUID}", "${AUST_FOOTBALL_NAME}", "${AUST_FOOTBALL_SLUG}"]

# Tests start for Australian Rules Football_leagues (https://jira.disney.com/browse/CSEAUTO-26481)

Get Australian Rules Football Leagues
    [Tags]  australian-football  valid   CSEAUTO-26631   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for australian-football
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${AUST_FOOTBALL_ID}", "${AUST_FOOTBALL_UID}", "${AUST_FOOTBALL_GUID}", "${AUST_FOOTBALL_NAME}", "${AUST_FOOTBALL_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Australian Rules Football Leagues with Filter Season
    [Tags]  australian-football  valid   CSEAUTO-26632   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for australian-football
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${AUST_FOOTBALL_ID}", "${AUST_FOOTBALL_UID}", "${AUST_FOOTBALL_GUID}", "${AUST_FOOTBALL_NAME}", "${AUST_FOOTBALL_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Australian Rules Football without Leagues in queryParams
    [Tags]  australian-football    valid     CSEAUTO-26633   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for australian-football
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${AUST_FOOTBALL_ID}", "${AUST_FOOTBALL_UID}", "${AUST_FOOTBALL_GUID}", "${AUST_FOOTBALL_NAME}", "${AUST_FOOTBALL_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Australian Rules Football Leagues with Filter invalid
    [Tags]  australian-football    invalid   CSEAUTO-26634   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Australian Rules Football with empty string in queryParams
    [Tags]  australian-football    invalid     CSEAUTO-26635   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
