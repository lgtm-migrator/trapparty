-- Revert trapparty:schema_private from pg

BEGIN;

DROP SCHEMA trapparty_private;

COMMIT;
