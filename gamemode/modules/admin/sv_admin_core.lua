function GetAdminUsergroup( usergroup )
  if flrp.config.usergroup["" .. usergroup .. ""] then return true else return false end
end

function GetAdminPermission( ply, permission )
  return table.HasValue(flrp.config.usergroup["" .. ply:GetUserGroup() .. ""], permission)
end

function LikenAdminImmunity( ply, target )
  if flrp.config.usergroup.immunity["" .. ply:GetUserGroup() .. ""] >= flrp.config.usergroup.immunity["" .. target:GetUserGroup() .. ""] then return true else return false end
end

function FLRPSetRank( ply, cmd, args )

  local target = args[1]
  local usergroup = args[2]

  for k,v in pairs(player.GetAll()) do
    if GetAdminPermission( ply, "setrank" ) then
      if (v:SteamID64() == target) && GetAdminUsergroup( usergroup ) && LikenAdminImmunity( ply, v ) then
        v:SetUserGroup( usergroup )
        v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы получили привилегию: " .. util.TypeToString(usergroup) .. "')" )
      else
        if !GetAdminUsergroup( usergroup ) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Данная привилегия отсутствует!' )" ) end
        if !LikenAdminImmunity( ply, v ) && v:SteamID64() == target then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" ) end
      end
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' У вас недостаточно прав!' )" )
    end
  end
end

function FLRPNoclip( ply )
  if GetAdminPermission( ply, "noclip" ) then
    if (ply:GetMoveType() != MOVETYPE_NOCLIP) then
  		ply:SetMoveType(MOVETYPE_NOCLIP)
  	else
  		ply:SetMoveType(MOVETYPE_WALK)
  	end
    if !GetAdminPermission( ply, "nologs" ) && flrp.config.logs["admin"] then
      flrp.logs.printlog( "[FL ADMIN] " .. ply:Nick() .. " использовал ноуклип." )
      for k, v in pairs( player.GetAll() ) do
        if GetAdminPermission( v, "viewlog" ) then
          v:SendLua( "print ('[FL ADMIN] " .. util.TypeToString(ply:Nick()) .. " использовал ноуклип. ')" )
        end
      end
    end
  end
end

concommand.Add( "fl_setrank" , FLRPSetRank )
concommand.Add( "fl_noclip" , FLRPNoclip )

--concommand.Add( "yamato" , function( ply ) print(flrp.config.usergroup.immunity["" .. ply:GetUserGroup() .. ""]) end )
