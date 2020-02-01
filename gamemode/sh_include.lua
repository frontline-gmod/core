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

	libs_isload = true
end

flrp.including.include_dir 'core'
flrp.including.include_dir 'config'
flrp.including.include_dir 'modules'

flrp.including.include_cl 'core/cl_fonts.lua'
flrp.including.include_cl 'core/cl_fps.lua'
flrp.including.include_sv 'core/sv_core.lua'

flrp.including.include_sh 'config/sh_config.lua'

flrp.including.include_sh 'modules/player_class/sh_standart_class.lua'
flrp.including.include_sh 'modules/player_class/sh_roleplay_class.lua'
