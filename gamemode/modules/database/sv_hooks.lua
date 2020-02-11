hook.Add("PlayerInitialSpawn", "frontline_player_initialze", function (ply)
  database.orm.getBy("users", {
    steamid64 = ply:SteamID64()
  }, function(data)
    if(#data == 0) then
        database.orm.insert("users", {
          name = ply:Name(),
          steamid64 = ply:SteamID64(),
          team = "TEAM_DOB",
          unit = "Доброволец",
          rank = "Rank",
          usergroup = "user"
        }, function(data)
            print("[FL-RP] Персонаж создан")
        end)
     else
       print("[FL-RP] Персонаж найден. Идет загрузка!")
     end
  end)
end)
