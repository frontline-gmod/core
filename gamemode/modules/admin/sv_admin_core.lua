function GetAdminUsergroup( usergroup )
  if flrp.config.usergroup["" .. usergroup .. ""] then return true else return false end
end

function GetAdminPermission( ply, permission )
  return table.HasValue(flrp.config.usergroup["" .. ply:GetUserGroup() .. ""], permission)
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
        v:SendLua( "chat.AddText( Color( 255, 174, 43 ), '[FL ADMIN] ', Color( 192, 214, 228 ), ' " .. util.TypeToString(ply:Nick()) .. " использовал ноуклип.' )" )
      end
    end
  end
end

concommand.Add( "fl_noclip" , FLRPNoclip )
