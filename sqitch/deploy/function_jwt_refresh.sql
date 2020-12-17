-- Deploy trapparty:function_jwt_refresh to pg
-- requires: privilege_execute_revoke
-- requires: schema_public
-- requries: extension_uuid-ossp
-- requires: type_jwt
-- requires: table_jwt
-- requires: role_anonymous
-- requires: role_authenticated

BEGIN;

CREATE FUNCTION trapparty.jwt_refresh(
  jwt_id UUID
) RETURNS trapparty.jwt AS $$
DECLARE
  _epoch_now BIGINT := EXTRACT(EPOCH FROM (SELECT date_trunc('second', NOW()::TIMESTAMP)));
  _jwt trapparty.jwt;
BEGIN
  SELECT (token).id, (token).exp, (token).role, (token).player_id, (token).team_id INTO _jwt
  FROM trapparty_private.jwt
  WHERE   uuid = $1
  AND     (token).exp >= _epoch_now;

  IF (_jwt IS NULL) THEN
    RETURN NULL;
  ELSE
    UPDATE trapparty_private.jwt
    SET token.exp = EXTRACT(EPOCH FROM ((SELECT date_trunc('second', NOW()::TIMESTAMP)) + COALESCE(current_setting('trapparty.jwt_expiry_duration', true), '1 day')::INTERVAL))
    WHERE uuid = $1;

    RETURN (
      SELECT token
      FROM trapparty_private.jwt
      WHERE   uuid = $1
      AND     (token).exp >= _epoch_now
    );
  END IF;
END;
$$ LANGUAGE PLPGSQL STRICT SECURITY DEFINER;

COMMENT ON FUNCTION trapparty.jwt_refresh(UUID) IS 'Refreshes a JWT.';

GRANT EXECUTE ON FUNCTION trapparty.jwt_refresh(UUID) TO trapparty_anonymous, trapparty_authenticated;

COMMIT;
