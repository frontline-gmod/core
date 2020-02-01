flrp = {
  config = config || {},
  including = including || {},
}

GM = GM or GAMEMODE
GAMEMODE = GM or GAMEMODE

pMeta = FindMetaTable( 'Player' )
eMeta = FindMetaTable( 'Entity' )
vMeta = FindMetaTable( 'Vector' )

GM.Name 		= 'FrontLine'
GM.Author 		= '_'
GM.Email 		= '_'
GM.Website 		= '_'

DeriveGamemode('sandbox')
