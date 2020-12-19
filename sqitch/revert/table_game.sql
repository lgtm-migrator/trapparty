-- Revert trapparty:table_game from pg

BEGIN;

DROP TABLE trapparty.game;

COMMIT;
