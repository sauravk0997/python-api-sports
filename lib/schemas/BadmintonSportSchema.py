#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.SportSchema import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint



class BadmintonSeasonTypeSchema(SeasonTypeSchema):
    class Meta:
        unknown = RAISE

    id           = fields.String(required=True)
    type         = fields.Integer(required=False)
    name         = fields.String(required=True)
    abbreviation = fields.String(required=True)
    startDate    = fields.String(required=True)
    endDate      = fields.String(required=True)
    slug         = fields.String(required=True)

class BadmintonSeasonSchema(SeasonSchema): 
    class Meta:
        unknown = RAISE
    
    type        = fields.Nested(BadmintonSeasonTypeSchema, required=False)


class BadmintonLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    id           = fields.String(required=True)
    uid          = LeagueItemUID(required=False)
    groupId      = fields.String(required=False)
    name         = fields.String(required=True)
    abbreviation = fields.String(required=True)
    shortName    = fields.String(required=False)
    midsizeName  = fields.String(required=False)
    slug         = fields.String(required=True)
    season       = fields.Nested(BadmintonSeasonSchema, required=False)
   

class BadmintonSportSchema(SportSchema):
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(BadmintonLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/badminton?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = BadmintonLeagueSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
