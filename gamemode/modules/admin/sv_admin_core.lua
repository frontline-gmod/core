function GetAdminUsergroup( usergroup )
  if flrp.config.usergroup[usergroup ] then return true else return false end
end

function GetAdminPermission( ply, permission )
  if (type(ply) == "Entity" and !IsValid(ply) and (ply.EntIndex and ply:EntIndex() == 0)) then return true end
  if IsValid(ply) then return table.HasValue(flrp.config.usergroup[ply:GetUserGroup()], permission) end
end

function GetAdminImmunity( ply )
  if (type(ply) == "Entity" and !IsValid(ply) and (ply.EntIndex and ply:EntIndex() == 0)) then return true end
  if IsValid(ply) then return flrp.config.usergroup.immunity[ply:GetUserGroup()] end
end

function CheckAdminImmunity( ply, target )
  if (type(ply) == "Entity" and !IsValid(ply) and (ply.EntIndex and ply:EntIndex() == 0)) then return true end
  if IsValid(ply) then if flrp.config.usergroup.immunity[ply:GetUserGroup()] >= flrp.config.usergroup.immunity[target:GetUserGroup()] then return true else return false end end
end

function IsConsole( ply )
	if (type(ply) == "Entity" and !IsValid(ply) and (ply.EntIndex and ply:EntIndex() == 0)) then
		return true
	end

	return false
end

function FindPlayer(identifier, user)
	if (!identifier) then return end

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
      if !IsConsole( ply ) then
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Вы выдали привилегию " .. util.TypeToString(usergroup) .. " игроку " .. util.TypeToString(target:Nick()) .. "' )" )
      end
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

function FLRPBan ( ply, command, args )

  local target = FindPlayer( args[1], ply )
  local length = tonumber(table.concat(args, " ", 2, 2))
  local reason_ban = table.concat(args, " ", 3, 3)

  if reason_ban == nil then reason_ban = "Без причины" end

  if !isnumber(length) || (length+0) == nil then
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы указали не правильный срок!' )" )
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Время указывается в минутах.' )" )
    return
  end

  if GetAdminPermission( ply, "ban" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      if flrp.config.usergroup.lenght[ply:GetUserGroup()] >= length && length > 0 then
        local insertbanTable = {
          steamid64 = target:SteamID64(),
          ip = target:IPAddress(),
          reason = reason_ban,
          date = os.time() + (length*60),
        }
        database.orm.insert("bans", {
          steamid64 = target:SteamID64(),
          ip = target:IPAddress(),
          reason = reason_ban,
          date = os.time() + (length*60),
        })
        table.insert( flrp.banlist[1], insertbanTable )
        target:Kick(reason_ban)
        for k, v in pairs(player.GetAll()) do
          v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target:Name()) .. " был заблокирован ".. util.TypeToString(ply:Name()) .." по причине: ".. util.TypeToString(reason_ban) .." сроком на " .. util.TypeToString(tostring(length+0)) .. " минут(ы)')" )
        end
      elseif length == 0 then
        if GetAdminPermission( ply, "perm" ) then
          local insertbanTable = {
            steamid64 = target:SteamID64(),
            ip = target:IPAddress(),
            reason = reason_ban,
            date = 0,
          }
          database.orm.insert("bans", {
            steamid64 = target:SteamID64(),
            ip = target:IPAddress(),
            reason = reason_ban,
            date = 0,
          })
          table.insert( flrp.banlist[1], insertbanTable )
          target:Kick(reason_ban)
          for k, v in pairs(player.GetAll()) do
            v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target:Name()) .. " был заблокирован ".. util.TypeToString(ply:Name()) .." пермаментно по причине: ".. util.TypeToString(reason_ban) .."')" )
          end
        else
          ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Слишком большой срок для вашей привилегии!' )" )
          ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' У вас нет прав на блокировку пермаментом!' )" )
        end
      else
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Слишком большой срок для вашей привилегии!' )" )
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш текущий максимальный срок блокировки: ".. flrp.config.usergroup.lenght["" .. ply:GetUserGroup() .. ""] .. " минут' )" )
      end
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), ' Ваш иммунитет меньше, чем у цели!' )" )
    end
  end

end

function FLRPUnBan ( ply, command, args )

  local target = table.concat(args, 1, 1)

  if GetAdminPermission( ply, "unban" ) then
    for k,v in pairs (flrp.banlist[1]) do
      if flrp.banlist[1][k].steamid64 == target then
        table.RemoveByValue( flrp.banlist, flrp.banlist[1][k])
        database.orm.delete("bans",
        {
          steamid64 = target
        })
        for k, v in pairs(player.GetAll()) do
          v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target) .. " был разблокирован ".. util.TypeToString(ply:Name()) .." ')" )
        end
      end
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
concommand.Add( "fl_ban" , FLRPBan )
concommand.Add( "fl_unban", FLRPUnBan )

concommand.Add( "fl_check" , function( ply, command, args )
  local target = FindPlayer( args[1], ply )

  if IsValid(target) then
    ply:ChatPrint(util.TypeToString(flrp.config.usergroup.immunity[target:GetUserGroup()]))
  end
end )

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
