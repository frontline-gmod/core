if flrp.config.enable_secondary_modules["QMenuAdmin"] == true then
  hook.Add( "OnSpawnMenuOpen", "CheckPermissionForSpawnMenu", function()
    if !GetAdminPermission(LocalPlayer(), "spawnmenu") then return true end
  end )
end

if flrp.config.enable_secondary_modules["ContextAdmin"] == true then
  hook.Add( "OnContextMenuOpen", "CheckPermissionForContextMenu", function()
    if !GetAdminPermission(LocalPlayer(), "spawnmenu") then return true end
  end )
end

hook.Add( "ChatText", "FLRPHideWelcomeMessages", function( index, name, text, typ )
  if ( typ == "joinleave" ) then return true end
  if ( typ == "namechange" ) then return true end
  --Тебе самому было бы интересно видеть это ? Вот и мне нет.
end )
