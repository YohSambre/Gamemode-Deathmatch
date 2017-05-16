print("//   sv_files.lua loaded   //")

resource.AddFile( "materials/sprites/sparkle.vmt" )
resource.AddFile( "materials/sprites/sparkle.vtf" )
resource.AddFile( "particles/vman_explosion.pcf" )
resource.AddFile( "particles/gmod_effects.pcf" )

function AddFile( str, id )
	if str then
		MsgC( Color( 0, 255, 255 ), "[FASTDL] Adding workshop file " .. str .. " ID: " .. id .. "\n" )
	else
		MsgC( Color( 0, 255, 255 ), "[FASTDL] Adding workshop file 'unknown' ID: " .. id .. "\n" )
	end
	resource.AddWorkshop( id )
end

AddFile( "CSS Weapons on M9K Base", "108720350" )
AddFile( "Explosion Effect", "127986968" )
