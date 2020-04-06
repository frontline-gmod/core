netstream.Hook( "WhiteList", function( ply, plyinfoTable )

  local frame = vgui.Create("XeninUI.Frame")
	frame:SetSize(XeninUI.Frame.Width, XeninUI.Frame.Height)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Вайтлист")
  function frame:Paint()
    draw.RoundedBox(6, 0, 0, XeninUI.Frame.Width, XeninUI.Frame.Height, XeninUI.Theme.Background)
  end

  local dlistplayers = vgui.Create( "DListView", frame )
  dlistplayers:SetPos( 20, 55 )
  dlistplayers:SetSize( XeninUI.Frame.Width-40, XeninUI.Frame.Height-125 )
  dlistplayers:SetMultiSelect( false )
  dlistplayers:AddColumn( "Ник", 1 )
  dlistplayers:AddColumn( "СтимИД64", 2)
  dlistplayers:AddColumn( "Специализация", 3 )
  dlistplayers:AddColumn( "Звание", 4 )

  for k,v in pairs( player.GetAll() ) do
    local plyinfoTableRank
    if v:SteamID64() == plyinfoTable[k].steamid64 then plyinfoTableRank = plyinfoTable[k].rank end
    dlistplayers:AddLine( v:Nick(), v:SteamID64(), team.GetName( v:Team() ), plyinfoTableRank )
  end

  function dlistplayers:OnRowSelected( index, panel )

    for k,v in pairs( player.GetAll() ) do
      local plyinfoTableRank
      local plyinfoLocalTableRank

      local ranktag
      local oldteam_index = panel:GetColumnText( 3 )
      local oldranktag = panel:GetColumnText( 4 )

      if v:SteamID64() == panel:GetColumnText( 2 ) then
        if v:SteamID64() == plyinfoTable[k].steamid64 then plyinfoTableRank = plyinfoTable[k].rank end
        if v:SteamID64() == LocalPlayer():SteamID64() then plyinfoLocalTableRank = plyinfoTable[k].rank end

        local joblist = {}

        for k,v in pairs (flrp.jobs) do
          if isnumber(k) then
            table.insert( joblist, flrp.jobs[k].Name )
          end
        end

        local player_frame = vgui.Create("XeninUI.Frame")
      	player_frame:SetSize(XeninUI.Frame.Width/2, XeninUI.Frame.Height/4-10)
      	player_frame:SetPos(ScrW()-XeninUI.Frame.Width/2-50, ScrH()/4)
      	player_frame:MakePopup()
      	player_frame:SetTitle("Панель игрока: " .. panel:GetColumnText( 1 ))
        function player_frame:Paint()
          draw.RoundedBox(6, 0, 0, XeninUI.Frame.Width, XeninUI.Frame.Height, XeninUI.Theme.Background)
          --draw.SimpleText( "Специализация:", "XeninUI.Frame.Title", 20, 50, Color(245,245,245))
        end

        local searchjob_profile = vgui.Create( "DTextEntry", player_frame)
        searchjob_profile:SetPos(125, 50)
        searchjob_profile:SetSize(340, 35)
        searchjob_profile:SetText("Поиск специализации...")
        searchjob_profile.OnChange = function( self )
          joblist_profile:Clear()
          for k,v in pairs( joblist ) do
            local searchnameplayer = string.find( string.lower(joblist[k]), string.lower(self:GetValue()))
            if searchnameplayer then
              joblist_profile:SetValue( v )
              joblist_profile:AddChoice( v )
            end
          end
        end

        local joblist_profile = vgui.Create( "DComboBox", player_frame )
        joblist_profile:SetPos(125, 86)
        joblist_profile:SetSize(340, 35)
        joblist_profile:SetValue(team.GetName( v:Team() ))
        for k,v in pairs(joblist) do
          joblist_profile:AddChoice( v )
        end

        local rank_profile = vgui.Create( "DComboBox", player_frame )
        rank_profile:SetPos(125, 122)
        rank_profile:SetSize(340, 35)
        rank_profile:SetValue(plyinfoTableRank)
        rank_profile:SetSortItems(false)
        for k,v in pairs(flrp.whitelist.ranks) do
          if flrp.whitelist.ranks[k] != plyinfoLocalTableRank then rank_profile:AddChoice( v ) else rank_profile:AddChoice( flrp.whitelist.ranks[k] ) break end
        end
        function rank_profile:OnSelect(index, value, data)
          ranktag = value
        end

        local givestat_profile = vgui.Create( "XeninUI.ButtonV2", player_frame )
        givestat_profile:SetPos(10, 50)
        givestat_profile:SetSize(105, 110)
        givestat_profile:SetText("Выдать")
        givestat_profile:SetSolidColor( Color(78,97,114) )
        function givestat_profile:DoClick()
          local target = v
          frame:SetVisible(false)
          player_frame:SetVisible(false)
          for k,v in pairs(flrp.jobs) do
            if isnumber(k) then
              if flrp.jobs[k].Name == joblist_profile:GetValue() then
                local team_index = flrp.jobs[k].index
                local jobtag = flrp.jobs[k].TeamID
                if GetAdminPermission( ply, "whitelist" ) then
                  local tableInfoTargetWhitelist = {
                    target = target,
                    oldteam_index = oldteam_index,
                    team_index = team_index,
                    jobtag = jobtag,
                    oldranktag = oldranktag,
                    ranktag = ranktag,
                  }
                  netstream.Start( "ReturnWhiteList", tableInfoTargetWhitelist )
                end
              end
            end
          end
        end
      end
    end
  end

  local searchplayer = vgui.Create( "DTextEntry", frame)
  searchplayer:SetPos( 20, 667 )
  searchplayer:SetSize( XeninUI.Frame.Width-40, XeninUI.Frame.Height/19 )
  searchplayer:SetText("Поиск игрока...")
  searchplayer.OnChange = function( self )
    dlistplayers:Clear()
    for k,v in pairs( player.GetAll() ) do
      local plyinfoTableRank
      if v:SteamID64() == plyinfoTable[k].steamid64 then plyinfoTableRank = plyinfoTable[k].rank end
      local searchnameplayer = string.find( string.lower(v:Nick()), string.lower(self:GetValue()))
      if searchnameplayer then
        dlistplayers:AddLine( v:Nick(), v:SteamID64(), team.GetName( v:Team() ), plyinfoTableRank )
      end
    end
  end

end )
