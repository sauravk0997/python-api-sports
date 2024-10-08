#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.SportSchema import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint



class GolfSeasonTypeSchema(SeasonTypeSchema):
    class Meta:
        unknown = RAISE


class GolfSeasonSchema(SeasonSchema): 
    class Meta:
        unknown = RAISE
    
    displayName = fields.String(required=True) 
    type        = fields.Nested(GolfSeasonTypeSchema, required=False)


class GolfLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    abbreviation = fields.String(required=True)
    season       = fields.Nested(GolfSeasonSchema, required=False)
   

class GolfSportSchema(SportSchema):
    class Meta:
        unknown = RAISE
    
    uid              = SportsItemUID(required=True)
    guid             = IntOrUUID(required=True)
    leagues          = fields.List(fields.Nested(GolfLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/badminton?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = GolfSportSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
