#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas import *
from marshmallow import ValidationError
from robot.api.deco import keyword, library
from robot.api.exceptions import Failure
import requests


@library(scope='GLOBAL', version='5.0.2')
class RugbySportsCoreValidator(object):
    """JSON validation for ESPN Sports Core API"""

    def __init__(self, *p, **k):
        pass

    @keyword('Sport Schema from ${response} should be valid for rugby', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def sports_resp_is_valid(self, response) -> bool:
        """ Schema for the endpoint: /v3/sports/rugby

            Expects to receive an embedded python requests object as 'response'
            and validates the json against the RugbySportSchema class

          Examples:
          Sport Schema from ${response} should be valid for rugby
        """
        try:
            schema = RugbySportSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('League Schema from ${response} should be valid for rugby', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def league_item_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid for rugby| True |
        """
        try:
            schema = RugbyLeagueSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True

    @keyword('Team Schema from ${response} should be valid for rugby', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def team_schema_resp_is_valid(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid for rugby| True |
        """
        try:
            schema = RugbyTeamsSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True