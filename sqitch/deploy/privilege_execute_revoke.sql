-- Deploy trapparty:privilege_execute_revoke to pg

BEGIN;

ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

COMMIT;
