-- Deploy trapparty:table_player to pg
-- requires: schema_public
-- requires: table_team
-- requires: extension_uuid-ossp

BEGIN;

CREATE TABLE trapparty.player (
  id                 SERIAL PRIMARY KEY,
  team_id            INT REFERENCES trapparty.team(id),
  name               TEXT NOT NULL CHECK (char_length(name) < 100),
  invitation_code    UUID NOT NULL UNIQUE DEFAULT trapparty.uuid_generate_v1mc(),
  UNIQUE (team_id, invitation_code)
);

COMMENT ON TABLE trapparty.player IS 'Players.';
COMMENT ON COLUMN trapparty.player.id IS 'The players''s internal id.';
COMMENT ON COLUMN trapparty.player.name IS 'The player''s name.';
COMMENT ON COLUMN trapparty.player.invitation_code IS 'The player''s invitation code.';
COMMENT ON COLUMN trapparty.player.team_id IS 'The player''s internal team id.';

COMMIT;
