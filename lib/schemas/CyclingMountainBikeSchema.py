#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE


class CyclingMountainBikeLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid = LeagueItemUID(required=False)
    groupId = fields.String(required=False)
    shortName = fields.String(required=False)


class CyclingMountainBikeSportSchema(SportSchema):
    class Meta:
        unknown = RAISE

    leagues = fields.List(fields.Nested(CyclingMountainBikeLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/mountain-bike?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = CyclingMountainBikeLeagueSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')