*** Settings ***
Documentation       Hockey tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/hockey-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/HockeySportsCoreValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py

*** Variables ***
#Global Variables
${SPORT}                    hockey
${LEAGUEID}                 nhl
${HOCKEY_ID}                70
${HOCKEY_UID}               s:${HOCKEYID}
${HOCKEY_NAME}              Hockey
${HOCKEY_LEAGUE_ID}         90
${HOCKEY_LEAGUE_UID}        s:${HOCKEY_ID}~l:${HOCKEY_LEAGUE_ID}
${HOCKEY_LEAGUE_GROUPID}    9
${HOCKEY_LEAGUE_NAME}       National Hockey League
${HOCKEY_EVENT_ID}          401133947

*** Test Cases ***
# HOCKEY
#--------------------------------CSEAUTO-25515-------------------------------------------------------------------------#

Get Hockey Baseline Responses
    [Documentation]    ESPN core sport base API GET call for hockey
    [Tags]  hockey  valid   smoke       CSEAUTO-25680
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${HOCKEY_ID}", "${HOCKEY_NAME}", "${SPORT}", "${HOCKEY_UID}"]

Get Hockey Leagues
    [Documentation]    ESPN core sport API GET call for hockey with leagues
    [Tags]  hockey_league    valid      hockey      smoke       CSEAUTO-25674
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${HOCKEY_ID}", "${HOCKEY_NAME}", "${SPORT}", "${HOCKEY_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Hockey Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for hockey leagues with filter season
    [Tags]  hockey    hockey_league    valid    smoke       CSEAUTO-25676
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${HOCKEY_ID}", "${HOCKEY_NAME}", "${SPORT}", "${HOCKEY_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Hockey without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for hockey without leagues in queryparams
    [Tags]  hockey    hockey_league   valid         CSEAUTO-25677
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${HOCKEY_ID}", "${HOCKEY_NAME}", "${SPORT}", "${HOCKEY_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}
    dictionary should not contain key    ${response.json()}     leagues

Get Hockey Leagues with Filter invalid
    [Documentation]     ESPN core sport base API GET call for hockey leagues with invalid filter
    [Tags]  hockey    hockey_league   invalid       CSEAUTO-25678
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Hockey with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for hockey with empty string in queryparams
    [Tags]  hockey    hockey_league   invalid       CSEAUTO-25679
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Hockey NHL with Filter Season and Type Groups
    [Documentation]    Get request for hockey with filter enable as season nested with types, groups of teams and
    ...                groups with nested teams
    [Tags]  smoke   nhl_season    valid     hockey      	CSEAUTO-25659
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${HOCKEY_LEAGUE_ID}", "${HOCKEY_LEAGUE_UID}", "${HOCKEY_LEAGUE_GROUPID}", "${HOCKEY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Hockey NHL with Filter Season and Type Groups without teams in nested groups
    [Documentation]    Get request for hockey with filter enable as season nested with types, groups of teams and
    ...                groups without nested teams
    [Tags]    nhl   hockey     valid      filterSeason      	CSEAUTO-25660
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams,groups)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${HOCKEY_LEAGUE_ID}", "${HOCKEY_LEAGUE_UID}", "${HOCKEY_LEAGUE_GROUPID}", "${HOCKEY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Hockey NHL with Filter Season and Type Groups without teams
    [Documentation]    Get request for hockey with filter enable as season nested with types, groups of teams
    ...                and without teams
    [Tags]   nhl    hockey    valid    filterSeason     	CSEAUTO-25661
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${HOCKEY_LEAGUE_ID}", "${HOCKEY_LEAGUE_UID}", "${HOCKEY_LEAGUE_GROUPID}", "${HOCKEY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Hockey NHL with Filter Season and Type Groups without nested groups
    [Documentation]    Get request for hockey with filter enable as season nested with types
    ...                without nested groups
    [Tags]   nhl     hockey    valid      filterSeason      	CSEAUTO-25663
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${HOCKEY_LEAGUE_ID}", "${HOCKEY_LEAGUE_UID}", "${HOCKEY_LEAGUE_GROUPID}", "${HOCKEY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Hockey NHL with Filter Season and Type Groups without teams and nested groups
    [Documentation]    Get request for hockey with filter enable as season nested with types, groups and
    ...                without groups with nested teams
    [Tags]  nhl   hockey       valid    filterSeason        	CSEAUTO-25664
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups()))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${HOCKEY_LEAGUE_ID}", "${HOCKEY_LEAGUE_UID}", "${HOCKEY_LEAGUE_GROUPID}", "${HOCKEY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Hockey NFL with Filter Season and Type Groups without groups
    [Documentation]    Get request for hockey with filter enable as season nested with types without groups
    [Tags]   nhl   hockey      valid    filterSeason        	CSEAUTO-25665
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type)
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${HOCKEY_LEAGUE_ID}", "${HOCKEY_LEAGUE_UID}", "${HOCKEY_LEAGUE_GROUPID}", "${HOCKEY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_FALSE}
    ...             ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Hockey NFL with Filter Season and Type Groups without type
    [Documentation]    Get request for hockey with filter enable as season nested without type
    [Tags]  nhl     hockey     valid     filterSeason       	CSEAUTO-25666
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}[season]                 type

Get Hockey NFL with Filter Season without filter season
    [Documentation]    Get request for hockey with filter enable without season
    [Tags]   nhl    hockey    valid     filterSeason    	CSEAUTO-25667
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Hockey NHL with Filter Season without enable query parameter
    [Documentation]    Get request for hockey with filter enable without enable query parameter
    [Tags]   nhl   hockey  valid     filterSeason       	CSEAUTO-25668
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?season(type(groups(teams,groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}                 season

Get Hockey NHL with Filter Season and Type with invalid value
    [Documentation]    Get request for hockey with invalid value of Type in season
    [Tags]   nhl    hockey    invalid     filterSeason      	CSEAUTO-25669
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(2!ab))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Hockey NHL with Filter Season and Type with invalid nested group
    [Documentation]    Get request for hockey with filter with invalid value of nested group
    [Tags]  nhl   hockey   invalid     filterSeason     	CSEAUTO-25671
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams,groups(2!bc))))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Hockey NHL with Filter Season and Type with invalid value of teams
    [Documentation]    Get request for hockey with invalid value of teams of group filter under season and type
    [Tags]  nhl   hockey   invalid     filterSeason     	CSEAUTO-25672
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(2!ab,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Hockey NHL with Filter Season and Type with invalid value of group
    [Documentation]    Get request for hockey with invalid value of nested groups under season and type of groups
    [Tags]  nhl   hockey   invalid     filterSeason     	CSEAUTO-25673
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(2!ab)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Hockey NHL 2018 Season Team Detail
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                with record, statistics and athletes in query param
    [Tags]  smoke   nhl_season    valid     hockey      CSEAUTO-25622
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}

Get Hockey NHL 2018 Season Team Detail without Athletes
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                without atheletes in query param
    [Tags]    hockey  nhl_season      valid     	CSEAUTO-25624
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=record,statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Hockey NHL 2018 Season Team Detail without Record
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                without record in query param
    [Tags]    hockey    valid     nhl_season        	CSEAUTO-25625
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
        ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}

Get Hockey NHL 2018 Season Team Detail without Statistics
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                without statistics in query param
    [Tags]    hockey    valid     nhl_season        	CSEAUTO-25626
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=record,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
        ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}

Get Hockey NHL 2018 Season Team Detail with record only
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                with only Record in query param
    [Tags]   hockey    valid      nhl_season        	CSEAUTO-25628
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=record
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
        ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Hockey NHL 2018 Season Team Detail with statistics only
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                with only Statistics in query param
    [Tags]   hockey    valid      nhl_season        	CSEAUTO-25629
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=statistics
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
        ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Hockey College 2018 Season Team Detail with athletes only
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                with only Athletes in query param
    [Tags]    hockey    valid     nhl_season        	CSEAUTO-25630
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}

Get Hockey NHL 2018 Season Team Detail without nested statistics in athletes
    [Documentation]    Get request for hockey team details with NHL season 2018 and team 10
    ...                without nested statistics in athletes in query param
    [Tags]    hockey    valid     nhl_season        	CSEAUTO-25631
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=record,statistics,athletes()
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
        ...       ${STATISTICS_FLAG_TRUE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_TRUE}

Get Hockey NHL 2018 Season Team Detail with invalid league
    [Documentation]    Get request for hockey team details with with invalid league nh123
    ...                season 2018 and team 10
    [Tags]    hockey    invalid      nhl_season     CSEAUTO-25632
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/nh123/seasons/2018/teams/10?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error

Get Hockey NHL 2018 Season Team Detail with invalid seasons
    [Documentation]    Get request for hockey team details with with invalid seasons as 2abc
    ...                nhl and team 10
    [Tags]    hockey    invalid     nhl_season      	CSEAUTO-25633
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2abc/teams/10?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error

Get Hockey NHL 2018 Season Team Detail with invalid team id
    [Documentation]    Get request for hockey team details with with invalid teams as 1ty
    ...                nhl and season 2018
    [Tags]    hockey    invalid      nhl_season     	CSEAUTO-25634
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/1ty?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error
    set test message    The test case is expected to throw 404 for no instance in api endpoint

Get Hockey College 2018 Season Team Detail with enable as empty
    [Documentation]    Get request for hockey team details with with enable filter as empty
    [Tags]  valid   hockey     nhl_season       	CSEAUTO-25635
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2018/teams/10?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid
    dictionary should not contain key    ${response.json()}     athletes
    dictionary should not contain key    ${response.json()}     record
    dictionary should not contain key    ${response.json()}     statistics

Get Hockey NHL Event with Competition Filter
    [Documentation]    Get request for hockey competition filter for NHL league event
    [Tags]  smoke   nhl_season    valid     hockey  competition-filter      	CSEAUTO-25636
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message     Probability key is expected to be present in situation

Get Hockey NHL Event with Competition Filter without nested linescores in competitors
    [Documentation]    Get request for hockey competition filter for NHL league event  without linescores in competitors
    [Tags]   smoke   hockey    valid      competition-filter        	CSEAUTO-25637
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(team,score))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}
    set test message     Probability key is expected to be present in situation

Get Hockey NHL Event with Competition Filter without nested score in competitors
    [Documentation]    Get request for hockey competition filter for NHL league event  without nested score in competitors
    [Tags]      hockey    valid      competition-filter     	CSEAUTO-25638
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(team,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message     Probability key is expected to be present in situation

Get Hockey NHL Event with Competition Filter without nested team in competitors
    [Documentation]    Get request for hockey competition filter for NHL league event  without nested team in competitors
    [Tags]   hockey    valid     competition-filter     	CSEAUTO-25639
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors(score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message     Probability key is expected to be present in situation

Get Hockey NHL Event with Competition Filter without nested play in situation
    [Documentation]    Get request for hockey competition filter for NHL league event  without nested play in situation
    [Tags]     hockey    valid     competition-filter       	CSEAUTO-25640
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid for hockey
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}
    set test message     Probability key is expected to be present in situation

Get Hockey NHL Event with Competition Filter without nested probability in situation
    [Documentation]    Get request for hockey competition filter for NHL league event  without nested probability in situation
    [Tags]     hockey    valid     competition-filter       	CSEAUTO-25641
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(play),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Hockey NHL Event with Competition Filter with situation only
    [Documentation]    Get request for hockey competition filter for NHL league event  with situation only
    [Tags]   hockey    valid     competition-filter     	CSEAUTO-25642
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(situation)
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid for hockey
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Hockey NHL Event with Competition Filter with competitors only
    [Documentation]    Get request for hockey competition filter for NHL league event  with competitors only
    [Tags]   hockey    valid     competition-filter     	CSEAUTO-25643
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(competitors)
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Hockey NHL Event with Competition Filter with status only
    [Documentation]    Get request for hockey competition filter for NHL league event  with status only
    [Tags]  hockey    valid     competition-filter      	CSEAUTO-25644
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(status)
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid for hockey
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Hockey NHL Event with Competition Filter with odds only
    [Documentation]    Get request for hockey competition filter for NHL league event  with odds only
    [Tags]  hockey    valid     competition-filter      	CSEAUTO-25645
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds)
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid for hockey
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}

Get Hockey NHL Event with Competition Filter with empty situation
    [Documentation]    Get request for hockey competition filter for NHL league event  with empty situation
    [Tags]  hockey    valid     competition-filter      	CSEAUTO-25646
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid for hockey
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_TRUE}    ${COMPETITORS_SCORE_FLAG_TRUE}    ${COMPETITORS_LINESCORES_FLAG_TRUE}
    ...    ${ODDS_FLAG_TRUE}

Get Hockey NHL Event with empty Competition Filter
    [Documentation]    Get request for hockey competition filter for NHL league event  with empty filter
    [Tags]  hockey    valid     competition-filter      nhl_season      	CSEAUTO-25648
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions()
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid for hockey
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_FALSE}    ${SITUATION_FLAG_FALSE}    ${SITUATION_PLAY_FLAG_FALSE}    ${SITUATION_PROBABILITY_FLAG_FALSE}
    ...    ${COMPETITORS_FLAG_FALSE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_FALSE}

Get Hockey NHL Event with Competition Filter with enable as empty
    [Documentation]    Get request for hockey competition filter for NHL league event with enable as empty
    [Tags]  hockey    valid     competition-filter      nhl_season      	CSEAUTO-25649
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid for hockey
    Validate key-value   ${response.json()}      id    ${HOCKEY_EVENT_ID}
    Validate key-value   ${response.json()}      uid   ${HOCKEY_LEAGUE_UID}~e:${HOCKEY_EVENT_ID}

Get Hockey NHL Event with Competition Filter with invalid path param
    [Documentation]    Get request for hockey competition filter for NHL league event with invalid path param
    [Tags]    nhl_season   hockey      competition-filter      invalid      	CSEAUTO-25650
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/nhl123/events/${HOCKEY_EVENT_ID}?enable=competitions(situation(play,probability),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     500
    should contain    ${response.json()["error"]["message"]}   application error

Get Hockey NHL Event with Competition Filter with invalid query param
    [Documentation]    Get request for hockey competition filter for NHL league event with invalid query param
    [Tags]      nhl_season   hockey      competition-filter      invalid        	CSEAUTO-25651
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(situation(play,prob12ac),competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Hockey NHL Event with Competition Filter with empty competitor
    [Documentation]    Get request for hockey competition filter for NHL league event with empty competitor
    [Tags]   nhl_season   hockey      competition-filter      valid
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}?enable=competitions(odds,status,situation(play,probability),competitors())
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate competitions array values of event schema is valid
    ...    ${response.json()}    ${STATUS_FLAG_TRUE}    ${SITUATION_FLAG_TRUE}    ${SITUATION_PLAY_FLAG_TRUE}    ${SITUATION_PROBABILITY_FLAG_TRUE}
    ...    ${COMPETITORS_FLAG_TRUE}    ${COMPETITORS_TEAM_FLAG_FALSE}    ${COMPETITORS_SCORE_FLAG_FALSE}    ${COMPETITORS_LINESCORES_FLAG_FALSE}
    ...    ${ODDS_FLAG_TRUE}
    set test message     Probability key is expected to be present in situation

Get Hockey NHL Event with Competition Plays
    [Documentation]    Get request for hockey competition plays for NHL league event athletes participants
    [Tags]  smoke   nhl_season    valid     competition-plays   hockey      CSEAUTO-25652
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}/competitions/${HOCKEY_EVENT_ID}/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_TRUE}

Get Hockey NHL Event Competition Plays without athletes
    [Documentation]    Get request for hockey competition plays for NHL league event without athletes
    [Tags]    hockey     nhl_season    valid     competition-plays      	CSEAUTO-25654
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}/competitions/${HOCKEY_EVENT_ID}/plays?enable=participants
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_TRUE}    ${ATHLETE_FLAG_FALSE}

Get Hockey NHL Event Competition Plays with enable as empty
    [Documentation]    Get request for hockey competition plays for NHL league event with enable as empty
    [Tags]      hockey   nhl_season    valid     competition-plays      	CSEAUTO-25655
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}/competitions/${HOCKEY_EVENT_ID}/plays?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Validate items array values of play schema is valid      ${response.json()}    ${PARTICIPANTS_FLAG_FALSE}    ${ATHLETE_FLAG_FALSE}

Get Hockey NHL Event Competition Plays with invalid query param
    [Documentation]    Get request for hockey competition plays for NHL league event with query param
    [Tags]      hockey    invalid     nhl_season     competition-plays      	CSEAUTO-25656
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/${HOCKEY_EVENT_ID}/competitions/${HOCKEY_EVENT_ID}/plays?enable=part123(ath123)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Hockey NHL Event Competition Plays with invalid path param
    [Documentation]    Get request for hockey competition plays for NHL league event with path param
    [Tags]      hockey    invalid       competition-plays       nhl_season      	CSEAUTO-25657
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/events/400/competitions/400/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 404
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     404
    should contain    ${response.json()["error"]["message"]}   no instance found

#--------------------------------CSEAUTO-25515-------------------------------------------------------------------------#