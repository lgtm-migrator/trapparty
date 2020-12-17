-- Verify trapparty:table_team on pg

BEGIN;

SELECT id,
       event_id,
       "name",
       emoji,
       charity_organization_id,
       donation_url,
       donation_amount,
       version_timestamp
FROM trapparty.team WHERE FALSE;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.team', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.team', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.team', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.team', 'DELETE'));
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.team', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.team', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.team', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_authenticated', 'trapparty.team', 'DELETE'));
END $$;

ROLLBACK;
