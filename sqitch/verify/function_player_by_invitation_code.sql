-- Verify trapparty:function_player_by_invitation_code on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_function_privilege('trapparty_anonymous', 'trapparty.player_by_invitation_code(UUID)', 'EXECUTE'));
END $$;

ROLLBACK;
