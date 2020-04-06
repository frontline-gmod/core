netstream.Hook( "ReturnWhiteList", function(ply, tableInfoTargetWhitelist)

  if GetAdminPermission( ply, "whitelist" ) then
    tableInfoTargetWhitelist.target:SetTeam(tableInfoTargetWhitelist.team_index)
    tableInfoTargetWhitelist.target:SetNWString("fl_rank", tableInfoTargetWhitelist.ranktag)

    database.orm.update("users", {
      team = tableInfoTargetWhitelist.jobtag,
      rank = tableInfoTargetWhitelist.ranktag,
    }, {
      steamid64 = tableInfoTargetWhitelist.target:SteamID64(),
    })
    if ply:SteamID64() != tableInfoTargetWhitelist.target:SteamID64() then
      if tableInfoTargetWhitelist.oldteam_index != team.GetName(tableInfoTargetWhitelist.team_index) then
        AddLogString(tostring(os.time()), "Специализация", string.format( "Игрок %s изменил игроку %s специализацию с %s на %s", ply:Name(), tableInfoTargetWhitelist.target:Name(), tableInfoTargetWhitelist.oldteam_index, team.GetName(tableInfoTargetWhitelist.team_index) ))
      end
      if tableInfoTargetWhitelist.oldranktag != tableInfoTargetWhitelist.ranktag then
        AddLogString(tostring(os.time()), "Звание", string.format( "Игрок %s изменил игроку %s звание с %s на %s", ply:Name(), tableInfoTargetWhitelist.target:Name(), tableInfoTargetWhitelist.oldranktag, tableInfoTargetWhitelist.ranktag ))
      end
    else
      if tableInfoTargetWhitelist.oldteam_index != team.GetName(tableInfoTargetWhitelist.team_index) then
        AddLogString(tostring(os.time()), "Специализация", string.format( "Игрок %s изменил специализацию с %s на %s", ply:Name(), tableInfoTargetWhitelist.oldteam_index, team.GetName(tableInfoTargetWhitelist.team_index) ))
      end
      if tableInfoTargetWhitelist.oldranktag != tableInfoTargetWhitelist.ranktag then
        AddLogString(tostring(os.time()), "Звание", string.format( "Игрок %s изменил звание с %s на %s", ply:Name(), tableInfoTargetWhitelist.oldranktag, tableInfoTargetWhitelist.ranktag ))
      end
    end
  end

end)
