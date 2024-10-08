*** Settings ***
Documentation       Cycling - Mountain Bike tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/cycling-mountain-bike-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.CyclingMountainBikeValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                 mountain-bike
${MOUNTAIN_BIKE_ID}      12
${MOUNTAIN_BIKE_NAME}    Cycling - Mountain Bike
${MOUNTAIN_BIKE_SLUG}    ${SPORT}

*** Test Cases ***
# MOUNTAIN_BIKE
Get Cycling - Mountain-Bike Baseline Responses
    [Tags]  mountain-bike  valid   CSEAUTO-26558
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${MOUNTAIN_BIKE_ID}", "${MOUNTAIN_BIKE_NAME}", "${MOUNTAIN_BIKE_SLUG}"]

# Tests start for MOUNTAIN_BIKE_leagues (https://jira.disney.com/browse/CSEAUTO-26480)

Get Cycling - Mountain-Bike Leagues
    [Tags]  mountain-bike  valid   CSEAUTO-26560   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for mountain-bike
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${MOUNTAIN_BIKE_ID}", "${MOUNTAIN_BIKE_NAME}", "${MOUNTAIN_BIKE_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Cycling - Mountain-Bike Leagues with Filter Season
    [Tags]  mountain-bike  valid   CSEAUTO-26563   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for mountain-bike
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${MOUNTAIN_BIKE_ID}", "${MOUNTAIN_BIKE_NAME}", "${MOUNTAIN_BIKE_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Cycling - Mountain-Bike without Leagues in queryParams
    [Tags]  mountain-bike    valid     CSEAUTO-26559   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "name", "slug"]   ["${MOUNTAIN_BIKE_ID}", "${MOUNTAIN_BIKE_NAME}", "${MOUNTAIN_BIKE_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Cycling - Mountain-Bike Leagues with Filter invalid
    [Tags]  mountain-bike    invalid   CSEAUTO-26561   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Cycling - Mountain-Bike with empty string in queryParams
    [Tags]  mountain-bike    invalid     CSEAUTO-26562   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
