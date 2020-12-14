-- Revert trapparty:role_postgraphile from pg

BEGIN;

DROP OWNED BY trapparty_postgraphile;
DROP ROLE trapparty_postgraphile;

COMMIT;
