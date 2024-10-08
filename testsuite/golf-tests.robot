*** Settings ***
Documentation       Golf tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/golf-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             lib.validators.GolfValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}               golf
${REQUEST_URL}         ${API_BASE}/${SPORT}
${GOLF_SLUG}           ${SPORT}
${GOLF_NAME}           Golf
${GOLF_ID}             1100
${GOLF_UID}            s:${GOLF_ID}


*** Test Cases ***
Get Golf Baseline Responses
    [Tags]  golf  valid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL} should respond with 200
    Sport Schema from ${response} should be valid for golf
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${GOLF_ID}", "${GOLF_NAME}", "${SPORT}", "${GOLF_UID}"]

Get Golf Leagues
    [Tags]  golf    golf-leagues   valid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues should respond with 200
    Sport Schema from ${response} should be valid for golf
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${GOLF_ID}", "${GOLF_NAME}", "${SPORT}", "${GOLF_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Golf Leagues with Filter Season
    [Tags]  golf  golf-leagues-season    valid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(season) should respond with 200
    Sport Schema from ${response} should be valid for golf
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${GOLF_ID}", "${GOLF_NAME}", "${SPORT}", "${GOLF_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Golf without Leagues in queryParams
    [Tags]  golf    invalid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable= should respond with 200
    Sport Schema from ${response} should be valid for golf
    Validate the expected and actual values from the response         ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${GOLF_ID}", "${GOLF_NAME}", "${SPORT}", "${GOLF_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Golf Leagues with Filter invalid
    [Tags]  golf    invalid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable=leagues(invalid) should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Golf with empty string in queryParams
    [Tags]  golf    invalid    cseauto-25514
    ${response}=        A GET request to ${REQUEST_URL}?enable="" should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle