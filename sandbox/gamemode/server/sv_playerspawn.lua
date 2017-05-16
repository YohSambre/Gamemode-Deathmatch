local models = {
	"models/player/Group03/Male_01.mdl",
	"models/player/Group03/Male_02.mdl",
	"models/player/Group03/Male_03.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/Male_06.mdl",
	"models/player/Group03/Male_07.mdl",
	"models/player/Group03/Male_08.mdl",
	"models/player/Group03/Male_09.mdl",
}

function GM:PlayerSpawn( ply )
	ply:SetRunSpeed( 355 )
	ply:SetWalkSpeed( 255 )
	ply:SetModel( table.Random( models ) )
	ply:SetupHands()
	
	local sid = ply:SteamID()
	ply:StripWeapons()
	
	ply:Give( "weapon_stunstick" )
	ply:Give( "weapon_slam" )
	ply:Give("bb_awp_alt")
	ply:Give("bb_deagle_alt")
	ply:Give("bb_famas_alt")
	ply:Give("bb_m3_alt")
	ply:Give( "bb_cssfrag_alt" )
	
	local spawnsounds = {
		"items/ammo_pickup.wav",
	}
	// Fancy sound effect/sound
	ply:Party()
	ply:EmitSound( Sound( table.Random( spawnsounds ) ), 100, 100 )
	
	ply:SelectWeapon( "bb_deagle_alt" )
	
end

function autoRespawn( ply )
	timer.Simple( 5, function() 
		if !ply:Alive() then
			ply:Spawn()
		end
	end )
end
hook.Add( "PlayerDeath", "autoRespawn", autoRespawn )

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam( 2 )
	ply:ChatPrint( "Bienvenue petit hemorroide" )
end
