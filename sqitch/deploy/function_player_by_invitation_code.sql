-- Deploy trapparty:function_player_by_invitation_code to pg
-- requires: privilege_execute_revoke
-- requires: schema_public
-- requires: extension_uuid-ossp
-- requires: table_player
-- requires: role_anonymous

BEGIN;

CREATE FUNCTION trapparty.player_by_invitation_code(invitation_code UUID)
RETURNS SETOF trapparty.player AS $$
BEGIN
  RETURN QUERY
    SELECT * FROM trapparty.player WHERE trapparty.player.invitation_code = $1;
END;
$$ LANGUAGE PLPGSQL STABLE STRICT SECURITY DEFINER;

COMMENT ON FUNCTION trapparty.player_by_invitation_code(UUID) IS E'@name player_by_invitation_code_fn\nRetrieves player data by invitation code.';

GRANT EXECUTE ON FUNCTION trapparty.player_by_invitation_code(UUID) TO trapparty_anonymous;

COMMIT;
