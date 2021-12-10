-- Revert trapparty:table_game_team_score from pg

BEGIN;

DROP TABLE trapparty.game_team_score;

COMMIT;
