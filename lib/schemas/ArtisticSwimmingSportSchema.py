#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import fields, RAISE

class ArtisticSwimmingSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE
    description = fields.String(required=True)

class ArtisticSwimmingLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    groupId         = fields.String(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=True)
    season       = fields.Nested(ArtisticSwimmingSeasonSchema, required=False)
    
class ArtisticSwimmingSportSchema(SportSchema):
    """
        Schema for Artistic Swimming sport endpoints

    """
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(ArtisticSwimmingLeagueSchema), required=False)

