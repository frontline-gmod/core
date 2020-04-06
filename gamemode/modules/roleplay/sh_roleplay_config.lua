if flrp.config.enable_primary_module ~= "Roleplay" then return end

flrp.config.roleplay = flrp.config.roleplay || {}
flrp.radiochannels = flrp.radiochannels || {}

flrp.config.roleplay.chat_distance = 500
flrp.config.roleplay.max_voice_distance = 202500

flrp.config.roleplay.first_name = {
  "Сергей",
  "Роман",
  "Данил",
  "Иван",
  "Алексей",
  "Александр",
}

flrp.config.roleplay.secondary_name = {
  "Кислов",
  "Семенов",
  "Петров",
  "Белов",
}

flrp.including.include_cl 'cl_radio_menu.lua'
flrp.including.include_sv 'sv_roleplay_chat.lua'
flrp.including.include_sh 'sh_roleplay_commands.lua'
flrp.including.include_sh 'sh_roleplay_meta.lua'
