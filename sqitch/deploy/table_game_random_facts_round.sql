-- Deploy trapparty:table_game_random_facts_round to pg
-- requires: schema_public
-- requires: table_game
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.game_random_facts_round (
  id              SERIAL PRIMARY KEY,
  answer_correct  INT CHECK (answer_correct >= 0),
  game_id         INT NOT NULL REFERENCES trapparty.game(id),
  is_active       BOOLEAN NOT NULL DEFAULT FALSE,
  questioner_name TEXT NOT NULL CHECK (char_length(questioner_name) < 100)
);

COMMENT ON TABLE trapparty.game_random_facts_round IS 'A round of a random facts game.';
COMMENT ON COLUMN trapparty.game_random_facts_round.id IS 'The round''s internal id.';
COMMENT ON COLUMN trapparty.game_random_facts_round.answer_correct IS 'The round''s correct answer.';
COMMENT ON COLUMN trapparty.game_random_facts_round.game_id IS 'The round''s internal game id';
COMMENT ON COLUMN trapparty.game_random_facts_round.is_active IS 'The round''s activeness.';
COMMENT ON COLUMN trapparty.game_random_facts_round.questioner_name IS 'The round''s questioner name';

GRANT SELECT, INSERT ON TABLE trapparty.game_random_facts_round TO trapparty_anonymous;
GRANT USAGE ON SEQUENCE trapparty.game_random_facts_round_id_seq TO trapparty_anonymous;

COMMIT;