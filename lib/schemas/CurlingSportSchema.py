#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.SportSchema import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint



class CurlingSeasonTypeSchema(SeasonTypeSchema):
    class Meta:
        unknown = RAISE

    type         = fields.Integer(required=False)
    slug         = fields.String(required=True)

class CurlingSeasonSchema(SeasonSchema): 
    class Meta:
        unknown = RAISE
        
    description = fields.String(required=True)
    type        = fields.Nested(CurlingSeasonTypeSchema, required=False)


class CurlingLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    shortName    = LeagueItemUID(required=False)
    groupId      = fields.String(required=False)
    season       = fields.Nested(CurlingSeasonSchema, required=False)
   

class CurlingSportSchema(SportSchema):
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(CurlingLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/badminton?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = CurlingSportSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
