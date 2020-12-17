-- Deploy trapparty:table_event to pg
-- requires: schema_public
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.event (
  id                         BIGSERIAL PRIMARY KEY,
  "name"                     TEXT NOT NULL UNIQUE CHECK (char_length(name) < 100),
  "start"                    TIMESTAMP WITH TIME ZONE NOT NULL,
  "end"                      TIMESTAMP WITH TIME ZONE,
  discord_invite_code        TEXT CHECK (discord_invite_code ~ '^[a-zA-Z0-9]{10}$'),
  stream_url                 TEXT CHECK (char_length(stream_url) < 100 AND stream_url ~ '^https://.+$'),
  common_donation_url        TEXT CHECK (char_length(common_donation_url) < 100 AND common_donation_url ~ '^https://.+$'),
  common_donation_is_live    BOOLEAN
);

COMMENT ON TABLE trapparty.event IS 'Events.';
COMMENT ON COLUMN trapparty.event.id IS 'The events''s internal id.';
COMMENT ON COLUMN trapparty.event.start IS 'The event''s start timestamp.';
COMMENT ON COLUMN trapparty.event.end IS 'The event''s end timestamp.';
COMMENT ON COLUMN trapparty.event.discord_invite_code IS 'The event''s discord code.';
COMMENT ON COLUMN trapparty.event.stream_url IS 'The event''s stream url.';
COMMENT ON COLUMN trapparty.event.common_donation_url IS 'The event''s common donation url.';
COMMENT ON COLUMN trapparty.event.common_donation_is_live IS 'Indicates whether the event''s common donations are featured in the stream.';

GRANT SELECT ON TABLE trapparty.event TO trapparty_anonymous;

COMMIT;
