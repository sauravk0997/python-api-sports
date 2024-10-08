*** Settings ***
Documentation       All API Common robot utils/functions and variables with respect to
...                 Baseball ESPNSports API's are maintained here

*** Variables ***
${SPORT}            baseball
${BASEBALL_ID}      1
${BASEBALL_UID}     s:${BASEBALL_ID}
${BASEBALL_GUID}    e364bfcd-493d-3bfb-ac83-bd27d66fedd0
${BASEBALL_NAME}    Baseball
${BASEBALL_SLUG}    baseball

${BASEBALL_SEASON_ID}       2018
${BASEBALL_TEAM_ID}         10

${LEAGUE_MLB}               mlb
${LEAGUE_MLB_ID}            10
${LEAGUE_MLB_UID}           s:${BASEBALL_ID}~l:${LEAGUE_MLB_ID}
${LEAGUE_MLB_NAME}          Major League Baseball
${LEAGUE_MLB_SHORT_NAME}    MLB
${LEAGUE_MLB_SLUG}          mlb

${LEAGUE_COLLEGE_BASEBALL}               college-baseball
${LEAGUE_COLLEGE_BASEBALL_ID}            14
${LEAGUE_COLLEGE_BASEBALL_UID}           s:${BASEBALL_ID}~l:${LEAGUE_COLLEGE_BASEBALL_ID}
${LEAGUE_COLLEGE_BASEBALL_NAME}          NCAA Men's Baseball
${LEAGUE_COLLEGE_BASEBALL_SLUG}          college-baseball

${LEAGUE_MLB_TEAM_YANKEES_ID}    10
${LEAGUE_MLB_TEAM_YANKEES_UID}   s:${BASEBALL_ID}~l:${LEAGUE_MLB_ID}~t:${LEAGUE_MLB_TEAM_YANKEES_ID}
${LEAGUE_MLB_TEAM_YANKEES_GUID}  2b9cedf3ce600bcffafe8cd055255685
${LEAGUE_MLB_TEAM_YANKEES_SLUG}  new-york-yankees
${LEAGUE_MLB_TEAM_YANKEES_NAME}  Yankees

${LEAGUE_MLB_EVENT_ID}          381016118
${LEAGUE_MLB_EVENT_UID}         s:${BASEBALL_ID}~l:${LEAGUE_MLB_ID}~e:${LEAGUE_MLB_EVENT_ID}
${LEAGUE_MLB_EVENT_NAME}        Boston Red Sox at Houston Astros
${LEAGUE_MLB_EVENT_SHORT_NAME}  BOS @ HOU