*** Settings ***
Documentation       Rugby tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/rugby-tests.robot

Library             RequestsLibrary
Library             ../lib/validators/ESPNSportsCoreValidator.py
Library             ../lib/validators/RugbySportsCoreValidator.py
Library             OperatingSystem
Resource            ../resource/ESPNCoreAPIResource.robot
Library             ../lib/validators/ESPNSportsCoreCommonValidator.py

*** Variables ***
#Global variables
${SPORT}                    rugby
${LEAGUEID}                 3
${RUGBY_NAME}               Rugby
${RUGBY_ID}                 300
${RUGBY_UID}                s:${RUGBY_ID}
${RUGBY_LEAGUE_UID}         ${RUGBY_UID}~l:${LEAGUEID}
${RUGBY_LEAGUE_GROUPID}     ${LEAGUEID}
${RUGBY_LEAGUE_NAME}        National Rugby League

*** Test Cases ***
# Rugby
#--------------------------------CSEAUTO-25582-------------------------------------------------------------------------#

Get Rugby Baseline Responses
    [Documentation]    ESPN core sport base API GET call for rugby
    [Tags]  rugby  valid    smoke       	CSEAUTO-26048
    set test variable   ${request_url}  ${API_BASE}/${SPORT}
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${RUGBY_ID}", "${RUGBY_NAME}", "${SPORT}", "${RUGBY_UID}"]

Get Rugby Leagues
    [Documentation]    ESPN core sport API GET call for rugby with leagues
    [Tags]  rugby  valid    smoke   rugby-league    	CSEAUTO-26049
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${RUGBY_ID}", "${RUGBY_NAME}", "${SPORT}", "${RUGBY_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_FALSE}

Get Rugby Leagues with Filter Season
    [Documentation]    ESPN core sport base API GET call for ice hockey leagues with filter season
    [Tags]  rugby  valid    smoke   rugby-league    	CSEAUTO-26050
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(season)
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${RUGBY_ID}", "${RUGBY_NAME}", "${SPORT}", "${RUGBY_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Rugby without Leagues in queryParams
    [Documentation]    ESPN core sport base API GET call for rugby without leagues in queryparams
    [Tags]    rugby  valid      rugby-league        	CSEAUTO-26051
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "name", "slug", "uid"]       ["${RUGBY_ID}", "${RUGBY_NAME}", "${SPORT}", "${RUGBY_UID}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_FALSE}  ${SEASONS_FLAG_FALSE}
    dictionary should not contain key    ${response.json()}     leagues

Get Rugby with Filter invalid
    [Documentation]     ESPN core sport base API GET call for rugby leagues with invalid filter
    [Tags]  rugby    invalid     rugby-league       	CSEAUTO-26052
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Rugby with empty string in queryParams
    [Documentation]     ESPN core sport base API GET call for rugby with empty string in queryparams
    [Tags]  rugby    invalid     rugby-league       	CSEAUTO-26053
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Rugby NRL with Filter Season and Type Groups
    [Documentation]    Get request for rugby with filter enable as season nested with types, groups of teams and
    ...                groups with nested teams
    [Tags]   smoke    valid     rugby      rugby-league     	CSEAUTO-26054
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Rugby NRL with Filter Season and Type Groups without teams in nested groups
    [Documentation]    Get request for rugby with filter enable as season nested with types, groups of teams and
    ...                groups without nested teams
    [Tags]    nrl   rugby     valid      filterSeason   rugby-league        	CSEAUTO-26055
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams,groups)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Rugby NRL with Filter Season and Type Groups without teams
    [Documentation]    Get request for football with filter enable as season nested with types, groups of teams
    ...                and without teams
    [Tags]   nrl    rugby    valid    filterSeason      	CSEAUTO-26056
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_TRUE}      ${NESTED_GROUPS_TEAMS_FLAG_TRUE}

Get Rugby NRL with Filter Season and Type Groups without nested groups
    [Documentation]    Get request for rugby with filter enable as season nested with types
    ...                without nested groups
    [Tags]    nrl    rugby    valid    filterSeason     	CSEAUTO-26058
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams)))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_TRUE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Rugby NFL with Filter Season and Type Groups without teams and nested groups
    [Documentation]    Get request for rugby with filter enable as season nested with types, groups and
    ...                without groups with nested teams
    [Tags]      nrl    rugby    valid    filterSeason       	CSEAUTO-26059
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups()))
    ${response}=        A GET request to ${request_url} should respond with 200
    ${values}=      create dictionary       id=3   uid=s:300~l:3   groupId=3   name=National Rugby League     season=${true}    type=${true}    groupName=Round-Robin
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_TRUE}
    ...             ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Rugby NRL with Filter Season and Type Groups without groups
    [Documentation]    Get request for rugby with filter enable as season nested with types without groups
    [Tags]    nrl    rugby    valid    filterSeason     	CSEAUTO-26060
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type)
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_TRUE}       ${GROUPS_FLAG_FALSE}
    ...             ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}

Get Rugby NRL with Filter Season and Type Groups without type
    [Documentation]    Get request for football with filter enable as season nested without type
    [Tags]  nrl    rugby    valid    filterSeason       	CSEAUTO-26061
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    Validate type groups array values of season schema is valid     ${response.json()}      ${TYPE_FLAG_FALSE}       ${GROUPS_FLAG_FALSE}
    ...             ${GROUPS_TEAMS_FLAG_FALSE}       ${NESTED_GROUPS_FLAG_FALSE}      ${NESTED_GROUPS_TEAMS_FLAG_FALSE}
    dictionary should not contain key    ${response.json()}[season]                 type

Get Rugby NRL with Filter Season without filter season
    [Documentation]    Get request for rugby with filter enable without season
    [Tags]   nrl    rugby    valid    filterSeason      CSEAUTO-26062
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    Validate the expected and actual values from the response    ${response.json()}
    ...         ["id", "uid", "groupId", "name"]       ["${LEAGUEID}", "${RUGBY_LEAGUE_UID}", "${RUGBY_LEAGUE_GROUPID}", "${RUGBY_LEAGUE_NAME}"]
    dictionary should not contain key    ${response.json()}                 season

Get Rugby NRL with Filter Season without enable query parameter
    [Documentation]    Get request for football with filter enable without enable query parameter
    [Tags]   nrl    rugby    valid    filterSeason      	CSEAUTO-26063
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?season(type(groups(teams,groups())))
    ${response}=        A GET request to ${request_url} should respond with 200
    League Schema from ${response} should be valid for rugby
    dictionary should not contain key    ${response.json()}                 season

Get Rugby NRL with Filter Season and Type with invalid value
    [Documentation]    Get request for rugby with invalid value of Type in season
    [Tags]   nrl    rugby    invalid    filterSeason        CSEAUTO-26064
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(2!ab))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Rugby NRL with Filter Season and Type with invalid nested group
    [Documentation]    Get request for rugby with filter with invalid value of nested group
    [Tags]  nrl    rugby    invalid    filterSeason    	CSEAUTO-26065
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(teams,groups(2!bc))))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings     ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Rugby NRL with Filter Season and Type with invalid value of teams
    [Documentation]    Get request for rugby with invalid value of teams of group filter under season and type
    [Tags]  nrl    rugby    invalid    filterSeason     	CSEAUTO-26066
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(2!ab,groups(teams))))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings     ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Rugby NRL with Filter Season and Type with invalid value of group
    [Documentation]    Get request for football with invalid value of nested groups under season and type of groups
    [Tags]  nrl    rugby    invalid    filterSeason     CSEAUTO-26067
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}?enable=season(type(groups(2!ab)))
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings     ${response.json()["error"]["code"]}      400
    should contain    ${response.json()["error"]["message"]}      Unknown toggle

Get Rugby NRL 2022 Season Team Detail
    [Documentation]    Get request for rubgy team details with NHL season 2022 and team 289194
    ...                with record, statistics and athletes in query param
    [Tags]   smoke    valid     rugby       nrl_season      	CSEAUTO-26070
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2022/teams/289194?enable=record,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid for rugby
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    set test message    Observed that statistics schema is not populated in Athletes although it has been provided in query param

Get Rugby NRL 2022 Season Team Detail without Athletes
    [Documentation]    Get request for rugby team details with NHL season 2022 and team 289194
    ...                without atheletes in query param
    [Tags]    valid     rugby       nrl_season      	CSEAUTO-26071
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2022/teams/289194?enable=record
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid for rugby
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_FALSE}

Get Rugby NRL 2022 Season Team Detail without Record
    [Documentation]    Get request for rugby team details with NHL season 2022 and team 289194
    ...                without record in query param
    [Tags]    valid     rugby       nrl_season      CSEAUTO-26072
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2022/teams/289194?enable=athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid for rugby
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
        ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_FALSE}     ${ATHLETE_STATISTICS_FLAG_TRUE}     ${ATHLETE_FLAG_TRUE}
    dictionary should not contain key       ${response.json()}      record

Get Rugby NRL 2022 Season Team Detail without nested statistics in athletes
    [Documentation]    Get request for rugby team details with NHL season 2022 and team 289194
    ...                without nested statistics in athletes in query param
    [Tags]   valid     rugby       nrl_season       	CSEAUTO-26073
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2022/teams/289194?enable=record,athletes()
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid for rugby
    Validate teams details for statistics athletes and record schema is valid       ${response.json()}
    ...       ${STATISTICS_FLAG_FALSE}   ${RECORD_FLAG_TRUE}     ${ATHLETE_STATISTICS_FLAG_FALSE}     ${ATHLETE_FLAG_TRUE}

Get Rugby NRL 2022 Season Team Detail with invalid league
    [Documentation]    Get request for rugby team details with with invalid league ab123
    ...                season 2022 and team 289194
    [Tags]    rugby    invalid      nrl_season      	CSEAUTO-26074
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/ab123/seasons/2022/teams/289194?enable=record,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error

Get Rugby NRL 2022 Season Team Detail with invalid seasons
    [Documentation]    Get request for rugby team details with with invalid seasons as 2abc
    ...                nrl and team 289194
    [Tags]    rugby    invalid      nrl_season      	CSEAUTO-26075
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2abc/teams/289194?enable=record,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error

Get Hockey NHL 2018 Season Team Detail with invalid team id
    [Documentation]    Get request for rugby team details with with invalid teams as 1ty
    ...                nrl and season 2022
    [Tags]    rugby    invalid      nrl_season      	CSEAUTO-26076
    set test variable   ${request_url}  ${API_BASE}/${SPORT}/${LEAGUEID}/seasons/2022/teams/1ty?enable=record,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 500
    Invalid Schema from ${response} should be valid
    should be equal as strings    ${response.json()["error"]["code"]}      500
    should contain    ${response.json()["error"]["message"]}      application error
    set test message    The test case is expected to throw 404 for no instance in api endpoint instead of 500

#--------------------------------CSEAUTO-25582-------------------------------------------------------------------------#

