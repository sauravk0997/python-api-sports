*** Settings ***
Documentation       Soccer tests are executing with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/soccer-tests.robot

Metadata    Author      Ganapathi Reshma Rani
Metadata    Date        27-09-2022

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             lib.validators.SoccerValidator
Library             lib.validators.ESPNSportsCoreCommonValidator
Library             OperatingSystem
Resource            resource/ESPNCoreAPIResource.robot

*** Variables ***
# Global Variables
${SPORT}          soccer
${SOCCER_ID}      600
${SOCCER_UID}     s:${SOCCER_ID}
${SOCCER_NAME}    Soccer
${SOCCER_SLUG}    ${SPORT}


*** Test Cases ***
# SOCCER
Get Soccer Baseline Responses
    [Tags]  soccer  valid   CSEAUTO-26284
    ${response}=        A GET request to ${API_BASE}/${SPORT} should respond with 200
    Sport Schema from ${response} should be valid
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${SOCCER_ID}", "${SOCCER_UID}", "${SOCCER_NAME}", "${SOCCER_SLUG}"]

# Tests start for soccer_leagues (https://jira.disney.com/browse/CSEAUTO-25516)

Get Soccer Leagues
    [Tags]  soccer  valid   CSEAUTO-26290   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for soccer
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${SOCCER_ID}", "${SOCCER_UID}", "${SOCCER_NAME}", "${SOCCER_SLUG}"]
    dictionary should contain key    ${response.json()}     leagues
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}}  ${SEASONS_FLAG_FALSE}

Get Soccer Leagues with Filter Season
    [Tags]  soccer  valid   CSEAUTO-26292   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?   
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for soccer
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${SOCCER_ID}", "${SOCCER_UID}", "${SOCCER_NAME}", "${SOCCER_SLUG}"]
    Validate leagues array of sports schema      ${response.json()}  ${LEAGUES_FLAG_TRUE}  ${SEASONS_FLAG_TRUE}

Get Soccer without Leagues in queryParams
    [Tags]  soccer    valid     CSEAUTO-26293   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=
    ${response}=        A GET request to ${request_url} should respond with 200
    Sport Schema from ${response} should be valid for soccer
    Validate the expected and actual values from the response  ${response.json()}   ["id", "uid", "name", "slug"]   ["${SOCCER_ID}", "${SOCCER_UID}", "${SOCCER_NAME}", "${SOCCER_SLUG}"]
    dictionary should not contain key    ${response.json()}     leagues

Get Soccer Leagues with Filter invalid
    [Tags]  soccer    invalid   CSEAUTO-26294   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=leagues(invalid)
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings  ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Soccer with empty string in queryParams
    [Tags]  soccer    invalid     CSEAUTO-26295   league_season
    set test variable   ${request_url}  ${API_BASE}/${SPORT}?enable=""
    ${response}=        A GET request to ${request_url} should respond with 400
    Invalid Schema from ${response} should be valid
    should be equal as strings      ${response.json()["error"]["code"]}     400
    should contain    ${response.json()["error"]["message"]}   Unknown toggle

Get Soccer USA 2018 Team Record
    [Tags]  smoke   soccer  valid
    set test variable   ${request_url}  ${API_BASE}/soccer/usa.1/seasons/2018/teams/186?enable=record,statistics,athletes(statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid

Get Soccer USA Event Plays with Participant Filter
    [Tags]  smoke   soccer    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/usa.1/events/533108/competitions/533108/plays?enable=participants(athlete)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid

Get Soccer USA Event Plays with Competition Filter
    [Tags]  smoke   soccer    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/usa.1/events/533108?enable=competitions(odds,status,competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid

Get Soccer USA Event Plays with Team and Participant Filter
    [Tags]  smoke   soccer    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/usa.1/events/533108/competitions/533108/plays?enable=team,participants(athlete,statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid

Get Soccer USA 2018 Team Details with Notes
    [Tags]  smoke   soccer    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/usa.1/seasons/2018/teams/186?enable=record,statistics,athletes(statistics),notes
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid

Get Soccer Olympic Mens Soccer 2020 Season Standings
    [Tags]  smoke   soccer   valid
    set test variable   ${request_url}  ${API_BASE}/soccer/olympics-mens-soccer/seasons/2020?enable=standings(entries(athlete(record)))&type=athletes&sort=silver
    ${response}=        A GET request to ${request_url} should respond with 200
    Season Schema from ${response} should be valid

Get Soccer Olympic Mens Soccer Event with Competition Filter
    [Tags]  smoke   soccer    valid    olympic_soccer_example_1
    set test variable   ${request_url}  ${API_BASE}/soccer/olympics-mens-soccer/events?enable=competitions(competitors(score,athlete,team,country,roster(athlete)))
    ${response}=        A GET request to ${request_url} should respond with 200
    Events Schema from ${response} should be valid

Get Soccer English Premier League Event with Competition Filter
    [Tags]  smoke   soccer    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/eng.1/events/605764?enable=competitions(odds,status,competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid


Get Soccer English Premier League Event Competition with Plays Filter
    [Tags]  smoke   soccer    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/eng.1/events/605764/competitions/605764/plays?enable=team,participants(athlete,statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid

Get Soccer English Premier League 2018 Team Details
    [Tags]  smoke   soccer    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/eng.1/seasons/2018/teams/359?enable=record,statistics,athletes(statistics),notes
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid

Get Soccer Spanish LaLiga Event with Competitions Filter
    [Tags]  smoke   soccer  esp.1    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/esp.1/events/610504?enable=competitions(odds,status,competitors(team,score,linescores))
    ${response}=        A GET request to ${request_url} should respond with 200
    Event Schema from ${response} should be valid

Get Soccer Spanish LaLiga Event Competition with Plays Filter
    [Tags]  smoke   soccer  esp.1    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/esp.1/events/610504/competitions/610504/plays?enable=team,participants(athlete,statistics)
    ${response}=        A GET request to ${request_url} should respond with 200
    Plays Schema from ${response} should be valid

Get Soccer Spanish LaLiga 2018 Team Details
    [Tags]  smoke   soccer  esp.1    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/esp.1/seasons/2018/teams/86?enable=record,statistics,athletes(statistics),notes
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid

Get Soccer French Ligue 1 2018 Team Details
    [Tags]  smoke   soccer  fra.1    valid_1
    set test variable   ${request_url}  ${API_BASE}/soccer/fra.1/seasons/2018/teams/167?enable=record,athletes(statistics),notes
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid

Get Soccer German Bundesliga 2018 Team Details
    [Tags]  smoke   soccer  bund    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/ger.1/seasons/2018/teams/11420?enable=record,statistics,athletes(statistics),notes
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid

Get Soccer Italian Serie A 2018 Team Details
    [Tags]  smoke   soccer  ita.1    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/ita.1/seasons/2018/teams/107?enable=record,statistics,athletes(statistics),notes
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid

Get Soccer UEFA Champions League 2018 Team Details
    [Tags]  smoke   soccer  ucl    valid
    set test variable   ${request_url}  ${API_BASE}/soccer/uefa.champions/seasons/2018/teams/110?enable=record,statistics,athletes(statistics),notes
    ${response}=        A GET request to ${request_url} should respond with 200
    Team Schema from ${response} should be valid