if flrp.config.enable_secondary_modules["QMenuAdmin"] == true then
  hook.Add( "OnSpawnMenuOpen", "CheckPermissionForSpawnMenu", function()
    if table.HasValue(flrp.config.usergroup["" .. LocalPlayer():GetUserGroup() .. ""], "spawnmenu") then return true end
  end )
end

if flrp.config.enable_secondary_modules["ContextAdmin"] == true then
  hook.Add( "OnContextMenuOpen", "CheckPermissionForContextMenu", function()
    if table.HasValue(flrp.config.usergroup["" .. LocalPlayer():GetUserGroup() .. ""], "spawnmenu") then return true end
  end )
end
