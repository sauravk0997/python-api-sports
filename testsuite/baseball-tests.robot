*** Settings ***
Documentation       Baseball tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/baseball-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot
Resource            resource/BaseballAPIResource.robot


*** Test Cases ***
# BASEBALL
Get Baseball Baseline Responses
    [Documentation]     This test case contains additional keyword references as well as assertion examples.
    [Tags]  baseball    valid    example    CSEAUTO-26470
    set test variable    ${league_key_flag}     False
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${BASEBALL_ID}", "${BASEBALL_UID}", "${BASEBALL_GUID}", "${BASEBALL_NAME}", "${BASEBALL_SLUG}"]

    # sample testcase assertions and keyword interactions:
    set test variable   ${file_dir}   response_output                 # directory output file will be uploaded
    set test variable   ${file_path}  ${file_dir}/${SPORT}.json       # path to output file

    should be equal as strings  ${response.json()["name"]}  ${BASEBALL_NAME}  # Example of how to compare a field value in the return results.

    log to console      ${API_BASE}/${SPORT}                                # Example of how to write output to console
    Dump ${response} text to ${file_path}                             # Example of how to write response output to text file

    # Example of how to delete a directory containing content (recursively) if a global variable (cleanup) is set to true.
    # e.g.: robot --pythonpath $PWD -i example -v cleanup:True testsuite/validation-demo.robot
    run keyword if    ${cleanup} == ${True}  Cleanup ${file_dir} ${True}  # if ${cleanup} is True, run equiv of: rm -rf ./response_output/

# Tests start for baseball_leagues (https://jira.disney.com/browse/CSEAUTO-23381)

Get Baseball Leagues
    [Documentation]    ESPN core sport API GET call for baseball leagues
    [Tags]  baseball    valid   CSEAUTO-26471
    ${response}=        A GET request to ${API_BASE}/${SPORT}?enable=leagues should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${BASEBALL_ID}", "${BASEBALL_UID}", "${BASEBALL_GUID}", "${BASEBALL_NAME}", "${BASEBALL_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Baseball Leagues with Filter Season
    [Documentation]    ESPN core sport API GET call for baseball leagues with filter season
    [Tags]  baseball    valid   CSEAUTO-26474
    ${response}=        A GET request to ${API_BASE}/${SPORT}?enable=leagues(season) should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${BASEBALL_ID}", "${BASEBALL_UID}", "${BASEBALL_GUID}", "${BASEBALL_NAME}", "${BASEBALL_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Baseball without Leagues in queryParams
    [Documentation]    ESPN core sport API GET call for baseball without leagues
    [Tags]  baseball    valid   CSEAUTO-26475
    ${response}=        A GET request to ${API_BASE}/${SPORT}?enable= should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${BASEBALL_ID}", "${BASEBALL_UID}", "${BASEBALL_GUID}", "${BASEBALL_NAME}", "${BASEBALL_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}

Get Baseball Leagues with Filter invalid
    [Documentation]    ESPN core sport API GET call for baseball leagues with invalid filter
    [Tags]  baseball    invalid     CSEAUTO-26476
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball with empty string in queryParams
    [Documentation]    ESPN core sport API GET call for baseball without queryParams
    [Tags]  baseball    invalid     CSEAUTO-26477
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

# Tests start for mlb_season (https://jira.disney.com/browse/CSEAUTO-24252)

Get Baseball MLB with Filter Season and Type Groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     groups of teams and groups with nested teams
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26478
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...     ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Baseball MLB with Filter Season and Type Groups without teams in nested groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     groups of teams and groups without nested teams
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26479
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(groups(teams,groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    set test message    Observed that teams schema is populated in response although it has been removed from the filter in query param

Get Baseball MLB with Filter Season and Type Groups without teams
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter season types,
    ...     groups with nested teams and without groups of teams
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26483
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(groups(groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}
    set test message    Observed that teams schema is populated in response although it has been removed from the filter in query param

Get Baseball MLB with Filter Season and Type Groups without teams in queryParam
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     without groups of teams and groups without nested teams
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26485
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(groups(groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    set test message    Observed that teams schema is populated in response although it has been removed from the filter in query param

Get Baseball MLB with Filter Season and Type Groups without nested groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     groups of teams and without groups nested teams
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26486
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(groups(teams)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Baseball MLB with Filter Season and Type without Groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types, without groups
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26487
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type())
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_FALSE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Baseball MLB with Filter Season without Type
    [Documentation]    ESPN core sport API GET call for baseball league and season without filter type
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26488
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season()
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_FALSE}
    ...     ${GROUPS_FLAG_FALSE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Baseball MLB without Filter season
    [Documentation]    ESPN core sport API GET call for baseball league and without season
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26799
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    dictionary should not contain key    ${response.json()}     season

Get Baseball MLB without queryParams
    [Documentation]    ESPN core sport API GET call for baseball league without queryParams
    [Tags]  smoke   mlb_season    valid     CSEAUTO-26492
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug", "shortName"]
    ...     ["${LEAGUE_MLB_ID}", "${LEAGUE_MLB_UID}", "${LEAGUE_MLB_NAME}", "${LEAGUE_MLB_SLUG}", "${LEAGUE_MLB_SHORT_NAME}"]
    dictionary should not contain key    ${response.json()}     season

Get Baseball MLB with invalid Filters in season
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter
    [Tags]  smoke   mlb_season    invalid   CSEAUTO-26493
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball MLB with invalid Filters in type
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter in type
    [Tags]  smoke   mlb_season    invalid      CSEAUTO-26494
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(invalid))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball MLB with invalid Filters in groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter in groups
    [Tags]  smoke   mlb_season    invalid       CSEAUTO-26495
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball MLB with invalid Filters in nested groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter in nested groups
    [Tags]  smoke   mlb_season    invalid   CSEAUTO-26496
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}?enable=season(type(teams,groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

# Tests start for college-season (https://jira.disney.com/browse/CSEAUTO-24882)

Get Baseball College with Filter Season and Type Groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     groups of teams and groups with nested teams
    [Tags]  smoke   college_season    valid     CSEAUTO-25139
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...     ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Baseball college with Filter Season and Type Groups without teams in nested groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     groups of teams and groups without nested teams
    [Tags]  smoke   college_season    valid     CSEAUTO-25152
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(groups(teams,groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
        Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...     ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    set test message    Observed that teams schema is populated in response although it has been removed from the filter in query param

Get Baseball college with Filter Season and Type Groups without teams
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     without groups of teams and groups with nested teams
    [Tags]  smoke   college_season    valid     CSEAUTO-25153
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(groups(groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}
    set test message    Observed that teams schema is populated in response although it has been removed from the filter in query param

Get Baseball college with Filter Season and Type Groups without teams in queryParam
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     groups without teams and groups without nested teams
    [Tags]  smoke   college_season    valid     CSEAUTO-25178
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(groups(groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Baseball college with Filter Season and Type Groups without nested groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types,
    ...     groups of teams and without groups with nested teams
    [Tags]  smoke   college_season    valid     CSEAUTO-25181
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(groups(teams)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Baseball college with Filter Season and Type without Groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with filter types, without groups
    [Tags]  smoke   college_season    valid     CSEAUTO-25183
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type())
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_FALSE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Baseball college with Filter Season without Type
    [Documentation]    ESPN core sport API GET call for baseball league and season without filter type
    [Tags]  smoke   college_season    valid     CSEAUTO-25185
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season()
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    dictionary should contain key    ${response.json()}     season

Get Baseball college without Filter season
    [Documentation]    ESPN core sport API GET call for baseball league and without season
    [Tags]  smoke   college_season    valid     CSEAUTO-25193
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]
    dictionary should not contain key    ${response.json()}     season

Get Baseball college without queryParams
    [Documentation]    ESPN core sport API GET call for baseball league without queryParams
    [Tags]  smoke   college_season    valid     CSEAUTO-25188
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/college-baseball
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]
    ...     ["${LEAGUE_COLLEGE_BASEBALL_ID}", "${LEAGUE_COLLEGE_BASEBALL_UID}", "${LEAGUE_COLLEGE_BASEBALL_NAME}", "${LEAGUE_COLLEGE_BASEBALL_SLUG}"]

Get Baseball college with invalid Filters in season
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter
    [Tags]  smoke   college_season    invalid   CSEAUTO-25191
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball college with invalid Filters in type
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter in types
    [Tags]  smoke   college_season    invalid   CSEAUTO-25196
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(invalid))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball college with invalid Filters in groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter in groups
    [Tags]  smoke   college_season    invalid   CSEAUTO-25198
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball college with invalid Filters in nested groups
    [Documentation]    ESPN core sport API GET call for baseball league and season with invalid filter in nested groups
    [Tags]  smoke   college_season    invalid   CSEAUTO-25202
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_COLLEGE_BASEBALL}?enable=season(type(teams,groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

# Tests start for mlb_season_team_stats

Get Baseball MLB Season Team 10 with Filter Record Stats and Athletes
    [Documentation]    ESPN core sport API GET call for baseball team details with league season and team
    ...                with filter record, statistics and athletes(Statistics)
    [Tags]  smoke   mlb_season_team_stats    valid      CSEAUTO-25884
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/seasons/${BASEBALL_SEASON_ID}/teams/${BASEBALL_TEAM_ID}?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${LEAGUE_MLB_TEAM_YANKEES_ID}", "${LEAGUE_MLB_TEAM_YANKEES_UID}", "${LEAGUE_MLB_TEAM_YANKEES_GUID}", "${LEAGUE_MLB_TEAM_YANKEES_NAME}", "${LEAGUE_MLB_TEAM_YANKEES_SLUG}"]
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message            Observed that athletes schema is not available in the response although it is in enable filter in query param

Get Baseball MLB Season Team 10 with Filter Record Stats without Athletes
    [Documentation]    ESPN core sport API GET call for baseball team details with league season and team
    ...                with filter record, statistics and without athletes(Statistics)
    [Tags]  smoke   mlb_season_team_stats    valid      CSEAUTO-25887
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/seasons/${BASEBALL_SEASON_ID}/teams/${BASEBALL_TEAM_ID}?enable=record,statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${LEAGUE_MLB_TEAM_YANKEES_ID}", "${LEAGUE_MLB_TEAM_YANKEES_UID}", "${LEAGUE_MLB_TEAM_YANKEES_GUID}", "${LEAGUE_MLB_TEAM_YANKEES_NAME}", "${LEAGUE_MLB_TEAM_YANKEES_SLUG}"]
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_FALSE}

Get Baseball MLB Season Team 10 with Filter Record and without statistics, Athletes
    [Documentation]    ESPN core sport API GET call for baseball team details with league season and team
    ...                with filter record, and without statistics and athletes(Statistics)
    [Tags]  smoke   mlb_season_team_stats    valid      CSEAUTO-25889
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/seasons/${BASEBALL_SEASON_ID}/teams/${BASEBALL_TEAM_ID}?enable=record
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${LEAGUE_MLB_TEAM_YANKEES_ID}", "${LEAGUE_MLB_TEAM_YANKEES_UID}", "${LEAGUE_MLB_TEAM_YANKEES_GUID}", "${LEAGUE_MLB_TEAM_YANKEES_NAME}", "${LEAGUE_MLB_TEAM_YANKEES_SLUG}"]
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Baseball MLB Season Team 10 without Filters
    [Documentation]    ESPN core sport API GET call for baseball team details with league season and team without filters
    [Tags]  smoke   mlb_season_team_stats    valid  CSEAUTO-25892
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/seasons/${BASEBALL_SEASON_ID}/teams/${BASEBALL_TEAM_ID}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${LEAGUE_MLB_TEAM_YANKEES_ID}", "${LEAGUE_MLB_TEAM_YANKEES_UID}", "${LEAGUE_MLB_TEAM_YANKEES_GUID}", "${LEAGUE_MLB_TEAM_YANKEES_NAME}", "${LEAGUE_MLB_TEAM_YANKEES_SLUG}"]
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Baseball MLB Season Team 10 without queryParams
    [Documentation]    ESPN core sport API GET call for baseball team details with league season and team without queryParams
    [Tags]  smoke   mlb_season_team_stats    valid  CSEAUTO-25893
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/seasons/${BASEBALL_SEASON_ID}/teams/${BASEBALL_TEAM_ID}
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "guid", "name", "slug"]
    ...     ["${LEAGUE_MLB_TEAM_YANKEES_ID}", "${LEAGUE_MLB_TEAM_YANKEES_UID}", "${LEAGUE_MLB_TEAM_YANKEES_GUID}", "${LEAGUE_MLB_TEAM_YANKEES_NAME}", "${LEAGUE_MLB_TEAM_YANKEES_SLUG}"]
    Validate the teams data retrieved is valid      ${response}  ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_FALSE}  ${ATHLETE_FLAG_FALSE}

Get Baseball MLB Season Team 10 with invalid Filter
    [Documentation]    ESPN core sport API GET call for baseball team details with league season and team with invalid filters
    [Tags]  smoke   mlb_season_team_stats    invalid    CSEAUTO-25885
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/seasons/${BASEBALL_SEASON_ID}/teams/${BASEBALL_TEAM_ID}?enable=invalid
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

# Tests start for mlb_event_comp_filter (https://jira.disney.com/browse/CSEAUTO-24942)

Get Baseball MLB Event with Competition Filter
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitions and competitiors
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25027
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message    Observed that situation schema is not populated in response when provided in the query param

Get Baseball MLB Event with Competition Filter without odds param in competitions
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitiors and without odds param in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25028
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(status,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_FALSE}
    set test message    Observed that situation schema is not populated in response when provided in the query param

Get Baseball MLB Event with Competition Filter without status param in competitions
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitiors and without status param in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25029
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(odds,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message    Observed that situation schema is not populated in response when provided in the query param

Get Baseball MLB Event with Competition Filter without play param in situation
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitiors and without play param
    ...     under situation in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25030
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(odds,status,situation(probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message    Observed that situation schema is not populated in response when provided in the query param

Get Baseball MLB Event with Competition Filter without probability param in situation
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitiors and without probability param
    ...     under situation in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25031
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(odds,status,situation(play),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message    Observed that situation schema is not populated in response when provided in the query param

Get Baseball MLB Event with Competition Filter without situation param
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitiors and without situation param
     ...    in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25032
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(odds,status,competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Baseball MLB Event with Competition Filter without competitors param
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitions and without competitiors
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25034
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(odds,status,situation(play,probability))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}
    set test message    Observed that situation schema is not populated in response when provided in the query param

Get Baseball MLB Event with Competition Filter without odds and status param
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitiors and
    ...     without adds and status param in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25035
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_FALSE}
    set test message    Observed that situation schema is not populated in response when provided in the query param

Get Baseball MLB Event with Competition Filter without odds, status and situation param
    [Documentation]    ESPN core sport API GET call for baseball league and event with filter competitiors and
    ...     without adds, status and situation param in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25036
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_FALSE}

Get Baseball MLB Event with Competition Filter without params
    [Documentation]    ESPN core sport API GET call for baseball league and event without filters in competitions
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25037
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions()
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    dictionary should contain key    ${response.json()}    competitions

Get Baseball MLB Event without Competition Filter
    [Documentation]    ESPN core sport API GET call for baseball league and event without competitions filter
    [Tags]  smoke   mlb_event_comp_filter   valid   CSEAUTO-25056
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "shortName"]
    ...     ["${LEAGUE_MLB_EVENT_ID}", "${LEAGUE_MLB_EVENT_UID}", "${LEAGUE_MLB_EVENT_NAME}", "${LEAGUE_MLB_EVENT_SHORT_NAME}"]
    dictionary should not contain key    ${response.json()}    competitions

Get Baseball MLB with invalid Event id
    [Documentation]    ESPN core sport API GET call for baseball league and invalid event
    [Tags]  smoke   mlb_event_comp_filter   invalid     CSEAUTO-25057
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/invalid?enable=
    ${response}=        A GET request to ${request_url} should respond with 404
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     404
    should contain    ${response.json()["error"]["message"]}   no instance found

Get Baseball MLB Event with invalid filters in competitions
    [Documentation]    ESPN core sport API GET call for baseball league and event with invalid filters in competitions
    [Tags]  smoke   mlb_event_comp_filter   invalid     CSEAUTO-25059
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(invalid,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Baseball MLB Event with invalid filters in situation
    [Documentation]    ESPN core sport API GET call for baseball league and event with filters in situation param
    [Tags]  smoke   mlb_event_comp_filter   invalid     CSEAUTO-25060
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}?enable=competitions(odds,status,situation(invalid),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

# Tests start for mlb_event_comp_plays (https://jira.disney.com/browse/CSEAUTO-24943)

Get Baseball MLB Event Competition Plays
    [Documentation]    ESPN core sport API GET call for baseball league, event and competetion with filter athlete in participants
    [Tags]  smoke   mlb_event_comp_plays    valid    comp   baseball    CSEAUTO-25451
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}/competitions/${LEAGUE_MLB_EVENT_ID}/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    ${length} =     get length    ${response.json()["items"]}
    should be equal    ${response.json()["pageCount"]}  ${length}
    should be true    ${length} <= ${response.json()["pageSize"]}
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_TRUE}

Get Baseball MLB Event Competition Plays without athlete param in participants
    [Documentation]    ESPN core sport API GET call for baseball league, event and competetion with filter without athlete in participants
    [Tags]  smoke   mlb_event_comp_plays    valid    comp   baseball    CSEAUTO-25452
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}/competitions/${LEAGUE_MLB_EVENT_ID}/plays?enable=participants()
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    ${length} =     get length    ${response.json()["items"]}
    should be equal    ${response.json()["pageCount"]}  ${length}
    should be true    ${length} <= ${response.json()["pageSize"]}
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_FALSE}

Get Baseball MLB Event Competition Plays without participants param
    [Documentation]    ESPN core sport API GET call for baseball league, event and competetion with filter without participants
    [Tags]  smoke   mlb_event_comp_plays    valid    comp   baseball    CSEAUTO-25453
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}/competitions/${LEAGUE_MLB_EVENT_ID}/plays?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    ${length} =     get length    ${response.json()["items"]}
    should be equal    ${response.json()["pageCount"]}  ${length}
    should be true    ${length} <= ${response.json()["pageSize"]}
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_FALSE}    ${ATHLETE_FLAG_FALSE}

Get Baseball MLB Event Competition Plays without queryParams
    [Documentation]    ESPN core sport API GET call for baseball league, event and competetion without queryParams
    [Tags]  smoke   mlb_event_comp_plays    valid    comp   baseball    CSEAUTO-25455
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}/competitions/${LEAGUE_MLB_EVENT_ID}/plays
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    ${length} =     get length    ${response.json()["items"]}
    should be equal    ${response.json()["pageCount"]}  ${length}
    should be true    ${length} <= ${response.json()["pageSize"]}
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_FALSE}    ${ATHLETE_FLAG_FALSE}

Get Baseball MLB Event Competition Plays with invalid competion Id
    [Documentation]    ESPN core sport API GET call for baseball league, event and invalid competetion id
    [Tags]  smoke   mlb_event_comp_plays    invalid    comp     baseball    CSEAUTO-25456
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}/competitions/3018/plays
    ${response}=        A GET request to ${request_url} should respond with 404
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     404
    should contain    ${response.json()["error"]["message"]}   no instance found

Get Baseball MLB Event Competition Plays with invalid event Id
    [Documentation]    ESPN core sport API GET call for baseball league, competetion and invalid event id
    [Tags]  smoke   mlb_event_comp_plays    invalid    comp     baseball    CSEAUTO-25457
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/3018/competitions/${LEAGUE_MLB_EVENT_ID}/plays
    ${response}=        A GET request to ${request_url} should respond with 200
    set test message    Observed When invalid eventId provided, getting status as 200 instead of 400

Get Baseball MLB Event Competition Plays with invalid param in participants
    [Documentation]    ESPN core sport API GET call for baseball league, event and competetion with invalid filter in participants
    [Tags]  smoke   mlb_event_comp_plays    invalid    comp     baseball    CSEAUTO-25458
    set test variable   ${request_url}     ${API_BASE}/${SPORT}/${LEAGUE_MLB}/events/${LEAGUE_MLB_EVENT_ID}/competitions/${LEAGUE_MLB_EVENT_ID}/plays?enable=participants(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle