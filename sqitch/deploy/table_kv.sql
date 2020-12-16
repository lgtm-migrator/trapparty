-- Deploy trapparty:table_kv to pg
-- requires: schema_public

BEGIN;

CREATE TABLE trapparty.kv (
    "key" TEXT UNIQUE,
    "value" TEXT
);

COMMENT ON TABLE trapparty.kv IS 'A key value store.';
COMMENT ON COLUMN trapparty.kv.key IS 'The key.';
COMMENT ON COLUMN trapparty.kv.value IS 'A value.';

ALTER TABLE trapparty.kv ENABLE ROW LEVEL SECURITY;

GRANT SELECT ON TABLE trapparty.kv TO trapparty_anonymous;

COMMIT;