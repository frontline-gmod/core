pMeta = FindMetaTable( "Player" )

function GetAdminUsergroup( usergroup )
  if flrp.config.usergroup[usergroup] then return true else return false end
end

function GetAdminPermission( ply, permission )
  if (type(ply) == "Entity" and !IsValid(ply) and (ply.EntIndex and ply:EntIndex() == 0)) then return true end
  if IsValid(ply) then return table.HasValue(flrp.config.usergroup[ply:GetUserGroup()], permission) end
end

function GetAdminImmunity( ply )
  if (type(ply) == "Entity" and !IsValid(ply) and (ply.EntIndex and ply:EntIndex() == 0)) then return true end
  if IsValid(ply) then return flrp.config.usergroup.immunity[ply:GetUserGroup()] end
end

function CheckAdminImmunity( ply, target )
  if (type(ply) == "Entity" and !IsValid(ply) and (ply.EntIndex and ply:EntIndex() == 0)) then return true end
  if IsValid(ply) then if flrp.config.usergroup.immunity[ply:GetUserGroup()] >= flrp.config.usergroup.immunity[target:GetUserGroup()] then return true else return false end end
end

function pMeta:IsSuperAdmin()
  if GetAdminPermission( self, "superadmin" ) then return true else return false end
end

function pMeta:IsAdmin()
  if GetAdminPermission( self, "admin" ) then return true else return false end
end
