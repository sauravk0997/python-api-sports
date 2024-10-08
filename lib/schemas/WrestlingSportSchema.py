#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE

class WrestlingLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=False)
    groupId         = fields.String(required=False)

class WrestlingSportSchema(SportSchema):
    """
        Schema for Wrestling sport endpoints

    """
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(WrestlingLeagueSchema), required=False)

