-- Revert trapparty:type_jwt from pg

BEGIN;

DROP TYPE trapparty.jwt;

COMMIT;
