-- Deploy trapparty:table_team to pg
-- requires: schema_public
-- requires: table_event
-- requires: table_charity_organization
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.team (
  id                         SERIAL PRIMARY KEY,
  event_id                   INT NOT NULL REFERENCES trapparty.event(id),
  "name"                     TEXT NOT NULL CHECK (char_length(name) < 100),
  emoji                      TEXT NOT NULL CHECK (char_length(emoji) = 1),
  charity_organization_id    INT REFERENCES trapparty.charity_organization(id),
  donation_url               TEXT CHECK (char_length(donation_url) < 100 AND donation_url ~ '^https://.+$'),
  donation_amount            MONEY CHECK (donation_amount >= 0::MONEY)
);

COMMENT ON TABLE trapparty.team IS 'Teams.';
COMMENT ON COLUMN trapparty.team.id IS 'The team''s internal id.';
COMMENT ON COLUMN trapparty.team.event_id IS 'The team''s internal event reference.';
COMMENT ON COLUMN trapparty.team.name IS 'The team''s name.';
COMMENT ON COLUMN trapparty.team.emoji IS 'The team''s emoji.';
COMMENT ON COLUMN trapparty.team.charity_organization_id IS 'The team''s internal charity organization id.';
COMMENT ON COLUMN trapparty.team.donation_url IS 'The team''s donation url.';
COMMENT ON COLUMN trapparty.team.donation_amount IS 'The team''s donation amount.';

GRANT SELECT ON TABLE trapparty.team TO trapparty_anonymous;

COMMIT;
