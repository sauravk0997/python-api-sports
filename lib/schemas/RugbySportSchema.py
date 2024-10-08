#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
from lib.schemas.SportSchema import *
import requests
from pprint import pprint


class RugbySeasonTypeGroupSchema(SeasonTypeGroupSchema):

    slug = fields.String(required=False)


class RugbySeasonTypeSchema(SeasonTypeSchema):
    class Meta:
        unknown = RAISE

    groups = fields.List(fields.Nested(RugbySeasonTypeGroupSchema), required=False)


class RugbySeasonSchema(SeasonSchema):
    class Meta:
        unknown = RAISE

    type = fields.Nested(RugbySeasonTypeSchema, required=False)


class RugbyLeagueSchema(LeagueSchema):
    class Meta:
        unknown = RAISE
    shortName    = fields.String(required=False)
    isClubCompetition = fields.Boolean(required=False)
    season = fields.Nested(RugbySeasonSchema, required=False)


class RugbySportSchema(SportSchema):
    """
        Schema for Rugby Sport
    """

    class Meta:
        unknown = RAISE

    leagues = fields.List(fields.Nested(RugbyLeagueSchema), required=False)


class RugbyStatsSchema(StatsSchema):
    """
        This class holds all stat items available from processed schemas...
        additions are definitely going to be necessary moving forward and
        can be merged as they arise.
    """
    # Record Stats
    bonusPoints      = fields.Nested(StatsValueSchema, required=False)
    triesFor             = fields.Nested(StatsValueSchema, required=False)
    byes           = fields.Nested(StatsValueSchema, required=False)
    triesAgainst           = fields.Nested(StatsValueSchema, required=False)
    triesBonus           = fields.Nested(StatsValueSchema, required=False)
    losingBonus           = fields.Nested(StatsValueSchema, required=False)
    OTWins           = fields.Nested(StatsValueSchema, required=False)
    losses           = fields.Nested(StatsValueSchema, required=False)
    points           = fields.Nested(StatsValueSchema, required=False)
    pointDifferential           = fields.Nested(StatsValueSchema, required=False)
    gamesPlayed           = fields.Nested(StatsValueSchema, required=False)
    leagueWinPercent           = fields.Nested(StatsValueSchema, required=False)
    rank           = fields.Nested(StatsValueSchema, required=False)
    wins           = fields.Nested(StatsValueSchema, required=False)
    pointsFor           = fields.Nested(StatsValueSchema, required=False)
    streak           = fields.Nested(StatsValueSchema, required=False)
    avgPointsFor           = fields.Nested(StatsValueSchema, required=False)
    playoffSeed           = fields.Nested(StatsValueSchema, required=False)
    divisionWinPercent           = fields.Nested(StatsValueSchema, required=False)
    pointsAgainst           = fields.Nested(StatsValueSchema, required=False)
    gamesBehind           = fields.Nested(StatsValueSchema, required=False)
    ties           = fields.Nested(StatsValueSchema, required=False)
    OTLosses           = fields.Nested(StatsValueSchema, required=False)
    triesFor           = fields.Nested(StatsValueSchema, required=False)
    winPercent           = fields.Nested(StatsValueSchema, required=False)
    avgPointsAgainst           = fields.Nested(StatsValueSchema, required=False)


class RugbyRecordStatsSchema(RecordStatsSchema):

    stats            = fields.Nested(RugbyStatsSchema, required=True)


class RugbyRecordSchema(RecordSchema):

    overall            = fields.Nested(RugbyRecordStatsSchema, required=False)



class RugbyTeamsSchema(TeamsSchema):
    class Meta:
        unknown = RAISE

    record           = fields.Nested(RugbyRecordSchema, required=False)
