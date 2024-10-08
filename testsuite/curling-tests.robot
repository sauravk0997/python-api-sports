*** Settings ***
Documentation       curling are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/curling-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.CurlingValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}            curling
${REQUEST_URL}      ${API_BASE}/${SPORT}
${CURLING_NAME}     Curling
${CURLING_ID}       10


*** Test Cases ***
Get Curling Baseline Responses
    [Tags]  curling  valid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL} should respond with 200
    Sport Schema from ${response} should be valid for curling
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${CURLING_ID}", "${CURLING_NAME}", "${SPORT}"]


Get Curling Leagues
    [Tags]  curling    valid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues should respond with 200
    Sport Schema from ${response} should be valid for curling
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${CURLING_ID}", "${CURLING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}


Get Curling Leagues with Filter Season
    [Tags]  curling    valid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(season) should respond with 200
    Sport Schema from ${response} should be valid for curling
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${CURLING_ID}", "${CURLING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Curling without Leagues in queryParams
    [Tags]  curling    invalid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable= should respond with 200
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug"]       ["${CURLING_ID}", "${CURLING_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Curling Leagues with Filter invalid
    [Tags]  curling    invalid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(invalid) should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Curling with empty string in queryParams
    [Tags]  curling    invalid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable="" should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle