-- Revert trapparty:table_player from pg

BEGIN;

DROP TABLE trapparty.player;

COMMIT;
