-- Verify maevsi:table_leader on pg

BEGIN;

SELECT id,
       team_id,
       player_id
FROM trapparty.leader WHERE FALSE;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.leader', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.leader', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.leader', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.leader', 'DELETE'));
END $$;

ROLLBACK;
