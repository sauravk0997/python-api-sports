#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE


class CrossCountryLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid = LeagueItemUID(required=False)
    shortName = fields.String(required=False)
    abbreviation = fields.String(required=False)
    groupId = fields.String(required=False)


class CrossCountrySportSchema(SportSchema):
    """
        Schema for Cross-Country sport endpoints

    """

    class Meta:
        unknown = RAISE

    leagues = fields.List(fields.Nested(CrossCountryLeagueSchema), required=False)
