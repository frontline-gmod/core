local pMeta = FindMetaTable( "Player" )

function pMeta:Name()
  return self:GetNWString( "fl_name" ) != "" && self:GetNWString( "fl_name" )
end

pMeta.GetName = pMeta.Name
pMeta.Nick = pMeta.Name
