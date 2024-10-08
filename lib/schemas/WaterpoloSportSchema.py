from lib.schemas.SportSchema import *
from lib.schemas import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint


class WaterPoloSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE

class WaterPoloLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE
    shortName    = fields.String(required=False)
    season       = fields.Nested(WaterPoloSeasonSchema, required=False)

class WaterPoloSportSchema(SportSchema):
    class Meta:
        unknown = RAISE
    leagues          = fields.List(fields.Nested(WaterPoloLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/water-polo?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = WaterPoloSportSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
