-- Revert trapparty:schema_public from pg

BEGIN;

DROP SCHEMA trapparty;

COMMIT;
