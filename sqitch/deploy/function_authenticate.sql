-- Deploy trapparty:function_authenticate to pg
-- requires: privilege_execute_revoke
-- requires: schema_public
-- requries: extension_uuid-ossp
-- requires: type_jwt
-- requires: schema_private
-- requires: table_participation
-- requires: table_jwt
-- requires: table_player
-- requires: role_anonymous

BEGIN;

CREATE FUNCTION trapparty.authenticate(
  participation_code UUID
) RETURNS trapparty.jwt AS $$
DECLARE
    _jwt_id UUID := trapparty.uuid_generate_v1mc();
    _jwt_exp BIGINT := EXTRACT(EPOCH FROM ((SELECT date_trunc('second', NOW()::TIMESTAMP)) + COALESCE(current_setting('trapparty.jwt_expiry_duration', true), '1 day')::INTERVAL));
    _jwt trapparty.jwt;
BEGIN
  IF ($1 IS NULL) THEN
    -- Authenticate as guest.
    _jwt := (_jwt_id, _jwt_exp, 'trapparty_anonymous', NULL, NULL)::trapparty.jwt;
  ELSIF ($1 IS NOT NULL) THEN
    WITH player_selected AS (
      WITH participation_selected AS (
        SELECT * FROM trapparty_private.participation
        WHERE participation.participation_code = $1
      ) SELECT player.* FROM trapparty.player, participation_selected WHERE trapparty.player.id = participation_selected.player_id
    ) SELECT _jwt_id, _jwt_exp, 'trapparty_authenticated', player_selected.id, player_selected.team_id
      FROM player_selected
      INTO _jwt;

    IF (_jwt IS NULL) THEN
      RAISE 'Participation not found!' USING ERRCODE = 'no_data_found';
    END IF;
  END IF;

  INSERT INTO trapparty_private.jwt(uuid, token) VALUES (_jwt_id, _jwt);
  RETURN _jwt;
END $$ LANGUAGE PLPGSQL SECURITY DEFINER;

COMMENT ON FUNCTION trapparty.authenticate(UUID) IS 'Creates a JWT token that will securely identify an participation and give it certain permissions.';

GRANT EXECUTE ON FUNCTION trapparty.authenticate(UUID) TO trapparty_anonymous;

COMMIT;
