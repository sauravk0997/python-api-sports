#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas import *
from marshmallow import ValidationError
from robot.api.deco import keyword, library
from robot.api.exceptions import Failure
import requests


@library(scope='GLOBAL', version='5.0.2')
class HockeySportsCoreValidator(object):
    """JSON validation for ESPN Sports Hockey Core API"""

    def __init__(self, *p, **k):
        pass

    @keyword('Event Schema from ${response} should be valid for hockey', tags=['schema checks', 'functional', 'CoreV3'],
             types={'response': requests.Response})
    def event_schema_resp_is_valid_for_sport(self, response) -> bool:
        """ Expects to receive an embedded python requests object as 'response' for 'sport' specific
           and validates the json against the BaseSchema class

          Examples:
          | Base Schema from ${response} should be valid for ${sport}| True |
        """
        try:
             schema = HockeyEventSchema().load(response.json())

        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')

        return True
