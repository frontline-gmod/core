hook.Add("PlayerCanHearPlayersVoice", "FLRPPlayerVoice", function(listener, talker)
    if listener:GetPos():Distance(talker:GetPos()) > flrp.config.roleplay.voice_distance then return false end
end)

hook.Add("PlayerCanSeePlayersChat", "FLRPPlayerChat", function(text, teamOnly, listener, speaker)
    if listener:GetPos():Distance(speaker:GetPos()) > flrp.config.roleplay.chat_distance then return false end
end)

hook.Add( "ChatText", "FLRPHideJoinLeaveChange", function( index, name, text, typ )
  if ( typ == "joinleave" ) then return true end
	if ( typ == "namechange" ) then return true end
end )
