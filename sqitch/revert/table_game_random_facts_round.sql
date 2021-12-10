-- Revert trapparty:table_game_random_facts_round from pg

BEGIN;

DROP TABLE trapparty.game_random_facts_round;

COMMIT;
