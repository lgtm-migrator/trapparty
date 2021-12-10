-- Deploy trapparty:table_game_team_score to pg
-- requires: schema_public
-- requires: table_game
-- requires: table_team
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.game_team_score (
  id         SERIAL PRIMARY KEY,
  game_id    INT NOT NULL REFERENCES trapparty.game(id),
  team_id    INT NOT NULL REFERENCES trapparty.team(id),
  score      INT NOT NULL
);

COMMENT ON TABLE trapparty.game_team_score IS 'Game scores.';
COMMENT ON COLUMN trapparty.game_team_score.id IS 'The game score''s internal id.';
COMMENT ON COLUMN trapparty.game_team_score.game_id IS 'The score''s internal game id';
COMMENT ON COLUMN trapparty.game_team_score.team_id IS 'The score''s internal team id';
COMMENT ON COLUMN trapparty.game_team_score.score IS 'The score.';

GRANT SELECT ON TABLE trapparty.game_team_score TO trapparty_anonymous;

COMMIT;