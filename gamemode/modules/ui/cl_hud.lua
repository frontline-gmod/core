print("[FL]Hud Loading!")

function HUDHide_FLRP ( flrphud )
	for _, v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudDeathNotice", "CHudHintDisplay" } do
		if flrphud == v then return false end
	end
end

function draw.ShadowSimpleText( text, font, x, y, color, xalign, yalign, sh, color_shadow )
	local sh = sh or 1
	draw.SimpleText(text, font, x+sh, y+sh, color_shadow or Color(0,0,0,190), xalign, yalign)
	draw.SimpleText(text, font, x, y, color, xalign, yalign)
end

hook.Add("HUDShouldDraw","HUDHide_FLRP",HUDHide_FLRP)

local x = 15
local y = ScrH() - 150
local scrdw = ScrW()

local function FLRP_hud()

	local ply = LocalPlayer()
	local hp = ply:Health() or 0
	local maxhp = ply:GetMaxHealth() or 0
	local arm = ply:Armor() or 0

	if ( !ply:Alive() ) then return end

	local heart = Material("materials/like.png")
	local armor = Material("materials/vest.png")
	local compass = Material("materials/compass.png")
	local timer = Material("materials/clock.png")
	local radio = Material("materials/radio.png")

	--Health
	surface.SetMaterial(heart)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(10, (ScrH() - 150) + 108 , 30, 30)
	draw.RoundedBox(2,50,(ScrH() - 150) + 114,125,16,Color(30,30,40,150))

	if hp <= 100 then
		draw.RoundedBox(1, 50 , (ScrH() - 150) + 114, math.Clamp(hp, 0, 100)*1.25, 16, Color(10, 120, 10, 255) )
	 elseif hp > 100 then
		draw.RoundedBox(1, 50 , (ScrH() - 150) + 114, 125, 16, Color(10, 120, 10, 255) )
	 end
	surface.SetDrawColor( Color( 10, 10, 10, 200 ) )
	surface.DrawOutlinedRect( 50 , (ScrH() - 150) + 114, 125, 17 )
	draw.ShadowSimpleText( hp, "TargetID",140, (ScrH() - 150) + 114, Color(255,255,255,255) )

	--Armor
	if arm ~= 0 then
		surface.SetMaterial(armor)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(207, (ScrH() - 150) + 105, 30, 30)
		draw.RoundedBox(2,250,(ScrH() - 150) + 114,125,16,Color(30,30,40,150))
		if arm <= 100 then
		  draw.RoundedBox(1, 250 , (ScrH() - 150) + 114, math.Clamp(arm, 0, 255)*1.25, 16, Color(10, 10, 200, 255) )
		elseif arm > 100 then
		  draw.RoundedBox(1, 250 , (ScrH() - 150) + 114, 125, 16, Color(20, 20, 200, 255) )
		end
		surface.SetDrawColor( Color( 10, 10, 10, 200 ) )
		surface.DrawOutlinedRect( 250 , (ScrH() - 150) + 114, 125, 17 )
		draw.ShadowSimpleText( arm, "TargetID",340, (ScrH() - 150) + 114, Color(255,255,255,255) )
	end

 end

local function FLRPHudPlayers( ply )

 	if ( !IsValid( ply ) ) then return end
 	if ( ply == LocalPlayer() ) then return end
 	if ( !ply:Alive() ) then return end

 	local Distance = LocalPlayer():GetPos():Distance( ply:GetPos() )

 	if ( Distance < 500 ) then

 		local offset = Vector( -3, 0, 85 )
 		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()
   	local team_color = team.GetColor()

 		ang:RotateAroundAxis( ang:Forward(), 90 )
 		ang:RotateAroundAxis( ang:Right(), 90 )

 		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.02 )

 		draw.DrawText( ply:GetName(), "font_base_3d2d", -4 , 650/2, team.GetColor(ply:Team()), TEXT_ALIGN_CENTER )
    if flrp.config.enable_primary_module == "Roleplay" then
      draw.DrawText( team.GetName(ply:Team()), "font_base_3d2d", -4 , 900/2, Color(255,255,255), TEXT_ALIGN_CENTER )
    end

 		cam.End3D2D()

 	end

end

hook.Add("HUDPaint", "FLRP_HUD", FLRP_hud)
hook.Add("PostPlayerDraw", "FLRPHudPlayers", FLRPHudPlayers)

if flrp.config.enable_primary_module == "Roleplay" then
  hook.Add("HUDDrawTargetID", "FLRPTargetName", function() return false end)
  hook.Add("DrawDeathNotice", "FLRPDeathNoticee", function() return 0,0 end)
  hook.Add("Initialize", "FLRPDeathNotice", function() hook.Add("AddDeathNotice", "FLRPDeathNotice2", function() return end) end)
end
