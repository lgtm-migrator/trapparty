-- Revert trapparty:table_participation from pg

BEGIN;

DROP TABLE trapparty_private.participation;

COMMIT;
