*** Settings ***
Documentation       Football tests executed with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/football-tests.robot

Library             RequestsLibrary
Library             OperatingSystem
Library             ../lib/validators/ESPNSportsCoreValidator.py
Resource            ../resource/ESPNCoreAPIResource.robot
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py


*** Variables ***
${SPORT}                                football
${FOOTBALL_ID}                          20
${FOOTBALL_NAME}                        Football
${FOOTBALL_UID}                         s:${FOOTBALL_ID}
${LEAGUE_NFL}                           nfl
${LEAGUE_CF}                            college-football
${FOOTBALL_SEASON_ID}                   2018
${FOOTBALL_TEAM_ID}                     194
${FOOTBALL_EVENT_ID}                    400953415

*** Test Cases ***
# FOOTBALL
Get Football Baseline Responses
    [Documentation]    ESPN core sport base API GET call for football
    [Tags]  smoke   football    valid       CSEAUTO-25758
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${FOOTBALL_ID}", "${FOOTBALL_NAME}", "${SPORT}", "${FOOTBALL_UID}"]

#--------------------------------CSEAUTO-23383-------------------------------------------------------------------------#
Get Football Leagues
    [Documentation]    ESPN core sport API GET call for football with leagues
    [Tags]       smoke       football    football_league    valid        CSEAUTO-25757
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${FOOTBALL_ID}", "${FOOTBALL_NAME}", "${SPORT}", "${FOOTBALL_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Football Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for football leagues with filter season
    [Tags]  football    football_league    valid        	CSEAUTO-25759
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${FOOTBALL_ID}", "${FOOTBALL_NAME}", "${SPORT}", "${FOOTBALL_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_TRUE}

Get Football without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for football without leagues in queryparams
    [Tags]  football      football_league   valid   	CSEAUTO-25760
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${FOOTBALL_ID}", "${FOOTBALL_NAME}", "${SPORT}", "${FOOTBALL_UID}"]

Get Football Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for football leagues with invalid filter
    [Tags]  football    invalid      football_league    	CSEAUTO-25761
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Football with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for football with empty string in queryparams
    [Tags]  football    invalid    football_league    	CSEAUTO-25762
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle
#--------------------------------CSEAUTO-23383-------------------------------------------------------------------------#

#--------------------------------CSEAUTO-24254-------------------------------------------------------------------------#
Get Football NFL with Filter Season and Type Groups
    [Documentation]    Get request for football with filter enable as season nested with types, groups of teams and
    ...                groups with nested teams
    [Tags]  smoke   football    nfl    valid    filterSeason        CSEAUTO-25764
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Football NFL with Filter Season and Type Groups without teams in nested groups
    [Documentation]    Get request for football with filter enable as season nested with types, groups of teams and
    ...                groups without nested teams
    [Tags]    nfl   football     valid      filterSeason     	CSEAUTO-25765
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(groups(teams,groups)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    set test message    Observed that teams schema is populated in response although it has been removed from the enable filter in query param

Get Football NFL with Filter Season and Type Groups without teams
    [Documentation]    Get request for football with filter enable as season nested with types, groups of teams
    ...                and without teams
    [Tags]   nfl    football    valid    filterSeason    	CSEAUTO-25766
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(groups(groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}
    set test message    Observed that teams schema is populated in response although it has been removed from the enable filter in query param

Get Football NFL with Filter Season and Type Groups without nested groups
    [Documentation]    Get request for football with filter enable as season nested with types
    ...                without nested groups
    [Tags]   nfl     football    valid      filterSeason      	CSEAUTO-25767
    set test variable    ${leagueID}    nfl
    set test variable   ${request_url}  ${API_BASE}/football/${leagueID}?enable=season(type(groups(teams)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Football NFL with Filter Season and Type Groups without teams and nested groups
    [Documentation]    Get request for football with filter enable as season nested with types, groups and
    ...                without groups with nested teams
    [Tags]  nfl   football       valid    filterSeason        	CSEAUTO-25768
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(groups()))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_TRUE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Football NFL with Filter Season and Type Groups without groups
    [Documentation]    Get request for football with filter enable as season nested with types without groups
    [Tags]   nfl   football      valid    filterSeason        	CSEAUTO-25769
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type)
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}
    ...     ${GROUPS_FLAG_FALSE}          ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Football NFL with Filter Season and Type Groups without type
    [Documentation]    Get request for football with filter enable as season nested without type
    [Tags]  nfl      football     valid     filterSeason       	CSEAUTO-25770
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}[season]                 type

Get Football NFL with Filter Season without filter season
    [Documentation]    Get request for football with filter enable without season
    [Tags]   nfl    football    valid     filterSeason        	CSEAUTO-25771
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Football NFL with Filter Season without enable query parameter
    [Documentation]    Get request for football with filter enable without enable query parameter
    [Tags]   nfl   football  valid     filterSeason      CSEAUTO-25772
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?season(type(groups(teams,groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Football NFL with Filter Season and Type with invalid value
    [Documentation]    Get request for football with invalid value of Type in season
    [Tags]   nfl    football    invalid     filterSeason       	CSEAUTO-25773
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(2!ab))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Football NFL with Filter Season and Type with invalid nested group
    [Documentation]    Get request for football with filter with invalid value of nested group
    [Tags]  nfl   football   invalid     filterSeason        	CSEAUTO-25774
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(groups(teams,groups(2!bc))))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Football NFL with Filter Season and Type with invalid value of teams
    [Documentation]    Get request for football with invalid value of teams of group filter under season and type
    [Tags]  nfl   football   invalid     filterSeason        CSEAUTO-25775
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(groups(2!ab,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Football NFL with Filter Season and Type with invalid value of group
    [Documentation]    Get request for football with invalid value of nested groups under season and type of groups
    [Tags]  nfl   football   invalid     filterSeason        	CSEAUTO-25776
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}?enable=season(type(groups(2!ab)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle
#--------------------------------CSEAUTO-24254-------------------------------------------------------------------------#

#--------------------------------CSEAUTO-24924-------------------------------------------------------------------------#
Get Football NFL Season Team 4 with Filter Record Stats and Athletes
    [Tags]  smoke  football  nfl    valid     filterSeason       CSEAUTO-24924
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}/seasons/2018/teams/4?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
#--------------------------------CSEAUTO-24924-------------------------------------------------------------------------#

#--------------------------------CSEAUTO-24925-------------------------------------------------------------------------#
Get Football NFL Event with Competition Filter
    [Tags]  smoke  football  nfl    valid   competition-filter  CSEAUTO-24925
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}/events/400999173?enable=competitions(odds,status,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
#--------------------------------CSEAUTO-24925-------------------------------------------------------------------------#

#--------------------------------CSEAUTO-24926-------------------------------------------------------------------------#
Get Football NFL Event Competition Plays
    [Tags]  smoke   football    nfl    valid  competition-plays      CSEAUTO-24926
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_NFL}/events/400999173/competitions/400999173/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
#--------------------------------CSEAUTO-24926-------------------------------------------------------------------------#

#--------------------------------CSEAUTO-24927-------------------------------------------------------------------------#
Get Football College 2018 Season Team Detail
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                with filter record, statistics and athletes(Statistics)
    [Tags]  smoke   football    valid       college-football        CSEAUTO-25081
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message            Observed that athletes schema is not available in the response although it is in enable filter in query param

Get Football College 2018 Season Team Detail without Athletes
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                without atheletes in query param
    [Tags]    football    valid     college-football       	CSEAUTO-25083
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=record,statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Football College 2018 Season Team Detail without Record
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                without record in query param
    [Tags]    football    valid     college-football        CSEAUTO-25085
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message            Observed that athletes schema is not available in the response although it is in enable filter in query param

Get Football College 2018 Season Team Detail without Statistics
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                without statistics in query param
    [Tags]    football    valid     college-football        	CSEAUTO-25086
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=record,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message            Observed that athletes schema is not available in the response although it is in enable filter in query param

Get Football College 2018 Season Team Detail with record only
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                with only Record in query param
    [Tags]   football    valid      college-football        	CSEAUTO-25093
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=record
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Football College 2018 Season Team Detail with statistics only
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                with only Statistics in query param
    [Tags]   football    valid        college-football      	CSEAUTO-25092
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Football College 2018 Season Team Detail with athletes only
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                with only Athletes in query param
    [Tags]    football    valid     college-football        	CSEAUTO-25094
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message            Observed that athletes schema is not available in the response although it is in enable filter in query param

Get Football College 2018 Season Team Detail without nested statistics in athletes
    [Documentation]    Get request for football team details with College-Football season 2018 and team 194
    ...                without nested statistics in athletes in query param
    [Tags]    football    valid       college-football      	CSEAUTO-25087
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=record,statistics,athletes()
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_TRUE}
    set test message            Observed that athletes schema is not available in the response although it is in enable filter in query param

Get Football College 2018 Season Team Detail with invalid league college football
    [Documentation]    Get request for football team details with with invalid league as coll123
    ...                season 2018 and team 194
    [Tags]    football    invalid      college-football        	CSEAUTO-25091
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/coll123/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error

Get Football College 2018 Season Team Detail with invalid seasons
    [Documentation]    Get request for football team details with with invalid seasons as 2abc
    ...                college-football and team 194
    [Tags]    football    invalid      college-football        	CSEAUTO-25089
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/2abc/teams/${FOOTBALL_TEAM_ID}?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error

Get Football College 2018 Season Team Detail with invalid team id
    [Documentation]    Get request for football team details with with invalid teams as 1ty
    ...                colleget-football and season 2018
    [Tags]    football    invalid      college-football    	CSEAUTO-25090
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/1ty?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 404
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      404
    should contain    ${response.json()["error"]["message"]}      no instance found

Get Football College 2018 Season Team Detail with enable as empty
    [Documentation]    Get request for football team details with with enable filter as empty
    [Tags]  valid   football     college-football       	CSEAUTO-25088
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/seasons/${FOOTBALL_SEASON_ID}/teams/${FOOTBALL_TEAM_ID}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}     athletes
#--------------------------------CSEAUTO-24927-------------------------------------------------------------------------#

#--------------------------------CSEAUTO-24928-------------------------------------------------------------------------#
Get Football College Event with Competition Filter
    [Tags]  smoke   football    competition-filter      CSEAUTO-25132
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with Competition Filter without nested linescores in competitors
    [Tags]   valid   college-football       football    competition-filter      	CSEAUTO-25120
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(team,score))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with Competition Filter without nested score in competitors
    [Tags]    valid   college-football      football    competition-filter      CSEAUTO-25121
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(team,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with Competition Filter without nested team in competitors
    [Tags]   valid   college-football    football    competition-filter      	CSEAUTO-25122
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with Competition Filter without nested play in situation
    [Tags]   valid   college-football       football    competition-filter      	CSEAUTO-25133
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with Competition Filter without nested probability in situation
    [Tags]   valid   college-football    football    competition-filter      	CSEAUTO-25119
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(play),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with Competition Filter with situation only
    [Tags]   valid      college-football       football    competition-filter      	CSEAUTO-25138
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(situation)
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Football College Event with Competition Filter with competitors only
    [Tags]   valid   college-football    football    competition-filter      	CSEAUTO-25135
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(competitors)
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Football College Event with Competition Filter with status only
    [Tags]  valid   college-football    football    competition-filter      CSEAUTO-25137
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(status)
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Football College Event with Competition Filter with odds only
    [Tags]  valid   college-football    football    competition-filter      	CSEAUTO-25136
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds)
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with Competition Filter with empty situation
    [Tags]  valid   college-football   football    competition-filter      	CSEAUTO-25134
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Football College Event with empty Competition Filter
    [Tags]  valid   college-football    competition-filter          CSEAUTO-25140
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions()
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Football College Event with Competition Filter with enable as empty
    [Tags]  valid   college-football   football    competition-filter      	CSEAUTO-25143
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid
    Validate key-value   ${response.json()}      id    ${FOOTBALL_EVENT_ID}
    Validate key-value   ${response.json()}      uid   s:20~l:23~e:${FOOTBALL_EVENT_ID}

Get Football College Event with Competition Filter with invalid path param
    [Tags]    college-football   football    competition-filter      	CSEAUTO-25145   invalid
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/coll123/events/${FOOTBALL_EVENT_ID}?enable=competitions(situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     500
    should contain    ${response.json()["error"]["message"]}   application error

Get Football College Event with Competition Filter with invalid query param
    [Tags]    college-football   football    competition-filter      	CSEAUTO-25144   invalid
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(situation(play,prob12ac),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Football College Event with Competition Filter with empty competitor
    [Tags]  valid   college-football      football    competition-filter      	CSEAUTO-25123
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors())
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}
#--------------------------------CSEAUTO-24928-------------------------------------------------------------------------#

#--------------------------------CSEAUTO-24929-------------------------------------------------------------------------#
Get Football College Event Competition Plays
    [Tags]  smoke   football    valid       competition-plays      	CSEAUTO-25435
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}/competitions/${FOOTBALL_EVENT_ID}/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_TRUE}

Get Football College Event Competition Plays without athletes
    [Tags]    football    valid       competition-plays      	CSEAUTO-25436
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}/competitions/${FOOTBALL_EVENT_ID}/plays?enable=participants
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_FALSE}

Get Football College Event Competition Plays with enable as empty
    [Tags]     football    valid       competition-plays      	CSEAUTO-25437
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}/competitions/${FOOTBALL_EVENT_ID}/plays?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_FALSE}    ${ATHLETE_FLAG_FALSE}

Get Football College Event Competition Plays with invalid query param
    [Tags]      football    invalid       competition-plays      	CSEAUTO-25438
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/${FOOTBALL_EVENT_ID}/competitions/${FOOTBALL_EVENT_ID}/plays?enable=part123(ath123)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Football College Event Competition Plays with invalid path param
    [Tags]      football    invalid       competition-plays      	CSEAUTO-25439
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUE_CF}/events/400/competitions/400/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 404
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     404
    should contain    ${response.json()["error"]["message"]}   no instance found
#--------------------------------CSEAUTO-24929-------------------------------------------------------------------------#