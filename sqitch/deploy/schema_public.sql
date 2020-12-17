-- Deploy trapparty:schema_public to pg
-- requires: role_anonymous
-- requires: role_authenticated

BEGIN;

CREATE SCHEMA trapparty;

COMMENT ON SCHEMA trapparty IS 'Is used by PostGraphile.';

GRANT USAGE ON SCHEMA trapparty TO trapparty_anonymous, trapparty_authenticated;

COMMIT;
