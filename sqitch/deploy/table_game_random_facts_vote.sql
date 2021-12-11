-- Deploy trapparty:table_game_random_facts_vote to pg
-- requires: schema_public
-- requires: table_player
-- requires: table_game_random_facts_round
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.game_random_facts_vote (
  id              SERIAL PRIMARY KEY,
  answer          INT NOT NULL CHECK (answer >= 0),
  player_id       INT NOT NULL REFERENCES trapparty.player(id),
  round_id        INT NOT NULL REFERENCES trapparty.game_random_facts_round(id),
  UNIQUE (player_id, round_id)
);

COMMENT ON TABLE trapparty.game_random_facts_vote IS 'A vote of a random facts game round.';
COMMENT ON COLUMN trapparty.game_random_facts_vote.id IS 'The vote''s internal id.';
COMMENT ON COLUMN trapparty.game_random_facts_vote.answer IS 'The vote''s answer.';
COMMENT ON COLUMN trapparty.game_random_facts_vote.player_id IS 'The vote''s internal player id';
COMMENT ON COLUMN trapparty.game_random_facts_vote.round_id IS 'The vote''s internal round id.';

GRANT SELECT, INSERT ON TABLE trapparty.game_random_facts_vote TO trapparty_anonymous;
GRANT USAGE ON SEQUENCE trapparty.game_random_facts_vote_id_seq TO trapparty_anonymous;

COMMIT;