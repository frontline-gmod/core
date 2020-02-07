hook.Add("PlayerSay", "FLRPAdminCommands", function( ply, text )
	if GetAdminUsergroup(ply:GetUserGroup()) then
		if ( string.sub( string.lower( text ), 1, 6 ) == "!admin" ) then
			ply:ConCommand( "fl_adminmenu" )
		end

		if ( string.sub( string.lower( text ), 1, 7 ) == "!noclip" ) then
			ply:ConCommand( "fl_noclip" )
		end

		if ( string.sub( string.lower( text ), 1, 6 ) == "!cloak" ) then
			ply:ConCommand( "fl_cloak" )
		end
	end
end)
