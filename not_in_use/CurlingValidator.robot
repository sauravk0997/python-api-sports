*** Settings ***
Documentation       All Common robot utils/functions and variables with respect to
...                 ESPNSports API's are maintained here

Library             RequestsLibrary
Library             lib.validators.ESPNSportsCoreValidator
Library             OperatingSystem
Library             Collections
Library             DateTime
Resource            ../resource/ESPNCoreAPIResource.robot 

*** Variables ***
${API_BASE}=        https://sports.core.api.espnsb.com/v3/sports  # tests default to the sandbox environment
${cleanup}=         ${False}  # False is a built-in RF variable

*** Keywords ***
Validate Sports Schema of curling
    [Documentation]    Validating the key-values of Sports schema
    [Arguments]    ${response}  ${name}     ${slug}     ${id}   ${league_key_flag}
    Validate the value matches the regular expression    ${response}   id     ^\\d+$
    Validate the value matches the regular expression    ${response}   name      ^[a-zA-Z'()\\- ]*$
    Validate the value matches the regular expression    ${response}   slug      ^[a-zA-Z'()\\- ]*$
    Validate the string is equal to the value for the given key     ${response}  name  ${name}
    Validate the string is equal to the value for the given key     ${response}  slug  ${slug}
    Validate the string is equal to the value for the given key     ${response}  id  ${id}
    IF    ${league_key_flag}
        dictionary should contain key    ${response}   leagues
    ELSE
        dictionary should not contain key    ${response}   leagues
    END

Validate League Schema of curling
    [Documentation]     Validating the key-values of league schema
    [Arguments]    ${response}  ${league}   ${season_key_flag}
    ${len} =    get length    ${response}[${league}]

    FOR    ${iter}  IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[${league}][${iter}]   id     ^\\d+$
        Validate the value matches the regular expression  ${response}[${league}][${iter}]     name      ^[a-zA-Z'()\\- ]*$
        Validate the value matches the regular expression  ${response}[${league}][${iter}]     abbreviation      ^[a-zA-Z0-9]*$
        Validate the value matches the regular expression  ${response}[${league}][${iter}]     slug      ^[a-zA-Z'()\\- ]*$
        IF    ${season_key_flag}
            dictionary should contain key    ${response}[${league}][${iter}]   season
        ELSE
            dictionary should not contain key    ${response}[${league}][${iter}]   season
        END
    END

Validate Season Schema of curling
    [Documentation]     Validating the key-values of seasons schema under League
    [Arguments]    ${response}      ${season}   ${type_key_flag}
    ${len} =    get length    ${response}[leagues]

    FOR    ${iter}  IN RANGE    ${len}
        Validate the value matches the regular expression    ${response}[leagues][${iter}][${season}]    year          \\d{4}
        Validate the value matches the regular expression    ${response}[leagues][${iter}][${season}]    startDate      [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
        Validate the value matches the regular expression    ${response}[leagues][${iter}][${season}]    endDate        [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]+:[0-9]+Z
        Validate the difference of startDate and endDate    ${response}[leagues][${iter}][${season}]
        Validate the value matches the regular expression  ${response}[leagues][${iter}][${season}]     description      ^[0-9a-zA-Z'()\\- ]*$
        
        IF    ${type_key_flag}
            dictionary should contain key    ${response}[leagues][${iter}][${season}]    type
        ELSE
            dictionary should not contain key    ${response}[leagues][${iter}][${season}]   type
        END
    END