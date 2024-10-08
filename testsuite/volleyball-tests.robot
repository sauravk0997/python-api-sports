*** Settings ***
Documentation       Basketball tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/volleyball-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.VolleyballValidator
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
#Global Variables
${SPORT}                volleyball
${REQUEST_URL}          ${API_BASE}/${SPORT}
${VOLLEYBALL_NAME}      Volleyball
${VOLLEYBALL_ID}        400
${VOLLEYBALL_UID}       s:${VOLLEYBALL_ID}
${VOLLEYBALL_GUID}      be9385dc-c518-3a55-9197-ec47a9e0e7f6
${SLUG}                 ${SPORT}


*** Test Cases ***
Get Volleyball Baseline Responses
    [Tags]  volleyball  valid     cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL} should respond with 200
    Sport Schema from ${response} should be valid for volleyball
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug", "uid", "guid"]       ["${VOLLEYBALL_ID}", "${VOLLEYBALL_NAME}", "${SPORT}", "${VOLLEYBALL_UID}", "${VOLLEYBALL_GUID}"]

Get Volleyball Leagues
    [Tags]  volleyball  volleyball_league   valid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues should respond with 200
    Sport Schema from ${response} should be valid for volleyball
    Validate the expected and actual values from the response         ${response.json()}
        ...         ["id", "name", "slug", "uid", "guid"]       ["${VOLLEYBALL_ID}", "${VOLLEYBALL_NAME}", "${SPORT}", "${VOLLEYBALL_UID}", "${VOLLEYBALL_GUID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}
 
Get Volleyball Leagues with Filter Season
    [Tags]  volleyball  volleyball-league    valid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(season) should respond with 200
    Sport Schema from ${response} should be valid for volleyball
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug", "uid", "guid"]       ["${VOLLEYBALL_ID}", "${VOLLEYBALL_NAME}", "${SPORT}", "${VOLLEYBALL_UID}", "${VOLLEYBALL_GUID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Volleyball without Leagues in queryParams
    [Tags]  volleyball    invalid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable= should respond with 200
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug", "uid", "guid"]       ["${VOLLEYBALL_ID}", "${VOLLEYBALL_NAME}", "${SPORT}", "${VOLLEYBALL_UID}", "${VOLLEYBALL_GUID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Volleyball Leagues with Filter invalid
    [Tags]  volleyball    invalid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(invalid) should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Volleyball with empty string in queryParams
    [Tags]  volleyball    invalid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable="" should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle