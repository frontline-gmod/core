util.AddNetworkString( "OpenBanMenu" )

hook.Add("PlayerSay", "FLRPAdminCommands", function( ply, text )
	local text_args = string.Explode( " ", text )

	if GetAdminUsergroup( ply:GetUserGroup() ) then
		if GetAdminPermission( ply, "noclip" ) then
			if text_args[1] == "!noclip" then
				FLRPGoto( ply, target )
			end
		end
		if GetAdminPermission( ply, "cloak" ) then
			if text_args[1] == "!cloak" then
				FLRPNoTarget( ply, target )
			end
		end
		if GetAdminPermission( ply, "teleport" ) then
			if text_args[1] == "!goto" then
				local target = FindPlayer( text_args[2], ply )
				if IsValid(target) then
					FLRPGoto( ply, target )
				end
			end
			if text_args[1] == "!bring" then
				local target = FindPlayer( text_args[2], ply )
				if IsValid(target) then
					FLRPBring( ply, target )
				end
			end
		end
		if GetAdminPermission( ply, "notarget" ) then
			if text_args[1] == "!notarget" then
				local target = FindPlayer( text_args[2], ply )
				if IsValid(target) then
					FLRPNoTarget( ply, target )
				end
			end
		end
		if GetAdminPermission( ply, "kick" ) then
			if text_args[1] == "!kick" then
				local target = FindPlayer( text_args[2], ply )
				local reason_kick = table.concat( text_args, " ", 3, #text_args )
				PrintTable( text_args )
				print(#text_args)
				if IsValid(target) then
					FLRPKick( ply, target, reason_kick )
				end
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
			end
		end
    if flrp.config.enable_secondary_modules["Whitelist"] == true then
			if GetAdminPermission( ply, "whitelist" ) then
	      if text_args[1] == "!whitelist" then
					-- тело
				end
			end
    end
	end
end)
