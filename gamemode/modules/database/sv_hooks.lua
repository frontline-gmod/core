hook.Add("CheckPassword", "frontline_player_checkbanned", function( steamid64_suspect )
	PrintTable(flrp.banlist)
	for k,v in pairs (flrp.banlist) do
		if flrp.banlist[k].steamid64 == steamid64_suspect then
			if os.time() <= tonumber(flrp.banlist[k].date) then
				return false, string.format( "Вы заблокированы на нашем проекте.\n\nПричина блокировки: %s\nРазблокировка: %s", flrp.banlist[k].reason, os.date( "%H:%M:%S - %d/%m/%Y", flrp.banlist[k].date ) )
			else
				database.orm.delete("bans", {
					steamid64 = steamid64_suspect
				})
				table.RemoveByValue(flrp.banlist, flrp.banlist[k])
			end
		end
	end
end)

hook.Add("PlayerInitialSpawn", "frontline_player_initialze", function( ply )
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
            print("[FL-RP] Персонаж создан")
        end)
     else
       database.orm.getBy("users", {
         steamid64 = ply:SteamID64()
       },
       function(result)
         if IsValid(ply) then
           ply:SetUserGroup(result[1].usergroup)
           for _, huy in pairs(flrp.jobs) do
             if result[1].team == huy.TeamID then
               ply:SetTeam(huy.index)
               hook.Call( "PlayerLoadout", GAMEMODE, ply )
               return
             end
           end
         end
       end)
       print("[FL-RP] Персонаж найден. Идет загрузка!")
     end
  end)
end)
