-- Revert trapparty:table_charity_organization from pg

BEGIN;

DROP TABLE trapparty.charity_organization;

COMMIT;
