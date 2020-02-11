hook.Add("PlayerInitialSpawn", "frontline_player_initialze", function (ply)
  database.orm.getBy("users", {
    steamid64 = ply:SteamID64()
  }, function(data)
    if(#data == 0) then
        database.orm.insert("users", {
          name = ply:Name(),
          steamid64 = ply:SteamID64(),
          team = "dob",
          unit = "Доброволец",
          rank = "",
          usergroup = "user"
        }, function(data)
            print("[FL-RP] Персонаж создан")
        end)
     else
       print("[FL-RP] Персонаж найден. Идет загрузка!")
     end
  end)

  database.orm.getBy("users", {
    steamid64 = ply:SteamID64()
  },
  function(result)
    ply:SetUserGroup(result[1].usergroup)
    for _, huy in pairs(flrp.jobs) do
      if result[1].team == huy.TeamID then
        ply:SetTeam(huy.index)
        hook.Call( "PlayerLoadout", GAMEMODE, ply )
        return
      end
    end
  end)

end)
