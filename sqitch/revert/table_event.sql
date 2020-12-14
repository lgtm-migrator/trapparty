-- Revert trapparty:table_event from pg

BEGIN;

DROP TABLE trapparty.event;

COMMIT;
