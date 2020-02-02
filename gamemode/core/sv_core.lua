function GM:PlayerSpawn( ply )

  hook.Call( "PlayerLoadout", GAMEMODE, ply );
end

function GM:PlayerLoadout( ply )

  if !(team and team ~= 1001) then return end

  /*
  if flrp.config.enable_primary_module["Roleplay"] then
    player_manager.SetPlayerClass(ply, "roleplay_class")
  else
    player_manager.SetPlayerClass(ply, "standart_class")
  end
  */
  player_manager.SetPlayerClass(ply, "standart_class")

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

  --for k, v in pairs(team.weapons) do
	--    ply:Give(v)
  --end

  ply:SetPlayerColor( Vector( 1, 1, 1 ) )

  ply:SetCrouchedWalkSpeed(25)
  ply:SetWalkSpeed(100)
  ply:SetJumpPower(160)
  ply:SetRunSpeed(225)

  ply:SetMaxHealth(100)
  ply:SetHealth(100)
  ply:SetArmor(0)

  ply:SetModel("models/player/charple.mdl")

  ply:ChatPrint(player_manager.GetPlayerClass(ply))

  print(flrp.config.enable_primary_module)

  return true

end

hook.Add( "PreGamemodeLoaded", "frontline_widgets_disable", function()
	function widgets.PlayerTick()
		--
	end
	hook.Remove( "PlayerTick", "TickWidgets" )
end )
