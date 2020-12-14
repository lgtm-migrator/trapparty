-- Revert trapparty:function_player_by_invitation_code from pg

BEGIN;

DROP FUNCTION trapparty.player_by_invitation_code;

COMMIT;
