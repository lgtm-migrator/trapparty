-- Verify trapparty:role_authenticated on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.pg_has_role('trapparty_postgraphile', 'trapparty_authenticated', 'USAGE'));
  -- Other authenticateds might not exist yet for a NOT-check.
END $$;

ROLLBACK;
