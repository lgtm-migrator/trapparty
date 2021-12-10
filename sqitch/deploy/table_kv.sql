-- Deploy trapparty:table_kv to pg
-- requires: schema_public
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.kv (
    "key" TEXT UNIQUE,
    "value" TEXT
);

COMMENT ON TABLE trapparty.kv IS 'A key value store.';
COMMENT ON COLUMN trapparty.kv.key IS 'The key.';
COMMENT ON COLUMN trapparty.kv.value IS 'A value.';

GRANT SELECT ON TABLE trapparty.kv TO trapparty_anonymous;

INSERT INTO trapparty.kv ("key", "value") VALUES ('GAME_CURRENT', NULL);

COMMIT;