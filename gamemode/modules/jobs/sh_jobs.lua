flrp.jobs = {}

local indexnumber = 1

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
    job.weapons = nil
    job.group_id = nil
		job.PlayerSpawn = nil
	end

	table.insert( flrp.jobs, indexnumber,  job )

	return indexnumber
end

function flrp.FindJob(index)
	return flrp.jobs[index] or false
end

function flrp.FindJobByID(strID)
	for _, job in pairs(flrp.jobs) do
		if job.jobID == strID then
			return job
		end
	end
end
