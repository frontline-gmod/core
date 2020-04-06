flrp.jobs = {}
flrp.jobs.standart_job = TEAM_DOB

local indexnumber = 1
AccessorFunc( FindMetaTable("Player"), "rank_user", "RankName", FORCE_STRING )

function flrp.jobs.add_job(name, job)
  indexnumber = indexnumber + 1

  team.SetUp( indexnumber, name, job.Color )
	job["index"] = indexnumber
	job.Name = name or ""

	if SERVER then
		util.PrecacheModel(job.WorldModel)
	else
    job.Color = nil
    job.WorldModel = nil
    job.Weapons = nil
		job.PlayerSpawn = nil
	end

	table.insert( flrp.jobs, indexnumber,  job )
	return indexnumber
end
