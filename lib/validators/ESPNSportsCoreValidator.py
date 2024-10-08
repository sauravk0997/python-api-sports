#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas import *
from marshmallow import ValidationError
from robot.api.deco import keyword, library
from robot.api.exceptions import Failure
import requests


@library(scope='GLOBAL', version='5.0.2')
class ESPNSportsCoreValidator(object):
    """JSON validation for ESPN Sports Core API"""

    def __init__(self, *p, **k):
        pass

    @keyword('Sports Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def base_resp_is_valid(self, response) -> bool:
        """
            Schema for the endpoint: /v3/sports

            Expects to receive an embedded python requests object as 'response'
            and validates the json against the SportsSchema class.

            Note the pluralization of "Sports" as this applies to the endpoint
            for listing sports.

          Examples:
          Sports Schema from ${response} should be valid
        """
        try:
            data = SportsSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')
        return True

    @keyword('Sport Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def sports_resp_is_valid(self, response) -> bool:
        """ Schema for the endpoint: /v3/sports/{SportName}
            ie: v3/sports/baseball/

            Expects to receive an embedded python requests object as 'response'
            and validates the json against the SportSchema class

          Examples:
          Sport Schema from ${response} should be valid
        """
        try:
            schema = SportSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')
        return True

    @keyword('League Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def league_item_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = LeagueSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Team Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def team_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = TeamsSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Event Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def event_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = EventSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Events Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def events_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = EventsSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Plays Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def plays_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = PlaysSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Season Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def season_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = SeasonSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Athlete Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def athlete_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = AthletesSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Invalid Schema from ${response} should be valid', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def invalid_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = InvalidSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True