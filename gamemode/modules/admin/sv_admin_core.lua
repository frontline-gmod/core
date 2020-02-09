function GetAdminUsergroup( usergroup )
  if flrp.config.usergroup["" .. usergroup .. ""] then return true else return false end
end

function GetAdminPermission( ply, permission )
  return table.HasValue(flrp.config.usergroup["" .. ply:GetUserGroup() .. ""], permission)
end

function GetAdminImmunity( ply )
  return flrp.config.usergroup.immunity["" .. ply:GetUserGroup() .. ""]
end

function CheckAdminImmunity( ply, target )
  if flrp.config.usergroup.immunity["" .. ply:GetUserGroup() .. ""] >= flrp.config.usergroup.immunity["" .. target:GetUserGroup() .. ""] then return true else return false end
end

function CheckSteamID64( target, steamid )
  if target:SteamID64() == steamid then return true else return false end
end

function CheckName( target, nick )
  local nick = string.lower(nick)
  local target = string.lower(target:Name())
  if target == nick then return true else return false end
end

function FLRPSetRank( ply, cmd, args )

  local target = args[1]
  local usergroup = args[2]

  for k,v in pairs(player.GetAll()) do
    if GetAdminPermission( ply, "setrank" ) then
      if (CheckName( v, target ) || CheckSteamID64( v, target )) && GetAdminUsergroup( usergroup ) && CheckAdminImmunity( ply, v ) then
        v:SetUserGroup( usergroup )
        v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы получили привилегию: " .. util.TypeToString(usergroup) .. "')" )
        flrp.logs.printlog( "[FL ADMIN] " .. ply:Nick() .. " выдал игроку " .. v:Nick() .. " привилегию " .. util.TypeToString(usergroup) .. "." )
        for k, val in pairs( player.GetAll() ) do
          if GetAdminPermission( val, "viewlog" ) then
            val:SendLua( "print ('[FL ADMIN] " .. ply:Nick() .. " выдал игроку " .. val:Nick() .. " привилегию " .. util.TypeToString(usergroup) .. ".')" )
          end
        end
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы выдали привилегию " .. util.TypeToString(usergroup) .. " игроку " .. util.TypeToString(v:Nick()) .. "' )" )
      else
        if !GetAdminUsergroup( usergroup ) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Данная привилегия отсутствует!' )" ) end
        if !CheckAdminImmunity( ply, v ) && (CheckName( v, target ) || CheckSteamID64( v, target )) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" ) end
      end
    end
  end

end

function FLRPNoclip( ply )

  if GetAdminPermission( ply, "noclip" ) then
    if ply:GetMoveType() != MOVETYPE_NOCLIP then
      ply:SetMoveType(MOVETYPE_NOCLIP)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы включили ноуклип!' )" )
      if flrp.config.admin_core_settings["EnableCloakWithNoclip"] == true then
        FLRPCloak( ply )
      end
    else
      ply:SetMoveType(MOVETYPE_WALK)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы выключили ноуклип!' )" )
      if flrp.config.admin_core_settings["EnableCloakWithNoclip"] == true then
        FLRPCloak( ply )
      end
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

function FLRPCloak( ply )

  AccessorFunc( pMeta, "admin_cloak", "AdminCloak", FORCE_BOOL )

  if ply:GetMoveType() == MOVETYPE_NOCLIP then ply:SetAdminCloak( false ) end

  if GetAdminPermission( ply, "cloak" ) then
    if ply:GetAdminCloak() == nil then ply:SetAdminCloak( false ) end
    if ply:GetAdminCloak() == false then
      ply:SetNoDraw(true)
      ply:SetNotSolid(true)
      ply:AddFlags(FL_NOTARGET)
      ply:GodEnable()
      ply:SetAdminCloak( true )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы включили невидимку!' )" )
      flrp.logs.printlog( "[FL ADMIN] " .. ply:Nick() .. " использовал невидимку." )
      for k, v in pairs( player.GetAll() ) do
        if GetAdminPermission( v, "viewlog" ) then
          v:SendLua( "print ('[FL ADMIN] " .. ply:Nick() .. " использовал невидимку.')" )
        end
      end
    elseif ply:GetAdminCloak() == true then
      ply:SetNoDraw(false)
      ply:SetNotSolid(false)
      ply:RemoveFlags(FL_NOTARGET)
      ply:GodDisable()
      ply:SetAdminCloak( false )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы выключили невидимку!' )" )
      flrp.logs.printlog( "[FL ADMIN] " .. ply:Nick() .. " использовал невидимку." )
      for k, v in pairs( player.GetAll() ) do
        if GetAdminPermission( v, "viewlog" ) then
          v:SendLua( "print ('[FL ADMIN] " .. ply:Nick() .. " использовал невидимку.')" )
        end
      end
    end
  end

end

function FLRPBring ( ply, cmd, args )

  local target = args[1]

  for k, v in pairs( player.GetAll() ) do
    if (CheckName( v, target ) || CheckSteamID64( v, target )) && GetAdminPermission( ply, "teleport" ) && CheckAdminImmunity( ply, v ) then
      v:SetPos(ply:GetPos()-Vector(0,-75,-10))
      v:SetMoveType(MOVETYPE_NONE)
      v:SetMoveType(MOVETYPE_WALK)
      v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вас телепортировал администратор: " .. util.TypeToString(ply:Nick()) .. "' )" )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы успешно телепортировали игрока!' )" )
    end
    if !CheckAdminImmunity( ply, v ) && (CheckName( v, target ) || CheckSteamID64( v, target )) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" ) end

  end

end

function FLRPGoto ( ply, cmd, args )

  local target = args[1]

  for k, v in pairs( player.GetAll() ) do
    if (CheckName( v, target ) || CheckSteamID64( v, target )) && GetAdminPermission( ply, "teleport" ) && CheckAdminImmunity( ply, v ) then
      ply:SetPos(v:GetPos()-Vector(0,-75,-10))
      ply:SetMoveType(MOVETYPE_NONE)
      ply:SetMoveType(MOVETYPE_WALK)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы успешно телепортировались к игроку!' )" )
      v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' К вам телепортировался администратор: " .. util.TypeToString(ply:Nick()) .. "' )" )
    end
    if !CheckAdminImmunity( ply, v ) && (CheckName( v, target ) || CheckSteamID64( v, target )) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" ) end
  end

end

concommand.Add( "fl_setrank" , FLRPSetRank )
concommand.Add( "fl_noclip" , FLRPNoclip )
concommand.Add( "fl_cloak" , FLRPCloak )
concommand.Add( "fl_bring" , FLRPBring )
concommand.Add( "fl_goto" , FLRPGoto )
concommand.Add( "fl_check" , function (ply, cmd, args)
  local target = args[1]

  for k, v in pairs( player.GetAll() ) do
    if CheckName( v, target ) || CheckSteamID64( v, target ) then
      ply:ChatPrint("Привилегия: " .. v:GetUserGroup() .. " Иммунитет: " .. flrp.config.usergroup.immunity["" .. v:GetUserGroup() .. ""])
    end
  end
end)

hook.Add( "PostPlayerDeath", "FLRPAdminDeath", function( ply )
  if GetAdminPermission( ply, "cloak" ) then
    if ply:GetAdminCloak() == true then
      ply:SetNoDraw(false)
      ply:SetNotSolid(false)
      ply:RemoveFlags(FL_NOTARGET)
      ply:GodDisable()
      ply:SetAdminCloak( false )
    end
  end
end)

hook.Add( "PhysgunPickup", "FLRPAdminPickUpPlayer", function( ply, ent )
	if GetAdminPermission( ply, "playerpickup" ) && ( ent:IsPlayer() && CheckAdminImmunity( ply, ent ) ) then
    ent:GodEnable()
    ent:SetNotSolid(true)
    ent:AddFlags(FL_NOTARGET, FL_FROZEN)
    ent:SetMoveType(MOVETYPE_NONE)
    ent:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вас взял физганом администратор: " .. util.TypeToString(ply:Nick()) .. "' )" )
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы взяли физганом игрока: " .. util.TypeToString(ent:Nick()) .. "' )" )
    return true
  end
end )

hook.Add( "PhysgunDrop", "FLRPAdminDropPlayer",function( ply, ent )
  if GetAdminPermission( ply, "playerpickup" ) && ( ent:IsPlayer() && CheckAdminImmunity( ply, ent ) ) then
    ent:GodDisable()
    ent:SetNotSolid(false)
    ent:RemoveFlags(FL_NOTARGET, FL_FROZEN)
    ent:SetMoveType(MOVETYPE_WALK)
    ent:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Администратор положил Вас!' )" )
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы отпустили игрока!' )" )
    return true
  end
end )
