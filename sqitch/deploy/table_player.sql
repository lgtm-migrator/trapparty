-- Deploy trapparty:table_player to pg
-- requires: schema_public
-- requires: table_event
-- requires: extension_uuid-ossp

BEGIN;

CREATE TABLE trapparty.player (
  id                 BIGSERIAL PRIMARY KEY,
  team_id            BIGINT REFERENCES trapparty.team(id),
  name               TEXT NOT NULL UNIQUE CHECK (char_length(name) < 100),
  invitation_code    UUID NOT NULL UNIQUE DEFAULT trapparty.uuid_generate_v1mc()
);

COMMENT ON TABLE trapparty.player IS 'Players.';
COMMENT ON COLUMN trapparty.player.id IS 'The players''s internal id.';
COMMENT ON COLUMN trapparty.player.name IS 'The player''s name.';
COMMENT ON COLUMN trapparty.player.invitation_code IS 'The player''s invitation code.';
COMMENT ON COLUMN trapparty.player.team_id IS 'The player''s internal team id.';

COMMIT;
