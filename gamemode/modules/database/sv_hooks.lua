hook.Add("PlayerInitialSpawn", "frontline_player_initialze", function (ply, button)
  database.query("SELECT * FROM users WHERE steamid64 = ?", function(data)
    if(#data == 0) then
        database.query("INSERT INTO users (name, steamid64, team, unit, rank, usergroup) VALUES (?,?,?,?,?,?)", function(data)
            print("[FL-RP] Персонаж создан")
        end, {ply:Name(), ply:SteamID64(), "TEAM_DOB", "Доброволец", "Rank", "user"})
     else
       print("[FL-RP] Персонаж найден. Идет загрузка!")
     end
  end, {ply:SteamID64()})
end)
