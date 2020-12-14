-- Revert trapparty:table_team from pg

BEGIN;

DROP TABLE trapparty.team;

COMMIT;
