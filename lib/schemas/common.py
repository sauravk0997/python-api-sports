#!/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64
from marshmallow import Schema, fields, INCLUDE, RAISE, ValidationError, pre_load


class IntOrUUID(fields.Field):
    def _deserialize(self, entry, attr, ctx, **k):
        if not isinstance(entry, int):
            try:
                fields.UUID().deserialize(entry)
            except ValidationError:
                raise ValidationError(f'{attr=} Field should be string or uuid')
        return entry


class SportsItemUID(fields.Field):
    def _deserialize(self, entry, attr, ctx, **k):
        if isinstance(entry, str) and entry:
            if entry.startswith('s:'):
                if entry[2::] == ctx['id']:
                    return entry
                raise ValidationError(f'SI {attr=} Field should be string with numeric value matching id - {ctx["id"]=} != {entry=}')
            raise ValidationError(f'SI {attr=} Field should be string starting with "s:" - {entry=}')
        raise ValidationError(f'SI {attr=} Field should be string - {entry=}')


class LeagueItemUID(fields.Field):
    def _deserialize(self, entryValue, attr, ctx, **k):
        if isinstance(entryValue, str) and entryValue:
            entry = entryValue.split("~")[1]
            if entry.startswith('l:'):
                if entry[2::] == ctx['id']:
                    return entryValue
                raise ValidationError(f'LI {attr=} Field should be string with numeric value matching id - {ctx["id"]=} != {entry=}')
            raise ValidationError(f'LI {attr=} Field should be string starting with "s:" - {entry=}')
        raise ValidationError(f'LI {attr=} Field should be string - {entryValue=}')


class CustomTimeout(fields.Field):
    def _deserialize(self, entry, attr, ctx, **k):
        if isinstance(entry, int):
            print('INT!')
        elif isinstance(entry, dict):
            print('DICT')
        else:
            raise ValidationError(f'CustomTimeout : Unexpected field type found. {type(entry)}')
