#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from lib.schemas.SportSchema import *
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint


class HockeyPlaySchema(PlaySchema):
    isPenalty = fields.Boolean(required=False)
    shootoutPlay = fields.Boolean(required=False)
    shootingPlay = fields.Boolean(required=False)
    odds            = fields.List(fields.Nested(OddsSchema), required=True)


class HockeySituationSchema(SituationSchema):
    """
        Schema for Hockey Situations invoked from the CompetitionSchema.

    """
    play = fields.Nested(HockeyPlaySchema, required=False)



class HockeyCompetitionSchema(CompetitionSchema):
    """
        Schema for hockey Competition Plays endpoint.

    """

    class Meta:
        unknown = RAISE

    situation = fields.Nested(HockeySituationSchema, required=False)



class HockeyEventSchema(EventSchema):
    """
        Schema for hockey Events such as:
        /v3/sports/hockey/nhl/events/{eventid}

        This is also used as the format for 'items' within EventsSchema
    """

    class Meta:
        unknown = RAISE

    competitions = fields.List(fields.Nested(HockeyCompetitionSchema), required=False)


class HockeyEventsSchema(Schema):
    """
        For Event listings where the Event ID isn't specified.

    """

    class Meta:
        unknown = RAISE

    items = fields.List(fields.Nested(HockeyEventSchema), required=True)
    count = fields.Integer(required=True)
