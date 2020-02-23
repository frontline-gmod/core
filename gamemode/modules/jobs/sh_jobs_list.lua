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

flrp.jobs.standart_job = TEAM_DOB
