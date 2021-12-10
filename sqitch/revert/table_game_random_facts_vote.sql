-- Revert trapparty:table_game_random_facts_vote from pg

BEGIN;

DROP TABLE trapparty.game_random_facts_vote;

COMMIT;
