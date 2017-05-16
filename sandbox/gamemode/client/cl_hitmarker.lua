MsgN( "//		cl_hitmarker.lua loaded		//" )

net.Receive("HitMarkerNet",function()
	hook.Add("HUDPaint","HitMarkerH",function()
		surface.SetDrawColor( 255, 255, 255, 180 )
		surface.DrawLine( ScrW() / 2 - 5, ScrH() / 2 - 5, ScrW() / 2 - 15, ScrH() / 2 - 15 )
		surface.DrawLine( ScrW() / 2 + 5, ScrH() / 2 + 5, ScrW() / 2 + 15, ScrH() / 2 + 15 )
		surface.DrawLine( ScrW() / 2 + 5, ScrH() / 2 - 5, ScrW() / 2 + 15, ScrH() / 2 - 15 )
		surface.DrawLine( ScrW() / 2 - 5, ScrH() / 2 + 5, ScrW() / 2 - 15, ScrH() / 2 + 15 )
	end)
	timer.Simple( 0.2,function() -- Le temps en sec du hitmarker
		hook.Remove("HUDPaint","HitMarkerH")
	end)
end)