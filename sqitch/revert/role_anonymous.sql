-- Revert trapparty:role_anonymous from pg

BEGIN;

DROP ROLE trapparty_anonymous;

COMMIT;
