local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
	local bnd = string.match(string.lower(bind), "gm_[a-z]+[12]?")
	if bnd && FKeyBinds[bnd] && GAMEMODE[FKeyBinds[bnd]] then
		GAMEMODE[FKeyBinds[bnd]](GAMEMODE)
	end
	return
end

function GM:ShowTeam()

	LocalPlayer().RadioOnlyListen = LocalPlayer().RadioOnlyListen || false

	local frame = vgui.Create( "XeninUI.Frame" )
	frame:SetSize( XeninUI.Frame.Width/2-135, XeninUI.Frame.Height/4-10 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( "Рация" )
	function frame:Paint()
		draw.RoundedBox( 6, 0, 0, XeninUI.Frame.Width, XeninUI.Frame.Height, XeninUI.Theme.Background )

		draw.SimpleText( "Сменить канал:", "XeninUI.Frame.Title", 10, 50, Color(235,235,235) )
	end

	local radio_channel_number = vgui.Create( "DNumberWang", frame )
	radio_channel_number:SetMin( 1 )
	radio_channel_number:SetMax( 100 )
	radio_channel_number:SetSize( 200, 20 )
	radio_channel_number:SetPos( 10, 90 )
	radio_channel_number:SetText( LocalPlayer().RadioChannel || "" )
	function radio_channel_number:OnEnter()
		LocalPlayer().RadioChannel = tonumber( radio_channel_number:GetValue() ) || 1
		RunConsoleCommand( "changeradiochannel", LocalPlayer().RadioChannel )
		frame:SetVisible( false )
	end
	radio_channel_number.OnValueChanged = function(self)
		local value = self:GetValue()

		if value > 100 then
			self:SetText( 100 )
		end
		if value < 1 then
			self:SetText( 1 )
		end
	end

	local radio_onlylisten_check = vgui.Create( "DCheckBoxLabel", frame )
	radio_onlylisten_check:SetPos( 225, 92 )
	radio_onlylisten_check:SetValue( LocalPlayer():GetNVar("RadioOnlyListen") && 1 || 0 )
	radio_onlylisten_check:SetText( "Только слушать" )
	function radio_onlylisten_check:OnChange( bVal )
		LocalPlayer().RadioOnlyListen = !LocalPlayer().RadioOnlyListen
		RunConsoleCommand( "onlylisten" )
	end

	local radio_change_button = vgui.Create( "XeninUI.ButtonV2", frame )
	radio_change_button:SetPos( 10, 125 )
	radio_change_button:SetSize( 150, 30 )
	radio_change_button:SetText( "Сменить" )
	radio_change_button:SetSolidColor( Color(78,97,114) )
	function radio_change_button:DoClick()
		frame:SetVisible( false )
		LocalPlayer().RadioChannel = tonumber( radio_channel_number:GetValue() ) || 1
		RunConsoleCommand( "changeradiochannel", LocalPlayer().RadioChannel )
	end

	local radio_enable_button = vgui.Create( "XeninUI.ButtonV2", frame )
	radio_enable_button:SetPos( 185, 125 )
	radio_enable_button:SetSize( 150, 30 )
	radio_enable_button:SetText( "Вкл/Выкл" )
	radio_enable_button:SetSolidColor( Color(78,97,114) )
	function radio_enable_button:DoClick()
		if LocalPlayer().RadioChannel == 0 || LocalPlayer().RadioChannel == nil then
			LocalPlayer().RadioChannel = LocalPlayer().PreRadioChannel || 1
			LocalPlayer().PreRadioChannel = nil
			RunConsoleCommand( "onradio" )
		else
			LocalPlayer().PreRadioChannel = LocalPlayer().RadioChannel
			LocalPlayer().RadioChannel = 0
			RunConsoleCommand( "offradio")
		end
	end

end

netstream.Hook( "ChangeRadioChannel",function(channel)
	LocalPlayer().RadioChannel = channel
end )
