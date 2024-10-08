#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE

class CyclingBmxSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE
    description = fields.String(required=True)

class CyclingBmxLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    groupId         = fields.String(required=False)
    shortName    = fields.String(required=False)
    season       = fields.Nested(CyclingBmxSeasonSchema, required=False)
    
class CyclingBmxSportSchema(SportSchema):
    """
        Schema for Cycling Bmx sport endpoints

    """
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(CyclingBmxLeagueSchema), required=False)

