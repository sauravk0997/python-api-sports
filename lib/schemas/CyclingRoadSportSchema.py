from lib.schemas.SportSchema import *
from lib.schemas import *
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint

class CyclingRoadSeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE
    description = fields.String(required=True)

class CyclingRoadLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE
    uid          = LeagueItemUID(required=False)
    groupId      = fields.String(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=True)
    season       = fields.Nested(CyclingRoadSeasonSchema, required=False)

class CyclingRoadSportSchema(SportSchema):
    class Meta:
        unknown = RAISE
    leagues          = fields.List(fields.Nested(CyclingRoadLeagueSchema), required=False)

