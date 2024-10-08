from lib.schemas.SportSchema import *
from lib.schemas import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint

class WeightliftingSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE
    description = fields.String(required=True)

class WeightliftingLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE
    uid          = LeagueItemUID(required=False)
    groupId      = fields.String(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=True)
    season       = fields.Nested(WeightliftingSeasonSchema, required=False)

class WeightliftingSportSchema(SportSchema):
    class Meta:
        unknown = RAISE
    leagues          = fields.List(fields.Nested(WeightliftingLeagueSchema), required=False)

