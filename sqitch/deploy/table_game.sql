-- Deploy trapparty:table_game to pg
-- requires: schema_public
-- requires: table_event

BEGIN;

CREATE TABLE trapparty.game (
  id          BIGSERIAL PRIMARY KEY,
  event_id    BIGINT NOT NULL REFERENCES trapparty.event(id),
  "name"      TEXT NOT NULL UNIQUE CHECK (char_length(name) < 100)
);

COMMENT ON TABLE trapparty.game IS 'Games.';
COMMENT ON COLUMN trapparty.game.id IS 'The games''s internal id.';
COMMENT ON COLUMN trapparty.game.event_id IS 'The game''s internal event id';
COMMENT ON COLUMN trapparty.game.name IS 'The games''s name.';

GRANT SELECT ON TABLE trapparty.game TO trapparty_anonymous;

COMMIT;