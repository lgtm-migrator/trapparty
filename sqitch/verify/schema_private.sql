-- Verify trapparty:schema_private on pg

BEGIN;

DO $$
BEGIN
  ASSERT NOT (SELECT pg_catalog.has_schema_privilege('trapparty_anonymous', 'trapparty_private', 'USAGE'));
  ASSERT NOT (SELECT pg_catalog.has_schema_privilege('trapparty_authenticated', 'trapparty_private', 'USAGE'));
END $$;

ROLLBACK;
