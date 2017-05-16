local Adverts = {
"Le gamemode n'est pas a vendre par respect au dev original qui nous autorise a le rendre a nouveaux utilisable. ",
"Les insultes ou menaces sont autorisés afin de rendre le pvp plus drôle",
"N'hesitez pas a MP Steam pour toute idées/suggestions > https://steamcommunity.com/id/HAAAAAAAAAAAAAAAAAX !",
}

timer.Create( "DM_Adverts", 100, 0, function() 
	chat.AddText( Color( 0, 255, 255 ), "[SH] ",
	Color( math.random( 1, 255 ), math.random( 1, 255 ), math.random( 1, 255 ) ), table.Random( Adverts ) )
end )

MsgN( "//		cl_adverts.lua loaded		//" )