#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.SportSchema import *
from lib.schemas import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint

class VolleyballRecordSchema(RecordSchema):
    class Meta:
        unknown = RAISE

    season           = fields.String(required=True, allow_none=True)
    last             = fields.String(required=True, allow_none=True)
    neutral          = fields.String(required=True, allow_none=True)
    conference       = fields.String(required=True, allow_none=True)

class VolleyballTeamsSchema(TeamsSchema):
    class Meta:
        unknown = RAISE

    uid              = fields.String(required=True)
    slug             = fields.String(required=True)
    location         = fields.String(required=True)
    name             = fields.String(required=True)
    nickname         = fields.String(required=True)
    shortDisplayName = fields.String(required=True)    
    color            = fields.String(required=True)
    active           = fields.Boolean(required=True)   
    allstar          = fields.Boolean(required=True)
    record           = fields.Nested(VolleyballRecordSchema, required=False)

class VolleyballSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE

    # year           = fields.Integer(required=True)
    # startDate      = fields.String(required=True)
    # endDate        = fields.String(required=True)

class VolleyballLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE


class VolleyballSportSchema(SportSchema):
    class Meta:
        unknown = RAISE


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/volleyball?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = VolleyballSportSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
