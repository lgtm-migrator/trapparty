-- Revert trapparty:table_kv from pg

BEGIN;

DROP TABLE trapparty.kv;

COMMIT;