-- Revert trapparty:type_enum_game_type from pg

BEGIN;

DROP TYPE trapparty.game_type;

COMMIT;
