-- Revert trapparty:role_authenticated from pg

BEGIN;

DROP ROLE trapparty_authenticated;

COMMIT;
