if flrp.config.enable_secondary_modules["QMenuAdmin"] == true then
  hook.Add( "OnSpawnMenuOpen", "CheckPermissionForSpawnMenu", function()
    if !GetAdminUsergroup( LocalPlayer():GetUserGroup() ) then
        return false
    end
  end )
end

if flrp.config.enable_secondary_modules["ContextAdmin"] == true then
  hook.Add( "OnContextMenuOpen", "CheckPermissionForContextMenu", function()
    if !GetAdminUsergroup( LocalPlayer():GetUserGroup() ) then
        return false
    end
  end )
end
