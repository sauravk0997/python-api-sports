*** Settings ***
Documentation       Badminton tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/badminton-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.BadmintonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}                badminton
${REQUEST_URL}          ${API_BASE}/${SPORT}
${BADMINTON_NAME}       Badminton
${BADMINTON_ID}         6


*** Test Cases ***
Get Badminton Baseline Responses
    [Tags]  badminton  valid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL} should respond with 200
    Sport Schema from ${response} should be valid for badminton
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${BADMINTON_ID}", "${BADMINTON_NAME}", "${SPORT}"]


Get Badminton Leagues
    [Tags]  badminton  badminton_league   valid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues should respond with 200
    Sport Schema from ${response} should be valid for badminton
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${BADMINTON_ID}", "${BADMINTON_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}
 
Get Badminton Leagues with Filter Season
    [Tags]  badminton  badminton_league    valid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(season) should respond with 200
    Sport Schema from ${response} should be valid for badminton
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${BADMINTON_ID}", "${BADMINTON_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Badminton without Leagues in queryParams
    [Tags]  badminton    invalid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable= should respond with 200
    Sport Schema from ${response} should be valid for badminton
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug"]       ["${BADMINTON_ID}", "${BADMINTON_NAME}", "${SPORT}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Badminton Leagues with Filter invalid
    [Tags]  badminton    invalid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(invalid) should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Badminton with empty string in queryParams
    [Tags]  badminton    invalid    cseauto-25577
    ${response}=        A GET request to ${REQUEST_URL}?enable="" should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle