if flrp.config.enable_secondary_modules["WhiteList"] == true then
  flrp.including.include_cl 'cl_whitelist.lua'
  flrp.including.include_sv 'sv_whitelist.lua'
end
