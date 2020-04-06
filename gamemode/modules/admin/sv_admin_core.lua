function FindPlayer(identifier, user)

	if (!identifier) then return end

	local output = {}

	for k,v in ipairs(player.GetAll()) do
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
	end

	if (identifier == "^") then
		return user
	end

	if (#output > 1) then
		if (IsValid(user)) then
      user:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Найдено несколько игроков с такими данными.')" )
		end
	else
		if (IsValid(user)) then
      user:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Невозможно найти игрока с такими данными.')" )
    end
	end
end

function FLRPSetRank( ply, target, usergroup )

  if GetAdminPermission( ply, "setrank" ) && IsValid(target) then
    if GetAdminUsergroup( usergroup ) && CheckAdminImmunity( ply, target ) then
      target:SetUserGroup( usergroup )
      database.orm.update("users", {
        usergroup = usergroup
      }, {
        steamid64 = target:SteamID64()
      })
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы выдали игроку " .. util.TypeToString(target:Nick()) .. " привилегию " .. util.TypeToString(usergroup) .. ".')" )
      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы получили привилегию: " .. util.TypeToString(usergroup) .. ".')" )
			AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) выдал игроку %s(%s) привилегию %s", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64(), usergroup ))
		else
      if !GetAdminUsergroup( usergroup ) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Данная привилегия отсутствует!')" ) end
      if !CheckAdminImmunity( ply, target ) then ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" ) end
    end
  end

end

function FLRPNoclip( ply )

  if GetAdminPermission( ply, "noclip" ) then
    if ply:GetMoveType() != MOVETYPE_NOCLIP then
      ply:SetMoveType(MOVETYPE_NOCLIP)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы включили ноуклип!')" )
      if flrp.config.admin_core_settings["EnableCloakWithNoclip"] == true then
        FLRPCloak( ply )
      end
    else
      ply:SetMoveType(MOVETYPE_WALK)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы выключили ноуклип!')" )
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
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы включили невидимку!')" )
    elseif ply:GetAdminCloak() == true then
      ply:SetNoDraw(false)
      ply:SetNotSolid(false)
      ply:RemoveFlags(FL_NOTARGET)
      ply:GodDisable()
      ply:SetAdminCloak( false )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы выключили невидимку!')" )
    end
  end

end

function FLRPBring ( ply, target )

  if GetAdminPermission( ply, "teleport" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      target:SetPos(ply:GetPos()-Vector(0,-75,-10))
      target:SetMoveType(MOVETYPE_NONE)
      target:SetMoveType(MOVETYPE_WALK)
      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вас телепортировал администратор: " .. util.TypeToString(ply:Nick()) .. ".')" )
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы успешно телепортировали игрока!')" )
			AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) телепортировал игрока %s(%s) к себе", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64() ))
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
    end
  end

end

function FLRPGoto( ply, target )

  if GetAdminPermission( ply, "teleport" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      ply:SetPos(target:GetPos()-Vector(0,-75,-10))
      ply:SetMoveType(MOVETYPE_NONE)
      ply:SetMoveType(MOVETYPE_WALK)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы успешно телепортировались к игроку!')" )
      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'К вам телепортировался администратор: " .. util.TypeToString(ply:Nick()) .. ".')" )
			AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) телепортировался к игроку %s(%s)", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64() ))
		else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
    end
  end

end

function FLRPModel( ply, target, model )

  if GetAdminPermission( ply, "model" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
			target:SetModel(model)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы успешно сменили модель игроку!')" )
      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Администратор: " .. util.TypeToString(ply:Nick()) .. " сменил вам модель.')" )
			AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) выдал игроку %s(%s) модель: %s", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64(), model ))
		else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
    end
  end

end

function FLRPScale( ply, target, scale )

  if GetAdminPermission( ply, "scale" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
			if isnumber(scale) then
				target:SetModelScale(scale, 1)
	      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы успешно изменили размер модели игроку!')" )
	      target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Администратор: " .. util.TypeToString(ply:Nick()) .. " изменил размер вашей модели.')" )
				AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) изменил игроку %s(%s) размер модели", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64() ))
			else
				ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Укажите размер увелечения модели в виде числа!')" )
			end
		else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
    end
  end

end

function FLRPNoTarget( ply, target )

  if GetAdminPermission( ply, "notarget" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      if target:IsFlagSet(65536) then
        target:RemoveFlags(65536)
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы успешно сняли невидимку от НПСи!')" )
        target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вам снял невидимку от НПСи администратор: " .. util.TypeToString(ply:Nick()) .. ".')" )
				AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) выключил ноутаргет игроку %s(%s)", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64() ))
		  else
        target:AddFlags(65536)
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы успешно выдали невидимку от НПСи игроку: " .. util.TypeToString(target:Nick()) .. ".')" )
        target:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вам была выдана невидимка от НПСи администратором: " .. util.TypeToString(ply:Nick()) .. ".')" )
				AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) включил ноутаргет игроку %s(%s)", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64() ))
		  end
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
    end
  end

end

function FLRPKick( ply, target, reason_kick )

  if reason_kick == nil then reason_kick = "Без причины" end

  if GetAdminPermission( ply, "kick" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      target:Kick(reason_kick)
      for k,v in pairs(player.GetAll()) do
        v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target:Name()) .. " был кикнут ".. util.TypeToString(ply:Name()) .." по причине: ".. util.TypeToString(reason_kick) ..".')" )
      end
			AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) кикнул игрока %s(%s) по причине: %s", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64(), reason_kick ))
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
    end
  end

end

function FLRPBan( ply, target, lenght, reason_ban )

  local maxlenght = tonumber(flrp.config.usergroup.lenght[ply:GetUserGroup()])

  if reason_ban == nil then reason_ban = "Без причины" end

  if !isnumber(lenght) then
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы указали не правильный срок!')" )
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Время указывается в минутах.')" )
    return
  end

  if GetAdminPermission( ply, "ban" ) && IsValid(target) then
    if CheckAdminImmunity( ply, target ) then
      if maxlenght >= lenght && lenght > 0 then
        local insertbanTable = {
					nick = target:Nick(),
          steamid64 = target:SteamID64(),
          ip = target:IPAddress(),
          reason = reason_ban,
          date = os.time() + (lenght*60),
        }
        database.orm.insert("bans", {
					nick = target:Nick(),
          steamid64 = target:SteamID64(),
          ip = target:IPAddress(),
          reason = reason_ban,
          date = os.time() + (lenght*60),
        })
        table.insert( flrp.banlist[1], insertbanTable )
        target:Kick(reason_ban)
        for k,v in pairs(player.GetAll()) do
          v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target:Name()) .. " был заблокирован ".. util.TypeToString(ply:Name()) .. " сроком на " .. util.TypeToString(tostring(lenght+0)) .. " минут(ы) по причине: " .. util.TypeToString(reason_ban) .. ".')" )
        end
				AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) заблокировал игрока %s(%s) сроком на %s минут(-ы) по причине: %s", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64(), lenght, reason_ban ))
      elseif lenght == 0 then
        if GetAdminPermission( ply, "perm" ) then
          local insertbanTable = {
						nick = target:Nick(),
            steamid64 = target:SteamID64(),
            ip = target:IPAddress(),
            reason = reason_ban,
            date = 0,
          }
          database.orm.insert("bans", {
						nick = target:Nick(),
            steamid64 = target:SteamID64(),
            ip = target:IPAddress(),
            reason = reason_ban,
            date = 0,
          })
          table.insert( flrp.banlist[1], insertbanTable )
          target:Kick(reason_ban)
          for k,v in pairs(player.GetAll()) do
            v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target:Name()) .. " был заблокирован ".. util.TypeToString(ply:Name()) .." перманентно по причине: ".. util.TypeToString(reason_ban) ..".')" )
          end
					AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) заблокировал игрока %s(%s) пермаментно по причине: %s", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64(), reason_ban ))
        else
          ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Слишком большой срок для вашей привилегии!')" )
          ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'У вас нет прав на блокировку пермаментом!')" )
        end
      else
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Слишком большой срок для вашей привилегии!')" )
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш текущий максимальный срок блокировки: ".. maxlenght .. " минут.')" )
      end
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
    end
  end

end

function FLRPUnban( ply, target )

  if GetAdminPermission( ply, "unban" ) then
    for k,v in pairs (flrp.banlist[1]) do
      if flrp.banlist[1][k].steamid64 == target then
        table.RemoveByValue( flrp.banlist, flrp.banlist[1][k])
        database.orm.delete("bans", {steamid64 = target})
        for k,v in pairs(player.GetAll()) do
          v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target) .. " был разблокирован администратором: " .. util.TypeToString(ply:Name()) .. ".')" )
        end
				AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) разблокировал игрока %s(%s)", ply:Name(), ply:SteamID64(), flrp.banlist[1][k].nick, flrp.banlist[1][k].steamid64 ))
      end
    end
  end

end

function FLRPIncognito( ply )

  if ply:GetUserGroup() != flrp.config.defaultusergroup then
    if GetAdminPermission( ply, "incognito" ) then
      local incognitoinsertTable = {
        steamid64 = ply:SteamID64(),
        usergroup = ply:GetUserGroup(),
      }
      table.insert( flrp.incognitolist, incognitoinsertTable )
      ply:SetUserGroup(flrp.config.defaultusergroup)
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы вошли в инкогнито!')" )
    else
      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'У вас нет прав на инкогнито!')" )
    end
  else
    for k,v in pairs (flrp.incognitolist) do
  		if flrp.incognitolist[k].steamid64 == ply:SteamID64() then
        ply:SetUserGroup(flrp.incognitolist[k].usergroup)
        table.RemoveByValue(flrp.incognitolist, flrp.incognitolist[k])
        ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы вышли из инкогнито!')" )
  		end
  	end
  end

end

function FLRPRespawn( ply, target )

  if GetAdminPermission( ply, "respawn" ) then
		if CheckAdminImmunity( ply, target ) then
	    target:Spawn()
	    for k,v in pairs(player.GetAll()) do
	      v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), '" .. util.TypeToString(target:Nick()) .. " был зареспавнен администратором: " .. util.TypeToString(ply:Name()) .. ".')" )
	    end
			AddLogString(tostring(os.time()), "Админ", string.format( "Игрок %s(%s) зареспавнил игрока %s(%s)", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64() ))
		else
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
		end
	end

end

function FLRPSetHealth( ply, target, health_value )

	if GetAdminPermission( ply, "sethealth" ) then
		if CheckAdminImmunity( ply, target ) then
			target:SetHealth(health_value)
			for k,v in pairs(player.GetAll()) do
	      v:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Здоровье игрока " .. util.TypeToString(target:Nick()) .. " было изменено администратором: " .. util.TypeToString(ply:Name()) .. ".')" )
	    end
		else
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Ваш иммунитет меньше, чем у цели!')" )
		end
	end

end

hook.Add( "PhysgunPickup", "FLRPAdminPickUpPlayer", function( ply, ent )

	if GetAdminPermission( ply, "playerpickup" ) && ( ent:IsPlayer() && CheckAdminImmunity( ply, ent ) ) then
    ent:GodEnable()
    ent:SetNotSolid(true)
    ent:AddFlags(FL_NOTARGET, FL_FROZEN)
    ent:SetMoveType(MOVETYPE_NONE)
    ent:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вас взял физганом администратор: " .. util.TypeToString(ply:Nick()) .. "')" )
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы взяли физганом игрока: " .. util.TypeToString(ent:Nick()) .. "')" )
    return true
  end

end )

hook.Add( "PhysgunDrop", "FLRPAdminDropPlayer",function( ply, ent )

  if GetAdminPermission( ply, "playerpickup" ) && ( ent:IsPlayer() && CheckAdminImmunity( ply, ent ) ) then
    ent:GodDisable()
    ent:SetNotSolid(false)
    ent:RemoveFlags(FL_NOTARGET, FL_FROZEN)
    ent:SetMoveType(MOVETYPE_WALK)
    ent:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Администратор положил Вас!')" )
    ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы отпустили игрока!')" )
    return true
  end

end )

concommand.Add( "fl_noclip", function( ply ) FLRPNoclip( ply ) end)
concommand.Add( "fl_cloak", function( ply ) FLRPCloak( ply ) end)

function GM:PlayerSpawnProp(ply)
	if GetAdminPermission( ply, "spawnmenu" ) then
		if ply:GetCount("props") <= flrp.config.usergroup.limits[ply:GetUserGroup()].props-1 then
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы заспавнили проп! Лимит: (" .. ply:GetCount("props")+1  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].props .. ")')" )
			return true
		else
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы уже достигли лимита! Лимит: (" .. ply:GetCount("props")  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].props .. ")')" )
			return false
		end
	end
end

function GM:PlayerSpawnVehicle(ply)
	if GetAdminPermission( ply, "spawnmenu" ) then
		if ply:GetCount("vehicles") <= flrp.config.usergroup.limits[ply:GetUserGroup()].vehicles-1 then
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы заспавнили технику! Лимит: (" .. ply:GetCount("vehicles")+1  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].vehicles .. ")')" )
			return true
		else
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы уже достигли лимита! Лимит: (" .. ply:GetCount("vehicles")  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].vehicles .. ")')" )
			return false
		end
	end
end

function GM:PlayerGiveSWEP(ply)
	if GetAdminPermission( ply, "spawnmenu" ) then return true else return false end
end

function GM:PlayerSpawnNPC(ply)
	if GetAdminPermission( ply, "spawnmenu" ) then
		if ply:GetCount("npcs") <= flrp.config.usergroup.limits[ply:GetUserGroup()].npcs-1 then
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы заспавнили НПСи! Лимит: (" .. ply:GetCount("npcs")+1  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].npcs .. ")')" )
			return true
		else
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы уже достигли лимита! Лимит: (" .. ply:GetCount("npcs")  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].npcs .. ")')" )
			return false
		end
	end
end

function GM:PlayerSpawnEffect(ply)
	if GetAdminPermission( ply, "spawnmenu" ) then
		if ply:GetCount("effects") <= flrp.config.usergroup.limits[ply:GetUserGroup()].effects-1 then
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы заспавнили эффект! Лимит: (" .. ply:GetCount("effects")+1  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].effects .. ")')" )
			return true
		else
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы уже достигли лимита! Лимит: (" .. ply:GetCount("effects")  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].effects .. ")')" )
			return false
		end
	end
end

function GM:PlayerSpawnRagdoll(ply)
	if GetAdminPermission( ply, "spawnmenu" ) then
		if ply:GetCount("ragdolls") <= flrp.config.usergroup.limits[ply:GetUserGroup()].ragdolls-1 then
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы заспавнили рэгдолл! Лимит: (" .. ply:GetCount("ragdolls")+1  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].ragdolls .. ")')" )
			return true
		else
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ADMIN] ', Color( 235, 235, 235 ), 'Вы уже достигли лимита! Лимит: (" .. ply:GetCount("ragdolls")  .. "/" .. flrp.config.usergroup.limits[ply:GetUserGroup()].ragdolls .. ")')" )
			return false
		end
	end
end

function GM:PlayerSpawnObject(ply)
	if GetAdminPermission( ply, "spawnmenu" ) then return true else return false end
end
