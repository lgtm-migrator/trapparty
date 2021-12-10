-- Verify trapparty:function_player_name_by_id on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_function_privilege('trapparty_anonymous', 'trapparty.player_name_by_id(INT)', 'EXECUTE'));
END $$;

ROLLBACK;
