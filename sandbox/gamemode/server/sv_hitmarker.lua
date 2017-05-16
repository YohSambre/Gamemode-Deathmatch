util.AddNetworkString("HitMarkerNet")

hook.Add("PlayerHurt","HitMarkerSV", function( victim, attacker)
	if attacker:IsPlayer() then
		net.Start("HitMarkerNet")
		net.Send(attacker)
	end
end)