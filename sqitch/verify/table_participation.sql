-- Verify trapparty:table_participation on pg

BEGIN;

SELECT id,
       player_id,
       participation_code
FROM trapparty_private.participation WHERE FALSE;

DO $$
BEGIN
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty_private.participation', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty_private.participation', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty_private.participation', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty_private.participation', 'DELETE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty_private.participation', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty_private.participation', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty_private.participation', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty_private.participation', 'DELETE'));
END $$;

ROLLBACK;
