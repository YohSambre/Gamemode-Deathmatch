/*
	Deathmatch
	Based on HvH by noPE
	
	Credits:
		Me - Obvious reasons
		noPE - HvH which i based this on, i removed most of his code, but i still used a bit of it.
		Fisheater - Shitty faggot sound system which will be replaced soon.
		Mythik: Testing, ideas, some snippets of code, cheat detection methods
		Maks: Fixing this obsolete gamemode
*/

// Fuck your gay ass net lib garry

print( "//		init.lua Loaded			//" )

AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )
AddCSLuaFile( "shared.lua" )

// global for a reason
DM = {}

-- Include server side
include( "server/sv_files.lua")
include( "server/sv_party.lua")
include( "server/sv_playerspawn.lua")
include( "server/sv_hitmarker.lua")
include( "server/sv_connect.lua")
-- include client side
AddCSLuaFile( "client/cl_adverts.lua")
AddCSLuaFile( "client/cl_fonts.lua")
AddCSLuaFile( "client/cl_hitmarker.lua")
AddCSLuaFile( "client/cl_hud.lua")
AddCSLuaFile( "client/cl_killsounds.lua")
AddCSLuaFile( "client/cl_scoreboard.lua")

print("//   config.lua loaded   //")

WeaponNames = { -- Nom des armes
	["weapon_stunstick"] = "Sextoy",
	["weapon_crowbar"] = "Baton Pour Taper",
	["weapon_crossbow"] = "Crossbow",
	["weapon_rpg"] = "Tube du Noob", 
	["prop_physics_multiplayer"] = "Prop",
	["prop_physics"] = "Prop",
	["weapon_357"] = "Magnum 357",
	["bb_cssfrag_alt"] = "Grenada",
	["weapon_slam"] = "SLAM",
	["bb_deagle_alt"] = "Desert Eagle",
	["bb_famas_alt"] = "Famas",
	["bb_m4a1_alt"] = "M4A1",
	["bb_awp_alt"] = "Fusil Sniper",
	["bb_m3_alt"] = "Pompeux",
	["bb_m249_alt"] = "Machinegun",
	["bb_dualelites_alt"] = "Dual Elite",
	["bb_glock_alt"] = "Glock",
	["bb_usp_alt"] = "USP",
	["bb_fiveseven_alt"] = "Five Seven",
	["bb_p228_alt"] = "P228",
	["m9k_davy_crockett"] = "Nuke",
}

WeaponPoints = { -- Quand on tue avec cette arme combien de points on gagne
	["weapon_stunstick"] = 10,
	["weapon_crowbar"] = 10,
	["weapon_crossbow"] = 5,
	["weapon_rpg"] = 1, 
	["prop_physics_multiplayer"] = 3,
	["weapon_357"] = 5,
	["bb_cssfrag_alt"] = 6,
	["weapon_slam"] = 6,
	["prop_physics"] = 3,
	["bb_deagle_alt"] = 5,
	["bb_famas_alt"] = 3,
	["bb_m4a1_alt"] = 2,
	["bb_awp_alt"] = 6,
	["bb_m3_alt"] = 5,
	["bb_m249_alt"] = 3,
	["bb_dualelites_alt"] = 5,
	["bb_glock_alt"] = 5,
	["bb_usp_alt"] = 5,
	["bb_fiveseven_alt"] = 5,
	["bb_p228_alt"] = 5,
	["m9k_davy_crockett"] = 0,
}

// stolen from hvh_redux
Killstreaks = { -- Texte du killstreak
	[3] = { " TU SAUVES L'HONNEUR MEC !", "s'engage pour l'Honneur de sa famille" },
	[5] = { " YEA EN ROUTE POURLE SKILL !", "en route pour le skill" },
	[8] = { "MODE KEYKETTE DUR ?!!?", "est en mode keykette dur" },
	[12] = { "CHAUD COMME LA BRAISE !", "chaud comme la braise" },
	[15] = { "OMG OWWWWW MY GAWD !", "oww my gawd" },
	[19] = { "PAPA DU GAME.", "papa du game" },
	[23] = { "BORDEL DE MERDE LE TALENT !", "le talent" },
	[25] = { "BAISODROME EN PVP", "baisodrome en pvp" },
	[30] = { "QUI PEUT ME STOPPER ?, PERSONNE !", "qui peut me stopper?" },
	[38] = { "HACK IN PROGRESS..SANIC AIMBOT ?!!?", "haaaaxx" },
}

function DM.Print( col, msg )
	MsgC( col, "[Serveur infos] " )
	MsgC( Color( 255, 255, 255 ), msg .. "\n" )
end

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
     return true
end

function GM:PlayerAuthed( ply, sid, uid )
	ply.killstreak = 0
	ply:SetNWInt( "dm_killstreak", ply.killstreak )
end

//if v:GetNWInt( "dm_killstreak" ) != 5 && v:GetNWInt( "dm_killstreak" ) != 10 && v:GetNWInt( "dm_killstreak" ) != 15 then
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	 if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 )
		for k, v in pairs( player.GetAll() ) do
			if hitgroup == HITGROUP_HEAD then
				v:PrintMessage( HUD_PRINTCENTER, dmginfo:GetAttacker():Nick() .. " VIENS DE FAIRE UN PUTAIN D'HEADSHOOT!" )
				ply:EmitSound( "ambient/creatures/town_child_scream1.wav" )
			end
		end
	 end
 
	// Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM || 
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then
 
		dmginfo:ScaleDamage( 0.50 )
 
	 end
 
end

function GM:PlayerDeathSound()
	return true
end

local plInfo = {}
function HealthRegen( pl )
	if( pl:Health() >= 100 ) then return; end
	timer.Simple( 0.1, function()
		if( pl:Health() < 100 && pl:Health() > 0 && pl:Alive() && ( plInfo[pl].ForceStop == false ) ) then
			pl:SetHealth( pl:Health() + 1 );
			HealthRegen( pl )
			
			plInfo[pl].Healing = true
		else
			plInfo[pl].Healing = false
		end
	end )
end

function GM:PlayerHurt( pl, attacker )
	if timer.Exists("HealingTimer") then
		timer.Destroy("HealingTimer")
	end
	if !plInfo[pl] then
		plInfo[pl] = {};
		plInfo[pl].Healing = false;
		plInfo[pl].ForceStop = false;
	end
	
	plInfo[pl].ForceStop = true;
	
	if pl:Alive() && pl:Health() >= 0 then
		timer.Create("HealingTimer", 8, 1,function()
			if IsValid( pl ) then
				if( pl:Alive() && pl:Health() > 0 ) then
					plInfo[pl].ForceStop = false;
					HealthRegen( pl )
				end
			end
		end)
	end
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )
	ply.killstreak = 0
	ply:SetNWInt( "dm_killstreak", ply.killstreak )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker != ply ) then
			attacker.killstreak = attacker.killstreak + 1
			attacker:SetNWInt( "dm_killstreak", attacker.killstreak )
		end
	end
	
	local text
	local weapon
	local wepname
	if attacker:Health() <= 0 || attacker:GetActiveWeapon() == nil then
		weapon = "wat"
	else
		weapon = attacker:GetActiveWeapon()
	end
	
	if attacker != ply then	
		if WeaponNames[tostring( weapon:GetClass())] == nil then
			MsgN("Add weapon name for "..weapon:GetClass())
			text = "[Serveur infos] Vous gagnez 5 points pour avoir tue " .. ply:Nick()
		else
			text = "[Serveur infos] Vous gagnez 5 points pour avoir tue " .. ply:Nick() .. " avec " .. WeaponNames[weapon:GetClass()]
		end
		attacker:AddFrags( 1 )
		attacker:PS_GivePoints( 5 )
	else
		text = "[Serveur Infos] " .. ply:Nick() .. " n'en pouvais plus..trop de stress"
	end
	//BroadcastLua( "chat.AddText( Color( 75, 75, 255 ), [[" .. text .. "]] )" )
	attacker:SendLua( "chat.AddText( Color( 75, 75, 255 ), [[" .. text .. "]] )" )

	if Killstreaks[attacker.killstreak] then
		if attacker.killstreak == 30 then
			PrintMessage( HUD_PRINTCENTER, string.upper( "OMG"..attacker:Nick().." viens de recevoir un soutient nucléaire..CACHEZ VOUS!" ) )
			attacker:Give("m9k_davy_crockett")
			attacker:SelectWeapon("m9k_davy_crockett")
		else
			attacker:PrintMessage( HUD_PRINTCENTER, string.upper( Killstreaks[attacker.killstreak][1] ) )
		end
		text = "[Serveur infos] Cadeaux de 5 points, " .. Killstreaks[attacker.killstreak][1]
		attacker:SendLua( "chat.AddText( Color( 255, 255, 255 ), [[" .. text .. "]] )" )
		
		text = "[Serveur infos] " .. attacker:Nick() .. " " .. Killstreaks[attacker.killstreak][2]
		BroadcastLua( "chat.AddText( Color( 255, 0, 0 ), [[" .. text .. "]] )" )
		
		attacker:AddFrags( 1 )
		attacker:PS_GivePoints( 5 )
	end
end