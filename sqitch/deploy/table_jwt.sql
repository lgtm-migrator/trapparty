-- Deploy trapparty:table_jwt to pg
-- requires: schema_private
-- requires: extension_uuid-ossp
-- requires: type_jwt

BEGIN;

CREATE TABLE trapparty_private.jwt (
  id       BIGSERIAL PRIMARY KEY,
  uuid     UUID NOT NULL UNIQUE DEFAULT trapparty.uuid_generate_v1mc(),
  token    trapparty.jwt NOT NULL UNIQUE
);

COMMENT ON TABLE trapparty_private.jwt IS 'A list of tokens.';
COMMENT ON COLUMN trapparty_private.jwt.id IS 'The token''s id.';
COMMENT ON COLUMN trapparty_private.jwt.id IS 'The token''s UUID.';
COMMENT ON COLUMN trapparty_private.jwt.token IS 'The token.';

COMMIT;
