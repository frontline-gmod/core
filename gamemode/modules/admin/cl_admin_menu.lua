function FLRPAdminMenu( ply, cmd, args )

  local frame = vgui.Create("XeninUI.Frame")
  frame:SetSize(960, 720)
  frame:Center()
  frame:MakePopup()
  frame:SetTitle("Админ меню")

end

concommand.Add( "fl_adminmenu", FLRPAdminMenu )
