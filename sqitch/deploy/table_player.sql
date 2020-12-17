-- Deploy trapparty:table_player to pg
-- requires: schema_public
-- requires: table_team
-- requires: role_anonymous
-- requires: role_authenticated

BEGIN;

CREATE TABLE trapparty.player (
  id                 BIGSERIAL PRIMARY KEY,
  team_id            BIGINT NOT NULL REFERENCES trapparty.team(id),
  name               TEXT NOT NULL CHECK (char_length(name) < 100),
  UNIQUE (team_id, name)
);

COMMENT ON TABLE trapparty.player IS 'Players.';
COMMENT ON COLUMN trapparty.player.id IS 'The players''s internal id.';
COMMENT ON COLUMN trapparty.player.name IS 'The player''s name.';
COMMENT ON COLUMN trapparty.player.team_id IS 'The player''s internal team id.';

GRANT SELECT ON TABLE trapparty.player TO trapparty_anonymous, trapparty_authenticated;

COMMIT;
