#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE


class TableTennisSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE

    shortDisplayName = fields.String(required=True)
    abbreviation = fields.String(required=True)


class TableTennisLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid = LeagueItemUID(required=False)
    groupId = fields.String(required=False)
    name = fields.String(required=False)
    shortName = fields.String(required=False)


class TableTennisSportSchema(SportSchema):
    class Meta:
        unknown = RAISE

    leagues = fields.List(fields.Nested(TableTennisLeagueSchema), required=False)


if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/table-tennis?enable=leagues'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = TableTennisLeagueSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
