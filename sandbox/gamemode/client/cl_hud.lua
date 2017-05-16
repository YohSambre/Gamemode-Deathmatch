surface.CreateFont( "HUDFont_1", { font = "ScoreboardText", size = 17, weight = 400, antialias = 0 } )
surface.CreateFont("HUDFont_2",{font = "HUDNumber", size = 36, weight = 700, antialias = 0})
surface.CreateFont("HUDFont_3",{font = "HUDNumber", size = 30, weight = 700, antialias = 0})
surface.CreateFont("TagFont",{font = "HUDNumber", size = 15, weight = 700, antialias = 0})


MsgN( "//		cl_hud.lua loaded		//" )

local OldHUD = {
	"CHudHealth",
	"CHudBattery",
	"CHudAmmo",
}

function GM:HUDShouldDraw( element )
	if ( table.HasValue( OldHUD, element ) ) then
		return false
	end
	return true
end

function myhud()
    local client = LocalPlayer()
    if !client:Alive() then return end
    if(client:GetActiveWeapon() == NULL or client:GetActiveWeapon() == "Camera") then return end
    
    local mag_left = client:GetActiveWeapon():Clip1()
    local mag_extra = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
    local secondary_ammo = client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType())
    local hp = client:Health()
    local armor = client:Armor()
    local mph = math.Round(client:GetVelocity():Length() * 0.056818181)
    local kph = math.Round(mph * 1.6093)
    local invehicle = client:InVehicle()
	local killstreak_count = client:GetNetworkedInt( "dm_killstreak" )
    
    //draw main hud 
    draw.RoundedBox( 0,10,ScrH() - 55,200,45, Color( 0,150,255,100 ))
    surface.SetDrawColor( 0,0,0,200 )
    surface.DrawOutlinedRect( 10,ScrH() - 55,200,45 )
    draw.SimpleTextOutlined( "Litre de Sang: ", "HUDFont_1",20,ScrH() - 50, Color( 255,0,0,245 ), 0, 0, 1, Color( 0,0,0,255 ))
    
    //draw clock
    draw.RoundedBox( 0,ScrW() / 2 - 80,10,160,20, Color( 0,150,255,100 ))
    surface.SetDrawColor( 0,0,0,200 )
    surface.DrawOutlinedRect( ScrW() / 2 - 80,10,160,20 )
    draw.SimpleTextOutlined( tostring(os.date()),"HUDFont_1",ScrW() / 2,11, Color( 240,240,240,245 ),TEXT_ALIGN_CENTER,0,1, Color( 0,0,0,255 ))
    
    if armor > 0 then
        draw.RoundedBox( 0,10,ScrH() - 80,140,20, Color( 0,150,255,100 ))
        surface.SetDrawColor( 0,0,0,200 )
        surface.DrawOutlinedRect( 10,ScrH() - 80,140,20 )
        draw.SimpleTextOutlined( "Armure: "..armor,"HUDFont_1",15,ScrH() - 98, Color( 100,255,255,245 ), 0, 0, 1, Color( 0,0,0,255 ))
        
        //draw energy bar
        draw.RoundedBox( 0,15,ScrH() - 75,130,10, Color( 50,200,150,200 ))
        draw.RoundedBox( 0,15,ScrH() - 75,130,3, Color( 0,0,0,50 ))
        draw.RoundedBox( 0,15,ScrH() - 75,math.floor(math.Clamp( armor * 1.3,0,130)),10, Color( 100,255,255,200 ))
        draw.RoundedBox( 0,15,ScrH() - 75,math.floor(math.Clamp( armor * 1.3,0,130)),3, Color( 255,255,255,100 ))
        surface.SetDrawColor( 0,0,0,200 )
        surface.DrawOutlinedRect( 15,ScrH() -75,130,10 )
        surface.DrawOutlinedRect( 15,ScrH() -75,math.Clamp( armor * 1.3,0,130),10 )
    end
    
	// PING
    draw.RoundedBox( 0,10,10,75,20, Color( 0,150,255,100 ))
	surface.SetDrawColor( 0,0,0,200 )
	surface.DrawOutlinedRect( 10,10,75,20 )
	draw.SimpleTextOutlined( "Ping: "..client:Ping(),"HUDFont_1",15,11, Color( 255,200,50,245 ), 0, 0, 1, Color( 0,0,0,255 ))
    
    if mag_left > 0 then //magazine counter
        draw.RoundedBox( 0,215,ScrH() - 55,50,20, Color( 0,150,255,100 ))
        surface.SetDrawColor( 0,0,0,200 )
        surface.DrawOutlinedRect( 215,ScrH() - 55,50,20 )
        draw.SimpleTextOutlined( "Munis","HUDFont_1",217,ScrH() - 72, Color( 50,200,50,220 ), 0, 0, 1, Color( 0,0,0,255 ))
        draw.SimpleTextOutlined( mag_left,"HUDFont_1",239,ScrH() - 54, Color( 50,200,50,220),TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,255 ))
    end
    
    if mag_left <= 0 and mag_extra > 0 then
        draw.SimpleTextOutlined( "Munis","HUDFont_1",217,ScrH() - 47, Color( 150,200,50,220 ),0,0,1, Color( 0,0,0,255 ))
    end
    
    if mag_extra > 0 then //leftover ammo counter
        draw.RoundedBox( 0,215,ScrH() - 30,50,20, Color( 0,150,255,100 ))
        surface.SetDrawColor( 0,0,0,200 )
        surface.DrawOutlinedRect( 215,ScrH() - 30,50,20 )
        draw.SimpleTextOutlined( mag_extra,"HUDFont_1",239,ScrH() - 29, Color( 150,200,50,220 ),TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,255 ))
    end
    
    if secondary_ammo > 0 then //secondary ammo counter
        draw.RoundedBox( 0,270,ScrH() - 30,40,20, Color( 0,150,255,100 ))
        surface.SetDrawColor( 0,0,0,200 )
        surface.DrawOutlinedRect( 270,ScrH() - 30,40,20 )
        draw.SimpleTextOutlined( secondary_ammo,"HUDFont_1",290,ScrH() - 29, Color( 240,90,50,220 ),TEXT_ALIGN_CENTER,0,1,Color( 0,0,0,255 ))
    end
		
    if armor > 0 then
		draw.SimpleTextOutlined( "Séries d'éliminations : " .. killstreak_count, "HUDFont_3", 10, ScrH() - 130, Color( 0, 150, 255 ), 0, 0, 3, Color( 0, 0, 0 ) )
	else
		draw.SimpleTextOutlined( "Séries d'éliminations : " .. killstreak_count, "HUDFont_3", 10, ScrH() - 108, Color( 0, 150, 255 ), 0, 0, 3, Color( 0, 0, 0 ) )
		draw.SimpleTextOutlined( "☠", "HUDFont_3", 280, ScrH() - 138, Color( 0, 150, 255 ), 0, 0, 3, Color( 0, 0, 0 ) )
    end
    //draw ..bar
    //health
    draw.RoundedBox( 0,20,ScrH() - 30,180,15, Color ( 255,255,255,255 ))
    draw.RoundedBox( 0,20,ScrH() - 30,180,5, Color ( 200,200,200,255 ))
    draw.RoundedBox( 0,20,ScrH() - 30,math.floor(math.Clamp( hp * 1.55,0,155 )),15, Color ( 255,0,0,245 ))
    draw.RoundedBox( 0,20,ScrH() - 30,math.floor(math.Clamp( hp * 1.55,0,155 )),5, Color ( 255,255,255,50 ))
    surface.SetDrawColor( 0,0,0,255 )
    surface.DrawOutlinedRect ( 20,ScrH() - 30,math.Clamp( hp * 1.55,0,155 ),15 )
    surface.DrawOutlinedRect ( 20,ScrH() - 30,180,15 )
    draw.SimpleTextOutlined( hp,"HUDFont_1", 23 + math.Clamp( hp * 1.55,0,152 ),ScrH() - 31, Color( 150, 25, 25 ), 0, 0,1, Color( 100, 25, 25 ))
	
	for k, v in pairs( player["GetAll"]() ) do
	
		local trace = LocalPlayer():GetEyeTrace()["Entity"]
		local pos = v:GetPos()
		pos.z = pos.z + 70
		pos = pos:ToScreen()
		
		if trace:IsPlayer() && LocalPlayer():GetPos():Distance( v:GetPos() ) < 1200 && trace != LocalPlayer() && trace == v then	
			
			surface.SetTexture(surface.GetTextureID("gui/silkicons/user"))
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( pos.x - 25, pos.y - 38, 16, 16 )	

			surface.SetTexture(surface.GetTextureID("gui/silkicons/heart"))
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( pos.x - 25, pos.y - 23, 16, 16 )
					
			draw.SimpleTextOutlined(v:Name(), "TagFont", pos.x - 10, pos.y -38, team.GetColor(v:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )
			draw.SimpleTextOutlined(v:Health(), "TagFont", pos.x - 10, pos.y -23, team.GetColor(v:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )
		end
	end
	
end

hook.Add("HUDPaint", "DMHud", myhud)

// ya

function GM:HUDDrawTargetID()
     return false
end
