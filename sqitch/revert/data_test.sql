-- Revert maevsi:data_test from pg

BEGIN;

DELETE FROM trapparty.player WHERE id = 1;
ALTER SEQUENCE trapparty.player_id_seq RESTART;
DELETE FROM trapparty.team WHERE id = 1;
ALTER SEQUENCE trapparty.team_id_seq RESTART;
DELETE FROM trapparty.charity_organization WHERE id = 1;
ALTER SEQUENCE trapparty.charity_organization_id_seq RESTART;
DELETE FROM trapparty.event WHERE id = 1;
ALTER SEQUENCE trapparty.event_id_seq RESTART;

COMMIT;
