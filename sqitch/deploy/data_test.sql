-- Deploy trapparty:data_test to pg

BEGIN;

INSERT INTO trapparty.event ("name", "start", discord_invite_code, stream_url, common_donation_url) VALUES ('2020', '2020-12-19 18:00:00.000+00', '1234abcd', 'https://event.stream.url', 'https://event.donation.url');
INSERT INTO trapparty.charity_organization (event_id, "name", "url") VALUES (1, 'Red Cross', 'https://charity.url');
INSERT INTO trapparty.team (event_id, "name", emoji, charity_organization_id, donation_url) VALUES (1, 'Cowboy', '🤠', 1, 'https://team.donation.url');
INSERT INTO trapparty.player (event_id, "name", invitation_code, team_id) VALUES (1, 'dargmuesli', 'f10ea826-3c0d-11eb-805b-af16ca5c3a47', 1);

COMMIT;
