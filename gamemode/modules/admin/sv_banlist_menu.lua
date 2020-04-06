netstream.Hook("AcceptedUnban", function(ply, tableUnbanInfo)
  if GetAdminPermission( ply, "unban" ) then
    for k,v in pairs (flrp.banlist[1]) do
      if flrp.banlist[1][k].steamid64 == tableUnbanInfo.steamid64_target then
        table.RemoveByValue( flrp.banlist, flrp.banlist[1][k])
        database.orm.delete("bans", {steamid64 = tableUnbanInfo.steamid64_target})
        for k, v in pairs(player.GetAll()) do
          v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(tableUnbanInfo.nick) .. " был разблокирован администратором: " .. util.TypeToString(ply:Name()) .. ".')" )
        end
        AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) разблокировал игрока %s(%s)", ply:Name(), ply:SteamID64(), flrp.banlist[1][k].nick, flrp.banlist[1][k].steamid64 ))
        database.orm.get("bans", function(result)
          table.Empty(flrp.banlist)
        	table.insert(flrp.banlist, result)
        end)
      end
    end
  end
end)
