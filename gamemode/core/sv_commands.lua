util.AddNetworkString( "OpenBanMenu" )

hook.Add("PlayerSay", "FLRPAdminCommands", function( ply, text )
	if GetAdminUsergroup(ply:GetUserGroup()) then
		if ( string.sub( string.lower( text ), 1, 7 ) == "!noclip" ) then
			ply:ConCommand( "fl_noclip" )
		end
		if ( string.sub( string.lower( text ), 1, 6 ) == "!cloak" ) then
			ply:ConCommand( "fl_cloak" )
		end
		if ( string.sub( string.lower( text ), 1, 5 ) == "!goto" ) then
			ply:ConCommand( "fl_goto" .. string.sub( text, 6 ) )
		end
		if ( string.sub( string.lower( text ), 1, 6 ) == "!bring" ) then
			ply:ConCommand( "fl_bring" .. string.sub( text, 7 ) )
		end
		if ( string.sub( string.lower( text ), 1, 9 ) == "!notarget" ) then
			ply:ConCommand( "fl_notarget" .. string.sub( text, 10 ) )
		end
		if ( string.sub( string.lower( text ), 1, 4 ) == "!ban" ) then
			if IsValid(FindPlayer(string.sub( text, 6 ), ply)) then
				return
			end
		end
    if flrp.config.enable_secondary_modules["Whitelist"] == true then
      if ( string.sub( string.lower( text ), 1, 10 ) == "!whitelist" ) then
        ply:ConCommand( "fl_whitelist" )
      end
    end
	end
end)