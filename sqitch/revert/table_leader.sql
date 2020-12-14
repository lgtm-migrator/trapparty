-- Revert trapparty:table_leader from pg

BEGIN;

DROP TABLE trapparty.leader;

COMMIT;
