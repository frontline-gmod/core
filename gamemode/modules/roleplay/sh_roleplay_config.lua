if flrp.config.enable_primary_module ~= "Roleplay" then return end

flrp.config.roleplay = flrp.config.roleplay or {}

flrp.config.roleplay.chat_distance = 500
flrp.config.roleplay.voice_distance = 300
flrp.including.include_sv 'sv_roleplay_chat.lua'
