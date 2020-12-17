-- Verify trapparty:type_jwt on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_type_privilege('trapparty.jwt', 'USAGE'));
END $$;

ROLLBACK;
