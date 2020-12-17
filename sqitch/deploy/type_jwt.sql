-- Deploy trapparty:type_jwt to pg
-- requires: schema_public

BEGIN;

CREATE TYPE trapparty.jwt AS (
  id UUID,
  "exp" BIGINT,
  "role" TEXT,
  player_id BIGINT,
  team_id BIGINT
);

COMMIT;
