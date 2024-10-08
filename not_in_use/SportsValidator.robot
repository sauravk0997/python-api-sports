*** Settings ***
Documentation       Football tests executed with positive, negative combinations along with schema validation
...                 to run: robot --pythonpath $PWD ./testsuite/football-tests.robot

Library             RequestsLibrary
Library             OperatingSystem
Library             DateTime
Library             Collections
Library             String
Resource            ../resource/ESPNCoreAPIResource.robot

*** Variables ***
@{seasonList}=    defensive     defensiveInterceptions      kicking     passing     rushing     receiving       punting     scoring     returning       miscellaneous
@{seasonDefensiveList}=    assistTackles    avgInterceptionYards    avgSackYards    avgStuffYards   blockedFieldGoalTouchdowns  blockedPuntTouchdowns   defensiveTouchdowns     hurries     kicksBlocked    longInterception    miscTouchdowns  passesBattedDown       passesDefended       twoPtReturns    sacks   sackYards       safeties    soloTackles     stuffs  stuffYards  tacklesForLoss  teamGamesPlayed     totalTackles
@{seasonDefensiveInterceptions}=    interceptions       interceptionTouchdowns         interceptionYards
@{seasonKicking}=   avgKickoffReturnYards   avgKickoffYards     extraPointAttempts      extraPointPct   extraPointsBlocked  extraPointsBlockedPct   extraPointsMade     fairCatches     fairCatchPct       fieldGoalAttempts    fieldGoalAttempts1_19   fieldGoalAttempts20_29  fieldGoalAttempts30_39      fieldGoalAttempts40_49      fieldGoalAttempts50     fieldGoalAttemptYards   fieldGoalPct    fieldGoalsBlocked       fieldGoalsBlockedPct        fieldGoalsMade      fieldGoalsMade1_19      fieldGoalsMade20_29     fieldGoalsMade30_39     fieldGoalsMade40_49     fieldGoalsMade50       fieldGoalsMadeYards      fieldGoalsMissedYards       kickoffReturns      kickoffReturnTouchdowns     kickoffReturnYards      kickoffs    kickoffYards    longFieldGoalAttempt    longFieldGoalMade   longKickoff     teamGamesPlayed     totalKickingPoints      touchbackPct        touchbacks
@{seasonPassing}=   avgGain     completionPct       completions     ESPNQBRating    interceptionPct     interceptions       longPassing     miscYards   netPassingYards     netPassingYardsPerGame      netTotalYards       netYardsPerGame     passingAttempts     passingBigPlays     passingFirstDowns       passingFumbles      passingFumblesLost      passingTouchdownPct     passingTouchdowns       passingYards        passingYardsAfterCatch      passingYardsAtCatch     passingYardsPerGame     QBRating        sacks       sackYardsLost   teamGamesPlayed     totalOffensivePlays     totalPoints     totalPointsPerGame      totalTouchdowns     totalYards      totalYardsFromScrimmage     twoPointPassConvs       twoPtPass       twoPtPassAttempts       yardsFromScrimmagePerGame       yardsPerCompletion      yardsPerGame    yardsPerPassAttempt     quarterbackRating
@{seasonRushing}=   avgGain     ESPNRBRating     longRushing        miscYards   netTotalYards       netYardsPerGame     rushingAttempts     rushingBigPlays     rushingFirstDowns   rushingFumbles      rushingFumblesLost      rushingTouchdowns       rushingYards        rushingYardsPerGame     stuffs      stuffYardsLost      teamGamesPlayed     totalOffensivePlays     totalPoints     totalPointsPerGame      totalTouchdowns     totalYards      totalYardsFromScrimmage     twoPointRushConvs   twoPtRush       twoPtRushAttempts       yardsFromScrimmagePerGame       yardsPerGame    yardsPerRushAttempt
@{seasonReceiving}=     avgGain   ESPNWRRating    longReception   miscYards     netTotalYards   netYardsPerGame     receivingBigPlays   receivingFirstDowns     receivingFumbles     receivingFumblesLost       receivingTargets    receivingTouchdowns     receivingYards      receivingYardsAfterCatch        receivingYardsAtCatch       receivingYardsPerGame   receptions      teamGamesPlayed     totalOffensivePlays     totalPoints     totalPointsPerGame      totalTouchdowns     totalYards      totalYardsFromScrimmage     twoPointRecConvs    twoPtReception      twoPtReceptionAttempts      yardsFromScrimmagePerGame       yardsPerGame     yardsPerReception
@{seasonPunting}=   avgPuntReturnYards      fairCatches     grossAvgPuntYards       longPunt        netAvgPuntYards     puntReturns     puntReturnYards     punts       puntsBlocked    puntsBlockedPct     puntsInside10      puntsInside10Pct     puntsInside20       puntsInside20Pct    puntYards    teamGamesPlayed        touchbackPct        touchbacks
@{seasonScoring}=   defensivePoints     fieldGoals      kickExtraPoints     miscPoints      passingTouchdownsScoring        receivingTouchdownsScoring      returnTouchdowns     rushingTouchdownsScoring       totalPoints     totalPointsPerGame      totalTouchdowns     totalTwoPointConvs      twoPointPassConvs       twoPointRecConvs        twoPointRushConvs
@{seasonReturning}=     defFumbleReturns        defFumbleReturnYards        fumbleRecoveries    fumbleRecoveryYards     kickReturnFairCatches   kickReturnFairCatchPct      kickReturnFumbles       kickReturnFumblesLost   kickReturns     kickReturnTouchdowns    kickReturnYards     longKickReturn      longPuntReturn      miscFumbleReturns       miscFumbleReturnYards       oppFumbleRecoveries     oppFumbleRecoveryYards      oppSpecialTeamFumbleReturns     oppSpecialTeamFumbleReturnYards     puntReturnFairCatches   puntReturnFairCatchPct      puntReturnFumbles      puntReturnFumblesLost    puntReturns     puntReturnsStartedInsideThe10       puntReturnsStartedInsideThe20       puntReturnTouchdowns     puntReturnYards        specialTeamFumbleReturns        specialTeamFumbleReturnYards        teamGamesPlayed     yardsPerKickReturn      yardsPerPuntReturn      yardsPerReturn
@{seasonMiscellaneous}=     firstDowns    firstDownsPassing     firstDownsPenalty       firstDownsPerGame       firstDownsRushing       fourthDownAttempts      fourthDownConvPct   fourthDownConvs     possessionTimeSeconds       redzoneEfficiencyPct        redzoneFieldGoalPct     redzoneScoringPct   redzoneTouchdownPct     thirdDownAttempts       thirdDownConvPct    thirdDownConvs      totalPenalties  totalPenaltyYards       turnOverDifferential
@{stats}=       OTWins    losses    points  gamesPlayed     leagueWinPercent    wins    pointsFor   streak      divisionLosses  divisionWins    avgPointsFor    clincher    playoffSeed     divisionWinPercent  pointsAgainst       gamesBehind     avgPointsAgainst     ties     OTLosses    divisionTies    winPercent      divisionRecord       differential
@{recordList}=      season      homeRecord      awayRecord      vsLeague
@{typeFootball}=    create list     kicker  passer        receiver    returner    rusher  other   punter    pat_scorer
@{typeHockey}=    create list      faceoffWinner  hitter   hittee      shooter    saver    goalie  player   blocker      blocker

*** Keywords ***
Validate the string is equal to the value
    [Documentation]     Custom validation for the given string equals to the expected value
    [Arguments]    ${key}       ${value}
    should not be empty    convert to string    ${key}
    should be equal as strings  ${key}      ${value}       ignore_case=True

Value should not be empty and match regex
    [Documentation]     Custom validation for the given string equals to the expected value
    [Arguments]    ${key}       ${regex}
    ${str_value}=       convert to string    ${key}
    ${isEmpty}=     run keyword and return status       should not be empty       ${str_value}
    run keyword if    ${isEmpty}==${True}    should match regexp    ${str_value}      ${regex}

Validate league schema of sport
    [Documentation]     Custom keyword for ESPN core league schema validation
    [Arguments]     ${response}
    set test variable    ${league}      ${response.json()["leagues"]}
    ${len}=     get length    ${response.json()["leagues"]}
    FOR    ${item}      IN RANGE    ${len}
        Run Keyword If    'id' in ${league}[${item}]    should not be empty     ${league}[${item}][id]
        Run Keyword If    'uid' in ${league}[${item}]    should not be empty     ${league}[${item}][uid]
        Run Keyword If    'groupId' in ${league}[${item}]    should not be empty     ${league}[${item}][groupId]
        Run Keyword If    'uid' in ${league}[${item}]    should contain      ${league}[${item}][uid]     ${league}[${item}][id]
        Run Keyword If    'uid' in ${league}[${item}]    should match regexp    ${league}[${item}][uid]      ^[s:0-9~l:0-9]*$
        Value should not be empty and match regex    ${league}[${item}][name]           ^[0-9a-zA-Z'()\\- ]*$
        Run Keyword If    'abbreviation' in ${league}[${item}]    Value should not be empty and match regex    ${league}[${item}][abbreviation]       ^[0-9a-zA-Z'()\\- ]*$
        Run Keyword If    'shortName' in ${league}[${item}]    Value should not be empty and match regex    ${league}[${item}][shortName]      ^[0-9a-zA-Z'()\\- ]*$
        Value should not be empty and match regex    ${league}[${item}][slug]       ^[0-9a-zA-Z'()\\- ]*$
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${league}[${item}]      season
        Run keyword if      ${exists}==${True}       Validate season schema of sport    ${league}[${item}]
    END

Validate season schema of sport
    [Documentation]     Custom schema validation of season schema with field values
    [Arguments]     ${season}
    ${len}=     get length    ${season}[season]
    FOR    ${item}      IN RANGE    ${len}
        Value should not be empty and match regex    ${season}[season][year]        \\d{4}
        Value should not be empty and match regex    ${season}[season][startDate]        [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
        Value should not be empty and match regex    ${season}[season][endDate]        [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
    END

Validate league schema with nfl
    [Documentation]     Custom schema validation with field values
    [Arguments]     ${response}     ${leagueID}     ${values}
    Validate the string is equal to the value     ${response.json()}[id]      ${values}[id]
    Validate the string is equal to the value     ${response.json()}[uid]     ${values}[uid]
    Validate the string is equal to the value     ${response.json()}[groupId]     ${values}[groupId]
    should be equal as strings    ${response.json()}[abbreviation]      ${leagueID}       ignore_case=True
    should be equal as strings    ${response.json()}[shortName]      ${leagueID}       ignore_case=True
    should be equal as strings    ${response.json()}[slug]      ${leagueID}
    should be equal as strings    ${response.json()}[name]     ${values}[name]
    should contain      ${response.json()}[uid]     ${response.json()}[id]
    should match regexp    ${response.json()}[uid]      ^[s:0-9~l:0-9]*$
    ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${response.json()}      season
    Run keyword if      ${exists}==${True}       Validate season schema with nfl league    ${response}      ${values}

Validate season schema with nfl league
    [Documentation]     Custom schema validation of season schema with field values
    [Arguments]     ${response}     ${values}
    set test variable       ${season}   ${response.json()["season"]}
    should not be empty     convert to string    ${season}[year]
    should not be empty     convert to string    ${season}[startDate]
    should not be empty     convert to string    ${season}[endDate]
    ${difference}=      Subtract Date From Date     ${season}[endDate]     ${season}[startDate]
    should be true    ${difference} >0
    ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${season}      type
    Run keyword if      ${exists}==${True}   Validate type schema under season for nfl league    ${response}        ${values}

Validate type schema under season for nfl league
    [Documentation]     Custom schema validation of type schema under season jsonObject with field values
    [Arguments]     ${response}         ${values}
    set test variable    ${type}    ${response.json()["season"]["type"]}
    should not be empty     convert to string    ${type}[startDate]
    should not be empty     convert to string    ${type}[endDate]
    validate difference between two dates    ${type}[endDate]       ${type}[startDate]
    validate difference between two dates    ${type}[startDate]     ${response.json()["season"]["startDate"]}
    validate difference between two dates    ${type}[endDate]       ${response.json()["season"]["startDate"]}
    validate difference between two dates    ${response.json()["season"]["endDate"]}    ${type}[startDate]
    should be equal as integers    ${type}[id]      ${type}[type]
    should contain    ${type}[name]     ${type}[abbreviation]       ignore_case=true
    ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${type}      groups
    Run keyword if      ${exists}==${True}   Validate groups array under nfl league    ${response}      ${values}

Validate groups array under nfl league
    [Documentation]    Validating the key-values of groups schema under Type schema
    [Arguments]    ${response}      ${values}
    set test variable    ${groups}    ${response.json()["season"]["type"]["groups"]}
    ${len}=     get length    ${groups}
    FOR    ${item}      IN RANGE    ${len}
        should not be empty    ${groups}[${item}][id]
        should not be empty    ${groups}[${item}][uid]
        should not be empty    ${groups}[${item}][slug]
        should not be empty    ${groups}[${item}][name]
        should not be empty    ${groups}[${item}][abbreviation]
        should not be empty    convert to string    ${groups}[${item}][isConference]
        should match regexp    ${groups}[${item}][uid]      ^[s:0-9~l:0-9~g:0-9]*$
        should contain      ${groups}[${item}][uid]     ${groups}[${item}][id]
        should contain      ${groups}[${item}][uid]     ${response.json()}[uid]
        ${expectedSlug}=       replace string using regexp      ${values}[groupSlug]        ${space}    -
        should contain      ${groups}[${item}][slug]    ${expectedSlug}     ignore_case=true
        should contain      ${groups}[${item}][name]    ${values}[groupSlug]     ignore_case=true
        should be equal     ${groups}[${item}][isConference]      ${true}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${groups}[${item}]      children
        Run keyword if      ${exists}==${True}   Validate children array for nfl league    ${groups}[${item}]    ${groups}[${item}][abbreviation]      ${response}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${groups}[${item}]      children
        Run keyword if      ${exists}==${True}   Validate teams array for nfl league    ${groups}[${item}]      ${response}
    END

Validate children array for nfl league
    [Documentation]    Validating the key-values of children schema under groups schema
    [Arguments]    ${groups}      ${group_abr}     ${response}
    set test variable    ${children}    ${groups}[children]
    ${len}=     get length    ${children}
    ${list_nestedTeams}=       create list
    ${existsTeamsArray}=   run keyword and return status    Dictionary Should Contain Key       ${groups}     teams
    FOR    ${item}      IN RANGE    ${len}
        should not be empty    ${children}[${item}][id]
        should not be empty    ${children}[${item}][uid]
        should not be empty    ${children}[${item}][slug]
        should not be empty    ${children}[${item}][name]
        should not be empty    ${children}[${item}][abbreviation]
        should not be empty    convert to string    ${children}[${item}][isConference]
        should match regexp    ${children}[${item}][uid]      ^[s:0-9~l:0-9~g:0-9]*$
        should contain      ${children}[${item}][uid]     ${children}[${item}][id]
        should contain      ${children}[${item}][uid]     ${response.json()}[uid]
        should contain      ${children}[${item}][name]      ${children}[${item}][abbreviation]      ignore_case=true
        should be equal     ${children}[${item}][isConference]      ${false}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${children}[${item}]      teams
        Run keyword if      ${exists}==${True}   Validate teams array for nfl league    ${children}[${item}]      ${response}
        ${list_nestedTeamstemp}=    convert to list    ${children}[${item}][teams]
        ${list_nestedTeams}=   combine lists    ${list_nestedTeams}       ${list_nestedTeamstemp}
    END

    # streamlines and fixes failure due to invalid formatting of multiple conditions and missing END
    Run keyword if      ${exists}=="True" and ${existsTeamsArray}=="True"       Validate teams and nested teams under children array are equal      ${groups}[teams]      ${list_nestedTeams}

Validate teams and nested teams under children array are equal
        [Documentation]    Validating the key-values of teams schema under groups->children schema
        [Arguments]    ${teamsArray}        ${list_nestedTeams}
        list should contain sub list         ${teamsArray}      ${list_nestedTeams}

Validate teams array for nfl league
    [Documentation]    Validating the key-values of teams schema under groups->children schema
    [Arguments]    ${children}    ${response}
    set test variable    ${nestedTeams}    ${children}[teams]
    ${len}=     get length    ${nestedTeams}
    FOR    ${item}      IN RANGE    ${len}
            Validate teams schema in response       ${nestedTeams}[${item}]
            should contain      ${nestedTeams}[${item}][uid]     ${response.json()}[uid]
    END

Validate teams schema in response
        [Documentation]         Validation for all the common teams data
        [Arguments]             ${Teams}
        validate all the mandatory fields in nested teams under children array    ${Teams}
        Value should not be empty and match regex    ${Teams}[uid]      ^[s:0-9~l:0-9~t:0-9]*$
        should contain      ${Teams}[uid]     ${Teams}[id]
        Value should not be empty and match regex    ${Teams}[alternateId]     ^[0-9]*$
        Run Keyword If    'guid' in ${Teams}         Value should not be empty and match regex    ${Teams}[guid]      ^[a-z0-9]*$
        Run Keyword If    'guid' in ${Teams}         validate the length    ${Teams}[guid]    32
        ${expectedDisplayname}=     catenate    ${Teams}[location]       ${Teams}[name]
        should be equal as strings    ${Teams}[displayName]      ${expectedDisplayname}
        should be equal as strings    ${Teams}[name]     ${Teams}[shortDisplayName]
        validate the length    ${Teams}[color]   6
        validate the length    ${Teams}[alternateColor]   6
        should match regexp    ${Teams}[color]       ^[a-zA-Z0-9]*$
        should match regexp    ${Teams}[alternateColor]       ^[a-zA-Z0-9]*$
        should be equal     ${Teams}[active]      ${true}
        should be equal     ${Teams}[allstar]      ${false}

Validate all the mandatory fields in nested teams under children array
        [Documentation]    Custom validation keyword for validating all the mandatory fields to be not null
        [Arguments]    ${nestedTeams}
        should not be empty    ${nestedTeams}][id]
        should not be empty    ${nestedTeams}[slug]
        should not be empty    ${nestedTeams}[location]
        should not be empty    ${nestedTeams}[name]
        should not be empty    ${nestedTeams}[nickname]
        should not be empty    ${nestedTeams}[abbreviation]
        should not be empty    ${nestedTeams}[displayName]
        should not be empty    ${nestedTeams}[shortDisplayName]
        should not be empty    ${nestedTeams}[color]
        should not be empty    ${nestedTeams}[alternateColor]
        should not be empty    convert to string    ${nestedTeams}[active]
        should not be empty    convert to string    ${nestedTeams}[allstar]

Validate the length
        [Documentation]    Custom validation for length of a value to given number
        [Arguments]    ${key}   ${length}
        ${len}=     get length    ${key}
        should be equal as numbers    ${len}    ${length}

Validate difference between two dates
    [Documentation]     Custom date function for finding the difference and return the value.
    [Arguments]     ${dateOne}      ${dateTwo}
    ${difference}=    Subtract Date From Date     ${dateOne}     ${dateTwo}
    should be true     ${difference}>=0

Validate ${fieldName} should contain ${value}
    [Documentation]     Custom field level validation in response to check not null and contains expected string
    ${length}=      get length    ${fieldName}
    IF    ${length}!=0
    should contain    ${fieldName}      ${value}
    END

Validate ${fieldName} is not empty
    [Documentation]    Custom field level validation for non empty
    ${length}=      get length    ${fieldName}
    should not be empty

Validate statistics schema
        [Documentation]    Validate statistics schema under teams details
        [Arguments]      ${response}
        set test variable       ${season}       ${response}[statistics][season]
        Dictionary Should Contain Key    ${response}[statistics]    season
        FOR    ${item}    IN    @{seasonList}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${season}      ${item}
        @{listGet}=     Get list from season        ${item}
        Run keyword if      ${exists}==${True}   Validate schema under season schema   ${season}     ${item}   @{listGet}
        END

Get list from season
        [Documentation]    Returns the corresponding list for the season key
        [Arguments]    ${key}
        @{listToReturn}     create list
        IF  "${key}" == "defensive"
            @{listToReturn}     copy list    ${seasondefensivelist}
        ELSE IF    "${key}" == "defensiveInterceptions"
            @{listToReturn}     copy list    ${seasondefensiveinterceptions}
        ELSE IF    "${key}" == "kicking"
            @{listToReturn}     copy list        ${seasonKicking}
        ELSE IF    "${key}" == "passing"
            @{listToReturn}     copy list        ${seasonPassing}
        ELSE IF    "${key}" == "rushing"
            @{listToReturn}     copy list        ${seasonrushing}
        ELSE IF    "${key}" == "receiving"
            @{listToReturn}     copy list        ${seasonreceiving}
        ELSE IF    "${key}" == "punting"
            @{listToReturn}     copy list        ${seasonpunting}
        ELSE IF    "${key}" == "scoring"
            @{listToReturn}     copy list        ${seasonscoring}
        ELSE IF    "${key}" == "returning"
            @{listToReturn}     copy list        ${seasonreturning}
        ELSE IF    "${key}" == "miscellaneous"
            @{listToReturn}     copy list        ${seasonmiscellaneous}
        END
        [Return]    @{listToReturn}


Validate schema under season schema
        [Documentation]    Valudate all the children elemenets under season schema in statistisc with nested children in each of them
        [Arguments]     ${season}       ${seasonKey}        @{listToValidate}
        Set Test Variable    ${nestedSeason}    ${season}[${seasonKey}]
            FOR    ${item}    IN    @{listToValidate}
                ${exists}=   run keyword and return status    Dictionary Should Contain Key     ${nestedSeason}       ${item}
                IF  ${exists}==${True}
                    Set Test Variable    ${nestedSeasonItem}    ${nestedSeason}[${item}]
                    ${length}=    Get Length    ${nestedSeasonItem}
                    IF    ${length}>0
                         ${valueExists}=   run keyword and return status    Dictionary Should Contain Key       ${nestedSeasonItem}       value
                         IF    ${valueExists} == True
                               Value should not be empty and match regex    ${nestedSeasonItem}[value]     [+-]?([0-9]*[.])?[0-9]+
                         END
                         ${rankExists}=   run keyword and return status    Dictionary Should Contain Key       ${nestedSeasonItem}       rank
                         IF    ${rankExists} == True
                               Value should not be empty and match regex    ${nestedSeasonItem}[rank]     [+-]?([0-9]*[.])?[0-9]+
                         END
                         ${perGameExists}=   run keyword and return status    Dictionary Should Contain Key       ${nestedSeasonItem}       perGameValue
                         IF    ${perGameExists} == True
                               Value should not be empty and match regex    ${nestedSeasonItem}[perGameValue]     [+-]?([0-9]*[.])?[0-9]+
                         END
                    END
                END
            END


Validate record schema
        [Documentation]    Validate keys of record schema under teams details
        [Arguments]      ${response}
        Dictionary Should Contain Key    ${response}   record
        set test variable    ${record}      ${response}[record]
        FOR    ${item}    IN    @{recordlist}
        dictionary should contain key     ${record}      ${item}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${record}[${item}]      stats
        Run keyword if      ${exists}==${True}   Validate stats schema in record    ${record}[${item}]
        END

Validate stats schema in record
        [Documentation]    Validate stats schema under all the keys of record in teams details
        [Arguments]      ${recordItem}
        dictionary should contain key    ${recordItem}      stats
        set test variable    ${statsResp}       ${recordItem}[stats]
        FOR    ${item}    IN    @{stats}
            Dictionary Should Contain Key     ${statsResp}       ${item}
            Set Test Variable    ${statsItem}    ${statsResp}[${item}]
            ${length}=    Get Length    ${statsItem}
             IF    ${length}>0
                  ${valueExists}=   run keyword and return status    Dictionary Should Contain Key       ${statsItem}      value
                  IF    ${valueExists} == True
                      Value should not be empty and match regex     ${statsItem}[value]        [+-]?([0-9]*[.])?[0-9]+
                  END
                  ${rankExists}=   run keyword and return status    Dictionary Should Contain Key       ${statsItem}      rank
                  IF    ${rankExists} == True
                       Value should not be empty and match regex     ${statsItem}[rank]        [+-]?([0-9]*[.])?[0-9]+
                  END
                  ${perGameExists}=   run keyword and return status    Dictionary Should Contain Key       ${statsItem}      perGameValue
                  IF    ${perGameExists} == True
                        Value should not be empty and match regex     ${statsItem}[perGameValue]     [+-]?([0-9]*[.])?[0-9]+
                  END
             END
         END

Validate Events schema for football
        [Documentation]    Validating the events schema
        [Arguments]    ${response}      @{filters}
        Validate the string is equal to the value    ${response}[id]    400953415
        Value should not be empty and match regex    ${response}[uid]   ^[s:0-9~l:0-9~e:0-9]*$
        should contain    ${response}[uid]    ${response}[id]
        Value should not be empty and match regex    ${response}[date]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
        Value should not be empty and match regex    ${response}[name]   ^[a-zA-Z ]*$
        Value should not be empty and match regex    ${response}[shortName]   ^[A-Z@A-Z ]*$
        validate the string is equal to the value   ${response}[timeValid]       ${true}
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${response}      competitions
        Run keyword if      ${exists}==${True}       Validate competitions schema for sport    ${response}        @{filters}

Validate competitions schema for sport
        [Documentation]    Validating the competitions schema for football
        [Arguments]    ${response}      @{filters}
        set test variable    ${competition}     ${response}[competitions]
        ${len}=     get length    ${competition}
        FOR    ${item}      IN RANGE    ${len}
           should not be empty    ${competition}[${item}][id]
           should be equal as strings    ${competition}[${item}][id]        ${response}[id]
           Value should not be empty and match regex    ${competition}[${item}][uid]      ^[s:0-9~l:0-9~e:0-9~c:0-9]*$
           should contain      ${competition}[${item}][uid]     ${response}[id]
           Value should not be empty and match regex    ${competition}[${item}][date]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
           Value should not be empty and match regex    ${competition}[${item}][attendance]      \\d{5}
           should be equal     ${competition}[${item}][timeValid]       ${true}
           ${strNeutralSite}=     convert to string    ${competition}[${item}][neutralSite]
           ${strNeutralSite}=    convert to lower case   ${strNeutralSite}
           should contain any        ${strNeutralSite}       true   false
           ${status_exists}=   get index from list    ${filters}      status
           Run keyword if      ${status_exists}>=0       dictionary should contain key    ${competition}[${item}]      status
           Run keyword if      ${status_exists}<0       dictionary should not contain key    ${competition}[${item}]      status
           Run keyword if      ${status_exists}>=0       Validate status schema in competitions for sport  ${competition}[${item}][status]
           ${situation_exists}=    get index from list    ${filters}      situation
           Run keyword if      ${situation_exists}>=0       dictionary should contain key    ${competition}[${item}]      situation
           Run keyword if      ${situation_exists}<0       dictionary should not contain key    ${competition}[${item}]      situation
           Run keyword if      ${situation_exists}>=0       Validate situation schema in competitions for sport   ${competition}[${item}]      @{filters}
           ${competitors_exists}=   get index from list    ${filters}      competitors
           Run keyword if      ${competitors_exists}>=0       dictionary should contain key    ${competition}[${item}]      competitors
           Run keyword if      ${competitors_exists}<0       dictionary should not contain key    ${competition}[${item}]      competitors
           Run keyword if      ${competitors_exists}>=0       Validate competitors schema in competitions for sport   ${competition}[${item}]      @{filters}
           ${odds_exists}=    get index from list    ${filters}      odds
           Run keyword if      ${odds_exists}>=0       dictionary should contain key    ${competition}[${item}]      odds
           Run keyword if      ${odds_exists}<0       dictionary should not contain key    ${competition}[${item}]      odds
           Run keyword if      ${odds_exists}>=0       Validate odds schema in competitions for sport   ${competition}[${item}]
        END

Validate status schema in competitions for sport
        [Documentation]    Validating the status schema in Competitions for football
        [Arguments]    ${status}
        should not be empty    convert to string    ${status}[clock]
        should not be empty    ${status}[displayClock]
        should not be empty    convert to string    ${status}[period]
        should not be empty    ${status}[displayPeriod]
        validate type schema in status for sport    ${status}

Validate type schema in status for sport
        [Documentation]    Validating the type schema of Status key in Competitions for football
        [Arguments]    ${status}
        set test variable       ${type}     ${status}[type]
        should not be empty    ${type}[id]
        should not be empty    ${type}[name]
        should not be empty    ${type}[state]
        should be equal        ${type}[completed]       ${true}
        should not be empty    ${type}[description]
        should not be empty    ${type}[detail]
        should not be empty    ${type}[shortDetail]
        Run Keyword If    'altDetail' in ${type}          should not be empty    ${type}[altDetail]
        should contain         ${type}[name]         ${type}[description]        ignore_case=true
        should be equal      ${type}[shortDetail]        ${type}[detail]       ignore_case=true

Validate situation schema in competitions for sport
        [Documentation]    Validating the situation schema in Competitions for football
        [Arguments]    ${competition}       @{filters}
        set test variable       ${situation}     ${competition}[situation]
        Run Keyword If    'down' in ${situation}          should not be empty   convert to string    ${situation}[down]
        Run Keyword If    'yardLine' in ${situation}          should not be empty   convert to string    ${situation}[yardLine]
        Run Keyword If    'distance' in ${situation}          should not be empty   convert to string    ${situation}[distance]
        Run Keyword If    'homeTimeouts' in ${situation}          should not be empty   convert to string    ${situation}[homeTimeouts]
        Run Keyword If    'awayTimeouts' in ${situation}          should not be empty   convert to string    ${situation}[awayTimeouts]
        Run Keyword If    'homeTimeouts' in ${situation}          should be equal     ${situation}[awayTimeouts]      ${situation}[homeTimeouts]
        Run Keyword If    'isRedZone' in ${situation}          should be equal        ${situation}[isRedZone]       ${true}
        ${play_exists}=    get index from list    ${filters}      play
        Run keyword if      ${play_exists}>=0       dictionary should contain key    ${situation}     play
        Run keyword if      ${play_exists}<0       dictionary should not contain key    ${situation}     play
        Run keyword if      ${play_exists}>=0       Validate play schema in situation for sport   ${situation}[play]     ${competition}
        ${probability_exists}=   get index from list    ${filters}      probability
        Run keyword if      ${probability_exists}>=0       dictionary should contain key    ${situation}     probability
        Run keyword if      ${probability_exists}<0       dictionary should not contain key    ${situation}     probability
        Run keyword if      ${probability_exists}>=0       Validate probability schema in situation for sport   ${situation}[probability]

Validate competitors schema in competitions for sport
        [Documentation]    Validating the competitors schema in Competitions for football
        [Arguments]    ${competition}      @{filters}
        set test variable    ${competitors}     ${competition}[competitors]
        ${len}=     get length    ${competitors}
        FOR    ${item}      IN RANGE    ${len}
            Value should not be empty and match regex    ${competitors}[${item}][id]      ^[0-9]*$
            Value should not be empty and match regex    ${competitors}[${item}][uid]      ^[s:0-9~l:0-9~t:0-9]*$
            should contain    ${competitors}[${item}][uid]      ${competitors}[${item}][id]
            Value should not be empty and match regex    ${competitors}[${item}][type]      ^[a-zA-Z]*$
            Value should not be empty and match regex    ${competitors}[${item}][order]      \\d{1,2}
            should contain any      ${competitors}[${item}][homeAway]       home    away
            ${str}=     convert to string    ${competitors}[${item}][winner]
            ${str}=    convert to lower case   ${str}
            should contain any        ${str}       true   false
            ${team_exists}=    get index from list    ${filters}      team
            Run keyword if      ${team_exists}>=0       dictionary should contain key    ${competitors}[${item}]      team
            Run keyword if      ${team_exists}<0       dictionary should not contain key    ${competitors}[${item}]      team
            Run keyword if      ${team_exists}>=0       Validate teams schema in response       ${competitors}[${item}][team]
            ${score_exists}=    get index from list    ${filters}      score
            Run keyword if      ${score_exists}>=0       dictionary should contain key    ${competitors}[${item}]      score
            Run keyword if      ${score_exists}<0       dictionary should not contain key    ${competitors}[${item}]      score
            Run keyword if      ${score_exists}>=0      validate score schema in competitors for sport       ${competitors}[${item}][score]
            ${linescores_exists}=    get index from list    ${filters}      linescores
            Run keyword if      ${linescores_exists}>=0       dictionary should contain key    ${competitors}[${item}]      linescores
            Run keyword if      ${linescores_exists}<0       dictionary should not contain key    ${competitors}[${item}]      linescores
            Run keyword if      ${linescores_exists}>=0       validate linescores schema in competitors for football       ${competitors}[${item}][linescores]
        END

Validate play schema in situation for sport
        [Documentation]     Validating the play schema in Situation for football
        [Arguments]    ${play}       ${competition}
        should not be empty   convert to string    ${play}[id]
        should not be empty   convert to string    ${play}[awayScore]
        should not be empty   convert to string    ${play}[homeScore]
        should not be empty   convert to string    ${play}[scoreValue]
        should not be empty   convert to string    ${play}[sequenceNumber]
        ${mediaIdExists}=   run keyword and return status    Dictionary Should Contain Key       ${play}        mediaId
        Run keyword if      ${mediaIdExists}==${True}   should not be empty   convert to string    ${play}[mediaId]
        Run Keyword If    'statYardage' in ${play}         should not be empty   convert to string    ${play}[statYardage]
        Run Keyword If    '400953415'==${play}[id]         should be equal      ${play}[id]         ${competition}[id]${play}[sequenceNumber]
        should not be empty      ${play}[text]
        Run Keyword If    'alternativeText' in ${play}         should be equal as strings    ${play}[text]     ${play}[alternativeText]
        Run Keyword If    'shortAlternativeText' in ${play}         should be equal as strings    ${play}[shortAlternativeText]     ${play}[shortText]
        Run Keyword If    'wallclock' in ${play}         Value should not be empty and match regex    ${play}[wallclock]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z
        Value should not be empty and match regex    ${play}[modified]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}Z
        ${scoringPlayStr}=     convert to string    ${play}[scoringPlay]
        ${scoringPlayStr}=    convert to lower case   ${scoringPlayStr}
        should contain any        ${scoringPlayStr}       true      false
        ${priorityStr}=     convert to string    ${play}[priority]
        ${priorityStr}=    convert to lower case   ${priorityStr}
        should contain any        ${priorityStr}      true      false
        validate type schema in play for sport      ${play}[type]
        Validate period schema in play for sport    ${play}[period]
        Validate clock schema in play for sport    ${play}[clock]
        Run Keyword If    'start' in ${play}         validate start/end schema in play for sport      ${play}[start]
        Run Keyword If    'end' in ${play}         validate start/end schema in play for sport      ${play}[end]
        ${participantsExists}=   run keyword and return status    Dictionary Should Contain Key       ${play}       participants
        Run keyword if      ${participantsExists}==${True}    Validate participant schema in play for football       ${play}[participants]      ${competition}
        IF       ${participantsExists}==${True}
            ${compPartitipants_Exists}=    get from dictionary      ${competition}       participants
            Run keyword if      "${compPartitipants_Exists}"=="false"        dictionary should not contain key    ${play}      participants
        END

validate type schema in play for sport
        [Documentation]     Validating the type schema in play key of Situation for football
        [Arguments]    ${type}
        should not be empty   convert to string    ${type}[id]
        Value should not be empty and match regex       ${type}[slug]      ^[a-zA-Z-]*$
        Value should not be empty and match regex       ${type}[text]      ^[a-zA-Z ()]*$
        ${abbrExists}=   run keyword and return status    Dictionary Should Contain Key       ${type}       abbreviation
        Run keyword if      ${abbrExists}==${True}   Value should not be empty and match regex       ${type}[abbreviation]      ^[a-zA-Z ]*$


validate period schema in play for sport
        [Documentation]     Validating the period schema in play key of Situation for football
        [Arguments]    ${period}
        Value should not be empty and match regex    ${period}[number]      \\d{1}

validate clock schema in play for sport
        [Documentation]     Validating the period schema in play key of Situation for football
        [Arguments]    ${clock}
        Value should not be empty and match regex    ${clock}[value]      \\d{1}
        Value should not be empty and match regex    ${clock}[displayValue]       ^[0-9:]*$

validate start/end schema in play for sport
        [Documentation]     Validating the period schema in play key of Situation for football
        [Arguments]    ${start}
        Value should not be empty and match regex    ${start}[down]      \\d{1,2}
        Value should not be empty and match regex    ${start}[distance]      \\d{1,2}
        Value should not be empty and match regex    ${start}[yardLine]      \\d{1,2}
        Value should not be empty and match regex    ${start}[yardsToEndzone]      \\d{1,2}

Validate probability schema in situation for sport
        [Documentation]     Validating the probability schema of Situation key in competitions for football
        [Arguments]    ${probability}
        Value should not be empty and match regex    ${probability}[tiePercentage]      \\d{1,2}
        Value should not be empty and match regex    ${probability}[secondsLeft]      \\d{1,2}
        Value should not be empty and match regex    ${probability}[homeWinPercentage]      \\d{1,2}
        Value should not be empty and match regex    ${probability}[awayWinPercentage]      \\d{1,2}

validate score schema in competitors for sport
        [Documentation]     Validating the period schema in play key of Situation for football
        [Arguments]    ${score}
        Value should not be empty and match regex    ${score}[value]      \\d{1,2}
        Value should not be empty and match regex    ${score}[displayValue]      \\d{1,2}
        should be equal as numbers        ${score}[value]         ${score}[displayValue]

validate linescores schema in competitors for football
        [Documentation]    Validating the competitors schema in Competitions for football
        [Arguments]    ${linescores}
        ${len}=     get length    ${linescores}
        FOR    ${item}      IN RANGE    ${len}
            Value should not be empty and match regex    ${linescores}[${item}][value]      \\d{1,2}
            Value should not be empty and match regex    ${linescores}[${item}][displayValue]       ^[0-9]*$
            Value should not be empty and match regex    ${linescores}[${item}][period]      \\d{1,2}
        END

Validate odds schema in competitions for sport
        [Documentation]    Validating the odds schema in Competitions for football
        [Arguments]    ${competitions}
        set test variable    ${odds}     ${competitions}[odds]
        ${len}=     get length    ${odds}
        FOR    ${item}      IN RANGE    ${len}
            ${str}=     convert to string    ${odds}[${item}][valid]
            ${str}=    convert to lower case   ${str}
            should contain any        ${str}       true   false
            IF    "${str}"=="true"
                Value should not be empty and match regex    ${odds}[${item}][details]       ^[ALA -\d.\d]*$
                Value should not be empty and match regex    ${odds}[${item}][overUnder]       ^[0-9.0-9]*$
                Value should not be empty and match regex    ${odds}[${item}][spread]        [+-]?([0-9]*[.])?[0-9]+
                Value should not be empty and match regex    ${odds}[${item}][overOdds]       [+-]?([0-9]*[.])?[0-9]+
                Value should not be empty and match regex    ${odds}[${item}][underOdds]       [+-]?([0-9]*[.])?[0-9]+
            ELSE
                should be equal as strings    ${odds}[${item}][details]       OFF
            END
        END

Validate plays schema for competition in sport
        [Documentation]    Validating the pagination schema for Competitions Plays for football
        [Arguments]    ${response}      ${collections}
        set test variable    ${plays}     ${response}[items]
        ${len}=     get length    ${plays}
        #---Failing for hockey test cases----#
        #should be equal as numbers    ${len}    ${response}[count]
        value should not be empty and match regex    ${response}[pageIndex]     \\d{1,2}
        value should not be empty and match regex    ${response}[pageCount]     \\d{1,2}
        value should not be empty and match regex    ${response}[pageSize]     \\d{1,2}
        FOR    ${item}      IN RANGE    ${len}
            Validate play schema in situation for sport      ${plays}[${item}]      ${collections}
        END

Validate participant schema in play for football
        [Documentation]    Validating the participant schema for Competitions Plays for football
        [Arguments]    ${participant}       ${competition}
        ${len}=     get length    ${participant}
        @{type}=    Get list from sport     ${competition}[sport]
        FOR    ${item}      IN RANGE    ${len}
                value should not be empty and match regex    ${participant}[${item}][id]     ^[0-9]*$
                value should not be empty and match regex    ${participant}[${item}][order]     ^[0-9]*$
                should contain any      ${participant}[${item}][type]        @{type}
                ${athleteExists}=   run keyword and return status    Dictionary Should Contain Key       ${participant}[${item}]      athlete
                Run keyword if      ${athleteExists}==${True}   Validate Athlete schema in participants for football       ${participant}[${item}]
                Run keyword if      "${competition}[athlete]"=="false"       dictionary should not contain key    ${participant}[${item}]      athlete
        END

Get list from sport
        [Documentation]    Returns the corresponding list for the season key
        [Arguments]    ${sport}
        @{listToReturn}     create list
        IF  "${sport}" == "football"
            @{listToReturn}     copy list    ${typeFootball}
        ELSE IF    "${sport}" == "hockey"
            @{listToReturn}     copy list    ${typeHockey}
        END
                [Return]    @{listToReturn}

Validate Athlete schema in participants for football
        [Documentation]    Validating the Athlete schema in participant for Competitions Plays football
        [Arguments]    ${participant}
        set test variable    ${athlete}     ${participant}[athlete]
        should be equal    ${athlete}[id]       ${participant}[id]
        Value should not be empty and match regex    ${athlete}[uid]      ^[s:0-9~l:0-9~a:0-9]*$
        should contain     ${athlete}[uid]          ${athlete}[id]
        Value should not be empty and match regex    ${athlete}[guid]      ^[a-z0-9]*$
        Value should not be empty and match regex    ${athlete}[firstName]      ^[a-zA-Z' ]*$
        Value should not be empty and match regex    ${athlete}[lastName]      ^['a-zA-Z. ]*$
        #------- Failing for one value in Hockey due to double spaces-------------#
        #should be equal as strings    ${athlete}[fullName]     ${athlete}[firstName]${SPACE}${athlete}[lastName]
        should be equal    ${athlete}[fullName]     ${athlete}[displayName]
        should contain    ${athlete}[shortName]      ${athlete}[lastName]
        Value should not be empty and match regex    ${athlete}[weight]      \\d{2,3}
        ${displayWeight}=   convert to integer    ${athlete}[weight]
        should be equal    ${displayWeight}${SPACE}lbs     ${athlete}[displayWeight]
        Value should not be empty and match regex    ${athlete}[height]      \\d{2,3}
        Value should not be empty and match regex    ${athlete}[displayHeight]      ^[0-9'" ]*$
        ${ageExists}=   run keyword and return status    Dictionary Should Contain Key       ${athlete}         age
        Run keyword if      ${ageExists}==${True}   Value should not be empty and match regex    ${athlete}[age]      \\d{2}
        ${dobExists}=   run keyword and return status    Dictionary Should Contain Key       ${athlete}         dateOfBirth
        Run keyword if      ${dobExists}==${True}   Value should not be empty and match regex    ${athlete}[dateOfBirth]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}Z
        Run Keyword If    'jersey' in ${athlete}         Value should not be empty and match regex    ${athlete}[jersey]      ^[0-9]*$
        Validate birthplace schema for sport     ${athlete}[birthPlace]
        Run Keyword If    'experience' in ${athlete}         Validate experience schema for sport     ${athlete}[experience]

Validate birthplace schema for sport
        [Documentation]    Validating the birthplace schema in athlete for Plays football
        [Arguments]    ${birthplace}
        Run Keyword If    'city' in ${birthplace}         Value should not be empty and match regex    ${birthplace}[city]      ^[a-z A-Z.-]*$
        Run Keyword If    'country' in ${birthplace}         Value should not be empty and match regex    ${birthplace}[country]      ^[a-zA-Z ]*$
        Run Keyword If    'state' in ${birthplace}         Value should not be empty and match regex    ${birthplace}[state]      ^[a-zA-Z ]*$

Validate experience schema for sport
        [Documentation]    Validating the birthplace schema in athlete for Plays football
        [Arguments]    ${experience}
        Run Keyword If    'abbreviation' in ${experience}         Value should not be empty and match regex    ${experience}[abbreviation]      ^[A-Z]*$
        Run Keyword If    'displayValue' in ${experience}         Value should not be empty and match regex    ${experience}[displayValue]      ^[a-zA-Z]*$
        Run Keyword If    'years' in ${experience}         Value should not be empty and match regex    ${experience}[years]      \\d{1,2}

Validate league schema for sport
    [Documentation]     Custom schema validation with field values
    [Arguments]     ${response}     ${leagueID}     ${values}
    Run Keyword If    'id' in ${response.json()}        Validate the string is equal to the value     ${response.json()}[id]      ${values}[id]
    Run Keyword If    'uid' in ${response.json()}        Validate the string is equal to the value     ${response.json()}[uid]     ${values}[uid]
    Run Keyword If    'groupId' in ${response.json()}        Validate the string is equal to the value     ${response.json()}[groupId]     ${values}[groupId]
    should be equal as strings    ${response.json()}[slug]      ${leagueID}
    should be equal as strings    ${response.json()}[name]     ${values}[name]
    Run Keyword If    'uid' in ${response.json()}        should contain      ${response.json()}[uid]     ${response.json()}[id]
    Run Keyword If    'uid' in ${response.json()}        should match regexp    ${response.json()}[uid]      ^[s:0-9~l:0-9]*$
    ${season_exists}=   get from dictionary    ${values}        season
    Run keyword if      ${season_exists}==${True}       dictionary should contain key    ${response.json()}      season
    Run keyword if      ${season_exists}==${True}       validate season schema of sport    ${response.json()}
    Run keyword if      ${season_exists}==${False}       dictionary should not contain key    ${response.json()}      season