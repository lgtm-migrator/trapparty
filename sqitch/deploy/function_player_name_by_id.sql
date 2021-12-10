-- Deploy trapparty:function_player_name_by_id to pg
-- requires: privilege_execute_revoke
-- requires: schema_public
-- requires: table_player
-- requires: role_anonymous

BEGIN;

CREATE FUNCTION trapparty.player_name_by_id(id INT)
RETURNS TEXT AS $$
BEGIN
  RETURN (SELECT name FROM trapparty.player WHERE trapparty.player.id = $1);
END;
$$ LANGUAGE PLPGSQL STABLE STRICT SECURITY DEFINER;

COMMENT ON FUNCTION trapparty.player_name_by_id(INT) IS E'Retrieves player name by player id.';

GRANT EXECUTE ON FUNCTION trapparty.player_name_by_id(INT) TO trapparty_anonymous;

COMMIT;
