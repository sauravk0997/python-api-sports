#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE

class ShootingLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=False)
    groupId         = fields.String(required=False)

class ShootingSportSchema(SportSchema):
    """
        Schema for Shooting sport endpoints

    """
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(ShootingLeagueSchema), required=False)

