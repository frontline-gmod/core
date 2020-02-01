local PLAYER = {}

PLAYER.DisplayName			= "Roleplay Player Class"

PLAYER.WalkSpeed	= 100
PLAYER.RunSpeed	= 225
PLAYER.CrouchedWalkSpeed	= 15
PLAYER.DuckSpeed	= 0.3
PLAYER.UnDuckSpeed	= 0.3
PLAYER.JumpPower	= 160
PLAYER.MaxHealth	= 100
PLAYER.StartHealth	= 100
PLAYER.StartArmor	= 0
PLAYER.DropWeaponOnDie	= false
PLAYER.TeammateNoCollide	= true
PLAYER.AvoidPlayers	= true
PLAYER.UseVMHands	= true

function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName( self.Player:GetModel() )
	return player_manager.TranslatePlayerHands( playermodel )
end

player_manager.RegisterClass("roleplay_class", PLAYER, "player_default")
