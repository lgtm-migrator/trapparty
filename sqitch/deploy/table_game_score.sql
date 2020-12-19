-- Deploy trapparty:table_game_score to pg
-- requires: schema_public
-- requires: table_game
-- requires: table_team

BEGIN;

CREATE TABLE trapparty.game_score (
  id         BIGSERIAL PRIMARY KEY,
  game_id    BIGINT NOT NULL REFERENCES trapparty.game(id),
  team_id    BIGINT NOT NULL REFERENCES trapparty.team(id),
  score      INT NOT NULL
);

COMMENT ON TABLE trapparty.game_score IS 'Game scores.';
COMMENT ON COLUMN trapparty.game_score.id IS 'The game score''s internal id.';
COMMENT ON COLUMN trapparty.game_score.game_id IS 'The score''s internal game id';
COMMENT ON COLUMN trapparty.game_score.team_id IS 'The score''s internal team id';
COMMENT ON COLUMN trapparty.game_score.score IS 'The score.';

GRANT SELECT ON TABLE trapparty.game_score TO trapparty_anonymous;

COMMIT;