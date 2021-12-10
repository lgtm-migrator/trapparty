-- Deploy trapparty:table_game to pg
-- requires: schema_public
-- requires: table_event
-- requires: type_enum_game_type
-- requires: role_anonymous

BEGIN;

CREATE TABLE trapparty.game (
  id        BIGSERIAL PRIMARY KEY,
  event_id  BIGINT NOT NULL REFERENCES trapparty.event(id),
  "type"    trapparty.game_type, --NOT NULL
  "name"    TEXT NOT NULL UNIQUE CHECK (char_length(name) < 100),
  is_active BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (event_id, "name")
);

COMMENT ON TABLE trapparty.game IS 'Games.';
COMMENT ON COLUMN trapparty.game.id IS 'The games''s internal id.';
COMMENT ON COLUMN trapparty.game.event_id IS 'The game''s internal event id';
COMMENT ON COLUMN trapparty.game.type IS 'The game''s type';
COMMENT ON COLUMN trapparty.game.name IS 'The games''s name.';
COMMENT ON COLUMN trapparty.game.is_active IS 'The games''s activeness.';

GRANT SELECT ON TABLE trapparty.game TO trapparty_anonymous;

COMMIT;