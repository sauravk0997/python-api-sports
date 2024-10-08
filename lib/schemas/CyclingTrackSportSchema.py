#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from lib.schemas.SportSchema import *
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint

class CyclingTrackLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE

    uid          = LeagueItemUID(required=False)
    shortName    = fields.String(required=False)
    abbreviation = fields.String(required=False)
    groupId         = fields.String(required=False)

class CyclingTrackSportSchema(SportSchema):
    """
        Schema for Cycling-Track sport endpoints

    """
    class Meta:
        unknown = RAISE

    leagues          = fields.List(fields.Nested(CyclingTrackLeagueSchema), required=False)

