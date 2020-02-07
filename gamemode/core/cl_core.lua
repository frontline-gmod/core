if flrp.config.enable_secondary_modules["QMenuAdmin"] == true then
  hook.Add( "OnSpawnMenuOpen", "CheckPermissionForSpawnMenu", function()
    if flrp.config.usergroup["" .. LocalPlayer():GetUserGroup() .. ""] then return true else return false end
  end )
end

if flrp.config.enable_secondary_modules["ContextAdmin"] == true then
  hook.Add( "OnContextMenuOpen", "CheckPermissionForContextMenu", function()
    if flrp.config.usergroup["" .. LocalPlayer():GetUserGroup() .. ""] then return true else return false end
  end )
end
