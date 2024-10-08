#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import IntOrUUID, SportsItemUID, LeagueItemUID, CustomTimeout
from marshmallow import Schema, fields, RAISE, ValidationError
import requests
from pprint import pprint


class FoulSchema(Schema):
    teamFouls        = fields.Integer(required=True)
    teamFoulsCurrent = fields.Integer(required=True)
    foulsToGive      = fields.Integer(required=True)
    bonusState       = fields.String(required=True)


class TimeoutSchema(Schema):
    timeoutsCurrent  = fields.Integer(required=True)
    timeoutsRemainingCurrent = fields.Integer(required=True)


class PlayStartEndSchema(Schema):
    down             = fields.Integer(required=True)
    distance         = fields.Integer(required=True)
    yardLine         = fields.Integer(required=True)
    yardsToEndzone   = fields.Integer(required=True)

    shortDownDistanceText = fields.String(required=False)
    downDistanceText      = fields.String(required=False)
    possessionText        = fields.String(required=False)


class ProbabilitySchema(Schema):
    # introduced in football, may apply to other sports
    tiePercentage     = fields.Float(required=True)
    secondsLeft       = fields.Float(required=False)  # missing in Basketball
    homeWinPercentage = fields.Float(required=True)
    awayWinPercentage = fields.Float(required=True)


class CountrySchema(Schema):
    id               = fields.String(required=True)
    slug             = fields.String(required=True)
    name             = fields.String(required=True)
    displayName      = fields.String(required=True)
    abbreviation     = fields.String(required=True)
    capital          = fields.String(required=False)  # not present in olympic soccer
    population       = fields.Integer(required=True)


class CityStateCountrySchema(Schema):
    # not every athlete has each field provided.
    city         = fields.String(required=False)
    state        = fields.String(required=False)
    country      = fields.String(required=False)

    # added with Golf
    countryAbbreviation = fields.String(required=False)
    stateAbbreviation   = fields.String(required=False)


class ExperienceSchema(Schema):
    years        = fields.Integer(required=True)

    # added with football
    displayValue = fields.String(required=False)
    abbreviation = fields.String(required=False)


class StatusTypeSchema(Schema):
    id           = fields.String(required=True)
    name         = fields.String(required=True)
    state        = fields.String(required=True)
    completed    = fields.Boolean(required=True)
    description  = fields.String(required=True)
    detail       = fields.String(required=True)
    shortDetail  = fields.String(required=True)

    # added with football
    altDetail    = fields.String(required=False)


class StatusSchema(Schema):
    period           = fields.Integer(required=True)
    displayPeriod    = fields.String(required=False)  # not present in Soccer??
    type             = fields.Nested(StatusTypeSchema, required=True)

    # baseball
    halfInning       = fields.Integer(required=False)
    periodPrefix     = fields.String(required=False)

    # football
    displayClock     = fields.String(required=False)
    clock            = fields.Float(required=False)

    # soccer
    addedClock       = fields.Float(required=False)

    # golf
    hadPlayoff       = fields.Boolean(required=False)


class DurationSchema(Schema):
    displayValue     = fields.String(required=True)


class CompetitionTypeSchema(Schema):
    slug             = fields.String(required=True)
    text             = fields.String(required=True)


class StatsValueSchema(Schema):
    value            = fields.Float(required=False, allow_none=True)
    rank             = fields.Integer(required=False)
    displayValue     = fields.String(required=False)
    perGameValue     = fields.Float(required=False)


class StatsSchema(Schema):
    """
        This class holds all stat items available from processed schemas...
        additions are definitely going to be necessary moving forward and
        can be merged as they arise.
    """
    # Record Stats
    gamesPlayed      = fields.Nested(StatsValueSchema, required=False)
    wins             = fields.Nested(StatsValueSchema, required=False)
    losses           = fields.Nested(StatsValueSchema, required=False)
    ties             = fields.Nested(StatsValueSchema, required=False)
    OTWins           = fields.Nested(StatsValueSchema, required=False)
    OTLosses         = fields.Nested(StatsValueSchema, required=False)
    homeWins         = fields.Nested(StatsValueSchema, required=False)
    homeLosses       = fields.Nested(StatsValueSchema, required=False)
    homeTies         = fields.Nested(StatsValueSchema, required=False)
    roadWins         = fields.Nested(StatsValueSchema, required=False)
    roadLosses       = fields.Nested(StatsValueSchema, required=False)
    roadTies         = fields.Nested(StatsValueSchema, required=False)
    pointsFor        = fields.Nested(StatsValueSchema, required=False)
    pointsAgainst    = fields.Nested(StatsValueSchema, required=False)
    pointDifferential = fields.Nested(StatsValueSchema, required=False)
    streak           = fields.Nested(StatsValueSchema, required=False)
    points           = fields.Nested(StatsValueSchema, required=False)
    gamesBehind      = fields.Nested(StatsValueSchema, required=False)
    playoffSeed      = fields.Nested(StatsValueSchema, required=False)
    clincher         = fields.Nested(StatsValueSchema, required=False)
    winPercent       = fields.Nested(StatsValueSchema, required=False)
    divisionWinPercent = fields.Nested(StatsValueSchema, required=False)
    leagueWinPercent = fields.Nested(StatsValueSchema, required=False)
    avgPointsFor     = fields.Nested(StatsValueSchema, required=False)
    avgPointsAgainst = fields.Nested(StatsValueSchema, required=False)
    magicNumberDivision = fields.Nested(StatsValueSchema, required=False)
    magicNumberWildcard = fields.Nested(StatsValueSchema, required=False)
    playoffPercent   = fields.Nested(StatsValueSchema, required=False)
    divisionPercent  = fields.Nested(StatsValueSchema, required=False)
    wildCardPercent  = fields.Nested(StatsValueSchema, required=False)
    divisionGamesBehind = fields.Nested(StatsValueSchema, required=False)
    divisionTied     = fields.Nested(StatsValueSchema, required=False)
    teamGamesPlayed  = fields.Nested(StatsValueSchema, required=False)
    saves            = fields.Nested(StatsValueSchema, required=False)
    groundBalls      = fields.Nested(StatsValueSchema, required=False)
    strikeouts       = fields.Nested(StatsValueSchema, required=False)
    sacFlies         = fields.Nested(StatsValueSchema, required=False)
    hits             = fields.Nested(StatsValueSchema, required=False)
    earnedRuns       = fields.Nested(StatsValueSchema, required=False)
    battersHit       = fields.Nested(StatsValueSchema, required=False)
    walks            = fields.Nested(StatsValueSchema, required=False)
    runs             = fields.Nested(StatsValueSchema, required=False)
    stolenBases      = fields.Nested(StatsValueSchema, required=False)
    caughtStealing   = fields.Nested(StatsValueSchema, required=False)
    sacBunts         = fields.Nested(StatsValueSchema, required=False)
    saveOpportunities = fields.Nested(StatsValueSchema, required=False)
    homeRuns         = fields.Nested(StatsValueSchema, required=False)
    triples          = fields.Nested(StatsValueSchema, required=False)
    finishes         = fields.Nested(StatsValueSchema, required=False)
    balks            = fields.Nested(StatsValueSchema, required=False)
    intentionalWalks = fields.Nested(StatsValueSchema, required=False)
    flyBalls         = fields.Nested(StatsValueSchema, required=False)
    battersFaced     = fields.Nested(StatsValueSchema, required=False)
    holds            = fields.Nested(StatsValueSchema, required=False)
    doubles          = fields.Nested(StatsValueSchema, required=False)
    completeGames    = fields.Nested(StatsValueSchema, required=False)
    perfectGames     = fields.Nested(StatsValueSchema, required=False)
    wildPitches      = fields.Nested(StatsValueSchema, required=False)
    RBIs             = fields.Nested(StatsValueSchema, required=False)
    thirdInnings     = fields.Nested(StatsValueSchema, required=False)
    teamEarnedRuns   = fields.Nested(StatsValueSchema, required=False)
    shutouts         = fields.Nested(StatsValueSchema, required=False)
    pickoffAttempts  = fields.Nested(StatsValueSchema, required=False)
    pitches          = fields.Nested(StatsValueSchema, required=False)
    runSupport       = fields.Nested(StatsValueSchema, required=False)
    catcherInterference = fields.Nested(StatsValueSchema, required=False)
    pitchesAsStarter = fields.Nested(StatsValueSchema, required=False)
    gamesStarted     = fields.Nested(StatsValueSchema, required=False)
    avgGameScore     = fields.Nested(StatsValueSchema, required=False)
    qualityStarts    = fields.Nested(StatsValueSchema, required=False)
    inheritedRunners = fields.Nested(StatsValueSchema, required=False)
    inheritedRunnersScored = fields.Nested(StatsValueSchema, required=False)
    playerRating     = fields.Nested(StatsValueSchema, required=False)
    atBats           = fields.Nested(StatsValueSchema, required=False)
    opponentTotalBases = fields.Nested(StatsValueSchema, required=False)
    isQualified      = fields.Nested(StatsValueSchema, required=False)
    isQualifiedSaves = fields.Nested(StatsValueSchema, required=False)
    fullInnings      = fields.Nested(StatsValueSchema, required=False)
    partInnings      = fields.Nested(StatsValueSchema, required=False)
    blownSaves       = fields.Nested(StatsValueSchema, required=False)
    innings          = fields.Nested(StatsValueSchema, required=False)
    ERA              = fields.Nested(StatsValueSchema, required=False)
    WHIP             = fields.Nested(StatsValueSchema, required=False)
    winPct           = fields.Nested(StatsValueSchema, required=False)
    caughtStealingPct = fields.Nested(StatsValueSchema, required=False)
    groundToFlyRatio = fields.Nested(StatsValueSchema, required=False)
    pitchesPerStart  = fields.Nested(StatsValueSchema, required=False)
    pitchesPerInning = fields.Nested(StatsValueSchema, required=False)
    pitchesPerPlateAppearance = fields.Nested(StatsValueSchema, required=False)
    runSupportAvg    = fields.Nested(StatsValueSchema, required=False)
    opponentAvg      = fields.Nested(StatsValueSchema, required=False)
    opponentSlugAvg  = fields.Nested(StatsValueSchema, required=False)
    opponentOnBasePct = fields.Nested(StatsValueSchema, required=False)
    opponentOPS      = fields.Nested(StatsValueSchema, required=False)
    savePct          = fields.Nested(StatsValueSchema, required=False)
    strikeoutsPerNineInnings = fields.Nested(StatsValueSchema, required=False)
    strikeoutToWalkRatio = fields.Nested(StatsValueSchema, required=False)
    toughLosses      = fields.Nested(StatsValueSchema, required=False)
    cheapWins        = fields.Nested(StatsValueSchema, required=False)
    saveOpportunitiesPerWin = fields.Nested(StatsValueSchema, required=False)
    pitchCount       = fields.Nested(StatsValueSchema, required=False)
    strikes          = fields.Nested(StatsValueSchema, required=False)
    strikePitchRatio = fields.Nested(StatsValueSchema, required=False)
    hitByPitch       = fields.Nested(StatsValueSchema, required=False)
    sacHits          = fields.Nested(StatsValueSchema, required=False)
    GIDPs            = fields.Nested(StatsValueSchema, required=False)
    grandSlamHomeRuns = fields.Nested(StatsValueSchema, required=False)
    runnersLeftOnBase = fields.Nested(StatsValueSchema, required=False)
    gameWinningRBIs  = fields.Nested(StatsValueSchema, required=False)
    pinchAtBats      = fields.Nested(StatsValueSchema, required=False)
    pinchHits        = fields.Nested(StatsValueSchema, required=False)
    isQualifiedSteals = fields.Nested(StatsValueSchema, required=False)
    totalBases       = fields.Nested(StatsValueSchema, required=False)
    plateAppearances = fields.Nested(StatsValueSchema, required=False)
    projectedHomeRuns = fields.Nested(StatsValueSchema, required=False)
    extraBaseHits    = fields.Nested(StatsValueSchema, required=False)
    runsCreated      = fields.Nested(StatsValueSchema, required=False)
    avg              = fields.Nested(StatsValueSchema, required=False)
    pinchAvg         = fields.Nested(StatsValueSchema, required=False)
    slugAvg          = fields.Nested(StatsValueSchema, required=False)
    secondaryAvg     = fields.Nested(StatsValueSchema, required=False)
    onBasePct        = fields.Nested(StatsValueSchema, required=False)
    OPS              = fields.Nested(StatsValueSchema, required=False)
    runsCreatedPer27Outs = fields.Nested(StatsValueSchema, required=False)
    batterRating     = fields.Nested(StatsValueSchema, required=False)
    atBatsPerHomeRun = fields.Nested(StatsValueSchema, required=False)
    stolenBasePct    = fields.Nested(StatsValueSchema, required=False)
    isolatedPower    = fields.Nested(StatsValueSchema, required=False)
    walkToStrikeoutRatio = fields.Nested(StatsValueSchema, required=False)
    walksPerPlateAppearance = fields.Nested(StatsValueSchema, required=False)
    secondaryAvgMinusBA = fields.Nested(StatsValueSchema, required=False)
    runsProduced     = fields.Nested(StatsValueSchema, required=False)
    runsRatio        = fields.Nested(StatsValueSchema, required=False)
    patienceRatio    = fields.Nested(StatsValueSchema, required=False)
    MLBRating        = fields.Nested(StatsValueSchema, required=False)
    WARBR            = fields.Nested(StatsValueSchema, required=False)
    doublePlays      = fields.Nested(StatsValueSchema, required=False)
    opportunities    = fields.Nested(StatsValueSchema, required=False)
    errors           = fields.Nested(StatsValueSchema, required=False)
    passedBalls      = fields.Nested(StatsValueSchema, required=False)
    assists          = fields.Nested(StatsValueSchema, required=False)
    outfieldAssists  = fields.Nested(StatsValueSchema, required=False)
    pickoffs         = fields.Nested(StatsValueSchema, required=False)
    putouts          = fields.Nested(StatsValueSchema, required=False)
    outsOnField      = fields.Nested(StatsValueSchema, required=False)
    triplePlays      = fields.Nested(StatsValueSchema, required=False)
    ballsInZone      = fields.Nested(StatsValueSchema, required=False)
    extraBases       = fields.Nested(StatsValueSchema, required=False)
    outsMade         = fields.Nested(StatsValueSchema, required=False)
    catcherThirdInningsPlayed = fields.Nested(StatsValueSchema, required=False)
    catcherCaughtStealing = fields.Nested(StatsValueSchema, required=False)
    catcherStolenBasesAllowed = fields.Nested(StatsValueSchema, required=False)
    catcherEarnedRuns = fields.Nested(StatsValueSchema, required=False)
    isQualifiedCatcher = fields.Nested(StatsValueSchema, required=False)
    isQualifiedPitcher = fields.Nested(StatsValueSchema, required=False)
    successfulChances = fields.Nested(StatsValueSchema, required=False)
    totalChances     = fields.Nested(StatsValueSchema, required=False)
    fullInningsPlayed = fields.Nested(StatsValueSchema, required=False)
    partInningsPlayed = fields.Nested(StatsValueSchema, required=False)
    fieldingPct      = fields.Nested(StatsValueSchema, required=False)
    rangeFactor      = fields.Nested(StatsValueSchema, required=False)
    zoneRating       = fields.Nested(StatsValueSchema, required=False)
    catcherCaughtStealingPct = fields.Nested(StatsValueSchema, required=False)
    catcherERA       = fields.Nested(StatsValueSchema, required=False)
    defWARBR         = fields.Nested(StatsValueSchema, required=False)

    # Football Specific
    divisionRecord   = fields.Nested(StatsValueSchema, required=False)
    divisionWins     = fields.Nested(StatsValueSchema, required=False)
    divisionTies     = fields.Nested(StatsValueSchema, required=False)
    divisionLosses   = fields.Nested(StatsValueSchema, required=False)
    differential     = fields.Nested(StatsValueSchema, required=False)
    assistTackles    = fields.Nested(StatsValueSchema, required=False)
    avgInterceptionYards = fields.Nested(StatsValueSchema, required=False)
    avgSackYards     = fields.Nested(StatsValueSchema, required=False)
    avgStuffYards    = fields.Nested(StatsValueSchema, required=False)
    blockedFieldGoalTouchdowns = fields.Nested(StatsValueSchema, required=False)
    blockedPuntTouchdowns = fields.Nested(StatsValueSchema, required=False)
    defensiveTouchdowns = fields.Nested(StatsValueSchema, required=False)
    hurries          = fields.Nested(StatsValueSchema, required=False)
    kicksBlocked     = fields.Nested(StatsValueSchema, required=False)
    longInterception = fields.Nested(StatsValueSchema, required=False)
    miscTouchdowns   = fields.Nested(StatsValueSchema, required=False)
    passesBattedDown = fields.Nested(StatsValueSchema, required=False)
    passesDefended   = fields.Nested(StatsValueSchema, required=False)
    twoPtReturns     = fields.Nested(StatsValueSchema, required=False)
    sacks            = fields.Nested(StatsValueSchema, required=False)
    sackYards        = fields.Nested(StatsValueSchema, required=False)
    safeties         = fields.Nested(StatsValueSchema, required=False)
    soloTackles      = fields.Nested(StatsValueSchema, required=False)
    stuffs           = fields.Nested(StatsValueSchema, required=False)
    stuffYards       = fields.Nested(StatsValueSchema, required=False)
    tacklesForLoss   = fields.Nested(StatsValueSchema, required=False)
    totalTackles     = fields.Nested(StatsValueSchema, required=False)
    interceptions    = fields.Nested(StatsValueSchema, required=False)
    interceptionTouchdowns = fields.Nested(StatsValueSchema, required=False)
    interceptionYards = fields.Nested(StatsValueSchema, required=False)
    avgKickoffReturnYards = fields.Nested(StatsValueSchema, required=False)
    avgKickoffYards  = fields.Nested(StatsValueSchema, required=False)
    extraPointAttempts = fields.Nested(StatsValueSchema, required=False)
    extraPointPct    = fields.Nested(StatsValueSchema, required=False)
    extraPointsBlocked = fields.Nested(StatsValueSchema, required=False)
    extraPointsBlockedPct = fields.Nested(StatsValueSchema, required=False)
    extraPointsMade  = fields.Nested(StatsValueSchema, required=False)
    fairCatches      = fields.Nested(StatsValueSchema, required=False)
    fairCatchPct     = fields.Nested(StatsValueSchema, required=False)
    fieldGoalAttempts = fields.Nested(StatsValueSchema, required=False)
    fieldGoalAttempts1_19 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalAttempts20_29 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalAttempts30_39 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalAttempts40_49 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalAttempts50 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalAttemptYards = fields.Nested(StatsValueSchema, required=False)
    fieldGoalPct     = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsBlocked = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsBlockedPct = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMade   = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMade1_19 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMade20_29 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMade30_39 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMade40_49 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMade50 = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMadeYards = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsMissedYards = fields.Nested(StatsValueSchema, required=False)
    kickoffReturns   = fields.Nested(StatsValueSchema, required=False)
    kickoffReturnTouchdowns = fields.Nested(StatsValueSchema, required=False)
    kickoffReturnYards = fields.Nested(StatsValueSchema, required=False)
    kickoffs         = fields.Nested(StatsValueSchema, required=False)
    kickoffYards     = fields.Nested(StatsValueSchema, required=False)
    longFieldGoalAttempt = fields.Nested(StatsValueSchema, required=False)
    longFieldGoalMade = fields.Nested(StatsValueSchema, required=False)
    longKickoff      = fields.Nested(StatsValueSchema, required=False)
    totalKickingPoints = fields.Nested(StatsValueSchema, required=False)
    touchbackPct     = fields.Nested(StatsValueSchema, required=False)
    touchbacks       = fields.Nested(StatsValueSchema, required=False)
    avgGain          = fields.Nested(StatsValueSchema, required=False)
    completionPct    = fields.Nested(StatsValueSchema, required=False)
    completions      = fields.Nested(StatsValueSchema, required=False)
    ESPNQBRating     = fields.Nested(StatsValueSchema, required=False)
    interceptionPct  = fields.Nested(StatsValueSchema, required=False)
    longPassing = fields.Nested(StatsValueSchema, required=False)
    miscYards = fields.Nested(StatsValueSchema, required=False)
    netPassingYards  = fields.Nested(StatsValueSchema, required=False)
    netPassingYardsPerGame = fields.Nested(StatsValueSchema, required=False)
    netTotalYards    = fields.Nested(StatsValueSchema, required=False)
    netYardsPerGame  = fields.Nested(StatsValueSchema, required=False)
    passingAttempts  = fields.Nested(StatsValueSchema, required=False)
    passingBigPlays  = fields.Nested(StatsValueSchema, required=False)
    passingFirstDowns = fields.Nested(StatsValueSchema, required=False)
    passingFumbles   = fields.Nested(StatsValueSchema, required=False)
    passingFumblesLost = fields.Nested(StatsValueSchema, required=False)
    passingTouchdownPct = fields.Nested(StatsValueSchema, required=False)
    passingTouchdowns = fields.Nested(StatsValueSchema, required=False)
    passingYards     = fields.Nested(StatsValueSchema, required=False)
    passingYardsAfterCatch = fields.Nested(StatsValueSchema, required=False)
    passingYardsAtCatch = fields.Nested(StatsValueSchema, required=False)
    passingYardsPerGame = fields.Nested(StatsValueSchema, required=False)
    QBRating         = fields.Nested(StatsValueSchema, required=False)
    sackYardsLost    = fields.Nested(StatsValueSchema, required=False)
    totalOffensivePlays = fields.Nested(StatsValueSchema, required=False)
    totalPoints      = fields.Nested(StatsValueSchema, required=False)
    totalPointsPerGame = fields.Nested(StatsValueSchema, required=False)
    totalTouchdowns  = fields.Nested(StatsValueSchema, required=False)
    totalYards       = fields.Nested(StatsValueSchema, required=False)
    totalYardsFromScrimmage = fields.Nested(StatsValueSchema, required=False)
    twoPointPassConvs = fields.Nested(StatsValueSchema, required=False)
    twoPtPass        = fields.Nested(StatsValueSchema, required=False)
    twoPtPassAttempts = fields.Nested(StatsValueSchema, required=False)
    yardsFromScrimmagePerGame = fields.Nested(StatsValueSchema, required=False)
    yardsPerCompletion = fields.Nested(StatsValueSchema, required=False)
    yardsPerGame     = fields.Nested(StatsValueSchema, required=False)
    yardsPerPassAttempt = fields.Nested(StatsValueSchema, required=False)
    quarterbackRating = fields.Nested(StatsValueSchema, required=False)
    ESPNRBRating     = fields.Nested(StatsValueSchema, required=False)
    longRushing      = fields.Nested(StatsValueSchema, required=False)
    rushingAttempts  = fields.Nested(StatsValueSchema, required=False)
    rushingBigPlays  = fields.Nested(StatsValueSchema, required=False)
    rushingFirstDowns = fields.Nested(StatsValueSchema, required=False)
    rushingFumbles   = fields.Nested(StatsValueSchema, required=False)
    rushingFumblesLost = fields.Nested(StatsValueSchema, required=False)
    rushingTouchdowns = fields.Nested(StatsValueSchema, required=False)
    rushingYards     = fields.Nested(StatsValueSchema, required=False)
    rushingYardsPerGame = fields.Nested(StatsValueSchema, required=False)
    stuffYardsLost   = fields.Nested(StatsValueSchema, required=False)
    twoPointRushConvs = fields.Nested(StatsValueSchema, required=False)
    twoPtRush        = fields.Nested(StatsValueSchema, required=False)
    twoPtRushAttempts = fields.Nested(StatsValueSchema, required=False)
    yardsPerRushAttempt = fields.Nested(StatsValueSchema, required=False)
    ESPNWRRating = fields.Nested(StatsValueSchema, required=False)
    longReception = fields.Nested(StatsValueSchema, required=False)
    receivingBigPlays = fields.Nested(StatsValueSchema, required=False)
    receivingFirstDowns = fields.Nested(StatsValueSchema, required=False)
    receivingFumbles = fields.Nested(StatsValueSchema, required=False)
    receivingFumblesLost = fields.Nested(StatsValueSchema, required=False)
    receivingTargets = fields.Nested(StatsValueSchema, required=False)
    receivingTouchdowns = fields.Nested(StatsValueSchema, required=False)
    receivingYards = fields.Nested(StatsValueSchema, required=False)
    receivingYardsAfterCatch = fields.Nested(StatsValueSchema, required=False)
    receivingYardsAtCatch = fields.Nested(StatsValueSchema, required=False)
    receivingYardsPerGame = fields.Nested(StatsValueSchema, required=False)
    receptions = fields.Nested(StatsValueSchema, required=False)
    twoPointRecConvs = fields.Nested(StatsValueSchema, required=False)
    twoPtReception = fields.Nested(StatsValueSchema, required=False)
    twoPtReceptionAttempts = fields.Nested(StatsValueSchema, required=False)
    yardsPerReception = fields.Nested(StatsValueSchema, required=False)
    avgPuntReturnYards = fields.Nested(StatsValueSchema, required=False)
    grossAvgPuntYards = fields.Nested(StatsValueSchema, required=False)
    longPunt = fields.Nested(StatsValueSchema, required=False)
    netAvgPuntYards = fields.Nested(StatsValueSchema, required=False)
    puntReturns = fields.Nested(StatsValueSchema, required=False)
    puntReturnYards = fields.Nested(StatsValueSchema, required=False)
    punts = fields.Nested(StatsValueSchema, required=False)
    puntsBlocked = fields.Nested(StatsValueSchema, required=False)
    puntsBlockedPct = fields.Nested(StatsValueSchema, required=False)
    puntsInside10 = fields.Nested(StatsValueSchema, required=False)
    puntsInside10Pct = fields.Nested(StatsValueSchema, required=False)
    puntsInside20 = fields.Nested(StatsValueSchema, required=False)
    puntsInside20Pct = fields.Nested(StatsValueSchema, required=False)
    puntYards = fields.Nested(StatsValueSchema, required=False)
    defensivePoints = fields.Nested(StatsValueSchema, required=False)
    fieldGoals = fields.Nested(StatsValueSchema, required=False)
    kickExtraPoints = fields.Nested(StatsValueSchema, required=False)
    miscPoints = fields.Nested(StatsValueSchema, required=False)
    passingTouchdownsScoring = fields.Nested(StatsValueSchema, required=False)
    receivingTouchdownsScoring = fields.Nested(StatsValueSchema, required=False)
    returnTouchdowns = fields.Nested(StatsValueSchema, required=False)
    rushingTouchdownsScoring = fields.Nested(StatsValueSchema, required=False)
    totalTwoPointConvs = fields.Nested(StatsValueSchema, required=False)
    defFumbleReturns = fields.Nested(StatsValueSchema, required=False)
    defFumbleReturnYards = fields.Nested(StatsValueSchema, required=False)
    fumbleRecoveries = fields.Nested(StatsValueSchema, required=False)
    fumbleRecoveryYards = fields.Nested(StatsValueSchema, required=False)
    kickReturnFairCatches = fields.Nested(StatsValueSchema, required=False)
    kickReturnFairCatchPct = fields.Nested(StatsValueSchema, required=False)
    kickReturnFumbles = fields.Nested(StatsValueSchema, required=False)
    kickReturnFumblesLost = fields.Nested(StatsValueSchema, required=False)
    kickReturns = fields.Nested(StatsValueSchema, required=False)
    kickReturnTouchdowns = fields.Nested(StatsValueSchema, required=False)
    kickReturnYards = fields.Nested(StatsValueSchema, required=False)
    longKickReturn = fields.Nested(StatsValueSchema, required=False)
    longPuntReturn = fields.Nested(StatsValueSchema, required=False)
    miscFumbleReturns = fields.Nested(StatsValueSchema, required=False)
    miscFumbleReturnYards = fields.Nested(StatsValueSchema, required=False)
    oppFumbleRecoveries = fields.Nested(StatsValueSchema, required=False)
    oppFumbleRecoveryYards = fields.Nested(StatsValueSchema, required=False)
    oppSpecialTeamFumbleReturns = fields.Nested(StatsValueSchema, required=False)
    oppSpecialTeamFumbleReturnYards = fields.Nested(StatsValueSchema, required=False)
    puntReturnFairCatches = fields.Nested(StatsValueSchema, required=False)
    puntReturnFairCatchPct = fields.Nested(StatsValueSchema, required=False)
    puntReturnFumbles = fields.Nested(StatsValueSchema, required=False)
    puntReturnFumblesLost = fields.Nested(StatsValueSchema, required=False)
    puntReturnsStartedInsideThe10 = fields.Nested(StatsValueSchema, required=False)
    puntReturnsStartedInsideThe20 = fields.Nested(StatsValueSchema, required=False)
    puntReturnTouchdowns = fields.Nested(StatsValueSchema, required=False)
    specialTeamFumbleReturns = fields.Nested(StatsValueSchema, required=False)
    specialTeamFumbleReturnYards = fields.Nested(StatsValueSchema, required=False)
    yardsPerKickReturn = fields.Nested(StatsValueSchema, required=False)
    yardsPerPuntReturn = fields.Nested(StatsValueSchema, required=False)
    yardsPerReturn   = fields.Nested(StatsValueSchema, required=False)
    firstDowns       = fields.Nested(StatsValueSchema, required=False)
    firstDownsPassing = fields.Nested(StatsValueSchema, required=False)
    firstDownsPenalty = fields.Nested(StatsValueSchema, required=False)
    firstDownsPerGame = fields.Nested(StatsValueSchema, required=False)
    firstDownsRushing = fields.Nested(StatsValueSchema, required=False)
    fourthDownAttempts = fields.Nested(StatsValueSchema, required=False)
    fourthDownConvPct = fields.Nested(StatsValueSchema, required=False)
    fourthDownConvs  = fields.Nested(StatsValueSchema, required=False)
    fumblesLost      = fields.Nested(StatsValueSchema, required=False)
    possessionTimeSeconds = fields.Nested(StatsValueSchema, required=False)
    redzoneEfficiencyPct = fields.Nested(StatsValueSchema, required=False)
    redzoneFieldGoalPct = fields.Nested(StatsValueSchema, required=False)
    redzoneScoringPct = fields.Nested(StatsValueSchema, required=False)
    redzoneTouchdownPct = fields.Nested(StatsValueSchema, required=False)
    thirdDownAttempts = fields.Nested(StatsValueSchema, required=False)
    thirdDownConvPct = fields.Nested(StatsValueSchema, required=False)
    thirdDownConvs   = fields.Nested(StatsValueSchema, required=False)
    totalGiveaways   = fields.Nested(StatsValueSchema, required=False)
    totalPenalties   = fields.Nested(StatsValueSchema, required=False)
    totalPenaltyYards = fields.Nested(StatsValueSchema, required=False)
    totalTakeaways   = fields.Nested(StatsValueSchema, required=False)
    turnOverDifferential = fields.Nested(StatsValueSchema, required=False)

    # added with hockey
    games = fields.Nested(StatsValueSchema, required=False)
    timeOnIce = fields.Nested(StatsValueSchema, required=False)
    shotDifferential = fields.Nested(StatsValueSchema, required=False)
    goalDifferential = fields.Nested(StatsValueSchema, required=False)
    PIMDifferential = fields.Nested(StatsValueSchema, required=False)
    overtimeLosses = fields.Nested(StatsValueSchema, required=False)
    goals = fields.Nested(StatsValueSchema, required=False)
    avgGoals = fields.Nested(StatsValueSchema, required=False)
    shotsTotal = fields.Nested(StatsValueSchema, required=False)
    avgShots = fields.Nested(StatsValueSchema, required=False)
    powerPlayGoals = fields.Nested(StatsValueSchema, required=False)
    powerPlayAssists = fields.Nested(StatsValueSchema, required=False)
    powerPlayOpportunities = fields.Nested(StatsValueSchema, required=False)
    powerPlayPct = fields.Nested(StatsValueSchema, required=False)
    shortHandedGoals = fields.Nested(StatsValueSchema, required=False)
    shortHandedAssists = fields.Nested(StatsValueSchema, required=False)
    shootoutAttempts = fields.Nested(StatsValueSchema, required=False)
    shootoutGoals = fields.Nested(StatsValueSchema, required=False)
    shootoutShotPct = fields.Nested(StatsValueSchema, required=False)
    emptyNetGoalsFor = fields.Nested(StatsValueSchema, required=False)
    shootingPct = fields.Nested(StatsValueSchema, required=False)
    unassistedGoals = fields.Nested(StatsValueSchema, required=False)
    goalsAgainst = fields.Nested(StatsValueSchema, required=False)
    avgGoalsAgainst = fields.Nested(StatsValueSchema, required=False)
    shotsAgainst = fields.Nested(StatsValueSchema, required=False)
    avgShotsAgainst = fields.Nested(StatsValueSchema, required=False)
    penaltyKillPct = fields.Nested(StatsValueSchema, required=False)
    powerPlayGoalsAgainst = fields.Nested(StatsValueSchema, required=False)
    shortHandedGoalsAgainst = fields.Nested(StatsValueSchema, required=False)
    shootoutSaves = fields.Nested(StatsValueSchema, required=False)
    shootoutShotsAgainst = fields.Nested(StatsValueSchema, required=False)
    shootoutSavePct = fields.Nested(StatsValueSchema, required=False)
    timesShortHanded = fields.Nested(StatsValueSchema, required=False)
    emptyNetGoalsAgainst = fields.Nested(StatsValueSchema, required=False)
    shutoutsAgainst = fields.Nested(StatsValueSchema, required=False)
    penaltyMinutes = fields.Nested(StatsValueSchema, required=False)
    penaltyMinutesAgainst = fields.Nested(StatsValueSchema, required=False)
    majorPenalties = fields.Nested(StatsValueSchema, required=False)
    minorPenalties = fields.Nested(StatsValueSchema, required=False)
    matchPenalties = fields.Nested(StatsValueSchema, required=False)
    misconducts = fields.Nested(StatsValueSchema, required=False)
    gameMisconducts = fields.Nested(StatsValueSchema, required=False)
    boardingPenalties = fields.Nested(StatsValueSchema, required=False)
    unsportsmanlikePenalties = fields.Nested(StatsValueSchema, required=False)
    fightingPenalties = fields.Nested(StatsValueSchema, required=False)
    avgFights = fields.Nested(StatsValueSchema, required=False)
    timeBetweenFights = fields.Nested(StatsValueSchema, required=False)
    instigatorPenalties = fields.Nested(StatsValueSchema, required=False)
    chargingPenalties = fields.Nested(StatsValueSchema, required=False)
    hookingPenalties = fields.Nested(StatsValueSchema, required=False)
    trippingPenalties = fields.Nested(StatsValueSchema, required=False)
    roughingPenalties = fields.Nested(StatsValueSchema, required=False)
    holdingPenalties = fields.Nested(StatsValueSchema, required=False)
    interferencePenalties = fields.Nested(StatsValueSchema, required=False)
    slashingPenalties = fields.Nested(StatsValueSchema, required=False)
    highStickingPenalties = fields.Nested(StatsValueSchema, required=False)
    crossCheckingPenalties = fields.Nested(StatsValueSchema, required=False)
    stickHoldingPenalties = fields.Nested(StatsValueSchema, required=False)
    goalieInterferencePenalties = fields.Nested(StatsValueSchema, required=False)
    elbowingPenalties = fields.Nested(StatsValueSchema, required=False)
    divingPenalties = fields.Nested(StatsValueSchema, required=False)
    awayOtLosses = fields.Nested(StatsValueSchema, required=False)
    pointsDiff = fields.Nested(StatsValueSchema, required=False)
    shootoutWins = fields.Nested(StatsValueSchema, required=False)
    shootoutLosses = fields.Nested(StatsValueSchema, required=False)
    awayWins = fields.Nested(StatsValueSchema, required=False)
    awayLosses = fields.Nested(StatsValueSchema, required=False)
    otWins = fields.Nested(StatsValueSchema, required=False)
    otLosses = fields.Nested(StatsValueSchema, required=False)
    homeOtLosses = fields.Nested(StatsValueSchema, required=False)
    awayTies = fields.Nested(StatsValueSchema, required=False)
    rotWins = fields.Nested(StatsValueSchema, required=False)
    production = fields.Nested(StatsValueSchema, required=False)
    faceoffsLost = fields.Nested(StatsValueSchema, required=False)
    faceoffsWon = fields.Nested(StatsValueSchema, required=False)
    totalFaceOffs = fields.Nested(StatsValueSchema, required=False)
    gameWinningGoals = fields.Nested(StatsValueSchema, required=False)
    gameTyingGoals = fields.Nested(StatsValueSchema, required=False)
    shifts = fields.Nested(StatsValueSchema, required=False)
    gameStarted = fields.Nested(StatsValueSchema, required=False)
    plusMinus = fields.Nested(StatsValueSchema, required=False)
    blockedShots = fields.Nested(StatsValueSchema, required=False)

    # added with Basketball
    avg48Points = fields.Nested(StatsValueSchema, required=False)
    trueShootingPct = fields.Nested(StatsValueSchema, required=False)
    avgFieldGoalsMade = fields.Nested(StatsValueSchema, required=False)
    avgThreePointFieldGoalsMade = fields.Nested(StatsValueSchema, required=False)
    avg48ThreePointFieldGoalsAttempted = fields.Nested(StatsValueSchema, required=False)
    avgTeamTurnovers = fields.Nested(StatsValueSchema, required=False)
    threePointPct = fields.Nested(StatsValueSchema, required=False)
    avgFreeThrowsAttempted = fields.Nested(StatsValueSchema, required=False)
    avg48ThreePointFieldGoalsMade = fields.Nested(StatsValueSchema, required=False)
    freeThrowPct = fields.Nested(StatsValueSchema, required=False)
    possessions = fields.Nested(StatsValueSchema, required=False)
    turnovers = fields.Nested(StatsValueSchema, required=False)
    pointsPerEstimatedPossessions = fields.Nested(StatsValueSchema, required=False)
    avgFreeThrowsMade = fields.Nested(StatsValueSchema, required=False)
    avg48Turnovers = fields.Nested(StatsValueSchema, required=False)
    avgOffensiveRebounds = fields.Nested(StatsValueSchema, required=False)
    threePointFieldGoalsMade = fields.Nested(StatsValueSchema, required=False)
    offReboundRate = fields.Nested(StatsValueSchema, required=False)
    offensiveRebounds = fields.Nested(StatsValueSchema, required=False)
    avgPoints = fields.Nested(StatsValueSchema, required=False)
    twoPointFieldGoalsMade = fields.Nested(StatsValueSchema, required=False)
    avgEstimatedPossessions = fields.Nested(StatsValueSchema, required=False)
    avgFieldGoalsAttempted = fields.Nested(StatsValueSchema, required=False)
    pointsInPaint = fields.Nested(StatsValueSchema, required=False)
    freeThrowsAttempted = fields.Nested(StatsValueSchema, required=False)
    shootingEfficiency = fields.Nested(StatsValueSchema, required=False)
    avgThreePointFieldGoalsAttempted = fields.Nested(StatsValueSchema, required=False)
    fieldGoalsAttempted = fields.Nested(StatsValueSchema, required=False)
    scoringEfficiency = fields.Nested(StatsValueSchema, required=False)
    twoPointFieldGoalPct = fields.Nested(StatsValueSchema, required=False)
    avg48FreeThrowsMade = fields.Nested(StatsValueSchema, required=False)
    turnoverRatio = fields.Nested(StatsValueSchema, required=False)
    fastBreakPoints = fields.Nested(StatsValueSchema, required=False)
    estimatedPossessions = fields.Nested(StatsValueSchema, required=False)
    avg48FieldGoalsAttempted = fields.Nested(StatsValueSchema, required=False)
    freeThrowsMade = fields.Nested(StatsValueSchema, required=False)
    teamTurnovers = fields.Nested(StatsValueSchema, required=False)
    effectiveFGPct = fields.Nested(StatsValueSchema, required=False)
    avgTurnovers = fields.Nested(StatsValueSchema, required=False)
    avg48FieldGoalsMade = fields.Nested(StatsValueSchema, required=False)
    threePointFieldGoalsAttempted = fields.Nested(StatsValueSchema, required=False)
    avg48FreeThrowsAttempted = fields.Nested(StatsValueSchema, required=False)
    avg48Assists = fields.Nested(StatsValueSchema, required=False)
    assistRatio = fields.Nested(StatsValueSchema, required=False)
    avg48OffensiveRebounds = fields.Nested(StatsValueSchema, required=False)
    twoPointFieldGoalsAttempted = fields.Nested(StatsValueSchema, required=False)
    threePointFieldGoalPct = fields.Nested(StatsValueSchema, required=False)
    offensiveReboundPct = fields.Nested(StatsValueSchema, required=False)
    paceFactor = fields.Nested(StatsValueSchema, required=False)
    avgAssists = fields.Nested(StatsValueSchema, required=False)
    ejections = fields.Nested(StatsValueSchema, required=False)
    avgFouls = fields.Nested(StatsValueSchema, required=False)
    technicalFouls = fields.Nested(StatsValueSchema, required=False)
    fouls = fields.Nested(StatsValueSchema, required=False)
    stealFoulRatio = fields.Nested(StatsValueSchema, required=False)
    avgTechnicalFouls = fields.Nested(StatsValueSchema, required=False)
    reboundRate = fields.Nested(StatsValueSchema, required=False)
    tripleDouble = fields.Nested(StatsValueSchema, required=False)
    avg48Disqualifications = fields.Nested(StatsValueSchema, required=False)
    avg48Rebounds = fields.Nested(StatsValueSchema, required=False)
    assistTurnoverRatio = fields.Nested(StatsValueSchema, required=False)
    avg48Fouls = fields.Nested(StatsValueSchema, required=False)
    fantasyRating = fields.Nested(StatsValueSchema, required=False)
    avg48Ejections = fields.Nested(StatsValueSchema, required=False)
    doubleDouble = fields.Nested(StatsValueSchema, required=False)
    avgEjections = fields.Nested(StatsValueSchema, required=False)
    avgMinutes = fields.Nested(StatsValueSchema, required=False)
    avgDisqualifications = fields.Nested(StatsValueSchema, required=False)
    blockFoulRatio = fields.Nested(StatsValueSchema, required=False)
    avgFlagrantFouls = fields.Nested(StatsValueSchema, required=False)
    flagrantFouls = fields.Nested(StatsValueSchema, required=False)
    avg48TechnicalFouls = fields.Nested(StatsValueSchema, required=False)
    minutes = fields.Nested(StatsValueSchema, required=False)
    totalTechnicalFouls = fields.Nested(StatsValueSchema, required=False)
    teamAssistTurnoverRatio = fields.Nested(StatsValueSchema, required=False)
    rebounds = fields.Nested(StatsValueSchema, required=False)
    avgTeamRebounds = fields.Nested(StatsValueSchema, required=False)
    ESPNRating = fields.Nested(StatsValueSchema, required=False)
    disqualifications = fields.Nested(StatsValueSchema, required=False)
    NBARating = fields.Nested(StatsValueSchema, required=False)
    avgRebounds = fields.Nested(StatsValueSchema, required=False)
    teamRebounds = fields.Nested(StatsValueSchema, required=False)
    stealTurnoverRatio = fields.Nested(StatsValueSchema, required=False)
    avg48FlagrantFouls = fields.Nested(StatsValueSchema, required=False)
    totalRebounds = fields.Nested(StatsValueSchema, required=False)
    avg48Blocks = fields.Nested(StatsValueSchema, required=False)
    steals = fields.Nested(StatsValueSchema, required=False)
    avg48DefensiveRebounds = fields.Nested(StatsValueSchema, required=False)
    avgDefensiveRebounds = fields.Nested(StatsValueSchema, required=False)
    blocks = fields.Nested(StatsValueSchema, required=False)
    turnoverPoints = fields.Nested(StatsValueSchema, required=False)
    defReboundRate = fields.Nested(StatsValueSchema, required=False)
    avg48Steals = fields.Nested(StatsValueSchema, required=False)
    avgBlocks = fields.Nested(StatsValueSchema, required=False)
    defensiveRebounds = fields.Nested(StatsValueSchema, required=False)
    avgSteals = fields.Nested(StatsValueSchema, required=False)

    # added with Soccer
    wonCorners = fields.Nested(StatsValueSchema, required=False)
    draws = fields.Nested(StatsValueSchema, required=False)
    subIns = fields.Nested(StatsValueSchema, required=False)
    avgRatingFromEditor = fields.Nested(StatsValueSchema, required=False)
    handBalls = fields.Nested(StatsValueSchema, required=False)
    subOuts = fields.Nested(StatsValueSchema, required=False)
    foulsCommitted = fields.Nested(StatsValueSchema, required=False)
    suspensions = fields.Nested(StatsValueSchema, required=False)
    avgRatingFromDataFeed = fields.Nested(StatsValueSchema, required=False)
    avgRatingFromCorrespondent = fields.Nested(StatsValueSchema, required=False)
    passPct = fields.Nested(StatsValueSchema, required=False)
    lostCorners = fields.Nested(StatsValueSchema, required=False)
    appearances = fields.Nested(StatsValueSchema, required=False)
    redCards = fields.Nested(StatsValueSchema, required=False)
    yellowCards = fields.Nested(StatsValueSchema, required=False)
    avgRatingFromUser = fields.Nested(StatsValueSchema, required=False)
    dnp = fields.Nested(StatsValueSchema, required=False)
    ownGoals = fields.Nested(StatsValueSchema, required=False)
    starts = fields.Nested(StatsValueSchema, required=False)
    foulsSuffered = fields.Nested(StatsValueSchema, required=False)
    tacklePct = fields.Nested(StatsValueSchema, required=False)
    totalClearance = fields.Nested(StatsValueSchema, required=False)
    effectiveClearance = fields.Nested(StatsValueSchema, required=False)
    effectiveTackles = fields.Nested(StatsValueSchema, required=False)
    inneffectiveTackles = fields.Nested(StatsValueSchema, required=False)
    goalAssists = fields.Nested(StatsValueSchema, required=False)
    shotAssists = fields.Nested(StatsValueSchema, required=False)
    totalThroughBalls = fields.Nested(StatsValueSchema, required=False)
    inaccurateCrosses = fields.Nested(StatsValueSchema, required=False)
    leftFootedShots = fields.Nested(StatsValueSchema, required=False)
    gameWinningAssists = fields.Nested(StatsValueSchema, required=False)
    freeKickShots = fields.Nested(StatsValueSchema, required=False)
    accurateLongBalls = fields.Nested(StatsValueSchema, required=False)
    shotsHeaded = fields.Nested(StatsValueSchema, required=False)
    throughBallPct = fields.Nested(StatsValueSchema, required=False)
    longballPct = fields.Nested(StatsValueSchema, required=False)
    inaccurateThroughBalls = fields.Nested(StatsValueSchema, required=False)
    offsides = fields.Nested(StatsValueSchema, required=False)
    penaltyKicksMissed = fields.Nested(StatsValueSchema, required=False)
    crossPct = fields.Nested(StatsValueSchema, required=False)
    shootOutMisses = fields.Nested(StatsValueSchema, required=False)
    penaltyKickShots = fields.Nested(StatsValueSchema, required=False)
    totalLongBalls = fields.Nested(StatsValueSchema, required=False)
    accurateCrosses = fields.Nested(StatsValueSchema, required=False)
    inaccuratePasses = fields.Nested(StatsValueSchema, required=False)
    accurateThroughBalls = fields.Nested(StatsValueSchema, required=False)
    shootOutGoals = fields.Nested(StatsValueSchema, required=False)
    shootOutPct = fields.Nested(StatsValueSchema, required=False)
    totalCrosses = fields.Nested(StatsValueSchema, required=False)
    inaccurateLongBalls = fields.Nested(StatsValueSchema, required=False)
    totalPasses = fields.Nested(StatsValueSchema, required=False)
    penaltyKickPct = fields.Nested(StatsValueSchema, required=False)
    penaltyKickGoals = fields.Nested(StatsValueSchema, required=False)
    freeKickGoals = fields.Nested(StatsValueSchema, required=False)
    headedGoals = fields.Nested(StatsValueSchema, required=False)
    accuratePasses = fields.Nested(StatsValueSchema, required=False)
    rightFootedShots = fields.Nested(StatsValueSchema, required=False)
    shotsOffTarget = fields.Nested(StatsValueSchema, required=False)
    shotPct = fields.Nested(StatsValueSchema, required=False)
    shotsOnTarget = fields.Nested(StatsValueSchema, required=False)
    shotsOnPost = fields.Nested(StatsValueSchema, required=False)
    totalGoals = fields.Nested(StatsValueSchema, required=False)
    totalShots = fields.Nested(StatsValueSchema, required=False)
    penaltyKickSavePct = fields.Nested(StatsValueSchema, required=False)
    shootOutKicksSaved = fields.Nested(StatsValueSchema, required=False)
    penaltyKickConceded = fields.Nested(StatsValueSchema, required=False)
    penaltyKicksSaved = fields.Nested(StatsValueSchema, required=False)
    crossesCaught = fields.Nested(StatsValueSchema, required=False)
    smothers = fields.Nested(StatsValueSchema, required=False)
    cleanSheet = fields.Nested(StatsValueSchema, required=False)
    goalsConceded = fields.Nested(StatsValueSchema, required=False)
    shotsFaced = fields.Nested(StatsValueSchema, required=False)
    punches = fields.Nested(StatsValueSchema, required=False)
    shootOutSavePct = fields.Nested(StatsValueSchema, required=False)
    unclaimedCrosses = fields.Nested(StatsValueSchema, required=False)
    penaltyKicksFaced = fields.Nested(StatsValueSchema, required=False)
    shootOutKicksFaced = fields.Nested(StatsValueSchema, required=False)
    partialCleenSheet = fields.Nested(StatsValueSchema, required=False)
    homePointsAgainst = fields.Nested(StatsValueSchema, required=False)
    awayPointsAgainst = fields.Nested(StatsValueSchema, required=False)
    homePointsFor = fields.Nested(StatsValueSchema, required=False)
    awayPointsFor = fields.Nested(StatsValueSchema, required=False)
    homeGamesPlayed = fields.Nested(StatsValueSchema, required=False)
    awayGamesPlayed = fields.Nested(StatsValueSchema, required=False)
    rank = fields.Nested(StatsValueSchema, required=False)
    timeEnded = fields.Nested(StatsValueSchema, required=False)
    timeStarted = fields.Nested(StatsValueSchema, required=False)
    secondAssists = fields.Nested(StatsValueSchema, required=False)
    freeKickPct = fields.Nested(StatsValueSchema, required=False)
    attemptsOutBox = fields.Nested(StatsValueSchema, required=False)
    attemptsInBox = fields.Nested(StatsValueSchema, required=False)

    # olympic soccer
    bronze           = fields.Nested(StatsValueSchema, required=False)
    silver           = fields.Nested(StatsValueSchema, required=False)
    gold             = fields.Nested(StatsValueSchema, required=False)
    totalMedals      = fields.Nested(StatsValueSchema, required=False)


class StatisticsTotalSchema(Schema):
    # baseball
    pitching         = fields.Nested(StatsSchema, required=False)
    batting          = fields.Nested(StatsSchema, required=False)
    fielding         = fields.Nested(StatsSchema, required=False)

    # football
    defensiveInterceptions = fields.Nested(StatsSchema, required=False)
    receiving        = fields.Nested(StatsSchema, required=False)
    kicking          = fields.Nested(StatsSchema, required=False)
    scoring          = fields.Nested(StatsSchema, required=False)
    passing          = fields.Nested(StatsSchema, required=False)
    defensive        = fields.Nested(StatsSchema, required=False)
    punting          = fields.Nested(StatsSchema, required=False)
    miscellaneous    = fields.Nested(StatsSchema, required=False)
    returning        = fields.Nested(StatsSchema, required=False)
    rushing          = fields.Nested(StatsSchema, required=False)

    # added with hockey
    offensive        = fields.Nested(StatsSchema, required=False)
    general          = fields.Nested(StatsSchema, required=False)
    penalties        = fields.Nested(StatsSchema, required=False)

    # added with Soccer
    goalKeeping      = fields.Nested(StatsSchema, required=False)


class StatisticsSchema(Schema):
    total            = fields.Nested(StatisticsTotalSchema, required=False)

    # added with football
    season           = fields.Nested(StatisticsTotalSchema, required=False)


class RecordStatsSchema(Schema):
    stats            = fields.Nested(StatsSchema, required=True)


class HandednessSchema(Schema):
    type             = fields.String(required=True)
    abbreviation     = fields.String(required=True)
    displayValue     = fields.String(required=True)


class RecordSchema(Schema):
    # added with Baseball
    total            = fields.Nested(RecordStatsSchema, required=False)  # not present in football
    home             = fields.Nested(RecordStatsSchema, required=False, allow_none=True)  # not present in football | null in basketball?
    away             = fields.Nested(RecordStatsSchema, required=False)  # not present in football
    lastTen          = fields.Nested(RecordStatsSchema, required=False)  # not present in football

    # added with Football
    vsOwnDivision    = fields.Nested(RecordStatsSchema, required=False, allow_none=True)
    vsOwnConference  = fields.Nested(RecordStatsSchema, required=False, allow_none=True)
    vsOwnLeague      = fields.Nested(RecordStatsSchema, required=False)
    homeRecord       = fields.Nested(RecordStatsSchema, required=False)
    season           = fields.Nested(RecordStatsSchema, required=False)
    vsLeague         = fields.Nested(RecordStatsSchema, required=False)
    awayRecord       = fields.Nested(RecordStatsSchema, required=False)

    # added with Hockey
    lastTenGames     = fields.Nested(RecordStatsSchema, required=False)

    # added with Basketball
    vsConf           = fields.Nested(RecordStatsSchema, required=False, allow_none=True)  # assuming type as only saw None so far
    vsDiv            = fields.Nested(RecordStatsSchema, required=False, allow_none=True)  # assuming type as only saw None so far
    road             = fields.Nested(RecordStatsSchema, required=False, allow_none=True)  # assuming type as only saw None so far

    # added with College Basketball
    vsApRankedTeams  = fields.Nested(RecordStatsSchema, required=False)
    vsUsaRankedTeams = fields.Nested(RecordStatsSchema, required=False)


class AthleteSchema(Schema):
    class Meta:
        unknown = RAISE

    id               = fields.String(required=True)
    uid              = fields.String(required=False)   # not present in some soccer players
    guid             = IntOrUUID(required=False)
    firstName        = fields.String(required=True)
    lastName         = fields.String(required=False)   # not present in some soccer players
    fullName         = fields.String(required=False)   # not present in some soccer players
    displayName      = fields.String(required=True)
    shortName        = fields.String(required=True)
    weight           = fields.Float(required=False)    # not present in some soccer players
    displayWeight    = fields.String(required=False)   # not present in some soccer players
    height           = fields.Float(required=False)    # not present in some soccer players
    displayHeight    = fields.String(required=False)   # not present in some soccer players
    age              = fields.Integer(required=False)  # not present in some football
    dateOfBirth      = fields.String(required=False)   # not present in some football
    birthPlace       = fields.Nested(CityStateCountrySchema, required=False)  # not present in some football
    jersey           = fields.String(required=False)   # not present in some football
    active           = fields.Boolean(required=False)  # not present in football
    experience       = fields.Nested(ExperienceSchema, required=False)  # missing for some hockey players

    # baseball
    bats             = fields.Nested(HandednessSchema, required=False)
    throws           = fields.Nested(HandednessSchema, required=False)

    # added @ football
    hand             = fields.Nested(HandednessSchema, required=False)

    # added @ hockey
    statistics       = fields.Nested(StatisticsSchema, required=False)

    # added @ basketball
    citizenship      = fields.String(required=False)

    # added @ soccer
    type             = fields.String(required=False)
    profiled         = fields.Boolean(required=False)
    linked           = fields.Boolean(required=False)

    # added with Soccer
    middleName       = fields.String(required=False)
    nickname         = fields.String(required=False)
    record           = fields.Nested(RecordSchema, required=False)

    # added with Golf
    debutYear        = fields.Integer(required=False)
    amateur          = fields.Boolean(required=False)


class AthletesSchema(Schema):
    """
        For Athlete listings where the Athlete ID isn't specified.

        Examples:
        /v3/sports/golf/athletes
    """

    class Meta:
        unknown = RAISE

    items = fields.List(fields.Nested(AthleteSchema), required=True)
    count = fields.Integer(required=True)


class TeamsSchema(Schema):
    class Meta:
        unknown = RAISE

    id               = fields.String(required=True)
    uid              = fields.String(required=False)    # missing from olympic soccer
    guid             = IntOrUUID(required=False)
    alternateId      = fields.String(required=False)
    slug             = fields.String(required=False)
    location         = fields.String(required=False)    # missing from olympic soccer
    name             = fields.String(required=False)
    abbreviation     = fields.String(required=True)
    nickname         = fields.String(required=False)
    displayName      = fields.String(required=True)
    shortDisplayName = fields.String(required=False)    # missing from olympic soccer
    color            = fields.String(required=False)
    alternateColor   = fields.String(required=False)
    active           = fields.Boolean(required=False)   # missing from olympic soccer
    allstar          = fields.Boolean(required=False)   # missing from olympic soccer
    statistics       = fields.Nested(StatisticsSchema, required=False)
    record           = fields.Nested(RecordSchema, required=False)
    athletes         = fields.List(fields.Nested(AthleteSchema), required=False)

    # added with soccer
    national         = fields.Boolean(required=False)


class StandingsEntriesSchema(Schema):
    id               = fields.String(required=False)
    athlete          = fields.Nested(AthleteSchema, required=False)


class SeasonStandingsSchema(Schema):
    name             = fields.String(required=True)
    entries          = fields.List(fields.Nested(StandingsEntriesSchema), required=False)


class STGBaseSchema(Schema):
    """
    Base Schema used by the following 2.
    """
    teams        = fields.List(fields.Nested(TeamsSchema), required=False)
    id           = fields.String(required=True)
    uid          = fields.String(required=True)
    slug         = fields.String(required=True)
    name         = fields.String(required=True)
    abbreviation = fields.String(required=True)
    shortName    = fields.String(required=True)
    midsizeName  = fields.String(required=True)
    isConference = fields.Boolean(required=False)


class SeasonTypeGroupChildrenSchema(STGBaseSchema):
    shortName    = fields.String(required=False)  # Not available in some football
    midsizeName  = fields.String(required=False)  # Not available in some football
    children     = fields.List(fields.Nested(STGBaseSchema), required=False)
    teams        = fields.List(fields.Nested(TeamsSchema), required=False)


class SeasonTypeGroupSchema(STGBaseSchema):
    abbreviation = fields.String(required=False)  # Not available in college basketball
    shortName    = fields.String(required=False)  # Not available in some football
    midsizeName  = fields.String(required=False)  # Not available in some football
    children     = fields.List(fields.Nested(SeasonTypeGroupChildrenSchema), required=False)
    teams        = fields.List(fields.Nested(TeamsSchema), required=False)


class SeasonTypeSchema(Schema):
    class Meta:
        unknown = RAISE

    id           = fields.String(required=True)
    type         = fields.Integer(required=True)
    name         = fields.String(required=True)
    abbreviation = fields.String(required=True)
    startDate    = fields.String(required=True)
    endDate      = fields.String(required=True)
    groups       = fields.List(fields.Nested(SeasonTypeGroupSchema), required=False)


class SeasonSchema(Schema):
    class Meta:
        unknown = RAISE

    year        = fields.Integer(required=True)
    startDate   = fields.String(required=True)
    endDate     = fields.String(required=True)
    description = fields.String(required=False)  # not all seasons have descriptions
    type        = fields.Nested(SeasonTypeSchema, required=False)

    # added for standings criteria in soccer example
    standings   = fields.Nested(SeasonStandingsSchema, required=False)

    displayName = fields.String(required=False)  # added with Golf


class LeagueSchema(Schema):
    class Meta:
        unknown = RAISE

    id           = fields.String(required=True)
    uid          = LeagueItemUID(required=True)  # needs further identification
    groupId      = fields.String(required=True)
    name         = fields.String(required=True)
    abbreviation = fields.String(required=False)  # Not present in Olympic Hockey
    shortName    = fields.String(required=True)
    midsizeName  = fields.String(required=False)  # Not present in all Football (only NCAA)
    slug         = fields.String(required=True)
    season       = fields.Nested(SeasonSchema, required=False)  # Hockey has a league instance with no season data
    seasons      = fields.List(fields.Nested(SeasonSchema), required=False)
    isTournament = fields.Boolean(required=False)  # added with Golf


class ScoringTypeSchema(Schema):
    name         = fields.String(required=True)
    displayName  = fields.String(required=True)
    abbreviation = fields.String(required=True)


class ScoreSchema(Schema):
    value            = fields.Float(required=True)
    displayValue     = fields.String(required=False)  # not present in olympic soccer

    # baseball specific?
    hits             = fields.Integer(required=False)
    errors           = fields.Integer(required=False)


class LinescoresSchema(ScoreSchema):
    period           = fields.Integer(required=True)


class CompetitorsSchema(Schema):
    id               = fields.String(required=True)
    uid              = fields.String(required=False)    # not present in olympic soccer | TODO: Address UID
    type             = fields.String(required=True)
    order            = fields.Integer(required=True)
    homeAway         = fields.String(required=False)    # not present in olympic soccer
    winner           = fields.Boolean(required=True)
    team             = fields.Nested(TeamsSchema, required=True)
    score            = fields.Nested(ScoreSchema, required=True)
    linescores       = fields.List(fields.Nested(LinescoresSchema), require=True)

    # olympic soccer specific?
    country          = fields.Nested(CountrySchema, required=False)


class OddsOddsSchema(Schema):
    summary          = fields.String(required=False)
    value            = fields.Float(required=False)
    handicap         = fields.Float(required=False)


class TeamOddsSchema(OddsOddsSchema):  # made OddsOdds schema due to eng premiere league sample oddities
    averageScore     = fields.Float(required=False)
    winPercentage    = fields.Float(required=False)
    favorite         = fields.Boolean(required=False)  # not present in soccer
    underdog         = fields.Boolean(required=False)  # not present in soccer
    moneyLine        = fields.Integer(required=False)
    moneyLineOdds    = fields.Float(required=False)
    moneyLineReturn  = fields.Float(required=False)
    spreadOdds       = fields.Float(required=False)
    spreadReturn     = fields.Float(required=False)

    # added with soccer eng premiere league
    odds            = fields.Nested(OddsOddsSchema, required=False)


class OddsProvider(Schema):
    id               = fields.String(required=True)
    name             = fields.String(required=True)
    priority         = fields.Integer(required=True)


class OddsSchema(Schema):
    valid            = fields.Boolean(required=False)   # not present in eng premiere league soccer example
    details          = fields.String(required=False)    # not present in eng premiere league soccer example
    spread           = fields.Float(required=False)
    initialSpread    = fields.Float(required=False)
    initialOverUnder = fields.Float(required=False)
    price            = fields.Float(required=False)
    overOdds         = fields.Float(required=False)
    underOdds        = fields.Float(required=False)
    overUnder        = fields.Float(required=False)
    awayTeamOdds     = fields.Nested(TeamOddsSchema, required=True)
    homeTeamOdds     = fields.Nested(TeamOddsSchema, required=True)
    homeBetUrl       = fields.String(required=False)
    awayBetUrl       = fields.String(required=False)

    # added during soccer
    drawOdds         = fields.Nested(TeamOddsSchema, required=False)
    drawBetUrl       = fields.String(required=False)
    provider         = fields.Nested(OddsProvider, required=False)


class PeriodSchema(Schema):
    type             = fields.String(required=False)  # not in football
    number           = fields.Integer(required=True)


class CoordinateSchema(Schema):
    x                = fields.Integer(required=True)
    y                = fields.Integer(required=True)


class CountSchema(Schema):
    balls            = fields.Integer(required=True)
    strikes          = fields.Integer(required=True)


class PlayTypeSchema(Schema):
    id               = fields.String(required=True)
    slug             = fields.String(required=True)
    text             = fields.String(required=True)
    abbreviation     = fields.String(required=False)
    alternativeText  = fields.String(required=False)


class PitchTypeSchema(Schema):
    id               = fields.String(required=True)
    text             = fields.String(required=True)
    abbreviation     = fields.String(required=True)


class BatsSchema(Schema):
    type             = fields.String(required=True)
    abbreviation     = fields.String(required=True)
    displayValue     = fields.String(required=True)


class ParticipantSchema(Schema):
    id               = fields.String(required=True)
    type             = fields.String(required=False)  # Not present in Basketball
    order            = fields.Integer(required=True)
    athlete          = fields.Nested(AthleteSchema, required=False)

    # added with Soccer
    jersey           = fields.String(required=False)  # why is this specified outside the athlete in soccer???
    statistics       = fields.Nested(StatisticsSchema, required=False)


class PlaySchema(Schema):
    id               = fields.String(required=True)
    sequenceNumber   = fields.String(required=True)
    text             = fields.String(required=False)
    alternativeText  = fields.String(required=False)
    shortAlternativeText = fields.String(required=False)
    awayScore        = fields.Integer(required=True)
    homeScore        = fields.Integer(required=True)
    valid            = fields.Boolean(required=False)  # not present in football
    scoringPlay      = fields.Boolean(required=True)
    priority         = fields.Boolean(required=True)
    scoreValue       = fields.Integer(required=True)
    modified         = fields.String(required=True)
    period           = fields.Nested(PeriodSchema, required=True)
    resultCount      = fields.Nested(CountSchema, required=False)  # not in football
    alternativeType  = fields.Nested(PlayTypeSchema, required=False)
    summaryType      = fields.String(required=False)
    shortText        = fields.String(required=False)
    shortPreviousPlayText = fields.String(required=False)
    previousPlayText = fields.String(required=False)

    bats             = fields.Nested(BatsSchema, required=False)
    batOrder         = fields.Integer(required=False)
    hitCoordinate    = fields.Nested(CoordinateSchema, required=False)
    trajectory       = fields.String(required=False)
    atBatId          = fields.String(required=False)

    pitchCount       = fields.Nested(CountSchema, required=False)
    pitchVelocity    = fields.Integer(required=False)
    pitchType        = fields.Nested(PitchTypeSchema, required=False)
    pitchCoordinate  = fields.Nested(CoordinateSchema, required=False)
    atBatPitchNumber = fields.Integer(required=False)
    strikeType       = fields.String(required=False)

    type             = fields.Nested(PlayTypeSchema, required=False)
    participants     = fields.List(fields.Nested(ParticipantSchema), required=False)

    # added during football dive
    statYardage      = fields.Integer(required=False)
    start            = fields.Nested(PlayStartEndSchema, required=False)
    end              = fields.Nested(PlayStartEndSchema, required=False)
    clock            = fields.Nested(StatsValueSchema, required=False)
    wallclock        = fields.String(required=False)
    scoringType      = fields.Nested(ScoringTypeSchema, required=False)
    mediaId          = fields.Integer(required=None)

    # added during basketball dive
    shootingPlay     = fields.Boolean(required=None)
    pointsAttempted  = fields.Integer(required=None)
    coordinate       = fields.Nested(CoordinateSchema, required=False)
    rawCoordinate    = fields.Nested(CoordinateSchema, required=False)

    # added during soccer dive
    yellowCard       = fields.Boolean(required=None)
    redCard          = fields.Boolean(required=None)
    penaltyKick      = fields.Boolean(required=None)
    ownGoal          = fields.Boolean(required=None)
    shootout         = fields.Boolean(required=None)
    hasVideoTagging  = fields.Boolean(required=None)
    modifiedDate     = fields.String(required=False)
    goalPositionX    = fields.Float(required=False)
    goalPositionY    = fields.Float(required=False)
    fieldPositionX   = fields.Float(required=False)
    fieldPositionY   = fields.Float(required=False)
    fieldPosition2X  = fields.Float(required=False)
    fieldPosition2Y  = fields.Float(required=False)
    addedClock       = fields.Nested(ScoreSchema, required=False)
    substitution     = fields.Boolean(required=False)

    # added with soccer
    team             = fields.Nested(TeamsSchema, required=False)


class PlaysSchema(Schema):
    class Meta:
        unknown = RAISE

    count            = fields.Integer(required=True)
    pageIndex        = fields.Integer(required=False)  # missing in Soccer
    pageSize         = fields.Integer(required=False)  # missing in Soccer
    pageCount        = fields.Integer(required=False)  # missing in Soccer
    items            = fields.List(fields.Nested(PlaySchema), required=True)


class SituationSchema(Schema):
    """
        Schema for Situations invoked from the CompetitionSchema.

        example:
        /v3/sports/baseball/mlb/events/381016118?enable=competitions(odds,status,situation(play,probability),competitors(team,score,linescores))

    """
    play             = fields.Nested(PlaySchema, required=False)  # Not present in a specific hockey instance

    # baseball
    balls            = fields.Integer(required=False)
    strikes          = fields.Integer(required=False)
    outs             = fields.Integer(required=False)

    # football (added in football, might apply elsewhere)
    distance         = fields.Integer(required=False)
    awayTimeouts     = CustomTimeout(required=False)  # TODO: Football is INT, Basketball is DICT -- FIX!
    homeTimeouts     = CustomTimeout(required=False)  # TODO: Football is INT, Basketball is DICT -- FIX!
    yardLine         = fields.Integer(required=False)
    down             = fields.Integer(required=False)
    isRedZone        = fields.Boolean(required=False)
    probability      = fields.Nested(ProbabilitySchema, required=False)

    # added in basketball
    awayFouls        = fields.Nested(FoulSchema, required=False)
    homeFouls        = fields.Nested(FoulSchema, required=False)

    # added in college basketball
    possessionArrow  = fields.String(required=False)


class ScoringSystemSchema(Schema):
    id               = fields.String(required=True)
    name             = fields.String(required=True)


class CompetitionSchema(Schema):
    """
        Schema for Competition Plays endpoint.

        example:
        /v3/sports/baseball/mlb/events/381016118/competitions/381016118/plays?enable=participants(athlete)

    """
    class Meta:
        unknown = RAISE

    id               = fields.String(required=True)
    uid              = fields.String(required=False)    # not present in olympic soccer | TODO: Write proper UID Validator
    date             = fields.String(required=True)
    timeOfDay        = fields.String(required=False)    # not present in football
    attendance       = fields.Integer(required=False)   # not present in olympic soccer
    timeValid        = fields.Boolean(required=True)
    dataFormat       = fields.String(required=False)    # not present in football
    neutralSite      = fields.Boolean(required=False)   # not present in olympic soccer
    duration         = fields.Nested(DurationSchema, required=False)
    status           = fields.Nested(StatusSchema, required=False)
    situation        = fields.Nested(SituationSchema, required=False)
    type             = fields.Nested(CompetitionTypeSchema, required=False)
    competitors      = fields.List(fields.Nested(CompetitorsSchema), required=False)
    odds             = fields.List(fields.Nested(OddsSchema), required=False)
    conferenceCompetition = fields.Boolean(required=False)  # not present in football

    # added during hockey
    lastUpdated      = fields.String(required=False)

    # added during soccer
    necessary        = fields.Boolean(required=False)
    divisionCompetition = fields.Boolean(required=False)

    # added during olympic soccer
    description      = fields.String(required=False)
    order            = fields.Integer(required=False)

    # added with Golf
    endDate          = fields.String(required=False)
    scoringSystem    = fields.Nested(ScoringSystemSchema, required=False)


class AlternateIdsSchema(Schema):
    sdr              = fields.String(required=True)


class PlayoffTypeSchema(Schema):
    id               = fields.String(required=True)
    description      = fields.String(required=True)
    minimumHoles     = fields.Integer(required=True)


class EventSchema(Schema):
    """
        Schema for individual Events such as:
        /v3/sports/football/nfl/events/400999173

        This is also used as the format for 'items' within EventsSchema
    """
    class Meta:
        unknown = RAISE

    id               = fields.String(required=True)
    uid              = fields.String(required=False)   # TODO: Write proper UID Validator
    date             = fields.String(required=False)
    name             = fields.String(required=True)
    shortName        = fields.String(required=True)
    timeValid        = fields.Boolean(required=False)
    competitions     = fields.List(fields.Nested(CompetitionSchema), required=False)

    # added with olympic soccer example 1
    type             = fields.String(required=False)
    slug             = fields.String(required=False)

    # added with Golf
    cutCount         = fields.Integer(required=False)
    cutScore         = fields.Integer(required=False)
    cutRound         = fields.Integer(required=False)
    timeZoneOffset   = fields.Integer(required=False)
    purse            = fields.Integer(required=False)
    numberOfRounds   = fields.Integer(required=False)
    primary          = fields.Boolean(required=False)
    guid             = fields.String(required=False)
    displayPurse     = fields.String(required=False)
    endDate          = fields.String(required=False)
    alternateIds     = fields.Nested(AlternateIdsSchema, required=False)
    playoffType      = fields.Nested(PlayoffTypeSchema, required=False)


class EventsSchema(Schema):
    """
        For Event listings where the Event ID isn't specified.

        Examples:
        /v3/sports/baseball/mlb/events/
        /v3/sports/football/nfl/events/
    """
    class Meta:
        unknown = RAISE

    items            = fields.List(fields.Nested(EventSchema), required=True)
    count            = fields.Integer(required=True)


class SportSchema(Schema):
    """
        Schema for individual sport endpoints such as (but not limited to):
        /v3/sports/baseball/
        /v3/sports/basketball/
        /v3/sports/hockey/

        This is also used as the format for 'items' within SportsSchema
    """
    class Meta:
        unknown = RAISE

    id               = fields.String(required=True)
    uid              = SportsItemUID(required=False)
    guid             = IntOrUUID(required=False)
    name             = fields.String(required=True)
    slug             = fields.String(required=True)
    leagues          = fields.List(fields.Nested(LeagueSchema), required=False)


class SportsSchema(Schema):
    """
        Schema for the endpoint: /v3/sports
    """
    class Meta:
        unknown = RAISE

    count            = fields.Integer(required=True)
    items            = fields.List(fields.Nested(SportSchema), required=True)


class InvalidMessageSchema(Schema):
    """
        Schema for the Invalid endpoint
    """

    class Meta:
        unknown = RAISE

    message        = fields.String(required=True)
    code           = fields.Integer(required=True)


class InvalidSchema(Schema):
    class Meta:
        unknown = RAISE

    error     = fields.Nested(InvalidMessageSchema, required=True)

if __name__ == '__main__':
    target = 'https://sports.core.api.espn.com/v3/sports/baseball?enable=leagues(seasons)'
    resp = requests.get(target)

    if resp.status_code == 200:
        try:
            page = SportSchema().load(resp.json())

        except ValidationError as ve:
            pprint(ve.messages)
        else:
            print(f'{target} received with status code {resp.status_code} has been Validated')
    else:
        print(f'Received unexpected status code {resp.status_code} from {target}')
