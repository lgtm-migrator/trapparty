-- Deploy trapparty:table_leader to pg
-- requires: schema_public
-- requires: table_team
-- requires: table_player

BEGIN;

CREATE TABLE trapparty.leader (
  id                 BIGSERIAL PRIMARY KEY,
  team_id            BIGINT NOT NULL REFERENCES trapparty.team(id),
  player_id          BIGINT NOT NULL REFERENCES trapparty.player(id),
  UNIQUE (team_id, player_id)
);

COMMENT ON TABLE trapparty.leader IS 'Leaders.';
COMMENT ON COLUMN trapparty.leader.id IS 'The leaders''s internal id.';
COMMENT ON COLUMN trapparty.leader.team_id IS 'The leader''s internal team id.';
COMMENT ON COLUMN trapparty.leader.player_id IS 'The leader''s internal player id.';

GRANT SELECT ON TABLE trapparty.leader TO trapparty_anonymous;

COMMIT;
