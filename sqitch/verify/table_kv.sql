-- Verify trapparty:table_kv on pg

BEGIN;

SELECT "key",
       "value"
FROM trapparty.kv WHERE FALSE;

DO $$
BEGIN
   ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.kv', 'SELECT'));
   ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.kv', 'INSERT'));
   ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.kv', 'UPDATE'));
   ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.kv', 'DELETE'));
END $$;

ROLLBACK;