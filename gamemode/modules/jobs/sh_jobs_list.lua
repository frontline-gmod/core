TEAM_DOB = flrp.jobs.add_job("Новобранец", {
	Color = Color(155, 45, 48),
	WorldModel = "models/player/Group01/male_03.mdl",
  TeamID = "dob",
	Weapons = {"weapon_crowbar"},
	PlayerSpawn = function(ply)
		ply:SetArmor(100)
	end
})

flrp.jobs.standart_job = TEAM_DOB
