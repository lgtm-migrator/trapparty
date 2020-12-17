-- Deploy trapparty:table_participation to pg
-- requires: schema_private
-- requires: schema_public
-- requires: table_player
-- requires: extension_uuid-ossp

BEGIN;

CREATE TABLE trapparty_private.participation (
  id                    BIGSERIAL PRIMARY KEY,
  player_id             BIGINT NOT NULL REFERENCES trapparty.player(id),
  participation_code    UUID NOT NULL UNIQUE DEFAULT trapparty.uuid_generate_v1mc()
);

COMMENT ON TABLE trapparty_private.participation IS 'Participations.';
COMMENT ON COLUMN trapparty_private.participation.id IS 'The participations''s internal id.';
COMMENT ON COLUMN trapparty_private.participation.player_id IS 'The participation''s internal player id.';
COMMENT ON COLUMN trapparty_private.participation.participation_code IS 'The participation''s participation code.';

COMMIT;
