-- Revert trapparty:table_lead from pg

BEGIN;

ALTER TABLE trapparty.team
  DROP COLUMN lead_player_id;

COMMIT;
