*** Settings ***
Documentation       Basketball tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/basketball-tests.robot

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
${SPORT}    basketball
${BASKETBALL_NAME}    Basketball
${BASKETBALL_SLUG}    ${SPORT}
${BASKETBALL_ID}    40
${BASKETBALL_UID}    s:${BASKETBALL_ID}
${BASKETBALL_GUID}    cd70a58e-a830-330c-93ed-52360b51b632
${LEAGUE_NBA}    nba
${LEAGUE_MCB}    mens-college-basketball
${BASKETBALL_SEASON_2018}    2018
${BASKETBALL_TEAM_5}    5
${BASKETBALL_TEAM_194}    194

*** Test Cases ***
Get Basketball Baseline Responses
    [Documentation]    ESPN core sport API GET call for Basketball
    [Tags]  basketball  valid    cseauto-26813
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...  ["id", "name", "slug", "uid", "guid"]       ["${BASKETBALL_ID}", "${BASKETBALL_NAME}", "${BASKETBALL_SLUG}", "${BASKETBALL_UID}", "${BASKETBALL_GUID}"]

Get Basketball Leagues
    [Documentation]    ESPN core sport API GET call for Basketball leagues
    [Tags]  basketball  basketball_league   valid    cseauto-26815
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...  ["id", "name", "slug", "uid", "guid"]       ["${BASKETBALL_ID}", "${BASKETBALL_NAME}", "${BASKETBALL_SLUG}", "${BASKETBALL_UID}", "${BASKETBALL_GUID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}
 
Get Basketball Leagues with Filter Season
    [Documentation]    ESPN core sport API GET call for Basketball leagues with filter season
    [Tags]  basketball  basketball_league    valid    cseauto-26816
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...  ["id", "name", "slug", "uid", "guid"]       ["${BASKETBALL_ID}", "${BASKETBALL_NAME}", "${BASKETBALL_SLUG}", "${BASKETBALL_UID}", "${BASKETBALL_GUID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Basketball without Leagues in queryParams
    [Documentation]    ESPN core sport API GET call for Basketball without Leagues in queryParams
    [Tags]  basketball    valid    cseauto-26817
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...  ["id", "name", "slug", "uid", "guid"]       ["${BASKETBALL_ID}", "${BASKETBALL_NAME}", "${BASKETBALL_SLUG}", "${BASKETBALL_UID}", "${BASKETBALL_GUID}"]

Get Basketball Leagues with Filter invalid
    [Documentation]    ESPN core sport API GET call for Basketball Leagues with Filter invalid
    [Tags]  basketball    invalid    cseauto-26818
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basketball with empty string in queryParams
    [Documentation]    ESPN core sport API GET call for Basketball with empty string in queryParams
    [Tags]  basketball    invalid    cseauto-26820
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

############# START https://jira.disney.com/browse/CSEAUTO-24253 ######################
Get Basketball NBA with Filter Season and Type Groups
    [Documentation]    ESPN core sport API GET call for Basketball with Filter Season and Type Groups
    [Tags]  smoke   basketball    valid     functional    cseauto-24253    cseauto-26821
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...  ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Basketball NBA with Filter Season and Type Groups without teams in nested groups
    [Documentation]    ESPN core sport API GET call for Basketball NBA with Filter Season and Type Groups without teams in nested groups
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26822
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(groups(teams,groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    set test message    Test should fail as teams key exist in groups under children array

Get Basketball NBA with Filter Season and Type Groups without teams
    [Documentation]    ESPN core sport API GET call for Basketball NBA with Filter Season and Type Groups without teams
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26823
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(groups(groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}
    set test message    Test should fail as teams key exist in groups

Get Basketball NBA with Filter Season and Type Groups without nested groups
    [Documentation]    ESPN core sport API GET call for Basketball NBA with Filter Season and Type Groups without nested groups
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26824
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(groups(teams)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Basketball NBA with Filter Season and Type Groups without teams and nested groups
    [Documentation]    ESPN core sport API GET call for Basketball NBA with Filter Season and Type Groups without teams and nested groups
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26825
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(groups()))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Basketball NBA with Filter Season and Type without Groups
    [Documentation]    ESPN core sport API GET call for Basketball NBA with Filter Season and Type without Groups
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26826
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type())
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_FALSE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Basketball NBA with Filter Season and without Type
    [Documentation]    ESPN core sport API GET call for Basketball NBA with Filter Season and without Type
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26827
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season()
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}[season]                 type

Get Basketball NBA without Filter Season
    [Documentation]    ESPN core sport API GET call for Basketball NBA without Filter Season
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26828
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Basketball NBA without enable query parameter key
    [Documentation]    ESPN core sport API GET call for Basketball NBA without enable query parameter key
    [Tags]  smoke   basketball    valid    functional    cseauto-24253    cseauto-26829
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Basketball NBA with invalid Filters in nested groups
    [Documentation]    ESPN core sport API GET call for Basketball NBA with invalid Filters in nested groups
    [Tags]  smoke   basketball    invalid    cseauto-24253    cseauto-26833
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(teams,groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basketball NBA with invalid Filters in groups
    [Documentation]    ESPN core sport API GET call for Basketball NBA with invalid Filters in groups
    [Tags]  smoke   basketball    invalid    cseauto-24253    cseauto-26832
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basketball NBA with invalid Filters in type
    [Documentation]    ESPN core sport API GET call for Basketball NBA with invalid Filters in type
    [Tags]  smoke   basketball    invalid    cseauto-24253    cseauto-26831
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(type(invalid))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basketball NBA with invalid Filters in season
    [Documentation]    ESPN core sport API GET call for Basketball NBA with invalid Filters in season
    [Tags]  smoke   basketball    invalid    cseauto-24253    cseauto-26830
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}?enable=season(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
############# END https://jira.disney.com/browse/CSEAUTO-24253 ######################

############# START https://jira.disney.com/browse/CSEAUTO-24930 ######################
Get Basketball NBA 2018 Season Team Details
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message    The athlete's attribute does not present in the response, So the test case should fail.

Get Basketball NBA 2018 Season Team Details without statistics in athletes
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details without statistics in athletes
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=record,statistics,athletes()
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message    The athlete's attribute does not present in the response, So the test case should fail.

Get Basketball NBA 2018 Season Team Details without athletes
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details without athletes
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=record,statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball NBA 2018 Season Team Details with query parameter shuffle and without athletes
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details with query parameter shuffle and without athletes
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=statistics,record
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball NBA 2018 Season Team Details with query parameter record
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details with query parameter record
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=record
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball NBA 2018 Season Team Details with query parameter statistics
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details with query parameter statistics
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball NBA 2018 Season Team Details with query parameter enable
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details with query parameter enable
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}     athletes

Get Basketball NBA 2018 Season Team Details without query parameter
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details without query parameter
    [Tags]  smoke   basketball    valid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}     athletes

Get Basketball NBA 2018 Season Team Details with invalid filter in athletes
    [Documentation]    ESPN core sport API GET call for Basketball NBA 2018 Season Team Details with invalid filter in athletes
    [Tags]  smoke   basketball    invalid    cseauto-24930
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_5}?enable=record,statistics,athletes(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
############# END https://jira.disney.com/browse/CSEAUTO-24930 ######################

Get Basketball NBA Event with Competition Filter
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event with Competition Filter
    [Tags]  smoke   basketball  valid    cseauto-26834
    set test variable   ${request_url}  ${API_BASE}/basketball/nba/events/401034614?enable=competitions(odds,status,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid

############# START https://jira.disney.com/browse/CSEAUTO-24932 ######################
Get Basketball NBA Event Competition Plays
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event Competition Plays
    [Tags]  smoke   basketball  valid    CSEAUTO-26169
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/events/401034614/competitions/401034614/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   ["count", "pageIndex", "pageSize", "pageCount"]   [468, 1, 25, 19]
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_TRUE}

Get Basketball NBA Event Competition Plays without athlete param in participants
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event Competition Plays without athlete param in participants
    [Tags]  smoke   basketball  valid    CSEAUTO-26170
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/events/401034614/competitions/401034614/plays?enable=participants()
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   ["count", "pageIndex", "pageSize", "pageCount"]   [468, 1, 25, 19]
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_FALSE}

Get Basketball NBA Event Competition Plays without participants param
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event Competition Plays without participants param
    [Tags]  smoke   basketball  valid    CSEAUTO-26171
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/events/401034614/competitions/401034614/plays?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   ["count", "pageIndex", "pageSize", "pageCount"]   [468, 1, 25, 19]
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_FALSE}    ${ATHLETE_FLAG_FALSE}

Get Basketball NBA Event Competition Plays without queryParams
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event Competition Plays without queryParams
    [Tags]  smoke   basketball  valid    CSEAUTO-26172
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/events/401034614/competitions/401034614/plays
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   ["count", "pageIndex", "pageSize", "pageCount"]   [468, 1, 25, 19]
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_FALSE}    ${ATHLETE_FLAG_FALSE}

Get Basketball NBA Event Competition Plays with invalid competition Id
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event Competition Plays with invalid competition Id
    [Tags]  basketball    invalid    CSEAUTO-26173
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/events/401034614/competitions/123/plays
    ${response}=        A GET request to ${request_url} should respond with 404
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     404
    should contain    ${response.json()["error"]["message"]}   no instance found

Get Basketball NBA Event Competition Plays with invalid event Id
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event Competition Plays with invalid event Id
    [Tags]  smoke   basketball    invalid    CSEAUTO-26174
    set test variable    ${event_id}    invalid
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/events/${event_id}/competitions/401034614/plays
    ${response}=        A GET request to ${request_url} should respond with 200
    Set Test Message    This test case should fail because of an invalid event id in the URL slug, but it is not failing

Get Basketball NBA Event Competition Plays with invalid param in participants
    [Documentation]    ESPN core sport API GET call for Basketball NBA Event Competition Plays with invalid param in participants
    [Tags]  smoke    basketball    invalid    CSEAUTO-26175
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NBA}/events/401034614/competitions/401034614/plays?enable=participants(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle invalid
############# END https://jira.disney.com/browse/CSEAUTO-24932 ######################

############# START https://jira.disney.com/browse/CSEAUTO-24933 ######################
Get Basketball College Season Details
    [Documentation]    ESPN core sport API GET call for Basketball College Season Details
    [Tags]    basketball  valid cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}
    Set Test Message    This test case should fail because the children and teams array does not exist in the group schema

Get Basketball MCB with Filter Season and Type Groups without teams in nested groups
    [Documentation]    ESPN core sport API GET call for Basketball MCB with Filter Season and Type Groups without teams in nested groups
    [Tags]    basketball  valid cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(groups(teams,groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    set test message    This test case should fail because the children and teams array does not exist in the group schema

Get Basketball MCB with Filter Season and Type Groups without teams
    [Documentation]    ESPN core sport API GET call for Basketball MCB with Filter Season and Type Groups without teams
    [Tags]    basketball  valid    mcb-season    cseauto-24933
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(groups(groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}
    set test message    This test case should fail because the children and teams array does not exist in the group schema

Get Basketball MCB with Filter Season and Type Groups without nested groups
    [Documentation]    ESPN core sport API GET call for Basketball MCB with Filter Season and Type Groups without nested groups
    [Tags]    basketball  valid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(groups(teams)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    Set Test Message    This test case should fail because the teams array does not exist in the group schema

Get Basketball MCB with Filter Season and Type Groups without teams and nested groups
    [Documentation]    ESPN core sport API GET call for Basketball MCB with Filter Season and Type Groups without teams and nested groups
    [Tags]    basketball  valid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(groups()))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Basketball MCB with Filter Season and Type without Groups
    [Documentation]    ESPN core sport API GET call for Basketball MCB with Filter Season and Type without Groups
    [Tags]    basketball  valid    mcb-season    cseauto-24933
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type())
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_FALSE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Basketball MCB with Filter Season and without Type
    [Documentation]    ESPN core sport API GET call for Basketball MCB with Filter Season and without Type
    [Tags]    basketball  valid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season()
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}[season]                 type

Get Basketball MCB without Filter Season
    [Documentation]    ESPN core sport API GET call for Basketball MCB without Filter Season
    [Tags]    basketball  valid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Basketball MCB without 'enable' query parameter key
    [Documentation]    ESPN core sport API GET call for Basketball MCB without 'enable' query parameter key
    [Tags]  basketball  valid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Basketball Mens college basketball with invalid Filters in nested groups
    [Documentation]    ESPN core sport API GET call for Basketball MCB with invalid Filters in nested groups
    [Tags]  basketball    invalid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(teams,groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basketball Mens college basketball with invalid Filters in groups
    [Documentation]    ESPN core sport API GET call for Basketball MCB with invalid Filters in groups
    [Tags]    basketball    invalid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(groups(invalid)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basketball Mens college basketball with invalid Filters in type
    [Documentation]    ESPN core sport API GET call for Basketball MCB with invalid Filters in type
    [Tags]    basketball    invalid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(type(invalid))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basketball Mens college basketball with invalid Filters in season
    [Documentation]    ESPN core sport API GET call for Basketball MCB with invalid Filters in season
    [Tags]    basketball    invalid    cseauto-24933    mcb-season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}?enable=season(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
############# END https://jira.disney.com/browse/CSEAUTO-24933 ######################

############# START https://jira.disney.com/browse/CSEAUTO-24934 ######################
Get Basketball College 2018 Season Team Details
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details
    [Tags]  smoke   basketball    valid     mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message    The test case should fail because athlete's attribute does not present in the response.

Get Basketball College 2018 Season Team Details without statistics in athletes
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details without statistics in athletes
    [Tags]  smoke   basketball    valid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=record,statistics,athletes()
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message    The test case should fail because athlete's attribute does not present in the response.

Get Basketball College 2018 Season Team Details without athletes
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details without athletes
    [Tags]  smoke   basketball    valid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=record,statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball College 2018 Season Team Details with query parameter shuffle and without athletes
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details with query parameter shuffle and without athletes
    [Tags]  smoke   basketball    valid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=statistics,record
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball College 2018 Season Team Details with query parameter record
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details with query parameter record
    [Tags]  smoke   basketball    valid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=record
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball College 2018 Season Team Details with query parameter statistics
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details with query parameter statistics
    [Tags]  smoke   basketball    valid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Basketball College 2018 Season Team Details with query parameter enable
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details with query parameter enable
    [Tags]  smoke   basketball    valid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}     athletes

Get Basketball College 2018 Season Team Details without query parameter
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details without query parameter
    [Tags]  smoke   basketball    valid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}     athletes

Get Basketball College 2018 Season Team Details with invalid filter in athletes
    [Documentation]    ESPN core sport API GET call for Basketball College 2018 Season Team Details with invalid filter in athletes
    [Tags]  smoke   basketball    invalid    mcb-season-team    cseauto-24934
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/seasons/${BASKETBALL_SEASON_2018}/teams/${BASKETBALL_TEAM_194}?enable=record,statistics,athletes(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
############# END https://jira.disney.com/browse/CSEAUTO-24934 ######################

############# START https://jira.disney.com/browse/CSEAUTO-24935 ######################
Get Basketball College Event with Competition Filter
    [Documentation]    Basketball ESPN Core API with competition filter odd, status, situation, competitors
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(odds,status,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Basketball MCB Event with Competition Filter without odds param in competitions
    [Documentation]    Basketball ESPN Core API without odds param in query parameter and response should not consist odds key in the response.
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(status,situation(play),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_FALSE}

Get Basketball MCB Event with Competition Filter without status param in competitions
    [Documentation]    Basketball ESPN Core API without status param in query parameter and response should not consist status key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26356
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(odds,situation(play),competitors(team,score,linescores)) 
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Basketball MCB Event with Competition Filter without play param in situation
    [Documentation]    Basketball ESPN Core API without play param in situation parameter and response should not consist play key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26357
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(odds,status,situation(probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_TRUE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Basketball MCB Event with Competition Filter without probalility param in situation
    [Documentation]    Basketball ESPN Core API without probability param in situation parameter and response should not consist probability key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26358
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(odds,status,situation(play),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_FALSE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Basketball MCB Event with Competition Filter without situation param
    [Documentation]    Basketball ESPN Core API without situation param in situation parameter and response should not consist situation key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26359
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(odds,status,competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Basketball MCB Event with Competition Filter without competitors param
    [Documentation]    Basketball ESPN Core API without competitors parameter and response should not consist competitors key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26364
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(odds,status,situation(play,probability))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}    
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}

Get Basketball MCB Event with Competition Filter without odds and status param
    [Documentation]    Basketball ESPN Core API without odds and status parameter and response should not consist odds and status key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26368
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_FALSE}

Get Basketball MCB Event with Competition Filter without odds, status and situation param
    [Documentation]    Basketball ESPN Core API without odds, status and situation parameter and response should not consist odds, status and situation key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26372
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}    
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_FALSE}

Get Basketball MCB Event with Competition Filter without params
    [Documentation]    Basketball ESPN Core API without parameter in competition and response should consist only competition key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26377
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions()
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]
    Validate competitions array values of event schema is valid   
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}    
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Basketball MCB Event without Competition Filter
    [Documentation]    Basketball ESPN Core API without competition filter and response should consist only competition key in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26381
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate the expected and actual values from the response     ${response.json()}   
    ...     ["id", "uid", "name", "shortName"]   ["401025888", "s:40~l:41~e:401025888", "Michigan Wolverines at Villanova Wildcats", "MICH @ VILL"]

Get Basketball MCB with invalid Event id
    [Documentation]    Basketball ESPN Core API with invalid event id and response should consist error code in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26382
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/invalid?enable=
    ${response}=        A GET request to ${request_url} should respond with 404
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     404
    should contain    ${response.json()["error"]["message"]}   no instance found

Get Basketball MCB Event with invalid filters in competitions
    [Documentation]    Basketball ESPN Core API with invalid filters in competitions and response should consist error code in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26383
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(invalid,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Basektball MCB Event with invalid filters in situation
    [Documentation]    Basketball ESPN Core API with invalid filters in situation and response should consist error code in the response.
    [Tags]  smoke   basketball  valid    CSEAUTO-26384
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_MCB}/events/401025888?enable=competitions(odds,status,situation(invalid),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
############# END https://jira.disney.com/browse/CSEAUTO-24935 ######################
