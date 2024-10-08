*** Settings ***
Library             RequestsLibrary
Library             OperatingSystem
Library             DateTime
Library             Collections
Library             String
Resource            ../resource/ESPNCoreAPIResource.robot
Resource            ../resource/SportsValidator.robot

*** Variables ***
@{totalList}=    general     offensive      defensive     penalties
@{totalGeneral}=    games    goalDifferential    overtimeLosses    PIMDifferential   shotDifferential  timeOnIce   wins
@{statisticsGeneral}=    games    gameStarted    losses    overtimeLosses   plusMinus  production      shifts   ties    timeOnIce   wins
@{totalOffensive}=    assists       avgGoals         avgShots   emptyNetGoalsFor    goals     points    powerPlayAssists    powerPlayGoals      powerPlayOpportunities      powerPlayPct    shootingPct     shootoutAttempts    shootoutGoals       shootoutShotPct     shortHandedAssists      shortHandedGoals    shotsTotal      shutouts    unassistedGoals
@{statisticsOffensive}=    assists       avgShots         faceoffsLost   faceoffsWon    gameTyingGoals     gameWinningGoals     goals    points      powerPlayAssists      powerPlayGoals    shootingPct     shootoutAttempts    shootoutGoals       shootoutShotPct     shortHandedAssists      shortHandedGoals    shotsTotal      shutouts    totalFaceOffs
@{totalDefensive}=   avgGoalsAgainst   avgShotsAgainst     emptyNetGoalsAgainst      goalsAgainst      overtimeLosses       penaltyKillPct   powerPlayGoalsAgainst     savePct     saves       shootoutSavePct    shootoutSaves   shootoutShotsAgainst      shortHandedGoalsAgainst      shotsAgainst      shutoutsAgainst     timesShortHanded
@{statisticsDefensive}=   avgGoalsAgainst   avgShotsAgainst     blockedShots      goalsAgainst      hits       overtimeLosses   savePct     saves     shootoutSavePct       shootoutSaves    shootoutShotsAgainst   shotsAgainst
@{totalPenalties}=   avgFights     boardingPenalties       chargingPenalties     crossCheckingPenalties    divingPenalties     elbowingPenalties       fightingPenalties     gameMisconducts   goalieInterferencePenalties     highStickingPenalties      holdingPenalties       hookingPenalties     instigatorPenalties     interferencePenalties     majorPenalties       matchPenalties      minorPenalties      misconducts     penaltyMinutes       penaltyMinutesAgainst        roughingPenalties      slashingPenalties     stickHoldingPenalties     timeBetweenFights        trippingPenalties       unsportsmanlikePenalties
@{statisticsPenalties}=   avgFights     boardingPenalties       chargingPenalties     crossCheckingPenalties    divingPenalties     elbowingPenalties       fightingPenalties     gameMisconducts   goalieInterferencePenalties     highStickingPenalties      holdingPenalties       hookingPenalties     instigatorPenalties     interferencePenalties     majorPenalties       matchPenalties      minorPenalties      misconducts     penaltyMinutes         roughingPenalties      slashingPenalties     stickHoldingPenalties     trippingPenalties       unsportsmanlikePenalties
@{statsSeason}=       avgPointsAgainst    avgPointsFor    awayLosses  awayOtLosses     awayTies    awayWins    clincher   differential      gamesPlayed  homeLosses    homeOtLosses    homeTies    homeWins     losses  otLosses       otWins     playoffSeed     points     pointsAgainst    pointsDiff    pointsFor      rotWins       shootoutLosses   shootoutWins      streak    ties    winPercent  wins
@{statsHomeRecord}=       avgPointsAgainst    avgPointsFor    awayLosses  awayOtLosses     awayTies    awayWins    clincher   differential      gamesPlayed  homeLosses    homeOtLosses    homeTies    homeWins     otLosses  otLosses       playoffSeed     points     pointsAgainst     pointsDiff    pointsFor    shootoutLosses      shootoutWins       streak
@{recordListHockey}=      awayRecord      homeRecord      lastTenGames      season        vsOwnDivision       vsOwnLeague


*** Keywords ***

Validate statistics schema for hockey
        [Documentation]    Validate statistics schema under teams details
        [Arguments]      ${response}
        set test variable       ${season}       ${response}[statistics][total]
        Dictionary Should Contain Key    ${response}[statistics]    total
        FOR    ${item}    IN    @{totalList}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${season}      ${item}
        @{listGet}=     Get list from total for hockey           ${item}
        Run keyword if      ${exists}==${True}   Validate schema under season schema   ${season}     ${item}   @{listGet}
        END

Get list from total for hockey
        [Documentation]    Returns the corresponding list for the season key
        [Arguments]    ${key}
        @{listToReturn}     create list
        IF  "${key}" == "general"
            @{listToReturn}     copy list    ${totalGeneral}
        ELSE IF    "${key}" == "offensive"
            @{listToReturn}     copy list    ${totalOffensive}
        ELSE IF    "${key}" == "defensive"
            @{listToReturn}     copy list        ${totalDefensive}
        ELSE IF    "${key}" == "penalties"
            @{listToReturn}     copy list        ${totalPenalties}
        END
        [Return]    @{listToReturn}

Validate statistics schema in Athletes for hockey
        [Documentation]    Validate statistics schema under teams details
        [Arguments]      ${response}
        set test variable       ${season}       ${response}[statistics][total]
        Dictionary Should Contain Key    ${response}[statistics]    total
        FOR    ${item}    IN    @{totalList}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${season}      ${item}
        @{listGet}=     Get list from statistics total           ${item}
        Run keyword if      ${exists}==${True}   Validate schema under season schema   ${season}     ${item}   @{listGet}
        END

Get list from statistics total
        [Documentation]    Returns the corresponding list for the season key
        [Arguments]    ${key}
        @{listToReturn}     create list
        IF  "${key}" == "general"
            @{listToReturn}     copy list    ${statisticsGeneral}
        ELSE IF    "${key}" == "offensive"
            @{listToReturn}     copy list    ${statisticsOffensive}
        ELSE IF    "${key}" == "defensive"
            @{listToReturn}     copy list        ${statisticsDefensive}
        ELSE IF    "${key}" == "penalties"
            @{listToReturn}     copy list        ${statisticsPenalties}
        END
        [Return]    @{listToReturn}

Validate record schema for hockey
        [Documentation]    Validate keys of record schema under teams details
        [Arguments]      ${response}
        Dictionary Should Contain Key    ${response}   record
        set test variable    ${record}      ${response}[record]
        FOR    ${item}    IN    @{recordListHockey}
        dictionary should contain key     ${record}      ${item}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${record}[${item}]      stats
        Run keyword if      ${exists}==${True}   Validate stats schema in record for hockey    ${record}[${item}]
        END

Validate stats schema in record for hockey
        [Documentation]    Validate stats schema under all the keys of record in teams details
        [Arguments]      ${recordItem}
        dictionary should contain key    ${recordItem}      stats
        set test variable    ${statsResp}       ${recordItem}[stats]
        FOR    ${item}    IN    @{statsSeason}
            ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${statsResp}       ${item}
            IF  ${exists}==${True}
            Dictionary Should Contain Key     ${statsResp}       ${item}
            Set Test Variable    ${statsItem}    ${statsResp}[${item}]
            ${length}=    Get Length    ${statsItem}
                 IF    ${length}>0
                    ${valueExists}=   run keyword and return status    Dictionary Should Contain Key       ${statsItem}      value
                     IF    ${valueExists} == True
                         Value should not be empty and match regex     ${statsItem}[value]        [+-]?([0-9]*[.])?[0-9]+
                     END
                END
             END
         END

Validate Events schema for Hockey
        [Documentation]    Validating the events schema
        [Arguments]    ${response}      @{filters}
        Validate the string is equal to the value    ${response}[id]    401133947
        Value should not be empty and match regex    ${response}[uid]   ^[s:0-9~l:0-9~e:0-9]*$
        should contain    ${response}[uid]    ${response}[id]
        Value should not be empty and match regex    ${response}[date]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
        Value should not be empty and match regex    ${response}[name]   ^[a-zA-Z. ]*$
        Value should not be empty and match regex    ${response}[shortName]   ^[A-Z@A-Z ]*$
        validate the string is equal to the value   ${response}[timeValid]       ${true}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${response}      competitions
        Run keyword if      ${exists}==${True}       Validate competitions schema for sport    ${response}        @{filters}


Validate Athletes schema for hockey
        [Documentation]    Validating the Athlete schema in participant for Competitions Plays football
        [Arguments]    ${response}      ${isStatistics}
        set test variable    ${athlete}     ${response}[athletes]
        ${len}=     get length    ${athlete}
        FOR    ${item}      IN RANGE    ${len}
        Value should not be empty and match regex    ${athlete}[${item}][uid]      ^[s:0-9~l:0-9~a:0-9]*$
        should contain     ${athlete}[${item}][uid]          ${athlete}[${item}][id]
        Value should not be empty and match regex    ${athlete}[${item}][guid]      ^[a-z0-9]*$
        Value should not be empty and match regex    ${athlete}[${item}][firstName]      ^[a-zA-Z' ]*$
        Value should not be empty and match regex    ${athlete}[${item}][lastName]      ^[a-zA-Z. ]*$
        should be equal    ${athlete}[${item}][fullName]     ${athlete}[${item}][firstName]${SPACE}${athlete}[${item}][lastName]
        should be equal    ${athlete}[${item}][fullName]     ${athlete}[${item}][displayName]
        should contain    ${athlete}[${item}][shortName]      ${athlete}[${item}][lastName]
        Value should not be empty and match regex    ${athlete}[${item}][weight]      \\d{2,3}
        ${displayWeight}=   convert to integer    ${athlete}[${item}][weight]
        should be equal    ${displayWeight}${SPACE}lbs     ${athlete}[${item}][displayWeight]
        Value should not be empty and match regex    ${athlete}[${item}][height]      \\d{2,3}
        Value should not be empty and match regex    ${athlete}[${item}][displayHeight]      ^[0-9'" ]*$
        ${ageExists}=   run keyword and return status    Dictionary Should Contain Key       ${athlete}[${item}]         age
        Run keyword if      ${ageExists}==${True}   Value should not be empty and match regex    ${athlete}[${item}][age]      \\d{2}
        ${dobExists}=   run keyword and return status    Dictionary Should Contain Key       ${athlete}[${item}]         dateOfBirth
        Run keyword if      ${dobExists}==${True}   Value should not be empty and match regex    ${athlete}[${item}][dateOfBirth]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}Z
        Run Keyword If    'jersey' in ${athlete}[${item}]      Value should not be empty and match regex    ${athlete}[${item}][jersey]      ^[0-9]*$
        Validate birthplace schema for sport     ${athlete}[${item}][birthPlace]
        Run Keyword If    'experience' in ${athlete}[${item}]      Validate experience schema for sport     ${athlete}[${item}][experience]
        Validate hand schema for hockey     ${athlete}[${item}][hand]
        IF  ${isStatistics}==${True}
            dictionary should contain key    ${athlete}[${item}]        statistics
            Validate statistics schema in Athletes for hockey       ${athlete}[${item}]
        ELSE
            dictionary should not contain key    ${athlete}[${item}]        statistics
        END
        END

Validate hand schema for hockey
        [Documentation]    Validating the birthplace schema in athlete for Plays football
        [Arguments]    ${hand}
        should contain any    ${hand}[type]         RIGHT   LEFT
        should contain any    ${hand}[abbreviation]         R   L
        should contain any    ${hand}[displayValue]         Right   Left
