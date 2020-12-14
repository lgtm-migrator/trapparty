-- Deploy trapparty:table_charity_organization to pg
-- requires: schema_public
-- requires: table_event
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.charity_organization (
  id          BIGSERIAL PRIMARY KEY,
  name        TEXT NOT NULL UNIQUE CHECK (char_length(name) < 100),
  url         TEXT NOT NULL UNIQUE CHECK (char_length(url) < 100 AND url ~ '^https://.+$')
);

COMMENT ON TABLE trapparty.charity_organization IS 'Charity organizations.';
COMMENT ON COLUMN trapparty.charity_organization.id IS 'The charity organization''s internal id.';
COMMENT ON COLUMN trapparty.charity_organization.name IS 'The charity organization''s name.';
COMMENT ON COLUMN trapparty.charity_organization.url IS 'The charity organization''s url.';

GRANT SELECT ON TABLE trapparty.charity_organization TO trapparty_anonymous;

COMMIT;