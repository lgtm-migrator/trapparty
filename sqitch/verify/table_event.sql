-- Verify maevsi:table_event on pg

BEGIN;

SELECT id,
       "name",
       "start",
       "end",
       discord_invite_code,
       stream_url,
       common_donation_url
FROM trapparty.event WHERE FALSE;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.event', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.event', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.event', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.event', 'DELETE'));
END $$;

ROLLBACK;
