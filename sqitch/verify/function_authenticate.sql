-- Verify trapparty:function_authenticate on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_function_privilege('trapparty_anonymous', 'trapparty.authenticate(UUID)', 'EXECUTE'));
  ASSERT NOT (SELECT pg_catalog.has_function_privilege('trapparty_authenticated', 'trapparty.authenticate(UUID)', 'EXECUTE'));
END $$;

ROLLBACK;
