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

function FindPlayer(identifier, user)
	if (!identifier) then
		return
	end

	local output = {}

	for k, v in ipairs(player.GetAll()) do
		local playerNick = string.lower(v:Nick())
		local playerName = string.lower(v:Name())

		if (v:SteamID() == identifier or v:UniqueID() == identifier or v:SteamID64() == identifier or (v:IPAddress():gsub(":%d+", "")) == identifier
    or playerNick == string.lower(identifier) or playerName == string.lower(identifier)) then
			return v
		end

		if (string.find(playerNick, string.lower(identifier), 0, true) or string.find(playerName, string.lower(identifier), 0, true)) then
			table.insert(output, v)
		end
	end

	if (#output == 1) then
		return output[1]
	elseif (#output > 1) then
		if (IsValid(user)) then
      user:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Найдено несколько игроков с такими данными.' )" )
		end
	else
		if (IsValid(user)) then
      user:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Невозможно найти игрока с такими данными.' )" )
    end
	end
end

function FLRPSetRank( ply, command, args )

  local target = FindPlayer( args[1], ply )
  local usergroup = args[2]

  if GetAdminPermission( ply, "setrank" ) && IsValid(target) then
    if GetAdminUsergroup( usergroup ) && CheckAdminImmunity( ply, target ) then
      target:SetUserGroup( usergroup )
      database.orm.update("users", {
        usergroup = usergroup
      }, {
        steamid64 = target:SteamID64()
      })
      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы получили привилегию: " .. util.TypeToString(usergroup) .. "')" )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы выдали привилегию " .. util.TypeToString(usergroup) .. " игроку " .. util.TypeToString(target:Nick()) .. "' )" )
    else
      if !GetAdminUsergroup( usergroup ) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Данная привилегия отсутствует!' )" ) end
      if !CheckAdminImmunity( ply, target ) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" ) end
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
  end

end

function FLRPCloak( ply )

  AccessorFunc( pMeta, "admin_cloak", "AdminCloak", FORCE_BOOL )

  if ply:GetMoveType() == MOVETYPE_NOCLIP then ply:SetAdminCloak( false ) end

  if GetAdminPermission( ply, "noclip" ) then
    if ply:GetAdminCloak() == nil then ply:SetAdminCloak( false ) end
    if ply:GetAdminCloak() == false then
      ply:SetNoDraw(true)
      ply:SetNotSolid(true)
      ply:AddFlags(FL_NOTARGET)
      ply:GodEnable()
      ply:SetAdminCloak( true )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы включили невидимку!' )" )
    elseif ply:GetAdminCloak() == true then
      ply:SetNoDraw(false)
      ply:SetNotSolid(false)
      ply:RemoveFlags(FL_NOTARGET)
      ply:GodDisable()
      ply:SetAdminCloak( false )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы выключили невидимку!' )" )
    end
  end

end

function FLRPBring ( ply, command, args )

  local target = FindPlayer( args[1], ply )

  if GetAdminPermission( ply, "teleport" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      target:SetPos(ply:GetPos()-Vector(0,-75,-10))
      target:SetMoveType(MOVETYPE_NONE)
      target:SetMoveType(MOVETYPE_WALK)
      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вас телепортировал администратор: " .. util.TypeToString(ply:Nick()) .. "' )" )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы успешно телепортировали игрока!' )" )
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" )
    end
  end

end

function FLRPGoto ( ply, command, args )

  local target = FindPlayer( args[1], ply )

  if GetAdminPermission( ply, "teleport" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      ply:SetPos(target:GetPos()-Vector(0,-75,-10))
      ply:SetMoveType(MOVETYPE_NONE)
      ply:SetMoveType(MOVETYPE_WALK)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы успешно телепортировались к игроку!' )" )
      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' К вам телепортировался администратор: " .. util.TypeToString(ply:Nick()) .. "' )" )
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" )
    end
  end

end

function FLRPNoTarget ( ply, command, args )

  local target = FindPlayer( args[1], ply )

  if GetAdminPermission( ply, "setnotarget" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      if target:GetFlags() != 65536 then
        target:AddFlags(FL_NOTARGET)
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы успешно выдали невидимку от НПСи!' )" )
        target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вам была выдана невидимка от НПСи администратором: " .. util.TypeToString(ply:Nick()) .. "' )" )
      else
        target:RemoveFlags(FL_NOTARGET)
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы успешно сняли невидимку от НПСи!' )" )
        target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вам снял невидимку от НПСи администратор: " .. util.TypeToString(ply:Nick()) .. "' )" )
      end
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" )
    end
  end

end

function FLRPKick ( ply, command, args )

  local target = FindPlayer( args[1], ply )
  local reason = table.concat(args, " ", 2)

  if reason == "" || nil then reason = "Без причины" end

  if GetAdminPermission( ply, "kick" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      target:Kick(reason)
      for k, v in pairs(player.GetAll()) do
        v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target:Name()) .. " был кикнут ".. util.TypeToString(ply:Name()) .." по причине: ".. util.TypeToString(reason) .."')" )
      end
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" )
    end
  end

end

concommand.Add( "fl_setrank" , FLRPSetRank )
concommand.Add( "fl_noclip" , FLRPNoclip )
concommand.Add( "fl_cloak" , FLRPCloak )
concommand.Add( "fl_bring" , FLRPBring )
concommand.Add( "fl_goto" , FLRPGoto )
concommand.Add( "fl_notarget" , FLRPNoTarget )
concommand.Add( "fl_kick" , FLRPKick )
--concommand.Add( "fl_ban" , FLRPBan )

concommand.Add( "fl_check" , function( ply, command, args )
  local target = FindPlayer( args[1], ply )

  ply:ChatPrint(util.TypeToString(flrp.config.usergroup.immunity["" .. target:GetUserGroup() .. ""]))
end )

hook.Add( "PostPlayerDeath", "FLRPAdminDeath", function( ply )
  if GetAdminPermission( ply, "noclip" ) then
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
