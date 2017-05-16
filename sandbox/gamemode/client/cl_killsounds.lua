MsgN( "//		cl_killsounds.lua loaded	//" )

local SongStopper1 = 0
local SongStopper2 = 0
local SongStopper3 = 0
local SongStopper4 = 0
hook.Add( "Think", "DMSounds", function()
	for k, v in pairs( player.GetAll() ) do
		if v:GetNWInt( "dm_killstreak" ) == 15 then
			if SongStopper1 == 0 then
				surface.PlaySound( "vo/ravenholm/madlaugh03.wav" )
				SongStopper1 = SongStopper1 + 1
			end
		end
		if v:GetNWInt( "dm_killstreak" ) == 16 then
			SongStopper1 = 0
		end
		
		if v:GetNWInt( "dm_killstreak" ) == 5 then
			if SongStopper2 == 0 then
				surface.PlaySound( "vo/npc/male01/nice.wav" )
				SongStopper2 = SongStopper2 + 1
			end
		end		
		if v:GetNWInt( "dm_killstreak" ) == 6 then
			SongStopper2 = 0
		end
		
		if v:GetNWInt( "dm_killstreak" ) == 10 then
			if SongStopper3 == 0 then
				surface.PlaySound( "vo/npc/male01/yeah02.wav" )
				SongStopper3 = SongStopper3 + 1
			end
		end		
		if v:GetNWInt( "dm_killstreak" ) == 11 then
			SongStopper3 = 0
		end
		
		if v:GetNWInt( "dm_killstreak" ) == 25 then
			if SongStopper4 == 0 then
				surface.PlaySound( "vo/npc/male01/hacks01.wav" )
				SongStopper4 = SongStopper4 + 1
			end
		end
		if v:GetNWInt( "dm_killstreak" ) == 26 then
			SongStopper4 = 0
		end
	end
end )