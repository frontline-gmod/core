util.AddNetworkString( "OpenWhitelistMenu" )

concommand.Add( "fl_whitelist", function( ply, command, args )
  net.Start( "OpenWhitelistMenu" )
  net.Send( ply )
end)
