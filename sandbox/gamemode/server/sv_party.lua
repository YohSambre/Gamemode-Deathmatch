print("//   sv_party.lua loaded   //")

local meta = FindMetaTable( 'Player' )

function meta:Party()

	local Effect = EffectData()
	Effect:SetOrigin( self:GetPos() + Vector(0, 0, 72) )
	Effect:SetEntity( self )
	util.Effect("balloon_pop", Effect, true, true)
	util.Effect("ShellEject", Effect, true, true)
	util.Effect("StunstickImpact", Effect, true, true)
end






