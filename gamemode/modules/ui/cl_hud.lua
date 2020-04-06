hook.Add("HUDPaint", "FLRPHud", function()
  local ply = LocalPlayer()
  local max_health = ply:GetMaxHealth()
  local health = ply:Health() || 0
  local armor = ply:Armor() || 0

  if !ply:Alive() then return false end
  if health > 100 then health = 100 end
  if armor > 100 then armor = 100 end

  draw.RoundedBox(1, 27, ScrH()-48, math.Clamp(health, 0, 100)*4, 30, Color(205, 38, 38, 255))
  surface.SetDrawColor( Color( 235, 235, 235, 200 ) )
	surface.DrawOutlinedRect( 27, ScrH()-48, math.Clamp(health, 0, 100)*4, 30 )

  if armor > 0 then
    draw.RoundedBox(1, 27, ScrH()-28, math.Clamp(armor, 0, 100)*4, 10, Color(16, 78, 139, 255))
    surface.SetDrawColor( Color( 235, 235, 235, 200 ) )
  	surface.DrawOutlinedRect( 27, ScrH()-28, math.Clamp(armor, 0, 100)*4, 10 )
  end

  if IsValid(ply:GetActiveWeapon()) then
    local weapon_clip = ply:GetActiveWeapon():Clip1() or 0
    local weapon_max_clip = ply:GetActiveWeapon():GetMaxClip1() or 0

    if weapon_clip > 999 then weapon_clip = 999 end

    if (weapon_clip > 0 && weapon_max_clip > 0) then
      draw.SimpleText(ply:GetActiveWeapon():Clip1(), "font_base_big", ScrW()-210, ScrH()-88, Color(255,255,255), TEXT_ALIGN_RIGHT)
      draw.SimpleText("\\", "font_base_big", ScrW()-210, ScrH()-100, Color(255,255,255))
      draw.SimpleText(ply:GetActiveWeapon():GetMaxClip1(), "font_base_big", ScrW()-199, ScrH()-112, Color(255,255,255), TEXT_ALIGN_LEFT)
    end
  end
end)

hook.Add("HUDDrawTargetID", "FLRPHudDrawTargetID", function() return false end)

hook.Add("PostPlayerDraw", "FLRP3D2DHUDPlayer", function( ply )
 	if !IsValid( ply ) then return end
 	if ply == LocalPlayer() then return end
 	if !ply:Alive() then return end

 	local distance = LocalPlayer():GetPos():Distance( ply:GetPos() )

 	if ( distance < 500 ) then
 		local offset = Vector( -3, 0, 85 )
 		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()

   	local team_color = team.GetColor()

 		ang:RotateAroundAxis( ang:Forward(), 90 )
 		ang:RotateAroundAxis( ang:Right(), 90 )

 		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.02 )

   		draw.DrawText( ply:GetName(), "font_base_3d2d", -75 , 650/2, team.GetColor(ply:Team()), TEXT_ALIGN_CENTER )
    	draw.DrawText( team.GetName(ply:Team()), "font_base_3d2d", -75 , 900/2, Color(255,255,255), TEXT_ALIGN_CENTER )

 		cam.End3D2D()
 	end
end)

hook.Add("HUDShouldDraw", "FLRPHideHUD", function( element )
  local hide_elements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudDeathNotice"] = true,
    ["CHudZoom"] = true,
    ["CHudHintDisplay"] = true,
  }

  if hide_elements[element] then return false end
end)

hook.Add("DrawDeathNotice", "FLRPHideDrawDeathNotice", function()
	return 0, 0
end)
