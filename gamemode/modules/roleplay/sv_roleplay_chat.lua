flrp.radio_channels = flrp.radio_channels || {}

hook.Add( "ChatText", "FLRPHideJoinLeaveChange", function( index, name, text, typ )
  if ( typ == "joinleave" ) then return true end
	if ( typ == "namechange" ) then return true end
end )

function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, speaker)
  if listener:GetPos():Distance(speaker:GetPos()) > flrp.config.roleplay.chat_distance then return false end
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if !talker:Alive() then return false end

  local shootPos = listener:GetShootPos()
  local TRadioOnlyListen = talker:GetNVar("RadioOnlyListen")
  local LRadioOnlyListen = listener:GetNVar("RadioOnlyListen")

	talker.RadioChannel = talker.RadioChannel || 0
	listener.RadioChannel = listener.RadioChannel || 0

	if RadioOnlyListen == nil then
		talker:SetNVar("RadioOnlyListen", true)
		RadioOnlyListen = true
	end

	if TRadioOnlyListen == true then
		if shootPos:DistToSqr(talker:GetShootPos()) < flrp.config.roleplay.max_voice_distance then
			return true, true
		end
	elseif (flrp.radio_channels[talker.RadioChannel] && table.HasValue(flrp.radio_channels[talker.RadioChannel],listener) && talker.RadioChannel != 0) || shootPos:DistToSqr(talker:GetShootPos()) < flrp.config.roleplay.max_voice_distance then
		return true, talker.RadioChannel == 0 || listener.RadioChannel == 0
	end
end
