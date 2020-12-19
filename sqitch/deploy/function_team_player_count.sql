-- Deploy trapparty:function_team_player_count to pg
-- requires: privilege_execute_revoke
-- requires: schema_public
-- requires: table_team
-- requires: table_player
-- requires: role_anonymous

BEGIN;

CREATE FUNCTION trapparty.team_player_count(event_id BIGINT)
RETURNS TABLE(team_id BIGINT, player_count BIGINT) AS $$
BEGIN
  RETURN QUERY
    WITH data AS (SELECT player.id AS player_id, team.id AS team_id FROM trapparty.team, trapparty.player WHERE team.id = player.team_id AND team.event_id = 1) SELECT data.team_id, SUM(1) AS player_count FROM data GROUP BY data.team_id ORDER BY data.team_id ASC;
END;
$$ LANGUAGE PLPGSQL STABLE STRICT SECURITY DEFINER;

COMMENT ON FUNCTION trapparty.team_player_count(BIGINT) IS E'Retrieves the player count of each team.';

GRANT EXECUTE ON FUNCTION trapparty.team_player_count(BIGINT) TO trapparty_anonymous;

COMMIT;
