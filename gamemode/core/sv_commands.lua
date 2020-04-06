hook.Add("PlayerSay", "FLRPAdminCommands", function( ply, text )
	local text_args = string.Explode( " ", string.lower(text) )

	if GetAdminUsergroup( ply:GetUserGroup() ) then

		if GetAdminPermission( ply, "noclip" ) then
			if text_args[1] == "!noclip" then
				FLRPNoclip( ply )
				return ""
			end
		end

		if GetAdminPermission( ply, "cloak" ) then
			if text_args[1] == "!cloak" then
				FLRPCloak( ply )
				return ""
			end
		end

		if GetAdminPermission( ply, "teleport" ) then
			if text_args[1] == "!goto" then
				local target = FindPlayer( text_args[2], ply )
				if IsValid(target) then
					FLRPGoto( ply, target )
				end
				return ""
			end
			if text_args[1] == "!bring" then
				local target = FindPlayer( text_args[2], ply )
				if IsValid(target) then
					FLRPBring( ply, target )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "notarget" ) then
			if text_args[1] == "!notarget" then
				local target = FindPlayer( text_args[2], ply )
				if IsValid(target) then
					FLRPNoTarget( ply, target )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "model" ) then
			if text_args[1] == "!model" then
				local target = FindPlayer( text_args[2], ply )
				local model = text_args[3]
				if IsValid(target) then
					FLRPModel( ply, target, model )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "scale" ) then
			if text_args[1] == "!scale" then
				local target = FindPlayer( text_args[2], ply )
				local scale = tonumber(text_args[3])
				if IsValid(target) then
					FLRPScale( ply, target, scale )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "kick" ) then
			if text_args[1] == "!kick" then
				local target = FindPlayer( text_args[2], ply )
				local reason_kick = table.concat( text_args, " ", 3, #text_args )
				if IsValid(target) then
					FLRPKick( ply, target, reason_kick )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "ban" ) then
			if text_args[1] == "!ban" then
				local target = FindPlayer( text_args[2], ply )
				local length = tonumber( text_args[3] )
				local reason_ban = table.concat( text_args, " ", 4, #text_args )
				if IsValid(target) then
					FLRPBan( ply, target, length, reason_ban )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "unban" ) then
			if text_args[1] == "!unban" then
				local target = text_args[2]
				if target then
					FLRPUnban( ply, target )
				end
				return ""
			end
			if text_args[1] == "!banlist" then
				local banlist = flrp.banlist[1]
				netstream.Start(ply, "BanListMenu", banlist)
				return ""
			end
		end

		if GetAdminPermission( ply, "setrank" ) then
			if text_args[1] == "!setrank" then
				local target = FindPlayer( text_args[2], ply )
				local usergroup = text_args[3]
				if IsValid(target) then
					FLRPSetRank( ply, target, usergroup )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "respawn" ) then
			if text_args[1] == "!respawn" then
				local target = FindPlayer( text_args[2], ply )
				if IsValid(target) then
					FLRPRespawn( ply, target )
				end
				return ""
			end
		end

		if GetAdminPermission( ply, "incognito" ) then
			if text_args[1] == "!incognito" then
				FLRPIncognito( ply )
				return ""
			end
		end

		if GetAdminPermission( ply, "logs" ) then
      if text_args[1] == "!logs" then
				local tableLogs = flrp.logs[1]
				netstream.Start( ply, "LogsMenu", ply, tableLogs )
				return ""
			end
		end

	 	for k, v in pairs(flrp.cmd.data) do
	 		if "/"..k == text_args[1] then
	 			text_args[1] = string.gsub(text_args[1], "/", "")
				v(ply, "flrp", text_args)
				return ""
	 		end
	 	end

    if flrp.config.enable_secondary_modules["Whitelist"] == true then
			if GetAdminPermission( ply, "whitelist" ) then
				local plyinfoTable = {}
	      if text_args[1] == "!whitelist" then
					table.Empty( plyinfoTable )
					for k,v in pairs( player.GetAll() ) do
						local getinfoTable = {
							steamid64 = v:SteamID64(),
							rank = v:GetRank(),
						}
						table.insert( plyinfoTable, getinfoTable )
					end
					netstream.Start( ply, "WhiteList", ply, plyinfoTable )
					return ""
				end
			end
    end

	end

	local ply_team_color = team.GetColor(ply:Team()):ToTable()

	if flrp.config.enable_primary_module == "Roleplay" then
		for _, v in pairs(ents.FindInSphere(ply:GetPos(), flrp.config.roleplay.chat_distance)) do
			if IsValid(v) && v:IsPlayer() && v != ply then
				v:SendLua(string.format("chat.AddText( Color( %s, %s, %s ), '%s: ', Color( 235, 235, 235 ), ' %s' )", ply_team_color[1], ply_team_color[2], ply_team_color[3], ply:Name(), text))
			end
		end
	end

	ply:SendLua(string.format("chat.AddText( Color( %s, %s, %s ), '%s: ', Color( 235, 235, 235 ), ' %s' )", ply_team_color[1], ply_team_color[2], ply_team_color[3], ply:Name(), text))
	return ""
end)

if flrp.config.enable_primary_module == "Roleplay" then

	concommand.Add("changeradiochannel", function(ply, cmd, args)
		local channel = math.Clamp(tonumber(args[1]), 1, 100)
		flrp.radio_channels[channel] = flrp.radio_channels[channel] or {}

		ply.RadioChannel = ply.RadioChannel or 1
		if flrp.radio_channels[ply.RadioChannel] then
			table.RemoveByValue(flrp.radio_channels[ply.RadioChannel],ply)
			if flrp.radio_channels[ply.RadioChannel] == {} then
				flrp.radio_channels[ply.RadioChannel] = nil
			end
		end

		ply.RadioChannel = channel
		table.insert(flrp.radio_channels[channel],ply)
		ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL RADIO] ', Color( 235, 235, 235 ), ' Вы поменяли на канал " .. channel .. ".' )" )
	end)

	concommand.Add("offradio", function(ply, cmd, args)
		flrp.radio_channels[0] = flrp.radio_channels[0] or {}

		ply.RadioChannel = ply.RadioChannel or 1
		if flrp.radio_channels[ply.RadioChannel] then
			table.RemoveByValue(flrp.radio_channels[ply.RadioChannel],ply)
			if flrp.radio_channels[ply.RadioChannel] == {} then
				flrp.radio_channels[ply.RadioChannel] = nil
			end
		end

		ply.PreRadioChannel = ply.RadioChannel
		ply.RadioChannel = 0
		table.insert(flrp.radio_channels[0],ply)
		ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL RADIO] ', Color( 235, 235, 235 ), ' Вы выключили рацию.' )" )
	end)

	concommand.Add("onradio", function(ply, cmd, args)
		ply.PreRadioChannel = ply.PreRadioChannel or 1

		local channel = ply.PreRadioChannel
		flrp.radio_channels[channel] = flrp.radio_channels[channel] or {}

		ply.RadioChannel = ply.RadioChannel or 1
		if flrp.radio_channels[0] and table.HasValue(flrp.radio_channels[0],ply) then
			table.RemoveByValue(flrp.radio_channels[0],ply)
			if flrp.radio_channels[ply.RadioChannel] == {} then
				flrp.radio_channels[ply.RadioChannel] = nil
			end
		end

		table.insert(flrp.radio_channels[channel],ply)
		ply.RadioChannel = channel
		ply.PreRadioChannel = nil
		ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL RADIO] ', Color( 235, 235, 235 ), ' Вы включили рацию.' )" )
		ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL RADIO] ', Color( 235, 235, 235 ), ' Канал был сменен на " .. channel .. ".' )" )
	end)

	concommand.Add("onlylisten", function(ply, cmd, args)
		local RadioOnlyListen = ply:GetNVar('RadioOnlyListen')
		if RadioOnlyListen then
			ply:SetNVar('RadioOnlyListen',false)
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL RADIO] ', Color( 235, 235, 235 ), ' Вы выключили режим прослушивания.' )" )
		else
			ply:SetNVar('RadioOnlyListen',true)
			ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL RADIO] ', Color( 235, 235, 235 ), ' Вы включили режим прослушивания.' )" )
		end
	end)

end
