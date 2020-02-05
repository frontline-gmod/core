hook.Add("PlayerSay", "FLRPAdminCommands", function( ply, text )

	if ply:IsAdmin() then

		if ( string.sub( string.lower( text ), 1, 6 ) == "!admin" ) then
			ply:ConCommand( "fl_adminmenu" )
		end

		if ( string.sub( string.lower( text ), 1, 6 ) == "!noclip" ) then
			ply:ConCommand( "fl_noclip" )
		end

	end

end)
