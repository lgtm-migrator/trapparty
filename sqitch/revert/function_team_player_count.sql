-- Revert trapparty:function_team_player_count from pg

BEGIN;

DROP FUNCTION trapparty.team_player_count;

COMMIT;
