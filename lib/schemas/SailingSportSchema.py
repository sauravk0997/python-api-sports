#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE

class SailingLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=False)
    groupId         = fields.String(required=False)

class SailingSportSchema(SportSchema):
    """
        Schema for Sailing sport endpoints

    """
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(SailingLeagueSchema), required=False)

