*** Settings ***
Documentation       Validator file for Rugby sport specific validations inheriting commonn sports validations

Library             RequestsLibrary
Library             OperatingSystem
Library             DateTime
Library             Collections
Library             String
Resource            ../resource/SportsValidator.robot


*** Variables ***
@{recordListRugby}=      triesBonus      OTWins      losses      points        bonusPoints       pointDifferential
...     leagueWinPercent    rank    wins    pointsFor   streak  avgPointsFor    triesAgainst    playoffSeed
...     pointsAgainst   gamesBehind     avgPointsAgainst    ties    OTLosses    losingBonus      byes   triesFor    winPercent



*** Keywords ***
Validate league schema for rugby
    [Documentation]     Custom schema validation with field values for rugby sport
    [Arguments]     ${response}     ${leagueID}     ${values}
    Run Keyword If    'id' in ${response.json()}        Validate the string is equal to the value     ${response.json()}[id]      ${values}[id]
    Run Keyword If    'uid' in ${response.json()}        Validate the string is equal to the value     ${response.json()}[uid]     ${values}[uid]
    Run Keyword If    'groupId' in ${response.json()}        Validate the string is equal to the value     ${response.json()}[groupId]     ${values}[groupId]
    should be equal as strings    ${response.json()}[slug]      ${leagueID}
    should be equal as strings    ${response.json()}[name]     ${values}[name]
    should be equal    ${response.json()}[isTournament]     ${False}
    should be equal    ${response.json()}[isClubCompetition]     ${False}
    Run Keyword If    'uid' in ${response.json()}        should contain      ${response.json()}[uid]     ${response.json()}[id]
    Run Keyword If    'uid' in ${response.json()}        should match regexp    ${response.json()}[uid]      ^[s:0-9~l:0-9]*$
    ${season_exists}=   get from dictionary    ${values}        season
    Run keyword if      ${season_exists}==${True}       dictionary should contain key    ${response.json()}      season
    Run keyword if      ${season_exists}==${True}       validate season schema of sport    ${response.json()}
    Run keyword if      ${season_exists}==${False}       dictionary should not contain key    ${response.json()}      season
    ${type_exists}=   get from dictionary    ${values}        type
    Run keyword if      ${season_exists}==${True} and ${type_exists}==${True}       dictionary should contain key    ${response.json()}[season]      type
    Run keyword if      ${season_exists}==${True} and ${type_exists}==${True}       Validate type schema under season for nrl league    ${response}    ${values}
    Run keyword if      ${season_exists}==${True} and ${type_exists}==${False}       dictionary should not contain key    ${response.json()}[season]      type

Validate type schema under season for nrl league
    [Documentation]     Custom schema validation of type schema under season jsonObject with field values for nrl league of rugby
    [Arguments]     ${response}     ${values}
    set test variable    ${type}    ${response.json()["season"]["type"]}
    should not be empty     convert to string    ${type}[startDate]
    should not be empty     convert to string    ${type}[endDate]
    validate difference between two dates    ${type}[endDate]       ${type}[startDate]
    validate difference between two dates    ${type}[startDate]     ${response.json()["season"]["startDate"]}
    validate difference between two dates    ${type}[endDate]       ${response.json()["season"]["startDate"]}
    validate difference between two dates    ${response.json()["season"]["endDate"]}    ${type}[startDate]
    should be equal as integers    ${type}[id]      ${type}[type]
    should contain    ${type}[name]     ${type}[abbreviation]       ignore_case=true
    should contain    ${type}[name]     ${type}[abbreviation]       ignore_case=true
    ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${type}      groups
    Run keyword if      ${exists}==${True}   Validate groups array under nrl league    ${response}      ${values}

Validate groups array under nrl league
    [Documentation]    Validating the key-values of groups schema under Type schema for nrl league of rubgy
    [Arguments]    ${response}      ${values}
    set test variable    ${groups}    ${response.json()["season"]["type"]["groups"]}
    ${len}=     get length    ${groups}
    FOR    ${item}      IN RANGE    ${len}
        should not be empty    ${groups}[${item}][id]
        should not be empty    ${groups}[${item}][uid]
        should not be empty    ${groups}[${item}][shortName]
        should not be empty    ${groups}[${item}][name]
        should not be empty    ${groups}[${item}][midsizeName]
        should not be empty    ${groups}[${item}][abbreviation]
        should match regexp    ${groups}[${item}][uid]      ^[s:0-9~l:0-9~g:0-9]*$
        should be equal as strings    ${groups}[${item}][shortName]     ${groups}[${item}][midsizeName]     ignore_case=true
        should be equal as strings    ${groups}[${item}][name]     ${values}[groupName]         ignore_case=true
        should be equal as strings    ${groups}[${item}][name]     ${groups}[${item}][midsizeName]      ignore_case=true
        should contain      ${groups}[${item}][uid]     ${groups}[${item}][id]
        should contain      ${groups}[${item}][uid]     ${response.json()}[uid]
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${groups}[${item}]      teams
        Run keyword if      ${exists}==${True}   Validate teams array for nrl league    ${groups}[${item}]
    END

Validate teams array for nrl league
    [Documentation]    Validating the key-values of groups schema under Type schema
    [Arguments]    ${groups}
    set test variable    ${teams}    ${groups}[teams]
    ${len}=     get length    ${teams}
    FOR    ${item}      IN RANGE    ${len}
        Validate teams scehma in rugby    ${teams}[${item}]
    END

Validate teams scehma in rugby
    [Documentation]    Validating the key-values of groups schema under Type schema
    [Arguments]    ${teams}
    should not be empty    ${teams}[id]
    should not be empty    ${teams}[uid]
    should not be empty    ${teams}[displayName]
    should not be empty    ${teams}[name]
    should not be empty    ${teams}[shortDisplayName]
    should not be empty    ${teams}[abbreviation]
    should match regexp    ${teams}[uid]      ^[s:0-9~t:0-9]*$
    should contain    ${teams}[uid]      ${teams}[id]
    should be equal as strings    ${teams}[displayName]     ${teams}[shortDisplayName]     ignore_case=true
    should be equal as strings    ${teams}[name]     ${teams}[shortDisplayName]      ignore_case=true
    should be equal     ${teams}[active]      ${true}
    should be equal     ${teams}[allstar]      ${false}
    should be equal     ${teams}[national]      ${false}

Validate record schema for rugby
        [Documentation]    Validate keys of record schema under teams details
        [Arguments]      ${response}
        Dictionary Should Contain Key    ${response}   record
        set test variable    ${overall}      ${response}[record][overall][stats]
        ${exists}=   run keyword and return status    Dictionary Should Contain Key       ${overall}      stats
        Run keyword if      ${exists}==${True}   Validate stats schema in record for rugby    ${overall}
#        END

Validate stats schema in record for rugby
        [Documentation]    Validate stats schema under all the keys of record in teams details
        [Arguments]      ${overall}
        set test variable    ${statsResp}       ${overall}[stats]
        FOR    ${item}    IN    @{recordListRugby}
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

Validate Athletes schema for rugby
        [Documentation]    Validating the Athlete schema in participant for Competitions Plays football
        [Arguments]    ${response}      ${isStatistics}
        set test variable    ${athlete}     ${response}[athletes]
        ${len}=     get length    ${athlete}
        FOR    ${item}      IN RANGE    ${len}
        Value should not be empty and match regex    ${athlete}[${item}][uid]      ^[s:0-9~l:0-9~a:0-9]*$
        should contain     ${athlete}[${item}][uid]          ${athlete}[${item}][id]
        Value should not be empty and match regex    ${athlete}[${item}][firstName]      ^[a-zA-Z' ]*$
        Value should not be empty and match regex    ${athlete}[${item}][lastName]      ^[a-zA-Z.' -]*$
        should be equal    ${athlete}[${item}][fullName]     ${athlete}[${item}][firstName]${SPACE}${athlete}[${item}][lastName]
        should be equal    ${athlete}[${item}][fullName]     ${athlete}[${item}][displayName]
        should contain    ${athlete}[${item}][shortName]      ${athlete}[${item}][lastName]
        ${weightExists}=   run keyword and return status    Dictionary Should Contain Key       ${athlete}[${item}]         weight
        IF  ${weightExists}==${True}
            Value should not be empty and match regex    ${athlete}[${item}][weight]      \\d
            ${displayWeight}=   convert to integer    ${athlete}[${item}][weight]
            should be equal    ${displayWeight}${SPACE}lbs     ${athlete}[${item}][displayWeight]
         END
        ${heightExists}=   run keyword and return status    Dictionary Should Contain Key       ${athlete}[${item}]         height
        IF  ${heightExists}==${True}
            Value should not be empty and match regex    ${athlete}[${item}][height]      \\d
            Value should not be empty and match regex    ${athlete}[${item}][displayHeight]      ^[0-9'" ]*$
        END
        ${dobExists}=   run keyword and return status    Dictionary Should Contain Key       ${athlete}[${item}]         dateOfBirth
        Run keyword if      ${dobExists}==${True}   Value should not be empty and match regex    ${athlete}[${item}][dateOfBirth]      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}Z
        Run Keyword If    'birthPlace' in ${athlete}[${item}]      Validate birthplace schema for sport     ${athlete}[${item}][birthPlace]
        IF  ${isStatistics}==${True}
            dictionary should contain key    ${athlete}[${item}]        statistics
        ELSE
            dictionary should not contain key    ${athlete}[${item}]        statistics
        END
        END
