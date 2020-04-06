netstream.Hook( "LogsMenu", function(ply, tableLogs)
  table.SortByMember(tableLogs, "date")

  local frame = vgui.Create("XeninUI.Frame")
	frame:SetSize(XeninUI.Frame.Width, XeninUI.Frame.Height)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Логи")
  function frame:Paint()
    draw.RoundedBox(6, 0, 0, XeninUI.Frame.Width, XeninUI.Frame.Height, XeninUI.Theme.Background)
  end

  local dlistplayers = vgui.Create( "DListView", frame )
  dlistplayers:SetPos( 20, 55 )
  dlistplayers:SetSize( XeninUI.Frame.Width-40, XeninUI.Frame.Height-125 )
  dlistplayers:SetMultiSelect( false )
  dlistplayers:SetSortable( true )
  dlistplayers:AddColumn( "Время" ):SetWidth(85)
  dlistplayers:AddColumn( "Категория" ):SetWidth(25)
  dlistplayers:AddColumn( "Лог" ):SetWidth(650)
  dlistplayers:SetSortable( true )
  dlistplayers:SortByColumn( 1, function(a, b) return a[1] < a[2] end )

  for k,v in pairs(tableLogs) do
    dlistplayers:AddLine( os.date("%H:%M:%S - %d/%m/%Y", tableLogs[k].date), tableLogs[k].category, tableLogs[k].logstring )
  end

  local searchplayer = vgui.Create( "DTextEntry", frame)
  searchplayer:SetPos( 20, 667 )
  searchplayer:SetSize( XeninUI.Frame.Width-40, XeninUI.Frame.Height/19 )
  searchplayer:SetText("Поиск лога...")
  searchplayer.OnChange = function( self )
    dlistplayers:Clear()
    for k,v in pairs(tableLogs) do
      local searchnameplayer = string.find( string.lower(tableLogs[k].logstring), string.lower(self:GetValue()))
      if searchnameplayer then
        dlistplayers:AddLine( os.date("%H:%M:%S - %d/%m/%Y", tableLogs[k].date), tableLogs[k].category, tableLogs[k].logstring )
      end
    end
  end

end)
