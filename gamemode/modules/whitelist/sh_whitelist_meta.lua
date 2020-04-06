local pMeta = FindMetaTable("Player")

function pMeta:GetRank()
  return self:GetNWString( "fl_rank" ) != "" && self:GetNWString( "fl_rank" )
end
