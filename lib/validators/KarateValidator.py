#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas import *
from marshmallow import ValidationError
from robot.api.deco import keyword, library
from robot.api.exceptions import Failure
import requests
from lib.schemas.KarateSportSchema import KarateSportSchema


@library(scope='GLOBAL', version='5.0.2')
class KarateValidator(object):
    """JSON validation for Karate Sports Core API"""

    def __init__(self, *p, **k):
        pass

    @keyword('Sport Schema from ${response} should be valid for karate', tags=['schema checks', 'functional', 'CoreV3'], types={'response': requests.Response})
    def sports_resp_is_valid(self, response) -> bool:
        """ Schema for the endpoint: /v3/sports/karate

            Expects to receive an embedded python requests object as 'response'
            and validates the json against the SportSchema class

          Examples:
          Sport Schema from ${response} should be valid for karate

        """
        try:
            schema = KarateSportSchema().load(response.json())    

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')
        return True
