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
  end
end

concommand.Add( "fl_noclip" , FLRPNoclip )
