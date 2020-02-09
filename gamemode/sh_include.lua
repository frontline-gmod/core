flrp = flrp ||  {}
flrp.including = flrp.including || {}

flrp.including.include_sv = (SERVER) and include or function() end
flrp.including.include_cl = (SERVER) and AddCSLuaFile or include

flrp.including.include_sh = function(f)
	flrp.including.include_sv(f)
	flrp.including.include_cl(f)
end

function flrp.including.include_load (fileName, strState)

	if ((strState == "server" or string.find(fileName, "sv_")) and SERVER) then
		flrp.including.include_sv(fileName)

	elseif (strState == "shared" or string.find(fileName, "sh_")) then
		flrp.including.include_sh(fileName)

	elseif (strState == "client" or string.find(fileName, "cl_")) then
		flrp.including.include_cl(fileName)
	end
end

function flrp.including.include_dir(directory)
	local fol = GM.FolderName .. '/gamemode/' .. directory .. '/'

	for k, v in ipairs(file.Find(fol .. '*', 'LUA')) do
		local fileName = directory..'/'..v
		flrp.including.include_load(fileName)
	end

	local _, folders = file.Find(fol .. '*', 'LUA')
	for k, folder in ipairs(folders) do
		for k, v in ipairs(file.Find(fol .. folder .. '/*', 'LUA')) do
			local fileName = fol .. folder .. '/' .. v
			flrp.including.include_load(fileName)
		end
	end
end

local libs_isload

if !libs_isload then
	flrp.including.include_sh 'libs/pon.lua'
	flrp.including.include_sh 'libs/netstream.lua'
	flrp.including.include_cl 'libs/cl_fonts.lua'

	flrp.including.include_sh 'libs/sh_include_xeninui.lua'

	libs_isload = true
end

flrp.including.include_dir 'config'
flrp.including.include_dir 'core'

flrp.including.include_cl 'modules/ui/cl_hud.lua'
flrp.including.include_sh 'modules/roleplay/sh_roleplay_config.lua'

flrp.including.include_sh 'modules/admin/sh_admin_core.lua'
flrp.including.include_sv 'modules/admin/sv_admin_core.lua'
flrp.including.include_cl 'modules/admin/cl_admin_menu.lua'

flrp.including.include_sv 'modules/database/sv_module.lua'
flrp.including.include_sv 'modules/database/sv_hooks.lua'

flrp.including.include_sh 'modules/logs/sh_logs_config.lua'
flrp.including.include_sv 'modules/logs/sv_logs_functions.lua'

flrp.including.include_sh 'modules/jobs/sh_jobs.lua'
flrp.including.include_sh 'modules/jobs/sh_jobs_list.lua'

flrp.including.include_sh 'modules/player_class/sh_standart_class.lua'
flrp.including.include_sh 'modules/player_class/sh_roleplay_class.lua'
