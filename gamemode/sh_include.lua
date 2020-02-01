flrp.include_sv = (SERVER) and include or function() end
flrp.include_cl = (SERVER) and AddCSLuaFile or include

flrp.include_sh = function(f)
	flrp.include_sv(f)
	flrp.include_cl(f)
end

function flrp. (fileName, strState)

	if ((strState == "server" or string.find(fileName, "sv_")) and SERVER) then
		flrp.include_sv(fileName)

	elseif (strState == "shared" or string.find(fileName, "sh_")) then
		flrp.include_sh(fileName)

	elseif (strState == "client" or string.find(fileName, "cl_")) then
		flrp.include_cl(fileName)
	end
end

function flrp.include_dir(directory)
	local fol = GM.FolderName .. '/gamemode/' .. directory .. '/'

	for k, v in ipairs(file.Find(fol .. '*', 'LUA')) do
		local fileName = directory..'/'..v
		flrp.include_load(fileName)
	end

	local _, folders = file.Find(fol .. '*', 'LUA')
	for k, folder in ipairs(folders) do
		for k, v in ipairs(file.Find(fol .. folder .. '/*', 'LUA')) do
			local fileName = fol .. folder .. '/' .. v
			flrp.include_load(fileName)
		end
	end
end

local libs_isload

if !libs_isload then
	flrp.include_sh 'libs/pon.lua'
	flrp.include_sh 'libs/netstream.lua'

	libs_isload = true
end

flrp.include_dir 'core'
flrp.include_dir 'config'
flrp.include_dir 'modules'

flrp.include_cl 'core/cl_fonts.lua'
flrp.include_cl 'core/cl_fps.lua'
flrp.include_sv 'core/sv_core.lua'

flrp.include_sh 'config/sh_config.lua'

flrp.include_sh 'modules/player_class/sh_standart_class.lua'
flrp.include_sh 'modules/player_class/sh_roleplay_class.lua'
