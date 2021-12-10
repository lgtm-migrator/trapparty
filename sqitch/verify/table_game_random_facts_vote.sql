-- Verify trapparty:table_game_random_facts_vote on pg

BEGIN;

SELECT id,
       answer,
       player_id,
       round_id
FROM trapparty.game_random_facts_vote WHERE FALSE;

DO $$
BEGIN
  ASSERT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.game_random_facts_vote', 'SELECT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.game_random_facts_vote', 'INSERT'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.game_random_facts_vote', 'UPDATE'));
  ASSERT NOT (SELECT pg_catalog.has_table_privilege('trapparty_anonymous', 'trapparty.game_random_facts_vote', 'DELETE'));
END $$;

ROLLBACK;
