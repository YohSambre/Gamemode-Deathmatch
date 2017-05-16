MsgN( "//		sv_connect.lua loaded		//" )

function SpawnMessage(ply)
	BroadcastLua("chat.AddText(Color( 255, 58, 24 ), '[SH] "..ply:Nick().." ', Color( 174, 255, 0 ), 'va tenter de devenir le meilleur joueur!')")
end
hook.Add("PlayerInitialSpawn", "SpawnMessage", SpawnMessage)

function EntityRemoved(ply)
	BroadcastLua("chat.AddText(Color( 255, 58, 24 ), '[SH] "..ply:Nick().." ', Color( 149, 102, 255 ), '("..ply:SteamID()..") A préféré fuir plutot que survivre!')")
end
hook.Add("PlayerDisconnected", "DecoMessage", DecoMessage)


