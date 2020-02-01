function GM:PlayerSpawn( ply )

  hook.Call( "PlayerLoadout", GAMEMODE, ply );

end

function GM:PlayerLoadout( ply )

  if !(team and team ~= 1001) then return end

  if flrp.config.enable_module == "Roleplay" then
    player_manager.SetPlayerClass(ply, "roleplay_class")
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

  --for k, v in pairs(team.weapons) do
	--    ply:Give(v)
  --end

  pPlayer:SetPlayerColor( Vector( 1, 1, 1 ) )

   pPlayer:SetCrouchedWalkSpeed(25)
   pPlayer:SetWalkSpeed(100)
   pPlayer:SetJumpPower(160)
   pPlayer:SetRunSpeed(225)

	 pPlayer:SetMaxHealth(100)
   pPlayer:SetHealth(100)
   pPlayer:SetArmor(0)

   pPlayer:SetModel("models/player/charple.mdl")

   return true

end

hook.Add( "PreGamemodeLoaded", "frontline_widgets_disable", function()
	function widgets.PlayerTick()
		--
	end
	hook.Remove( "PlayerTick", "TickWidgets" )
end )
