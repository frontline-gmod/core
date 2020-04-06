TEAM_DOB = flrp.jobs.add_job("Новобранец", {
	Color = Color(155, 45, 48),
	WorldModel = "models/player/Group01/male_03.mdl",
  TeamID = "dob",
	Weapons = {"weapon_crowbar"},
	PlayerSpawn = function(ply)
		ply:SetArmor(100)
		ply:SetPos(Vector(172.982941, 272.901672, -12223.968750))
	end
})

TEAM_CAV1 = flrp.jobs.add_job("Стрелок", {
	Color = Color(253, 124, 48),
	WorldModel = "models/player/Group01/male_03.mdl",
  TeamID = "cav1",
	Weapons = {"weapon_crowbar"},
	PlayerSpawn = function(ply)
		ply:SetArmor(100)
		ply:SetPos(Vector(172.982941, 272.901672, -12223.968750))
	end
})

TEAM_CAV2 = flrp.jobs.add_job("Радист", {
	Color = Color(253, 124, 48),
	WorldModel = "models/player/Group01/male_03.mdl",
  TeamID = "cav2",
	Weapons = {"weapon_crowbar"},
	PlayerSpawn = function(ply)
		ply:SetArmor(100)
		ply:SetPos(Vector(172.982941, 272.901672, -12223.968750))
	end
})

TEAM_CAV3 = flrp.jobs.add_job("Снайпер", {
	Color = Color(253, 124, 48),
	WorldModel = "models/player/Group01/male_03.mdl",
  TeamID = "cav3",
	Weapons = {"weapon_crowbar"},
	PlayerSpawn = function(ply)
		ply:SetArmor(100)
		ply:SetPos(Vector(172.982941, 272.901672, -12223.968750))
	end
})

TEAM_CAV4 = flrp.jobs.add_job("Командир", {
	Color = Color(253, 124, 48),
	WorldModel = "models/player/Group01/male_03.mdl",
  TeamID = "cav4",
	Weapons = {"weapon_crowbar"},
	PlayerSpawn = function(ply)
		ply:SetArmor(100)
		ply:SetPos(Vector(172.982941, 272.901672, -12223.968750))
	end
})

TEAM_GOOK = flrp.jobs.add_job("Вьетконговец", {
	Color = Color(65, 251, 94),
	WorldModel = "models/player/Group01/male_03.mdl",
  TeamID = "gook",
	Weapons = {"weapon_crowbar"},
	PlayerSpawn = function(ply)
		ply:SetArmor(100)
		ply:SetPos(Vector(172.982941, 272.901672, -12223.968750))
	end
})
