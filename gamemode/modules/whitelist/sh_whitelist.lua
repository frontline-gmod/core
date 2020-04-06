if flrp.config.enable_secondary_modules["Whitelist"] == true then
  flrp.including.include_cl 'cl_whitelist.lua'
  flrp.including.include_sv 'sv_whitelist.lua'
  flrp.including.include_sh 'sh_whitelist_meta.lua'
  flrp.including.include_sh 'sh_whitelist_config.lua'
end
