function GM:PlayerSpawn( ply )
  ply:SetTeam(flrp.jobs.standart_job)

  hook.Call( "PlayerLoadout", GAMEMODE, ply );
end

function GM:PlayerLoadout( ply )

  local team = flrp.jobs[ply:Team()]
  if !(team and team ~= 1001) then return end

  if flrp.config.enable_primary_module == "Roleplay" then
    player_manager.SetPlayerClass(ply, "roleplay_class")
  else
    player_manager.SetPlayerClass(ply, "standart_class")
  end

	ply:ShouldDropWeapon(false)

	if ply:FlashlightIsOn() then
		ply:Flashlight(false)
	end

  ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
  ply:SetMaterial("")
  ply:SetMoveType(MOVETYPE_WALK)
  ply:Extinguish()
  ply:UnSpectate()
  ply:GodDisable()
  ply:SetCanZoom(false)
  ply:ConCommand("-duck")
  ply:SetColor(Color(255, 255, 255, 255))
  ply:SetupHands()

  ply:SetModelScale(1)

  ply:SetModel(team.WorldModel)

  for k, v in pairs(team.weapons) do
	   ply:Give(v)
  end

  ply:SetPlayerColor( Vector( 1, 1, 1 ) )

  ply:SetCrouchedWalkSpeed(25)
  ply:SetWalkSpeed(100)
  ply:SetJumpPower(160)
  ply:SetRunSpeed(225)

  ply:SetMaxHealth(100)
  ply:SetHealth(100)
  ply:SetArmor(0)

  ply:SetMaxHealth(team.maxHealth or 100);
	ply:SetHealth(team.maxHealth or 100);
	ply:SetArmor(team.maxArmor or 0);

	ply:SetModel(team.WorldModel)

  if ply then
		team.PlayerSpawn(ply)
	end

  return true

end

hook.Add( "PreGamemodeLoaded", "frontline_widgets_disable", function()
	function widgets.PlayerTick()
		--
	end
	hook.Remove( "PlayerTick", "TickWidgets" )
end )

if flrp.config.enable_secondary_modules["CanPropertyAdmin"] == true then
  hook.Add("CanProperty", "block_remover_property", function( ply ) if ( !ply:IsAdmin() ) then return false end end)
end

if flrp.config.enable_secondary_modules["RealisticFallDamage"] == true then
  hook.Add("GetFallDamage", "FLRPFallDamage", function( ply, fallspeed ) return fallspeed / 10 end)
end

concommand.Add( "cls", function()
	for i = 0, 750, 1 do
		print(" ")
	end
end)

concommand.Add( "setteam", function()
	for k,v in pairs(player.GetAll()) do
    v:SetTeam(TEAM_DOB)
  end
end)
