*** Settings ***
Documentation       Field-Hockey tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/field-hockey-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/FieldHockeySportsCoreValidator.py
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global variables
${SPORT}    field-hockey
${FIELDHOCKEY_ID}  800
${FIELDHOCKEY_UID}  s:${FIELDHOCKEY_ID}
${FIELDHOCKEY_NAME}    Field Hockey


*** Test Cases ***
# Field-Hockey
#--------------------------------CSEAUTO-25583-------------------------------------------------------------------------#
Get Field-Hockey Baseline Responses
    [Documentation]    ESPN core sport base API GET call for Field-Hockey
    [Tags]  field-hockey  valid    smoke    	CSEAUTO-26731
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Field Hockey
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "name", "slug"]       ["${FIELDHOCKEY_ID}", "${FIELDHOCKEY_UID}", "${FIELDHOCKEY_NAME}", "${SPORT}"]

Get Field-Hockey Leagues
    [Documentation]    ESPN core sport API GET call for Field-Hockey with leagues
    [Tags]  field-hockey_league    field-hockey  valid    smoke       	CSEAUTO-26732
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Field Hockey
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "name", "slug"]       ["${FIELDHOCKEY_ID}", "${FIELDHOCKEY_UID}", "${FIELDHOCKEY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Field-Hockey Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for Field-Hockey leagues with filter season
    [Tags]  field-hockey_league    field-hockey    valid    smoke       CSEAUTO-26733
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Field Hockey
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "name", "slug"]       ["${FIELDHOCKEY_ID}", "${FIELDHOCKEY_UID}", "${FIELDHOCKEY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_TRUE}

Get Field-Hockey without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for Field-Hockey without leagues in queryparams
    [Tags]  field-hockey_league    field-hockey   valid      	CSEAUTO-26734
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for Field Hockey
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "name", "slug"]       ["${FIELDHOCKEY_ID}", "${FIELDHOCKEY_UID}", "${FIELDHOCKEY_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Field-Hockey Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for Field-Hockey leagues with invalid filter
    [Tags]  field-hockey_league    field-hockey   invalid       	CSEAUTO-26735
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Field-Hockey with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for Field-Hockey with empty string in queryparams
    [Tags]  field-hockey_league    field-hockey   invalid       CSEAUTO-26736
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

#--------------------------------CSEAUTO-25583-------------------------------------------------------------------------#
