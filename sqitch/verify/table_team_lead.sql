-- Verify trapparty:table_lead on pg

BEGIN;

SELECT lead_player_id
FROM trapparty.team WHERE FALSE;

ROLLBACK;
