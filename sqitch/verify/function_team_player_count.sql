-- Verify trapparty:function_team_player_count on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_function_privilege('trapparty_anonymous', 'trapparty.team_player_count(BIGINT)', 'EXECUTE'));
END $$;

ROLLBACK;
