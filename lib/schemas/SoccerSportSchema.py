#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.SportSchema import *
from marshmallow import Schema, fields, RAISE


class SoccerSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE

    shortDisplayName = fields.String(required=True)
    abbreviation = fields.String(required=True)


class SoccerLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    alternateId = fields.String(required=True)
    season = fields.Nested(SoccerSeasonSchema, required=False)
    seasons = fields.List(fields.Nested(SoccerSeasonSchema), required=False)


class SoccerSportSchema(SportSchema):
    class Meta:
        unknown = RAISE

    leagues = fields.List(fields.Nested(SoccerLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/badminton?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = SoccerLeagueSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
