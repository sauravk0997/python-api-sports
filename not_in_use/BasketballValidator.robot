*** Settings ***
Documentation       Basketball tests executed with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/basketball-tests.robot

Library             RequestsLibrary
Library             OperatingSystem
Library             DateTime
Library             Collections
Library             String
Resource            ../resource/ESPNCoreAPIResource.robot 

*** Variables ***
@{recordTotalStatsValueList}=  OTWins    losses    points    gamesPlayed    leagueWinPercent    wins    pointsFor    streak    avgPointsFor    clincher    playoffSeed    divisionWinPercent    pointsAgainst    gamesBehind    avgPointsAgainst    ties    OTLosses    winPercent
@{recordLastTenGamesStatsValueList}=         @{recordTotalStatsValueList}
@{statisticsTotalDefensiveList}=    blocks    defensiveRebounds    steals    turnoverPoints    defReboundRate    avgDefensiveRebounds    avgBlocks    avgSteals    avg48DefensiveRebounds    avg48Blocks    avg48Steals
@{statisticsTotalOffensiveList}=    assists    effectiveFGPct    fieldGoalsAttempted     fieldGoalsMade    fieldGoalPct    freeThrowPct    freeThrowsAttempted    freeThrowsMade    offensiveRebounds    points    turnovers    threePointPct    threePointFieldGoalsAttempted    trueShootingPct    teamTurnovers    assistRatio    pointsInPaint    offReboundRate    turnoverRatio    fastBreakPoints    possessions    paceFactor    avgFieldGoalsMade    avgFieldGoalsAttempted    avgFreeThrowsMade    avgFreeThrowsAttempted    avgPoints    avgOffensiveRebounds    avgAssists    avgTurnovers    offensiveReboundPct    estimatedPossessions    avgEstimatedPossessions    pointsPerEstimatedPossessions    avgTeamTurnovers    threePointFieldGoalPct    twoPointFieldGoalPct    twoPointFieldGoalsMade    twoPointFieldGoalsAttempted    twoPointFieldGoalPct    shootingEfficiency    scoringEfficiency    avg48FieldGoalsMade    avg48FieldGoalsAttempted    avg48ThreePointFieldGoalsMade    avg48ThreePointFieldGoalsAttempted    avg48FreeThrowsMade    avg48FreeThrowsAttempted    avg48Points    avg48OffensiveRebounds    avg48Assists    avg48Turnovers   
@{statisticsTotalGeneralList}=    disqualifications    flagrantFouls    fouls    reboundRate    ejections    technicalFouls    rebounds    minutes    avgMinutes    fantasyRating    NBARating    ESPNRating    plusMinus    avgRebounds    avgFouls    avgFlagrantFouls    avgTechnicalFouls    avgEjections    avgDisqualifications    assistTurnoverRatio    stealFoulRatio    blockFoulRatio    avgTeamRebounds    totalRebounds    totalTechnicalFouls    teamAssistTurnoverRatio    teamRebounds    stealTurnoverRatio    avg48Rebounds    avg48Fouls    avg48FlagrantFouls    avg48Ejections    avg48Disqualifications    gamesPlayed    gamesStarted    doubleDouble    tripleDouble
@{statisticsTotalList}=    offensive    defensive    general
@{recordList}=    total    home    road    vsDiv    vsConf    lastTenGames
@{statisticsSeasonDefensiveList}=    blocks    defensiveRebounds    steals    turnoverPoints    avgDefensiveRebounds    avgBlocks    avgSteals
@{statisticsSeasonOffensiveList}=    assists    fieldGoalsAttempted    fieldGoalsMade    fieldGoalPct    freeThrowPct    freeThrowsAttempted    freeThrowsMade    offensiveRebounds    points    turnovers    threePointFieldGoalsAttempted    threePointFieldGoalsMade    teamTurnovers    fastBreakPoints    avgFieldGoalsMade    avgFieldGoalsAttempted    avgThreePointFieldGoalsMade    avgThreePointFieldGoalsAttempted    avgFreeThrowsMade    avgFreeThrowsAttempted    avgPoints    avgOffensiveRebounds    avgAssists    avgTurnovers    offensiveReboundPct    estimatedPossessions    avgEstimatedPossessions    pointsPerEstimatedPossessions    avgTeamTurnovers    threePointFieldGoalPct    twoPointFieldGoalsMade    twoPointFieldGoalsAttempted    twoPointFieldGoalPct    shootingEfficiency    scoringEfficiency  
@{statisticsSeasonGeneralList}=    disqualifications    flagrantFouls    fouls    ejections    technicalFouls    rebounds    minutes    avgMinutes    ESPNRating    avgRebounds    avgFouls    avgFlagrantFouls    avgTechnicalFouls    avgEjections    avgDisqualifications    assistTurnoverRatio    stealFoulRatio    blockFoulRatio    avgTeamRebounds    totalRebounds    totalTechnicalFouls    teamAssistTurnoverRatio    teamRebounds    stealTurnoverRatio    gamesPlayed    gamesStarted    doubleDouble    tripleDouble 
@{recordMCBList}=    season    homeRecord    awayRecord    vsApRankedTeams    vsUsaRankedTeams   vsLeague
@{recordMCBStatsValueList}=  OTWins    losses    points    gamesPlayed    leagueWinPercent    wins    pointsFor    streak    avgPointsFor    playoffSeed    divisionWinPercent    pointsAgainst    gamesBehind    avgPointsAgainst    ties    OTLosses    winPercent

*** Keywords ***
Validate Team Schema
    [Documentation]     Validating the key-values of Team schema
    [Arguments]    ${response}     ${athletes_key_flag}
        Validate the value matches the regular expression    ${response}   id     ^\\d+$
        Validate the value matches the regular expression    ${response}  uid  ^[s:0-9~l:0-9~t:0-9]*$
        Validate the value matches the regular expression    ${response}   guid    ^[a-zA-Z0-9]*$
        Run Keyword If    'alternateId' in ${response}
        ...    Validate the value matches the regular expression    ${response}   alternateId     ^\\d+$
        Validate the value matches the regular expression    ${response}   slug     ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression    ${response}   location     ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}     name      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'nickname' in ${response}
        ...    Validate the value matches the regular expression    ${response}   nickname     ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}     abbreviation      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}   displayName      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}    shortDisplayName      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}    color      ^[a-zA-Z0-9]*$
        Validate the value matches the regular expression  ${response}    alternateColor      ^[a-zA-Z0-9]*$
        should be equal     ${response}[active]      ${true}
        should be equal     ${response}[allstar]      ${false}
        Should Contain    ${response}[uid]    ${response}[id]
        Run Keyword If    'statistics' in ${response}
            ...     dictionary should contain key    ${response}   statistics
        Run Keyword If    'record' in ${response}
            ...     dictionary should contain key    ${response}   record
        IF    ${athletes_key_flag} == True
           dictionary should contain key    ${response}   athletes
        END

Validate record schema
    [Documentation]     Validating the key-values of record schema
    [Arguments]    ${league_name}    ${response}
    Dictionary Should Contain Key    ${response}     record
    Set Test Variable    ${record}    ${response}[record]
    IF    "${league_name}" == "nba"
        FOR    ${item}    IN    @{recordList}
            Dictionary Should Contain Key     ${record}       ${item}   
        END
    Validate record stats schema     ${league_name}    ${response}
    END
    IF    "${league_name}" == "mcb"
        FOR    ${item}    IN    @{recordMCBList}
            Dictionary Should Contain Key     ${record}       ${item}   
        END 
    Validate record stats schema     ${league_name}    ${response}
    END
    
Validate record stats schema
    [Documentation]     Validating the key-values of stats schema
    [Arguments]    ${league_name}    ${response}
    IF    "${league_name}" == "nba"
        Set Test Variable    ${total}    ${response}[record][total]
        Set Test Variable    ${lastTenGames}    ${response}[record][lastTenGames]
        Dictionary Should Contain Key    ${total}     stats
        Dictionary Should Contain Key    ${lastTenGames}     stats
        Set Test Variable    ${totalStats}      ${total}[stats]
        Set Test Variable    ${lastTenGamesStats}      ${lastTenGames}[stats]
        validate rank value perGame attribute values    ${response}    ${totalStats}    ${recordTotalStatsValueList}
        validate rank value perGame attribute values    ${response}    ${lastTenGamesStats}    ${recordLastTenGamesStatsValueList}
    END
    IF    "${league_name}" == "mcb"
        Set Test Variable    ${season}    ${response}[record][season]
        Set Test Variable    ${homeRecord}    ${response}[record][homeRecord]
        Set Test Variable    ${awayRecord}    ${response}[record][awayRecord]
        Set Test Variable    ${vsApRankedTeams}    ${response}[record][vsApRankedTeams]
        Set Test Variable    ${vsUsaRankedTeams}    ${response}[record][vsUsaRankedTeams]
        Set Test Variable    ${vsLeague}    ${response}[record][vsLeague]
        Dictionary Should Contain Key    ${season}     stats
        Dictionary Should Contain Key    ${homeRecord}     stats
        Dictionary Should Contain Key    ${awayRecord}     stats
        Dictionary Should Contain Key    ${vsApRankedTeams}     stats
        Dictionary Should Contain Key    ${vsUsaRankedTeams}     stats
        Dictionary Should Contain Key    ${vsLeague}     stats
        Set Test Variable    ${seasonStats}      ${season}[stats]
        Set Test Variable    ${homeRecordStats}      ${homeRecord}[stats]
        Set Test Variable    ${awayRecordStats}      ${awayRecord}[stats]
        Set Test Variable    ${vsApRankedTeamsStats}      ${vsApRankedTeams}[stats]
        Set Test Variable    ${vsUsaRankedTeamsStats}      ${vsUsaRankedTeams}[stats]
        Set Test Variable    ${vsLeagueStats}      ${vsLeague}[stats]
        validate rank value perGame attribute values    ${response}    ${seasonStats}    ${recordMCBStatsValueList}
        validate rank value perGame attribute values    ${response}    ${homeRecordStats}    ${recordMCBStatsValueList}
        validate rank value perGame attribute values    ${response}    ${awayRecordStats}    ${recordMCBStatsValueList}
        validate rank value perGame attribute values    ${response}    ${vsApRankedTeamsStats}    ${recordMCBStatsValueList}
        validate rank value perGame attribute values    ${response}    ${vsUsaRankedTeamsStats}    ${recordMCBStatsValueList}
        validate rank value perGame attribute values    ${response}    ${vsLeagueStats}    ${recordMCBStatsValueList}
    END  

validate rank value perGame attribute values
    [Documentation]     Validating the key-values of stats schema
    [Arguments]    ${response}    ${stats}    ${statsValueList}
        FOR    ${item}    IN    @{statsValueList}
        Dictionary Should Contain Key     ${stats}       ${item}
        Set Test Variable    ${statsItem}    ${stats}[${item}]
        ${length}=    Get Length    ${statsItem}
            IF    ${length}>0
                    ${valueExists}=   run keyword and return status    Dictionary Should Contain Key       ${statsItem}      value
                    IF    ${valueExists} == True
                        Validate the value matches the regular expression     ${statsItem}   value     [+-]?([0-9]*[.])?[0-9]+
                    END
                    ${rankExists}=   run keyword and return status    Dictionary Should Contain Key       ${statsItem}      rank
                    IF    ${rankExists} == True
                        Validate the value matches the regular expression     ${statsItem}   rank     [+-]?([0-9]*[.])?[0-9]+
                    END
                    ${perGameExists}=   run keyword and return status    Dictionary Should Contain Key       ${statsItem}      perGameValue
                    IF    ${perGameExists} == True
                        Validate the value matches the regular expression     ${statsItem}   perGameValue     [+-]?([0-9]*[.])?[0-9]+
                    END             
            END    
    END 

Validate statistics schema
    [Documentation]     Validating the key-values of statistics schema
    [Arguments]    ${schema}    ${response}    ${total_key_flag}    ${season_key_flag}
    IF    ${total_key_flag} == True
        Dictionary Should Contain Key    ${response}[statistics]    total
        Set Test Variable    ${total}    ${response}[statistics][total]
        FOR    ${item}    IN    @{statisticsTotalList}
            Dictionary Should Contain Key     ${total}       ${item} 
        END   
    END
    IF    ${season_key_flag} == True
        Dictionary Should Contain Key    ${response}[statistics]    season
        Set Test Variable    ${season}    ${response}[statistics][season]
        FOR    ${item}    IN    @{statisticsTotalList}
            Dictionary Should Contain Key     ${season}       ${item} 
        END   
    END
    Validate statistics general schema     ${response}    ${schema}
    Validate statistics offensive schema     ${response}    ${schema}
    Validate statistics defensive schema     ${response}    ${schema}


Validate statistics defensive schema
    [Documentation]     Validating the key-values of defensive schema
    [Arguments]    ${response}    ${schema}
    IF    "${schema}" == "total"
        Set Test Variable    ${total}    ${response}[statistics][total]
        Dictionary Should Contain Key    ${total}     defensive
        Set Test Variable    ${defensive}      ${total}[defensive]
        @{Items}=    Copy List    ${statisticsTotalDefensiveList}
        validate rank value perGame attribute values    ${response}    ${defensive}    ${Items}   
    END
    IF    "${schema}" == "season"
        Set Test Variable    ${season}    ${response}[statistics][season]
        Dictionary Should Contain Key    ${season}     defensive
        Set Test Variable    ${defensive}      ${season}[defensive]
        @{Items}=    Copy List    ${statisticsSeasonDefensiveList}
        validate rank value perGame attribute values    ${response}    ${defensive}    ${Items}
    END

Validate statistics offensive schema
    [Documentation]     Validating the key-values of offensive schema
    [Arguments]    ${response}    ${schema}
     IF    "${schema}" == "total"
        Set Test Variable    ${total}    ${response}[statistics][total]
        Dictionary Should Contain Key    ${total}     offensive
        Set Test Variable    ${offensive}      ${total}[offensive]
        @{Items}=    Copy List    ${statisticsTotalOffensiveList}   
        validate rank value perGame attribute values    ${response}    ${offensive}    ${Items}  
    END
    IF    "${schema}" == "season"
        Set Test Variable    ${season}    ${response}[statistics][season]
        Dictionary Should Contain Key    ${season}     offensive
        Set Test Variable    ${offensive}      ${season}[offensive]
        @{Items}=    Copy List    ${statisticsSeasonOffensiveList}
        validate rank value perGame attribute values    ${response}    ${offensive}    ${Items} 
    END
Validate statistics general schema
    [Documentation]     Validating the key-values of general schema
    [Arguments]    ${response}    ${schema}
    IF    "${schema}" == "total"
        Set Test Variable    ${total}    ${response}[statistics][total]
        Dictionary Should Contain Key    ${total}     general
        Set Test Variable    ${general}      ${total}[general]
        @{Items}=    Copy List    ${statisticsTotalGeneralList}   
        validate rank value perGame attribute values    ${response}    ${general}    ${Items}  
    END
    IF    "${schema}" == "season"
        Set Test Variable    ${season}    ${response}[statistics][season]
        Dictionary Should Contain Key    ${season}     general
        Set Test Variable    ${general}      ${season}[general]
        @{Items}=    Copy List    ${statisticsSeasonGeneralList}
        validate rank value perGame attribute values    ${response}    ${general}    ${Items} 
    END 

Validate Groups Schema under Type for the league MCB
    [Documentation]     Validating the key-values of groups schema under Type
    [Arguments]    ${response}  ${season}   ${type}     ${groups}   ${children_key_flag}    ${teams_key_flag}   ${nested_teams_key_flag}
    ${len}=     Get Length    ${response}[${season}][${type}][${groups}]
    FOR     ${iter}    IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]   id     ^\\d+$
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]  uid  ^[s:0-9~l:0-9~g:0-9]*$
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]  slug      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]  name      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'abbreviation' in ${response}[${season}][${type}][${groups}][${iter}]
            ...     Validate the value matches the regular expression  ${response}[${season}][${type}][${groups}][${iter}]     abbreviation      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}[${season}][${type}][${groups}][${iter}]     shortName      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}[${season}][${type}][${groups}][${iter}]    midsizeName      ^[a-zA-Z'()\\- ]*$
        should be true    ${response}[${season}][${type}][${groups}][${iter}][isConference] == False
        IF    ${children_key_flag} == True
            dictionary should contain key    ${response}[${season}][${type}][${groups}][${iter}]   children
            Validate childrens array for the league MCB         ${response}[${season}][${type}][${groups}][${iter}]    children      ${response}[uid]    ${nested_teams_key_flag} 
        END
        IF    ${teams_key_flag} == True
            dictionary should contain key    ${response}[${season}][${type}][${groups}][${iter}]    teams
            Validate team array for the league MCB    ${response}[${season}][${type}][${groups}][${iter}][teams]
        END
    END

Validate childrens array for the league MCB
    [Documentation]    Validating the key-values of children schema under Groups
    [Arguments]    ${response}      ${children}     ${league_uid}   ${teams_key_flag}
    ${len}=     get length    ${response}[${children}]

    FOR    ${iter}      IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${children}][${iter}]   id     ^\\d+$
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  uid  ^[s:0-9~l:0-9~g:0-9]*$
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  slug      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  name      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  abbreviation      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression  ${response}     shortName      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}    midsizeName      ^[a-zA-Z'()\\- ]*$
        should be true    ${response}[${children}][${iter}][isConference] == True
        Run Keyword If    'children' in ${response}[${children}][${iter}]
            ...     Validate nested children array for the league MCB  ${response}[${children}][${iter}][children]
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  uid  ^[s:0-9~l:0-9~g:0-9]*$
        Validate uid    ${league_uid}    ${response}[${children}][${iter}][id]  g     ${response}[${children}][${iter}][uid]
    END

Validate nested children array for the league MCB
    [Documentation]    Validating the key-values of nested children schema under Groups
    [Arguments]    ${response}
    ${len}=     get length    ${response}
    FOR    ${iter}      IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${iter}]   id     ^\\d+$
        Validate the value matches the regular expression    ${response}[${iter}]  uid  ^[s:0-9~l:0-9~g:0-9]*$
        Validate the value matches the regular expression    ${response}[${iter}]  slug      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${iter}]  name      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${iter}]  abbreviation      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${iter}]  shortName      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${iter}]  midsizeName      ^([0-9])|([a-z A-Z])*$
         Run Keyword If    'teams' in ${response}[${iter}]
            ...     Validate team array for the league MCB  ${response}[${iter}][teams]
        
    END

Validate team array for the league MCB
    [Documentation]    Validating the key-values of nested children schema under Groups
    [Arguments]    ${response}
    ${len}=     get length    ${response}
    FOR    ${iter}      IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${iter}]   id     ^\\d+$
        Validate the value matches the regular expression    ${response}[${iter}]  uid  ^[s:0-9~l:0-9~t:0-9]*$
        Validate the value matches the regular expression    ${response}[${iter}]   guid    ^[a-zA-Z0-9]*$
        Validate the value matches the regular expression    ${response}[${iter}]   alternateId     ^\\d+$
        Validate the value matches the regular expression    ${response}[${iter}]  slug      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${iter}]  name      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${iter}]   nickname     ^[ A-Za-zÀ-ú0-9_()@./#&'+-]*$
        Validate the value matches the regular expression    ${response}[${iter}]  abbreviation      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression  ${response}[${iter}]   displayName      ^([a-zA-Z'()\\- ])|([a-zA-Z 0-9a-zA-Z])*$
        Validate the value matches the regular expression  ${response}[${iter}]    shortDisplayName      ^[ A-Za-zÀ-ú0-9_()@./#&'+-]*$
        Validate the value matches the regular expression  ${response}[${iter}]    color      ^[a-zA-Z0-9]*$
        should be equal     ${response}[${iter}][active]      ${true}
        should be equal     ${response}[${iter}][allstar]      ${false}
    END