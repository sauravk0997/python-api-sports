#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.GymnasticTrampolineSportSchema import GymnasticTrampolineSportSchema
from lib.validators.ESPNSportsCoreCommonValidator import *


@library(scope='GLOBAL', version='5.0.2')
class GymnasticTrampolineValidator(object):
    """
       *Author:* `Ganapathi Reshma Rani`\n
       *Date :* `27-09-2022`\n
       *Description:* JSON validation for ESPN Sports Core API for Gymnastic - Trampoline\n
    """

    def __init__(self, *p, **k):
        pass

    @keyword('Sport Schema from ${response} should be valid for gymnastic-trampoline', tags=['schema checks', 'functional', 'CoreV3'],
             types={'response': requests.Response})
    def sports_resp_is_valid_for_gymnastic_trampoline(self, response) -> bool:
        """ Schema for the endpoint: /v3/sports/{SportName}
            ie: v3/sports/trampoline/

            Expects to receive an embedded python requests object as 'response'
            and validates the json against the SportSchema class

          Examples:
          Sport Schema from ${response} should be valid
        """
        try:
            schema = GymnasticTrampolineSportSchema().load(response.json())
        except ValidationError as ve:
            raise Failure(f'Schema Data failed validation: {ve.messages}')
        return True

