-- Verify trapparty:function_jwt_refresh on pg

BEGIN;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_function_privilege('trapparty_anonymous', 'trapparty.jwt_refresh(UUID)', 'EXECUTE'));
  ASSERT (SELECT pg_catalog.has_function_privilege('trapparty_authenticated', 'trapparty.jwt_refresh(UUID)', 'EXECUTE'));
END $$;

ROLLBACK;
