-- Revert trapparty:table_jwt from pg

BEGIN;

DROP TABLE trapparty_private.jwt;

COMMIT;
