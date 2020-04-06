resource.AddWorkshop( "1900562881" )

function GM:PlayerSpawn( ply )
  if ply:Team() == 1001 then ply:SetPos(Vector(-905.630432, 4.803902, -12703.968750)) end

  hook.Call( "PlayerLoadout", GAMEMODE, ply )
end

function GM:PlayerLoadout( ply )

  local team = flrp.jobs[ply:Team()]
  if !(team and team != 1001) then return end

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

  ply:SetPlayerColor( Vector( 1, 1, 1 ) )

  ply:SetCrouchedWalkSpeed(25)
  ply:SetWalkSpeed(100)
  ply:SetJumpPower(160)
  ply:SetRunSpeed(225)

  ply:SetModel(team.WorldModel)

  for k, v in pairs(flrp.config.default_weapons) do
     ply:Give(v)
  end

  ply:SelectWeapon(flrp.config.default_weapons[1])

  for k, v in pairs(team.Weapons) do
     ply:Give(v)
  end

  if GetAdminUsergroup( ply:GetUserGroup() ) then
    for k, v in pairs(flrp.config.default_admin_weapons) do
       ply:Give(v)
    end
  end

  ply:SetMaxHealth(team.maxHealth or 100);
  ply:SetHealth(team.maxHealth or 100);
  ply:SetArmor(team.maxArmor or 0);

  ply:SetModel(team.WorldModel)

  if ply then
    team.PlayerSpawn(ply)
  end

  return true

end

if flrp.config.enable_secondary_modules["CanPropertyAdmin"] == true then
  hook.Add("CanProperty", "FLRPBlockProperty", function( ply ) if ( !GetAdminPermission( ply, "property" ) ) then return false end end)
end

if flrp.config.enable_secondary_modules["RealisticFallDamage"] == true then
  hook.Add("GetFallDamage", "FLRPFallDamage", function( ply, fallspeed ) return fallspeed / 10 end)
end

if flrp.config.enable_secondary_modules["NoFriendlyFire"] == true then
  hook.Add("PlayerShouldTakeDamage", "FLRPNoFriendlyFire", function(target, attacker) if !attacker:IsPlayer() then return else if flrp.config.nofriendlyfirelist[attacker:Team()] && !flrp.config.friendlyfireallowlist[target:Team()] then return false else return true end end end)
end

if flrp.config.enable_secondary_modules["CanSuicide"] == false then
  hook.Add("CanSuicide", "FLRPCanSuicide", function() return false end)
end

hook.Add( "PreGamemodeLoaded", "FLRPWidgetsRemove", function()
	function widgets.PlayerTick() end
	hook.Remove( "PlayerTick", "TickWidgets" )
end )

if flrp.config.advert_message && istable(flrp.config.advert_message) then
  timer.Create( "FLRPAdverts", flrp.config.advert_delay, 0, function()
    for k,v in pairs(player.GetAll()) do
      local ply_value = {}
      table.insert(ply_value, v)
      for k,v in pairs(flrp.config.advert_message) do
        local advert_color = flrp.config.advert_message[k][1]:ToTable()
        ply_value[1]:SendLua( string.format("chat.AddText( Color(%s, %s, %s), '%s' )", advert_color[1], advert_color[2], advert_color[3], flrp.config.advert_message[k][2] ) )
      end
    end
  end)
end

function GM:PlayerSpawnProp(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end

function GM:PlayerSpawnVehicle(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end

function GM:PlayerGiveSWEP(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end

function GM:PlayerSpawnNPC(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end

function GM:PlayerSpawnEffect(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end

function GM:PlayerSpawnSENT(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end

function GM:PlayerSpawnRagdoll(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end

function GM:PlayerSpawnObject(ply)
	return GetAdminPermission( ply, "spawnmenu" )
end
