-- Revert trapparty:table_game_score from pg

BEGIN;

DROP TABLE trapparty.game_score;

COMMIT;
