#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import  fields, RAISE

class KarateSeasonSchema(SeasonSchema): 
    class Meta:
        unknown = RAISE
        
    description = fields.String(required=True)

class KarateLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    groupId         = fields.String(required=False)
    abbreviation = fields.String(required=True)
    shortName    = fields.String(required=False)
    season       = fields.Nested(KarateSeasonSchema, required=False)

class KarateSportSchema(SportSchema):
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(KarateLeagueSchema), required=False)

