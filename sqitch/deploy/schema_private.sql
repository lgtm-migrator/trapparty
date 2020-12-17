-- Deploy trapparty:schema_private to pg
-- requires: role_authenticated

BEGIN;

CREATE SCHEMA trapparty_private;

COMMENT ON SCHEMA trapparty_private IS 'Contains participation information and is not used by PostGraphile.';

COMMIT;
