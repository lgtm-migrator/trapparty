-- Revert trapparty:function_jwt_refresh from pg

BEGIN;

DROP FUNCTION trapparty.jwt_refresh;

COMMIT;
