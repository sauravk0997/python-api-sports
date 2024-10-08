*** Settings ***
Documentation       Ice Hockey tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/ice-hockey-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/IceHockeySportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    ice-hockey
${ICEHOCKEY_ID}  29
${ICEHOCKEY_NAME}    Ice Hockey

*** Test Cases ***
# ICE HOCKEY
#--------------------------------CSEAUTO-25515-------------------------------------------------------------------------#

Get Ice Hockey Baseline Responses
    [Documentation]    ESPN core sport base API GET call for ice hockey
    [Tags]  ice-hockey  valid    smoke      	CSEAUTO-25747
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${ICEHOCKEY_ID}", "${ICEHOCKEY_NAME}", "${SPORT}"]

Get Ice Hockey Leagues
    [Documentation]    ESPN core sport API GET call for ice hockey with leagues
    [Tags]  ice-hockey_league    valid      ice-hockey      smoke     	CSEAUTO-25748
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Ice Hockey
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${ICEHOCKEY_ID}", "${ICEHOCKEY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Ice Hockey Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for ice hockey leagues with filter season
    [Tags]  ice-hockey_league    ice-hockey_league    valid    smoke        CSEAUTO-25749
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    set test variable   ${name}   Ice Hockey
    Sport Schema from ${response} should be valid for Ice Hockey
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${ICEHOCKEY_ID}", "${ICEHOCKEY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Ice Hockey without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for ice hockey without leagues in queryparams
    [Tags]  ice-hockey    ice-hockey_league   valid     	CSEAUTO-25750
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Ice Hockey
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${ICEHOCKEY_ID}", "${ICEHOCKEY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Ice Hockey Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for ice hockey leagues with invalid filter
    [Tags]  ice-hockey    ice-hockey_league   invalid       	CSEAUTO-25751
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Ice Hockey with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for ice hockey with empty string in queryparams
    [Tags]  ice-hockey    ice-hockey_league   invalid       	CSEAUTO-25752
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-25515-------------------------------------------------------------------------#
