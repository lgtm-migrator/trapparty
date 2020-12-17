-- Revert trapparty:function_authenticate from pg

BEGIN;

DROP FUNCTION trapparty.authenticate;

COMMIT;
