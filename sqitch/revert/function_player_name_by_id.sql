-- Revert trapparty:function_player_name_by_id from pg

BEGIN;

DROP FUNCTION trapparty.player_name_by_id;

COMMIT;
