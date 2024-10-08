*** Settings ***
Documentation       All Common robot utils/functions and variables with respect to
...                 ESPNSports API's are maintained here${\n}
...      *Author:*    `Ganapathi Reshma Rani`${\n}
...      *Date :*    `27-09-2022`${\n}

Library             RequestsLibrary
Library             OperatingSystem
Library             Collections
Library             DateTime

*** Variables ***
${API_BASE}=        https://sports.core.api.espnsb.com/v3/sports  # tests default to the sandbox environment
${cleanup}=         ${False}  # False is a built-in RF variable


${LEAGUES_FLAG_TRUE}                    True
${LEAGUES_FLAG_FALSE}                   False
${SEASONS_FLAG_TRUE}                    True
${SEASONS_FLAG_FALSE}                   False
${TYPE_FLAG_TRUE}                       True
${TYPE_FLAG_FALSE}                      False
${GROUPS_FLAG_TRUE}                     True
${GROUPS_FLAG_FALSE}                    False
${GROUPS_TEAMS_FLAG_TRUE}               True
${GROUPS_TEAMS_FLAG_FALSE}              False
${NESTED_GROUPS_FLAG_TRUE}              True
${NESTED_GROUPS_FLAG_FALSE}             False
${NESTED_GROUPS_TEAMS_FLAG_TRUE}        True
${NESTED_GROUPS_TEAMS_FLAG_FALSE}       False
${STATISTICS_FLAG_TRUE}                 True
${STATISTICS_FLAG_FALSE}                False
${RECORD_FLAG_TRUE}                     True
${RECORD_FLAG_FALSE}                    False
${ATHLETE_FLAG_TRUE}                    True
${ATHLETE_FLAG_FALSE}                   False
${ATHLETE_STATISTICS_FLAG_TRUE}         True
${ATHLETE_STATISTICS_FLAG_FALSE}        False

${STATUS_FLAG_TRUE}                     True
${STATUS_FLAG_FALSE}                    False
${SITUATION_FLAG_TRUE}                  True
${SITUATION_FLAG_FALSE}                 False
${SITUATION_PLAY_FLAG_TRUE}             True
${SITUATION_PLAY_FLAG_FALSE}            False
${SITUATION_PROBABILITY_FLAG_TRUE}      True
${SITUATION_PROBABILITY_FLAG_FALSE}     False
${COMPETITORS_FLAG_TRUE}                True
${COMPETITORS_FLAG_FALSE}               False
${COMPETITORS_TEAM_FLAG_TRUE}           True
${COMPETITORS_TEAM_FLAG_FALSE}          False
${COMPETITORS_SCORE_FLAG_TRUE}          True
${COMPETITORS_SCORE_FLAG_FALSE}         False
${COMPETITORS_LINESCORES_FLAG_TRUE}     True
${COMPETITORS_LINESCORES_FLAG_FALSE}    False
${ODDS_FLAG_TRUE}                       True
${ODDS_FLAG_FALSE}                      False
${PARTICIPANTS_FLAG_TRUE}               True
${PARTICIPANTS_FLAG_FALSE}              False

*** Keywords ***
A GET request to ${endpoint} should respond with ${status}
    [Documentation]     Custom GET keyword with status validation.
    ${api_response}=    GET  url=${endpoint}  expected_status=${status}
    [Return]    ${api_response}

Validate the string is equal to the value for the given key
    [Documentation]     Custom validation for the given string equals to the expected value
    [Arguments]    ${response}  ${key}  ${value}
    dictionary should contain key    ${response}   ${key}
    should not be empty    ${response}[${key}]
    should be equal as strings  ${response}[${key}]      ${value}

Validate ${fieldName} should be equal to ${value}
    [Documentation]     Custom field level validation in response to check not null and equal to expected string
    ${length}=      get length    ${fieldName}
    IF    ${length}!=0
    should be equal as strings    ${fieldName}      ${value}
    END

Validate the string is not empty
    [Documentation]     Custom validation for the given string equals to the expected value
    [Arguments]    ${response}       ${key}
    ${length}=      get length    ${response}[${key}]
    should be true    ${length}>0
Validate the value matches the regular expression
    [Documentation]     Custom validation for the given string matches to the given regrex value
    [Arguments]    ${response}  ${key}       ${regx}
    dictionary should contain key    ${response}   ${key}
    ${value}=   convert to string    ${response}[${key}]
    should not be empty    ${value}
    should match regexp  ${value}      ${regx}

Dump ${response} text to ${path}
    [Documentation]     Quick keyword to output a file from response object.
    create file    ${path}    ${response.text}

Cleanup ${path} ${recursively}
    [Documentation]     shortcut to rm -rf directory and contents as long as they aren't specifically the primary
    ...                 directories for the suite.
    @{path_list}=       Create List     lib  resources  testsuite  lib/  resources/  testsuite/
    should not contain  ${path_list}    ${path}  Uh oh! Your delete path includes a required directory.  ignore_case=True
    Remove Directory    ${path}         ${recursively}

Validate the difference of startDate and endDate
    [Documentation]     Custom validation to check the difference between startDate and endDate
    [Arguments]    ${response}
    ${difference}=    Subtract Date From Date   ${response["endDate"]}      ${response["startDate"]}
    should be true      ${difference} > 0

Validate uid
    [Documentation]     Custom validation for the given string uid equals to the expected value
    [Arguments]     ${league_uid}       ${id}    ${type}    ${actual_uid}
    ${expected_uid}=    set variable    ${league_uid}~${type}:${id}
    should be equal as strings    ${expected_uid}   ${actual_uid}

Validate Sports Schema
    [Documentation]    Validating the key-values of Sports schema
    [Arguments]    ${response}  ${name}     ${slug}     ${id}   ${uid}      ${guid}     ${league_key_flag}
    Validate the value matches the regular expression    ${response}   id     ^\\d+$
    Validate the value matches the regular expression    ${response}  uid  ^[s:0-9]*$
    Validate the value matches the regular expression    ${response}   name      ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression    ${response}   slug      ^[a-zA-Z'()\\- ]*$
    should end with    ${response}[uid]  ${response}[id]
    Validate the value matches the regular expression    ${response}   guid      ^[{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?$
    Validate the string is equal to the value for the given key     ${response}  name  ${name}
    Validate the string is equal to the value for the given key     ${response}  slug  ${slug}
    Validate the string is equal to the value for the given key     ${response}  id  ${id}
    Validate the string is equal to the value for the given key     ${response}  uid  ${uid}
    Validate the string is equal to the value for the given key     ${response}  guid  ${guid}
    IF    ${league_key_flag}
        dictionary should contain key    ${response}   leagues
    ELSE
        dictionary should not contain key    ${response}   leagues
    END

Validate League Schema
    [Documentation]     Validating the key-values of league schema
    [Arguments]    ${response}  ${league}   ${season_key_flag}
    ${len} =    get length    ${response}[${league}]

    FOR    ${iter}  IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${league}][${iter}]   id     ^\\d+$
        Validate the value matches the regular expression    ${response}[${league}][${iter}]  uid  ^[s:0-9~l:0-9]*$
        Validate the value matches the regular expression    ${response}[${league}][${iter}]   groupId     ^\\d+$
        Validate the value matches the regular expression  ${response}[${league}][${iter}]     name      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}[${league}][${iter}]     abbreviation      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'shortName' in ${response}[${league}][${iter}]
            ...     Validate the value matches the regular expression  ${response}[${league}][${iter}]     shortName      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'midsizeName' in ${response}[${league}][${iter}]
            ...     Validate the value matches the regular expression  ${response}[${league}][${iter}]     midsizeName      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}[${league}][${iter}]     slug      ^[a-zA-Z'()\\- ]*$
        IF    ${season_key_flag}
            dictionary should contain key    ${response}[${league}][${iter}]   season
            Validate the value matches the regular expression    ${response}[${league}][${iter}][season]    year          \\d{4}
            Validate the value matches the regular expression    ${response}[${league}][${iter}][season]    startDate      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
            Validate the value matches the regular expression    ${response}[${league}][${iter}][season]    endDate        [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
            Validate the difference of startDate and endDate    ${response}[${league}][${iter}][season]
            Run Keyword If    'description' in ${response}[${league}][${iter}][season]
            ...     Validate the value matches the regular expression  ${response}[${league}][${iter}][season]     description      ^[a-zA-Z'()\\- ]*$
        ELSE
            dictionary should not contain key    ${response}[${league}][${iter}]   season
        END
    END

Validate League Schema for the league
    [Documentation]     Validating the key-values of league schema  for the given league
    [Arguments]    ${response}  ${name}     ${slug}     ${id}   ${uid}  ${groupId}     ${season_key_flag}
    Validate the value matches the regular expression    ${response}   id     ^\\d+$
    Validate the value matches the regular expression    ${response}  uid  ^[s:0-9~l:0-9]*$
    should end with    ${response}[uid]  ${response}[id]
    Validate the value matches the regular expression    ${response}   groupId     ^\\d+$
    Validate the string is equal to the value for the given key     ${response}  name  ${name}
    Validate the string is equal to the value for the given key     ${response}  slug  ${slug}
    Validate the string is equal to the value for the given key     ${response}  id  ${id}
    Validate the string is equal to the value for the given key     ${response}  uid  ${uid}
    Validate the string is equal to the value for the given key     ${response}  groupId  ${groupId}
    Validate the value matches the regular expression  ${response}     name      ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression  ${response}     slug     ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression    ${response}  abbreviation      ^[a-zA-Z'()\\- ]*$
    Run Keyword If    'shortName' in ${response}
            ...     Validate the value matches the regular expression  ${response}     shortName      ^[a-zA-Z'()\\- ]*$
    Run Keyword If    'midsizeName' in ${response}
            ...     Validate the value matches the regular expression  ${response}    midsizeName      ^[a-zA-Z'()\\- ]*$
    IF    ${season_key_flag}
        dictionary should contain key    ${response}   season
    ELSE
        dictionary should not contain key    ${response}   season
    END

Validate Season Schema for given league
    [Documentation]     Validating the key-values of seasons schema under League
    [Arguments]    ${response}      ${season}   ${type_key_flag}
    Validate the value matches the regular expression    ${response}[${season}]    year          \\d{4}
    Validate the value matches the regular expression    ${response}[${season}]    startDate      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
    Validate the value matches the regular expression    ${response}[${season}]    endDate        [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
    Validate the difference of startDate and endDate    ${response}[${season}]
    IF    ${type_key_flag}
            dictionary should contain key    ${response}[${season}]   type
        ELSE
            dictionary should not contain key    ${response}[${season}]   type
    END
    Run Keyword If    'description' in ${response}[${season}]
    ...     Validate the value matches the regular expression    ${response}[${season}]  description      ^[a-zA-Z'()\\- ]*$

Validate type Schema under season
    [Documentation]     Validating the key-values of type schema under seasons schema
    [Arguments]    ${response}  ${season}     ${type}   ${groups_key_flag}
    Validate the value matches the regular expression    ${response}[${season}][${type}]   id     ^\\d+$
    Validate the value matches the regular expression    ${response}[${season}][${type}]   type     ^\\d+$
    Validate the value matches the regular expression    ${response}[${season}][${type}]  name      ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression    ${response}[${season}][${type}]  abbreviation      ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression    ${response}[${season}][${type}]    startDate      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
    Validate the value matches the regular expression    ${response}[${season}][${type}]    endDate        [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
    Validate the difference of startDate and endDate    ${response}[${season}][${type}]
    IF    ${groups_key_flag}
        dictionary should contain key    ${response}[${season}][${type}]   groups
    ELSE
        dictionary should not contain key    ${response}[${season}][${type}]   groups
    END

Validate Groups Schema under Type
    [Documentation]     Validating the key-values of groups schema under Type
    [Arguments]    ${response}  ${season}   ${type}     ${groups}   ${children_key_flag}    ${teams_key_flag}   ${nested_teams_key_flag}
    ${len}=     Get Length    ${response}[${season}][${type}][${groups}]
    FOR     ${iter}    IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]   id     ^\\d+$
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]  slug      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]  abbreviation      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'shortName' in ${response}[${season}][${type}][${groups}][${iter}]
            ...     Validate the value matches the regular expression  ${response}[${season}][${type}][${groups}][${iter}]     shortName      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'midsizeName' in ${response}[${season}][${type}][${groups}][${iter}]
            ...     Validate the value matches the regular expression  ${response}[${season}][${type}][${groups}][${iter}]   midsizeName      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'isConference' in ${response}[${season}][${type}][${groups}][${iter}]
            ...     should be true    ${response}[${season}][${type}][${groups}][${iter}][isConference] == True
        IF    ${children_key_flag}
            dictionary should contain key    ${response}[${season}][${type}][${groups}][${iter}]   children
            Run Keyword If    'children' in ${response}[${season}][${type}][${groups}][${iter}]
            ...     Validate childrens array        ${response}[${season}][${type}][${groups}][${iter}]    children     ${response}[uid]    ${nested_teams_key_flag}
        ELSE
            dictionary should not contain key    ${response}[${season}][${type}][${groups}][${iter}]   children
        END
        IF    ${teams_key_flag}
            dictionary should contain key    ${response}[${season}][${type}][${groups}][${iter}]   teams
            Run Keyword If    'teams' in ${response}[${season}][${type}][${groups}][${iter}]
            ...     Validate teams array    ${response}[${season}][${type}][${groups}][${iter}]    teams     ${response}[uid]
        ELSE
            dictionary should not contain key    ${response}[${season}][${type}][${groups}][${iter}]   teams
        END
        Validate the value matches the regular expression    ${response}[${season}][${type}][${groups}][${iter}]  uid  ^[s:0-9~l:0-9~g:0-9]*$
        Validate uid    ${response}[uid]    ${response}[${season}][${type}][${groups}][${iter}][id]  g     ${response}[${season}][${type}][${groups}][${iter}][uid]
    END

Validate childrens array
    [Documentation]    Validating the key-values of children schema under Groups
    [Arguments]    ${response}      ${children}     ${league_uid}   ${teams_key_flag}
    ${len}=     get length    ${response}[${children}]

    FOR    ${iter}      IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${children}][${iter}]   id     ^\\d+$
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  slug      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  name      ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  abbreviation      ^([0-9])|([a-z A-Z])*$
        Run Keyword If    'shortName' in ${response}
            ...     Validate the value matches the regular expression  ${response}     shortName      ^[a-zA-Z'()\\- ]*$
        Run Keyword If    'midsizeName' in ${response}
            ...     Validate the value matches the regular expression  ${response}    midsizeName      ^[a-zA-Z'()\\- ]*$

        Run Keyword If    'isConference' in ${response}[${children}][${iter}]
            ...     should be true    ${response}[${children}][${iter}][isConference] == False
        Run Keyword If    'children' in ${response}[${children}][${iter}]
            ...     Validate nested children array  ${response}[${children}][${iter}][children]

        IF    ${teams_key_flag}
            dictionary should contain key    ${response}[${children}][${iter}]   teams
            Run Keyword If    'teams' in ${response}[${children}][${iter}]
            ...     Validate teams array    ${response}[${children}][${iter}]    teams     ${league_uid}
        ELSE
            dictionary should not contain key    ${response}[${children}][${iter}]   teams
        END
        Validate the value matches the regular expression    ${response}[${children}][${iter}]  uid  ^[s:0-9~l:0-9~g:0-9]*$
        Validate uid    ${league_uid}    ${response}[${children}][${iter}][id]  g     ${response}[${children}][${iter}][uid]
    END

Validate teams array
    [Documentation]    Validating the key-value of teams schema under Groups and children
    [Arguments]    ${response}      ${teams}    ${league_uid}
    ${len}=     get length    ${response}[${teams}]

    FOR    ${iter}  IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${teams}][${iter}]    id    ^\\d+$
        Run Keyword If    'slug' in ${response}[${teams}][${iter}]
            ...     Validate the value matches the regular expression    ${response}[${teams}][${iter}]  slug      ^([0-9])|([a-z A-Z])*$
        Run Keyword If    'name' in ${response}[${teams}][${iter}]
            ...     Validate the value matches the regular expression    ${response}[${teams}][${iter}]  name      ^([0-9])|([a-z A-Z])*$

        Validate the value matches the regular expression    ${response}[${teams}][${iter}]  abbreviation      ^[ A-Za-z0-9_@./#&+-]*$
        Validate the value matches the regular expression    ${response}[${teams}][${iter}]  shortDisplayName      ^([0-9])|([a-z A-Z])*$

        Validate the value matches the regular expression    ${response}[${teams}][${iter}]  uid  ^[s:0-9~l:0-9~t:0-9]*$
        Validate uid    ${league_uid}    ${response}[${teams}][${iter}][id]  t     ${response}[${teams}][${iter}][uid]
    END

Validate teams data from groups and nested groups are equal
    [Documentation]    Validating the teams from groups is equal to the teams data present in nested groups
    [Arguments]    ${response}
    ${groups_len}=     Get Length    ${response}[season][type][groups]

    FOR     ${groups_iter}    IN RANGE    ${groups_len}

        set test variable   ${teams_list}       ${response}[season][type][groups][${groups_iter}][teams]

        ${child_len}=     get length    ${response}[season][type][groups][${groups_iter}][children]
        ${teams_len} =   get length    ${teams_list}

        FOR    ${child_iter}      IN RANGE    ${child_len}

            ${child_teams_len}=     get length    ${response}[season][type][groups][${groups_iter}][children][${child_iter}][teams]

            FOR    ${child_teams_iter}     IN RANGE    ${child_teams_len}
                should contain    ${teams_list}     ${response}[season][type][groups][${groups_iter}][children][${child_iter}][teams][${child_teams_iter}]
                FOR    ${teams_list_iter}  IN    ${teams_len}
                    Remove Values From List    ${teams_list}    ${response}[season][type][groups][${groups_iter}][children][${child_iter}][teams][${child_teams_iter}]
                END
            END
        END
        should be empty    ${teams_list}
    END

Validate Event Schema for the event
    [Documentation]     Validating the key-values of event schema  for the given event
    [Arguments]    ${response}  ${id}   ${uid}  ${name}     ${shortName}   ${competitions_key_flag}
    Validate the value matches the regular expression    ${response}    id      ^\\d+$
    Validate the value matches the regular expression    ${response}    uid     ^[s:0-9~l:0-9~e:0-9]*$
    Validate the value matches the regular expression    ${response}    date    [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
    Validate the value matches the regular expression    ${response}    name    ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression    ${response}    shortName     ^[a-zA-Z '()\\\-\\S]*$
    Validate the string is equal to the value for the given key     ${response}  id  ${id}
    Validate the string is equal to the value for the given key     ${response}  uid  ${uid}
    should end with    ${response}[uid]  ${response}[id]
    Validate the string is equal to the value for the given key     ${response}  name  ${name}
    Validate the string is equal to the value for the given key     ${response}  shortName  ${shortName}
    Run Keyword If    'timeValid' in ${response}
            ...     should be true    ${response}[timeValid] == True
    IF    ${competitions_key_flag}
        dictionary should contain key    ${response}   competitions
    ELSE
        dictionary should not contain key    ${response}   competitions
    END

Validate competitions schema for the given event
    [Documentation]     Validating the key-values of competitions schema for the given event
    [Arguments]     ${response}  ${odds_key_flag}    ${status_key_flag}      ${situation_key_flag}
    ...     ${competitors_key_flag}

    ${competitions_len} =    get length    ${response}[competitions]

    FOR    ${citer}  IN RANGE    ${competitions_len}
        Validate the value matches the regular expression    ${response}[competitions][${citer}]    id      ^\\d+$
        Validate the value matches the regular expression    ${response}[competitions][${citer}]    uid      ^[s:0-9~l:0-9~e:0-9~c:0-9]*$
        Validate the value matches the regular expression    ${response}[competitions][${citer}]    date    [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
        IF    ${status_key_flag}
            dictionary should contain key    ${response}[competitions][${citer}]   status
        ELSE
            dictionary should not contain key    ${response}[competitions][${citer}]   status
        END
        IF    ${situation_key_flag}
            dictionary should contain key    ${response}[competitions][${citer}]   situation
        ELSE
            dictionary should not contain key    ${response}[competitions][${citer}]   situation
        END
        IF    ${competitors_key_flag}
            dictionary should contain key    ${response}[competitions][${citer}]   competitors
        ELSE
            dictionary should not contain key    ${response}[competitions][${citer}]   competitors
        END
        IF    ${odds_key_flag}
            dictionary should contain key    ${response}[competitions][${citer}]   odds
        ELSE
            dictionary should not contain key    ${response}[competitions][${citer}]   odds
        END
        Run Keyword If    'type' in ${response}[competitions][${citer}]
        ...     Validate type schema under competitions     ${response}[competitions][${citer}][type]
    END

Validate type schema under competitions
    [Documentation]     Validating the key-values of type schema for the given event under competitions
    [Arguments]     ${response}

    Validate the value matches the regular expression       ${response}    slug    ^[a-zA-Z '()\\\-\\S]*$
    Validate the value matches the regular expression       ${response}    text    ^[a-zA-Z '()\\\-\\S]*$

Validate status schema under competitions key
    [Documentation]     Validating the key-values of status schema for the given event under competitions
    [Arguments]     ${response}  ${competitiors_key}    ${status_key}

    ${competitions_len} =    get length    ${response}[${competitiors_key}]

    FOR    ${citer}  IN RANGE    ${competitions_len}

        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}]    period     ^\\d+$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}]    displayPeriod     ^([0-9])|([a-z A-Z])*$
        dictionary should contain key   ${response}[${competitiors_key}][${citer}][${status_key}]    type
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}][type]    id     ^\\d+$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}][type]    name     ^[a-zA-Z '()\\\-\\S]*$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}][type]    state     ^[a-zA-Z '()\\\-\\S]*$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}][type]    description     ^[a-zA-Z '()\\\-\\S]*$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}][type]    detail     ^[a-zA-Z '()\\\-\\S]*$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${status_key}][type]    shortDetail     ^[a-zA-Z '()\\\-\\S]*$
    END

Validate situation schema under competitions key
    [Documentation]     Validating the key-values of situation schema for the given event under competitions
    [Arguments]     ${response}  ${competitiors_key}    ${situation_key}   ${situation_play_key_flag}   ${situation_probability_key_flag}

    ${competitions_len} =    get length    ${response}[${competitiors_key}]

    FOR    ${citer}  IN RANGE    ${competitions_len}
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${situation_key}]    balls     ^\\d+$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${situation_key}]    strikes     ^\\d+$
        Validate the value matches the regular expression
        ...     ${response}[${competitiors_key}][${citer}][${situation_key}]    outs     ^\\d+$
        IF  ${situation_play_key_flag}
            dictionary should contain key    ${response}[${competitiors_key}][${citer}][${situation_key}]    play
            Validate the play schema under situation schema    ${response}[${competitiors_key}][${citer}][${situation_key}][play]
        END

        IF  ${situation_probability_key_flag}
            dictionary should contain key    ${response}[${competitiors_key}][${citer}][${situation_key}]    probability
        ELSE
            dictionary should not contain key    ${response}[${competitiors_key}][${citer}][${situation_key}]    probability
        END
    END

Validate the play schema under situation schema
    [Documentation]     Validating the key-values of play schema for the given event under situation
    [Arguments]     ${response}

    Validate the value matches the regular expression   ${response}     id  ^\\d+$
    Validate the value matches the regular expression   ${response}     sequenceNumber  ^\\d+$
    Validate the value matches the regular expression   ${response}     text  ^([0-9])|([a-z A-Z])*$
    Validate the value matches the regular expression   ${response}     alternativeText  ^([0-9])|([a-z A-Z])*$
    Validate the value matches the regular expression   ${response}     shortAlternativeText  ^([0-9])|([a-z A-Z])*$
    Validate the value matches the regular expression   ${response}     awayScore  ^\\d+$
    Validate the value matches the regular expression   ${response}     homeScore  ^\\d+$
    Run Keyword If    'period' in ${response}
            ...     Validate period schema  ${response}[period]

    Validate the value matches the regular expression   ${response}     scoreValue  ^\\d+$
    Validate the value matches the regular expression   ${response}     modified  [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
    Run Keyword If    'pitchCount' in ${response}
            ...     Validate count schema  ${response}[pitchCount]
    Run Keyword If    'resultCount' in ${response}
            ...     Validate count schema  ${response}[resultCount]

Validate period schema
    [Documentation]     Validating the key-values of period schema for the given event under situation
    [Arguments]     ${response}

    Validate the value matches the regular expression   ${response}     type  ^([0-9])|([a-z A-Z])*$
    Validate the value matches the regular expression   ${response}     number  ^\\d+$

Validate count schema
    [Documentation]     Validating the key-values of count schema for the given event under situation
    [Arguments]     ${response}

    Validate the value matches the regular expression   ${response}    balls     ^\\d+$
    Validate the value matches the regular expression   ${response}    strikes     ^\\d+$

Validate competitors schema under competitions key
    [Documentation]     Validating the key-values of competitors schema for the given event under competions
    [Arguments]     ${response}     ${competitions_key}     ${competitors_key}
    ...     ${competitors_team_key_flag}    ${competitors_score_key_flag}   ${competitors_linescrores_key_flag}

    ${competitions_len} =    get length    ${response}[${competitions_key}]

    FOR    ${citer}  IN RANGE    ${competitions_len}
        dictionary should contain key    ${response}[${competitions_key}][${citer}]     ${competitors_key}
        ${competitors_len} =    get length    ${response}[${competitions_key}][${citer}][${competitors_key}]
        FOR    ${comp_iter}   IN RANGE    ${competitors_len}
            Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]    id     ^\\d+$
            Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]    uid    ^[s:0-9~l:0-9~t:0-9]*$
            Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]    type   ^([0-9])|([a-z A-Z])*$
            Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]    order  ^\\d+$
            Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]    homeAway   ^[a-zA-Z '()\\\-\\S]*$

            IF    ${competitors_team_key_flag}
                dictionary should contain key
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]     team
                Validate the team schema under competitors
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}][team]
            ELSE
                dictionary should not contain key
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]     team
            END

            IF    ${competitors_score_key_flag}
                dictionary should contain key
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]     score
                Validate the score schema under competitors
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}][score]
            ELSE
                dictionary should not contain key
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]     score
            END

            IF    ${competitors_linescrores_key_flag}
                dictionary should contain key
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]     linescores
                Validate the linescores schema under competitors
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}][linescores]
            ELSE
                dictionary should not contain key
                ...     ${response}[${competitions_key}][${citer}][${competitors_key}][${comp_iter}]     linescores
            END
        END
    END

Validate the team schema under competitors
    [Documentation]     Validating the key-values of team schema for the given event under competitors
    [Arguments]     ${response}

    Validate the value matches the regular expression   ${response}    id     ^\\d+$
    Validate the value matches the regular expression   ${response}    uid     ^[s:0-9~l:0-9~t:0-9]*$
    Validate the value matches the regular expression   ${response}    guid    ([a-zA-Z]+([0-9]+[a-zA-Z]+)+)
    Validate the value matches the regular expression   ${response}    alternateId     ^\\d+$
    Validate the value matches the regular expression   ${response}    slug     ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression   ${response}    location     ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression   ${response}    name     ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression   ${response}    abbreviation     ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression   ${response}    displayName     ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression   ${response}    shortDisplayName     ^[a-zA-Z'()\\- ]*$

Validate the score schema under competitors
    [Documentation]     Validating the key-values of score schema for the given event under competitors
    [Arguments]     ${response}
    Validate the value matches the regular expression   ${response}    value     ^[-+]?[0-9]*\.?[0-9]*$
    Run Keyword If    'displayValue' in ${response}
        ...     Validate the value matches the regular expression   ${response}    displayValue     ^\\d+$
    Run Keyword If    'hits' in ${response}
        ...     Validate the value matches the regular expression   ${response}    hits     ^\\d+$
    Run Keyword If    'errors' in ${response}
        ...     Validate the value matches the regular expression   ${response}    errors     ^\\d+$

Validate the linescores schema under competitors
    [Documentation]     Validating the key-values of linescores schema for the given event under competitors
    [Arguments]     ${response}
    ${len} =    get length    ${response}

    FOR    ${iter}  IN RANGE    ${len}
        Run Keyword If    'value' in ${response}
        ...     Validate the value matches the regular expression   ${response}    value     ^[-+]?[0-9]*\.?[0-9]*$
        Run Keyword If    'displayValue' in ${response}
        ...     Validate the value matches the regular expression   ${response}    displayValue     ^\\d+$
        Run Keyword If    'period' in ${response}
        ...     Validate the value matches the regular expression   ${response}    period      ^[-+]?[0-9]*\.?[0-9]*$
        Run Keyword If    'hits' in ${response}
        ...     Validate the value matches the regular expression   ${response}    hits     ^\\d+$
        Run Keyword If    'errors' in ${response}
        ...     Validate the value matches the regular expression   ${response}    errors     ^\\d+$
    END

Validate odds schema under competitions key
    [Documentation]     Validating the key-values of odds schema for the given event under competitions
    [Arguments]     ${response}     ${competitions_key}     ${odds_key}

    ${len} =    get length    ${response}[${competitions_key}]

    FOR    ${iter}  IN RANGE    ${len}
        ${odds_len} =   get length    ${response}[${competitions_key}][${iter}][${odds_key}]

        FOR    ${odds_iter}     IN RANGE    ${odds_len}
            Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    details    ^[a-zA-Z '()\\\-\\S]*$
            Run Keyword If    'overUnder' in ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]
            ...     Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    overUnder    ^[-+]?[0-9]*\.?[0-9]*$
            Run Keyword If    'spread' in ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]
            ...     Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    spread    ^[-+]?[0-9]*\.?[0-9]*$
            Run Keyword If    'initialSpread' in ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]
            ...     Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    initialSpread    ^[-+]?[0-9]*\.?[0-9]*$
            Run Keyword If    'initialOverUnder' in ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]
            ...     Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    initialOverUnder    ^[-+]?[0-9]*\.?[0-9]*$
            Run Keyword If    'price' in ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]
            ...     Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    price    ^[-+]?[0-9]*\.?[0-9]*$
            Run Keyword If    'overOdds' in ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]
            ...     Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    overOdds    ^[-+]?[0-9]*\.?[0-9]*$
            Run Keyword If    'underOdds' in ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]
            ...     Validate the value matches the regular expression
            ...     ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]    underOdds    ^[-+]?[0-9]*\.?[0-9]*$
            dictionary should contain key    ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]   awayTeamOdds
            dictionary should contain key    ${response}[${competitions_key}][${iter}][${odds_key}][${odds_iter}]   homeTeamOdds
        END
    END

Validate nested children array
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
    END

Validate plays schema
    [Documentation]    Validating the key-values of plays schema
    [Arguments]    ${response}  ${participants_key}     ${athelets_key}
    Validate the value matches the regular expression    ${response}    count   ^\\d+$
    Run Keyword If    'pageIndex' in ${response}
        ...     Validate the value matches the regular expression    ${response}    pageIndex   ^\\d+$
    Run Keyword If    'pageSize' in ${response}
        ...     Validate the value matches the regular expression    ${response}    pageSize   ^\\d+$
    Run Keyword If    'pageCount' in ${response}
        ...     Validate the value matches the regular expression    ${response}    pageCount   ^\\d+$

    ${len}=     get length    ${response}[items]
    FOR    ${iter}  IN RANGE    ${len}
        Validate the value matches the regular expression   ${response}[items][${iter}]   id  ^\\d+$
        Validate the value matches the regular expression   ${response}[items][${iter}]   sequenceNumber  ^\\d+$
        Run Keyword If    'type' in ${response}[items][${iter}]
            ...     Validate type play schema   ${response}[items][${iter}][type]
        Run Keyword If    'text' in ${response}[items][${iter}]
            ...     Validate the value matches the regular expression    ${response}[items][${iter}]    text   ^([0-9])|([a-z A-Z])*$
        Run Keyword If    'text' in ${response}[items][${iter}]
            ...     Validate the value matches the regular expression    ${response}[items][${iter}]    alternativeText   ^([0-9])|([a-z A-Z])*$
        Run Keyword If    'text' in ${response}[items][${iter}]
            ...     Validate the value matches the regular expression    ${response}[items][${iter}]    shortAlternativeText   ^([0-9])|([a-z A-Z])*$
        Validate the value matches the regular expression    ${response}[items][${iter}]    awayScore   ^\\d+$
        Validate the value matches the regular expression    ${response}[items][${iter}]    homeScore   ^\\d+$
        dictionary should contain key    ${response}[items][${iter}]    period
        Run Keyword If    'type' in ${response}[items][${iter}][period]
            ...     Validate the value matches the regular expression    ${response}[items][${iter}][period]    type   ^([0-9])|([a-z A-Z])*$

        Validate the value matches the regular expression    ${response}[items][${iter}][period]    number   ^\\d+$
        Validate the value matches the regular expression    ${response}[items][${iter}]    modified   [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z

        Run Keyword If    'pitchCount' in ${response}[items][${iter}]
            ...     Validate count schema   ${response}[items][${iter}][pitchCount]
        Run Keyword If    'resultCount' in ${response}[items][${iter}]
            ...     Validate count schema   ${response}[items][${iter}][resultCount]
        IF    ${participants_key}
            Run Keyword If    'participants' in ${response}[items][${iter}]
                ...     Validate participants schema   ${response}[items][${iter}][participants]    ${athelets_key}
        ELSE
            dictionary should not contain key   ${response}[items][${iter}]     participants
        END
    END

Validate participants schema
    [Documentation]    Validating the key-values of participants schema under play schema
    [Arguments]    ${response}      ${athelets_key}
    ${len} =    get length    ${response}

    FOR    ${iter}  IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${iter}]    id   ^\\d+$
        Validate the value matches the regular expression    ${response}[${iter}]    order   ^\\d+$
        Run Keyword If    'type' in ${response}[${iter}]
            ...     Validate the value matches the regular expression    ${response}[${iter}]    type   ^([0-9])|([a-z A-Z])*$
        IF    ${athelets_key}
            Run Keyword If    'athlete' in ${response}[${iter}]
                ...     Validate the athlete schema     ${response}[${iter}][athlete]
        ELSE
            dictionary should not contain key    ${response}[${iter}]   athlete
        END
    END

Validate the athlete schema
    [Documentation]    Validating the key-values of athlete schema under play schema
    [Arguments]    ${response}

    Validate the value matches the regular expression    ${response}    id   ^\\d+$
    Validate the value matches the regular expression    ${response}    firstName   ^([0-9])|([a-z A-Z])*$
    Validate the value matches the regular expression    ${response}    displayName   ^([0-9])|([a-z A-Z])*$
    Validate the value matches the regular expression    ${response}    shortName   ^([0-9])|([a-z A-Z])*$
    Run Keyword If    'uid' in ${response}
            ...     Validate the value matches the regular expression    ${response}    uid   ^[s:0-9~l:0-9~a:0-9]*$
    Run Keyword If    'lastName' in ${response}
            ...     Validate the value matches the regular expression    ${response}    lastName   ^([0-9])|([a-z A-Z])*$
    Run Keyword If    'fullName' in ${response}
            ...     Validate the value matches the regular expression    ${response}    fullName   ^([0-9])|([a-z A-Z])*$
    Run Keyword If    'displayName' in ${response}
            ...     Validate the value matches the regular expression    ${response}    displayName   ^([0-9])|([a-z A-Z])*$
    Run Keyword If    'shortName' in ${response}
            ...     Validate the value matches the regular expression    ${response}    shortName   ^([0-9])|([a-z A-Z])*$
    Run Keyword If    'weight' in ${response}
            ...     Validate the value matches the regular expression    ${response}    weight   ^[0-9]*\.[0-9]$
    Run Keyword If    'displayWeight' in ${response}
            ...     Validate the value matches the regular expression    ${response}    displayWeight   ^([0-9])|([a-z A-Z])*$
    Run Keyword If    'dateOfBirth' in ${response}
            ...     Validate the value matches the regular expression    ${response}    dateOfBirth   [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z

Validate type play schema
    [Documentation]    Validating the key-values of type schema under play schema
    [Arguments]    ${response}

    Validate the value matches the regular expression    ${response}    id   ^\\d+$
    Validate the value matches the regular expression    ${response}    slug   ^([0-9])|([a-z A-Z])*$
    Validate the value matches the regular expression    ${response}    text   ^([0-9])|([a-z A-Z])*$