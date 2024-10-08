#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
import logging
import string
import re
from types import NoneType

import requests
from robot.api.deco import keyword, library
from robot.api.exceptions import Failure
from lib.schemas.SoccerSportSchema import *

"""
*Author:* `Ganapathi Reshma Rani`\n
*Date :* `27-09-2022`\n
*Description:* JSON validation for ESPN Sports Core API for a sport with common methods\n
"""

def check_key_values(response):
    if 'value' in response and response['value'] == "":
        logging.error(
            f"Expected the key 'value' is not null, actually found ${response['value']}")

    if 'rank' in response and response['rank'] == "":
        logging.error(
            f"Expected the key 'rank' is not null, actually found ${response['rank']}")

    if 'displayValue' in response and response['displayValue'] == "":
        logging.error(
            f"Expected the key 'displayValue' is not null, actually found ${response['displayValue']}")
    pass


def validate_team_schema_keys(response_data, key):
    key_list = response_data[key].keys()
    for key1 in key_list:
        if isinstance(response_data[key][key1], NoneType):
            pass
        else:
            key_list1 = response_data[key][key1].keys()
            for key2 in key_list1:
                key_list2 = response_data[key][key1][key2].keys()
                for key3 in key_list2:
                    check_key_values(response_data[key][key1][key2][key3])
    pass


def validate_play_schema_participants_athelet_values(response, athlete_flag):
    for participant_key in response:
        for key, value in participant_key.items():
            if participant_key.get(key) == "":
                logging.error(
                    f"Expected the key '${key}' is not null, but found ${participant_key.get(key)}")
            if athlete_flag and key == "athlete":
                athlete_dict = participant_key.get(key)
                for athlete_key in athlete_dict:
                    if athlete_dict.get(athlete_key) == "":
                        logging.error(
                            f"Expected the key '${key}' is not null, but found ${athlete_dict.get(athlete_key)}")


def validate_groups_schema_keys(response, nested_teams_flag):
    """Validate keys to be not null Groups'(children) schema in a sport"""
    for children_dict in response:
        for key in children_dict:
            if children_dict.get(key) == "":
                logging.error(
                    f"Expected the key '${key}' is not null, but found ${children_dict.get(key)}")
            if nested_teams_flag and key == "teams":
                nested_teams_dict = children_dict.get(key)
                validate_teams_schema_in_groups(nested_teams_dict)
            else:
                if key == "teams":
                    logging.error(
                        "Teams schema should not be populated as per expectation")
    pass


def validate_teams_schema_in_groups(response):
    """Validate keys to be not null Teams' schema in a sport"""
    for teams_Key in response:
        for key in teams_Key:
            if teams_Key.get(key) == "":
                logging.error(
                    f"Expected the key '${key}' is not null, but found ${teams_Key.get(key)}")

    pass


@library(scope='GLOBAL', version='5.0.2')
class ESPNSportsCoreCommonValidator(object):
    """JSON validation for ESPN Sports Core API"""

    def __init__(self, *p, **k):
        pass

    @keyword('Validate key-value', tags=['functional', 'CoreV3', 'baseball'],
             types={'response_data': requests.Response, 'key': string, 'expected_value': string})
    def validate_keys_from_response(self, response_data, key, expected_value) -> bool:
        """
        Validating the key values of JSON data
        """

        try:
            if response_data.get(key) == "":
                logging.error(
                    f"Expected the key '${key}' is not null, actually found ${response_data.get(key)}")

            if expected_value != "":
                if response_data.get(key) == expected_value:
                    pass
                else:
                    logging.error(
                        f"Expected the key '${key}' as ${expected_value}, actually found ${response_data.get(key)}")

        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')

        return True

    @keyword('Validate the teams data retrieved is valid',
             tags=['functional', 'CoreV3', 'sport'], types={'response_data': requests.Response, 'statistics_flag': bool,
                                                            'record_flag': bool, 'athlete_flag': bool})
    def validate_the_teams_data_for_seasons_teams_stats(self, response_data, statistics_flag, record_flag,
                                                        athlete_flag) -> bool:
        """
        Validating the keys' statistics, record and athletes for season teams
        """
        try:

            if statistics_flag and "statistics" in response_data:
                validate_team_schema_keys(response_data, 'statistics')
            else:
                if "statistics" not in response_data:
                    logging.error(
                        "The key 'statistics' does not exist in the JSON")

            if record_flag and "record" in response_data:
                validate_team_schema_keys(response_data, 'record')

            else:
                if "record" not in response_data:
                    logging.error(
                        "The key 'record' does not exist in the JSON")

            if athlete_flag and "athletes" in response_data:
                validate_team_schema_keys(response_data, 'athletes')
            else:
                if "athletes" not in response_data:
                    logging.error(
                        "The key 'athletes' does not exist in the JSON")

        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')
        return True

    @keyword('Validate leagues array of sports schema',
             tags=['functional', 'CoreV3', 'soccer'], types={'response': requests.Response, 'leagues_flag': bool,
                                                             'season_flag': bool})
    def validate_the_leagues_array_of_sports_schema(self, response, leagues_flag, season_flag) -> bool:
        """
        Validating the key-values from league schema
        """
        try:

            if leagues_flag:
                if "leagues" not in response:
                        logging.error("The 'leagues' key is not found, which is expected in the Response.")
                else:
                    for league in response.get("leagues"):
                        leagues_key_list = league.keys()
                        for league_key in leagues_key_list:
                            if league.get(league_key) == "":
                                logging.error(f"Expected the key '${league_key}' is not null, but found ${league.get(league_key)}")

                            if season_flag and league_key == "season" and "season" in league:
                                    seasons_dict = league.get(league_key)
                                    for season_key in seasons_dict.keys():
                                        if seasons_dict.get(season_key) == "":
                                            logging.error(f"Expected the key '${season_key}' is not null, but found ${seasons_dict.get(season_key)}")

                                        if season_key == "year":
                                            re.match(r'^\d{4}$', str(seasons_dict.get(season_key)))

                                        if season_key == "endDate" or season_key == "startDate":
                                            re.match(r'^\d{4}-\d\d-\d\dT\d\d:\d\dZ$', str(seasons_dict.get(season_key)))
                            else:
                                if league.get(league_key) == "season":
                                    logging.error("The 'season' key is not found, which is expected in the Response.")
            else:
                if "leagues" in response:
                    logging.error("The 'leagues' key is found, which is expected in the Response.")

        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')

        return True

    @keyword('Validate the expected and actual values from the response', tags=['functional', 'CoreV3', 'soccer'],
             types={'response': requests.Response, 'actual_values': list, 'expected_values': list})
    def validate_the_expected_actual_values(self, response, actual_values, expected_values) -> bool:
        """
        Validate the actual and expected values
        """

        try:
            for key in actual_values:
                for value in expected_values:
                    if response.get(key) == value:
                        pass
                    else:
                        logging.error(
                            f"Expected the key '${key}' is not null, but actually found ${response.getkey}")
                    expected_values.remove(value)
                    break
        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')

        return True

    @keyword('Validate items array values of play schema is valid',
             tags=['functional', 'CoreV3', 'basketball'], types={'response': requests.Response, 'participants_flag': bool,
                                                                 'athlete_flag': bool})
    def validate_the_items_array_of_play_schema_is_valid(self, response, participants_flag, athlete_flag) -> bool:
        """
        Validating the keys' statistics, record and athletes for season teams
        """
        try:
            if "items" in response:
                for item in response.get("items"):
                    for key in item.keys():
                        if item.get(key) == "":
                            logging.error(
                                f"Expected the key '${key}' is not null, but found ${response.get(key)}")
                        if participants_flag and key == "participants":
                            participants_dict = item.get(key)
                            validate_play_schema_participants_athelet_values(
                                participants_dict, False)
                            if athlete_flag:
                                validate_play_schema_participants_athelet_values(
                                    participants_dict, True)
            else:
                logging.error(f"Expected the key 'items' exists in the JSON response but 'items' not found. "
                              f"\n${response}")
        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')
        return True

    @keyword('Validate competitions array values of event schema is valid',
             tags=['functional', 'CoreV3', 'basketball'], types={'response': requests.Response, 'status_flag': bool,
                                                                 'situation_flag': bool, 'situation_play_flag': bool,
                                                                 'situation_probability_flag': bool,
                                                                 'competitors_flag': bool,
                                                                 'competitors_team_flag': bool,
                                                                 'competitors_score_flag': bool,
                                                                 'competitors_linescores_flag': bool,
                                                                 'odds_flag': bool})
    def validate_the_competitions_array_of_event_schema_is_valid(self, response, status_flag,
                                                                 situation_flag, situation_play_flag,
                                                                 situation_probability_flag,
                                                                 competitors_flag, competitors_team_flag,
                                                                 competitors_score_flag, competitors_linescores_flag,
                                                                 odds_flag) -> bool:
        """
        Validating the keys' competitions, status, situation, competitors and odds of event schema
        """
        try:
            if "competitions" in response:
                for competition_item in response.get("competitions"):
                    for key in competition_item.keys():

                        if status_flag and key == "status":
                           status_dict = competition_item.get(key)
                           for status_item in status_dict:
                               if status_dict.get(status_item) == "":
                                    logging.error(f"Expected the key '${status_item}' is not null, "
                                                  f"but found ${status_dict.get(status_item)}")
                        else:
                            if key == "status":
                                logging.error(
                                    "The 'status' key is found, which is not expected in the Response.")

                        if situation_flag and key == "situation":
                           situation_dict = competition_item.get(key)
                           for situtation_key in situation_dict:
                               if situation_play_flag and situtation_key == "play":
                                    if situation_dict.get(situtation_key) == "":
                                       logging.error(
                                           f"Expected the key '${situtation_key}' is not null, but found ${situation_dict.get(situtation_key)}")
                               else:
                                    if situtation_key == "play":
                                        logging.error("The 'play' key is found, which is not expected in the Response.")
                               if situation_probability_flag and situtation_key == "probability":
                                    if situation_dict.get(situtation_key) == "":
                                       logging.error(
                                           f"Expected the key '${situtation_key}' is not null, but found ${situation_dict.get(situtation_key)}")
                               else:
                                    if situtation_key == "probability":
                                            logging.error("The 'probability' key is found, which is not expected in the Response.")
                        else:
                            if key == "situation":
                                logging.error(
                                    "The 'situation' key is found, which is not expected in the Response.")

                        if competitors_flag and key == "competitors":
                               for competitors_key in competition_item.get(key):
                                    for comp_key in competitors_key.keys():
                                        if competitors_team_flag and comp_key == "team":
                                               if competitors_key.get(comp_key) == "":
                                                    logging.error(
                                                        f"Expected the key '${comp_key}' is not null, but found ${competitors_key.get(comp_key)}")
                                        else:
                                            if comp_key == "team":
                                               logging.error("The 'team' key is found, which is not expected in the Response.")
                                        if competitors_score_flag and comp_key == "score":
                                               if competitors_key.get(comp_key) == "":
                                                    logging.error(
                                                        f"Expected the key '${comp_key}' is not null, but found ${competitors_key.get(comp_key)}")
                                        else:
                                            if comp_key == "score":
                                                      logging.error("The 'score' key is found, which is not expected in the Response.")
                                        if competitors_linescores_flag and comp_key == "linescores":
                                               if competitors_key.get(comp_key) == "":
                                                   logging.error(
                                                       f"Expected the key '${comp_key}' is not null, but found ${competitors_key.get(comp_key)}")
                                        else:
                                            if comp_key == "linescores":
                                                      logging.error("The 'linescores' key is found, which is not expected in the Response.")
                        else:
                            if key == "competitors":
                                logging.error(
                                    "The 'competitors' key is found, which is not expected in the Response.")

                        if odds_flag and key == "odds":
                               for odds_key in competition_item.get(key):
                                    for odd_key in odds_key.keys():
                                        if odds_key.get(odd_key) == "":
                                            logging.error(
                                                f"Expected the key '${odd_key}' is not null, but found ${odds_key.get(odd_key)}")
                        else:
                            if key == "odds":
                                logging.error(
                                    "The 'odds' key is found, which is not expected in the Response.")

            else:
                logging.error(f"Expected the key 'competitions' exists in the JSON response but 'competitions' not found. "
                              f"\n${response}")
        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')

        return True

    @keyword('Validate type groups array values of season schema is valid',
             tags=['functional', 'CoreV3', 'sport'], types={'response': requests.Response, 'type_flag': bool,
                                                            'groups_flag': bool, 'groups_teams_flag': bool,
                                                            'nested_groups_flag': bool, 'nested_groups_teams_flag': bool
                                                            })
    def validate_type_groups_array_values_of_season_schema_is_valid(self, response, type_flag, groups_flag,
                                                                    groups_teams_flag, nested_groups_flag,
                                                                    nested_groups_teams_flag) -> bool:
        """
        Validating the keys for Type, Groups, Children and Teams schemas in Season details endpoints.

        Example:
          /${SPORT}/${LEAGUE_NFL}?enable=season(type(groups(teams,groups(teams))))

        """
        try:
            for key in response:
                if key == "season":
                    season_dict = response.get(key)
                    for season_item in season_dict:
                        if season_dict.get(season_item) == "":
                            logging.error(f"Expected the key '${season_item}' is not null, "
                                          f"but found ${season_dict.get(season_item)}")
                        if season_item == "type":
                            type_dict = season_dict.get(season_item)
                            for type_key in type_dict:
                                if type_dict.get(type_key) == "":
                                    logging.error(f"Expected the key '${type_key}' is not null, "
                                                  f"but found ${type_dict.get(type_key)}")
                                if groups_flag and type_key == "groups":
                                    for groups_dict in type_dict.get(type_key):
                                        for groupsElement in groups_dict:
                                            if groups_dict.get(groupsElement) == "":
                                                logging.error(f"Expected the key '${groupsElement}' is not null, "
                                                              f"but found ${groups_dict.get(groupsElement)} ")
                                            if groups_teams_flag and groupsElement == "teams":
                                                validate_teams_schema_in_groups(
                                                    groups_dict.get(groupsElement))
                                            else:
                                                if groupsElement == "teams":
                                                    logging.error("Teams schema should not be populated as per "
                                                                  "expectation")
                                            if nested_groups_flag and groupsElement == "children":
                                                nested_groups_dict = groups_dict.get(
                                                    groupsElement)
                                                validate_groups_schema_keys(nested_groups_dict,
                                                                            nested_groups_teams_flag)
                                            else:
                                                if groupsElement == "children":
                                                    logging.error("Children schema should not be populated as per "
                                                                  "expectation")
                                else:
                                    if type_key == "groups":
                                        logging.error(
                                            "Groups schema should not be populated as per expectation")
                        else:
                            if season_item == "type":
                                logging.error(
                                    "Type schema should not be populated as per expectation")
                else:
                    if response.get(key) == "":
                        logging.error(
                            f"Expected the key '${key}' is not null, but found ${response.get(key)}")
        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')
        return True

    @keyword('Validate teams details for statistics athletes and record schema is valid',
             tags=['functional', 'CoreV3', 'sport'], types={'response': requests.Response, 'statistics_flag': bool,
                                                            'record_flag': bool, 'nested_statistics_flag': bool,
                                                            'athlete_flag': bool})
    def validate_teams_details_for_statistics_athletes_and_record_schema_is_valid(self, response, statistics_flag,
                                                                                  record_flag, nested_statistics_flag,
                                                                                  athlete_flag) -> bool:
        """
        Validating the keys for Statistics, Athletes and Record schemas in Teams details endpoints.

        Example:
          /${SPORT}/${LEAGUE_ID}/seasons/${SEASON_ID}/teams/${TEAM_ID}?enable=record,statistics,athletes(statistics)

        """
        try:
            for key in response:
                if response.get(key) == "":
                    logging.error(
                        f"Expected the key '${key}' is not null, but found ${response.get(key)}")
                if record_flag and key == "record":
                    validate_team_schema_keys(response, key)
                else:
                    if key == "record":
                        logging.error(
                            "Record schema should not be populated as per expectation")
                if statistics_flag and key == "statistics":
                    validate_team_schema_keys(response, key)
                else:
                    if key == "statistics":
                        logging.error(
                            "Statistics schema should not be populated as per expectation")
                if athlete_flag and key == "athletes":
                    athletes_dict = response.get(key)
                    for athletes_key in athletes_dict:
                        for ath_key in athletes_key:
                            if athletes_key.get(ath_key) == "":
                                logging.error(f"Expected the key '${ath_key}' is not null, but "
                                              f"found ${athletes_key.get(ath_key)}")
                            if nested_statistics_flag and athletes_key == "statistics":
                                athletes_statistics_dict = athletes_dict.get(
                                    athletes_key)
                                for athletes_stats_key in athletes_statistics_dict:
                                    if athletes_statistics_dict.get(athletes_stats_key) == "":
                                        logging.error(f"Expected the key '${athletes_stats_key}' is not null, but "
                                                      f"found ${athletes_statistics_dict.get(athletes_stats_key)}")
                            else:
                                if athletes_key == "statistics":
                                    logging.error(
                                        "Athlete Statistics schema should not be populated as per expectation")
                else:
                    if key == "athletes":
                        logging.error("Athletes schema should not be populated as per expectation")
                        break
        except ValidationError as ve:
            raise Failure(f'Data validation failed: {ve.messages}')
        return True
