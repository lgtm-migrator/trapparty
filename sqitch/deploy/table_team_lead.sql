-- Deploy trapparty:table_lead to pg
-- requires: schema_public
-- requires: table_team
-- requires: table_player

BEGIN;

ALTER TABLE trapparty.team
  ADD COLUMN lead_player_id BIGINT REFERENCES trapparty.player(id);

COMMENT ON COLUMN trapparty.team.lead_player_id IS 'The team''s internal lead player id.';

COMMIT;
