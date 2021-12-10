-- Verify trapparty:type_enum_game_type on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_type_privilege('trapparty.game_type', 'USAGE'));
END $$;

ROLLBACK;
