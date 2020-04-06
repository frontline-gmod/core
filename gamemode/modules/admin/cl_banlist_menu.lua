netstream.Hook("BanListMenu", function( banlist )

  PrintTable(banlist)

  local frame = vgui.Create( "XeninUI.Frame" )
	frame:SetSize(XeninUI.Frame.Width, XeninUI.Frame.Height)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Лист Блокировок")
  function frame:Paint()
    draw.RoundedBox(6, 0, 0, XeninUI.Frame.Width, XeninUI.Frame.Height, XeninUI.Theme.Background)
  end

  local dlistplayers = vgui.Create( "DListView", frame )
  dlistplayers:SetPos(20, 55)
  dlistplayers:SetSize(XeninUI.Frame.Width-40, XeninUI.Frame.Height-125)
  dlistplayers:SetMultiSelect(false)
  dlistplayers:AddColumn("Ник", 1)
  dlistplayers:AddColumn("СтимИД64", 2)
  dlistplayers:AddColumn("Причина", 3)
  dlistplayers:AddColumn("Конец Блокировки", 4)

  for k,v in pairs( banlist ) do
    if tonumber(banlist[k].date) > os.time() || tonumber(banlist[k].date) == 0 then
      if tonumber(banlist[k].date) == 0 then
        dlistplayers:AddLine( banlist[k].nick, banlist[k].steamid64, banlist[k].reason, "Перманент" )
      else
        dlistplayers:AddLine( banlist[k].nick, banlist[k].steamid64, banlist[k].reason, os.date( "%H:%M:%S - %d/%m/%Y" , banlist[k].date ) )
      end
    end
  end

  function dlistplayers:OnRowSelected( index, panel )
    for k,v in pairs(banlist) do
      if panel:GetColumnText(2) == banlist[k].steamid64 then
        local steamid64_banned_player = panel:GetColumnText(2)
        local reason_banned_player = panel:GetColumnText(3)

        local player_frame = vgui.Create("XeninUI.Frame")
      	player_frame:SetSize(XeninUI.Frame.Width/2, XeninUI.Frame.Height/2)
      	player_frame:SetPos(ScrW()-XeninUI.Frame.Width/2-50, ScrH()/3)
      	player_frame:MakePopup()
      	player_frame:SetTitle("Разблокировка")
        function player_frame:Paint()
          draw.RoundedBox(6, 0, 0, XeninUI.Frame.Width, XeninUI.Frame.Height, XeninUI.Theme.Background)
          draw.SimpleText( "Разблокировать пользователя ?", "XeninUI.Frame.Title", 53, 75, Color(245,245,245))
        end

        local yes_button = vgui.Create( "XeninUI.ButtonV2", player_frame )
        yes_button:SetPos(10, XeninUI.Frame.Height/2-85)
        yes_button:SetSize(200, 75)
        yes_button:SetText("Да, конечно")
        yes_button:SetSolidColor( Color(0, 175, 0) )
        function yes_button:DoClick()
          local tableUnbanInfo = {
            ply = LocalPlayer(),
            nick = panel:GetColumnText(1),
            steamid64_target = panel:GetColumnText(2),
          }
          frame:SetVisible(false)
          player_frame:SetVisible(false)
          netstream.Start("AcceptedUnban", tableUnbanInfo)
        end

        local no_button = vgui.Create( "XeninUI.ButtonV2", player_frame )
        no_button:SetPos(XeninUI.Frame.Width/2-110, XeninUI.Frame.Height/2-85)
        no_button:SetSize(100, 75)
        no_button:SetText("Отмена")
        no_button:SetSolidColor( Color(175, 0, 0) )
        function no_button:DoClick()
          player_frame:SetVisible(false)
        end
      end
    end

  end

  local searchplayer = vgui.Create( "DTextEntry", frame)
  searchplayer:SetPos( 20, 667 )
  searchplayer:SetSize( XeninUI.Frame.Width-40, XeninUI.Frame.Height/19 )
  searchplayer:SetText("Поиск...")
  searchplayer.OnChange = function( self )
    dlistplayers:Clear()
    for k,v in pairs( banlist ) do
      local searchnameplayer = string.find( string.lower(banlist[k].nick), string.lower(self:GetValue()) )
      if searchnameplayer then
        dlistplayers:AddLine( banlist[k].nick, banlist[k].steamid64, banlist[k].reason, os.date( "%H:%M:%S - %m/%d/%Y" , banlist[k].date ) )
      end
    end
  end

end)
