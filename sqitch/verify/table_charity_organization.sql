-- Verify maevsi:table_charity_organization on pg

BEGIN;

SELECT id,
       event_id,
       name,
       url
FROM trapparty.charity_organization WHERE FALSE;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.charity_organization', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.charity_organization', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.charity_organization', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.charity_organization', 'DELETE'));
END $$;

ROLLBACK;
