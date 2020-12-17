-- Verify trapparty:table_player on pg

BEGIN;

SELECT id,
       team_id,
       "name"
FROM trapparty.player WHERE FALSE;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.player', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.player', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.player', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.player', 'DELETE'));
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.player', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.player', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.player', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.player', 'DELETE'));
END $$;

ROLLBACK;
