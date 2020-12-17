-- Verify trapparty:schema_public on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_schema_privilege('trapparty_anonymous', 'trapparty', 'USAGE'));
  ASSERT (SELECT pg_catalog.has_schema_privilege('trapparty_authenticated', 'trapparty', 'USAGE'));
END $$;

ROLLBACK;
