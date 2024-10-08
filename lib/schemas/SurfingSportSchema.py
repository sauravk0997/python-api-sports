#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from lib.schemas.common import LeagueItemUID
from lib.schemas.SportSchema import *
from marshmallow import RAISE


class SurfingSportSchema(SportSchema):
    class Meta:
        unknown = RAISE

