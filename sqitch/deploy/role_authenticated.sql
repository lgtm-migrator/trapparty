-- Deploy trapparty:role_authenticated to pg
-- requires: role_postgraphile

BEGIN;

CREATE ROLE trapparty_authenticated;

GRANT trapparty_authenticated to trapparty_postgraphile;

COMMIT;
