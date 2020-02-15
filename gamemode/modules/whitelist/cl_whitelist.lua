function WhitelistMenu()

  local frame = vgui.Create("XeninUI.Frame")
	frame:SetSize(960, 720)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Вайтлист")
  
end
--
net.Receive( "OpenWhitelistMenu", WhitelistMenu )
