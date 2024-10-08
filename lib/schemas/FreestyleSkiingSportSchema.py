from lib.schemas.SportSchema import *
from lib.schemas import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint

class FreestyleSkiingSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE
    description = fields.String(required=True)

class FreestyleSkiingLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE
    uid          = LeagueItemUID(required=False)
    groupId      = fields.String(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=True)
    season       = fields.Nested(FreestyleSkiingSeasonSchema, required=False)

class FreestyleSkiingSportSchema(SportSchema):
    class Meta:
        unknown = RAISE
    leagues          = fields.List(fields.Nested(FreestyleSkiingLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/freestyle-skiing?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = FreestyleSkiingSportSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
