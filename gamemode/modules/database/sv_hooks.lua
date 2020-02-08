hook.Add("PlayerInitialSpawn", "frontline_player_initialze", function (ply)
  print("[FL]Player spawned");

  local existsQuery = DataBase:prepare("SELECT * FROM users WHERE steamid64 = ?")

  function existsQuery:onSuccess(data)
	   if(#data == 0) then
        local insertQuery = DataBase:prepare("INSERT INTO users (name, steamid64, team, unit, rank, usergroup) VALUES (?,?,?,?,?)")

        function insertQuery:onSuccess()
            print("[FL-RP] Персонаж создан")
        end

        function insertQuery:onError(err)
            print("[FL ERROR] An error occured while executing the query: " .. err)
        end

        insertQuery:setString(1, ply:Name());
        insertQuery:setNumber(2, ply:SteamID64());
        insertQuery:setString(3, "TEAM_DOB");
        insertQuery:setString(4, "Доброволец");
        insertQuery:setString(5, "");
        insertQuery:setString(6, "user");

        insertQuery:start();
     end
  end

  function existsQuery:onError(err)
  	print("[FL ERROR] An error occured while executing the query: " .. err)
  end

  existsQuery:setNumber(1, ply:SteamID64());
  existsQuery:start();
end)
