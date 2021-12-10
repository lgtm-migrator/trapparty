-- Revert trapparty:table_team_leader from pg

BEGIN;

DROP TABLE trapparty.team_leader;

COMMIT;
