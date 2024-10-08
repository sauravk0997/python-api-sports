#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas import *
from marshmallow import ValidationError
from robot.api.deco import keyword, library
from robot.api.exceptions import Failure
import requests


@library(scope='GLOBAL', version='5.0.2')
class BadmintonValidator(object):
    """JSON validation for ESPN Sports Core API"""

    def __init__(self, *p, **k):
        pass

    @keyword('Sport Schema from ${response} should be valid for badminton', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def sports_resp_is_valid_for_badminton(self, response) -> bool:
        """ Schema for the endpoint: /v3/sports/{SportName}
            ie: v3/sports/badminton/

            Expects to receive an embedded python requests object as 'response'
            and validates the json against the SportSchema class

          Examples:
          Sport Schema from ${response} should be valid
        """
        try:
            schema = BadmintonSportSchema().load(response.json())     
        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')
        return True
    
    @keyword('League Schema from ${response} should be valid for badminton', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def league_item_schema_resp_is_valid_for_badminton(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response'
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid | True |
        """
        try:
            schema = BadmintonLeagueSchema().load(response.json())
        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True