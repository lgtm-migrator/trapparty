-- Deploy trapparty:table_team_leader to pg
-- requires: schema_public
-- requires: table_team
-- requires: table_player
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.team_leader (
  id                 SERIAL PRIMARY KEY,
  team_id            INT NOT NULL REFERENCES trapparty.team(id),
  player_id          INT NOT NULL REFERENCES trapparty.player(id)
);

COMMENT ON TABLE trapparty.team_leader IS 'Leaders.';
COMMENT ON COLUMN trapparty.team_leader.id IS 'The team leaders''s internal id.';
COMMENT ON COLUMN trapparty.team_leader.team_id IS 'The team leader''s internal team id.';
COMMENT ON COLUMN trapparty.team_leader.player_id IS 'The team leader''s internal player id.';

GRANT SELECT ON TABLE trapparty.team_leader TO trapparty_anonymous;

COMMIT;
