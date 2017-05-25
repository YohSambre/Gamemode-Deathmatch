MsgN( "//		cl_scoreboard.lua loaded	//" )
jc_color_bg = Color( 12, 12, 12, 235 )
jc_color_bg2 = Color( 21, 21, 21, 145 )
jc_color_title = Color( 255, 255, 255, 255 )
jc_color_line = Color( 148, 148, 148, 255 )

jc_color_white 	= Color( 255, 255, 255, 255 ) 
jc_color_red 	= Color( 255, 0, 0, 255 )
jc_color_green 	= Color( 0, 255, 0, 255 )
jc_color_blue 	= Color( 0, 0, 255, 255 )
jc_color_black	= Color( 0, 0, 0, 255 )
jc_color_alpha 	= Color( 0, 0, 0, 0 )
jc_color_button = Color( 68, 87, 101, 255 )

toggledon = 0
btoggledon = 0
bopened = 0
bmini = 1
 
bw = 135
bx = (ScrW()/2)-(bw/2)
bty = 27
btw = 70
btx = (ScrW()/2)-(btw/2)

function DrawBox( x, y, w, h, col, s ) --originally by the maw
	if not s then s = 3 end
	
	for i = 0, s do
		draw.RoundedBox( 0, x+i, y+i, w-i*2, h-i*2, Color( col.r/i, col.g/i, col.b/i, col.a ) )
	end
end

function DrawBoxNormal( x, y, w, h, col )
	draw.RoundedBox( 0, x, y, w, h, Color( col.r, col.g, col.b, col.a ) )
end

function DrawLine(x, y, w, h, col )
	surface.SetDrawColor( col )
	surface.DrawLine( x, y, w, h )
end

function Pulsate(c) --used for flashing colors
	return (math.cos(CurTime()*c)+1)/2 --originally by the maw
end

function CursorPos(x,y,w,h) --used for un parented buttons (originally by the maw)

	local cpx,cpy = gui.MousePos()
	
	if (cpx>x)and(cpx<x+w)and(cpy>y)and(cpy<y+h) then return true end
	return false
	
end

B = {}

function input.MousePress(MOUSE) --MOUSE _LEFT, _RIGHT, _MIDDLE
if (input.IsMouseDown(MOUSE)) then

	if (!B[MOUSE]) then
		B[MOUSE] = true
		return true
	else
		return false
	end
	
	elseif (!input.IsKeyDown(MOUSE)) then
		if (B[MOUSE]) then B[MOUSE] = false end
	end
end

function DrawPText( text, font, x, y, col, align1, align1 )
	color = Color( Pulsate(3)*col.r, Pulsate(3)*col.g, Pulsate(3)*col.b, col.a )
	draw.SimpleText( text, font, x, y, color, align1, align2 )
end

function DrawPTextOutlined( text, font, x, y, col, align1, align2, s, col2 )
	color = Color( Pulsate(3)*col.r, Pulsate(3)*col.g, Pulsate(3)*col.b, col.a )
	draw.SimpleTextOutlined( text, font, x, y, color, align1, align2, s, col2 )
end

function DrawText( text, font, x, y, col, align1, align2 )
	draw.SimpleText( text, font, x, y, col, align1, align2 )
end

function DrawTextOutlined( text, font, x, y, col, align1, align2, s, col2 )
	draw.SimpleTextOutlined( text, font, x, y, col, align1, align2, s, col2 )
end


surface.CreateFont("JcText", {
		font	= "Trebuchet18",
		size	= 16,
		weight	= 1000,
		antialias 	= true,
		additive = false,
		
	}
)	

surface.CreateFont("SgText", {
		font	= "Trebuchet18",
		size	= 32,
		weight	= 1000,
		antialias 	= true,
		additive = false,
		
	}
)	
function ScoreboardShow()	
	GAMEMODE.ShowScoreboard = true --show scoreboard
	gui.SetMousePos( ScrW()/4, ScrH()/5 ) --mouse pos
	gui.EnableScreenClicker( true ) --enable mouse
	return true
end
hook.Add( "ScoreboardShow", "Show", ScoreboardShow )

function ScoreboardHide()
	GAMEMODE.ShowScoreboard = false --hide scoreboard
	gui.EnableScreenClicker( false )
end
hook.Add( "ScoreboardHide", "Hide", ScoreboardHide )

--Variables
bcol = Color( 20, 20, 20, 135 ) --background color
rcol = Color( 25, 25, 25, 135 ) --button color
scol = Color( 0, 161, 255, 135 ) --standard color

local y = 80 --base y
local w = 60 --base w
local h = 20 --base h
local b = 5 --base b

local x = (ScrW()/2)-((w + 765 + (65*2))/2)-40 --base x
local tx = ((ScrW()/2)-((w + 765 + (65*2))/2))+270 --base tx (text x)

local Selected = "General"

function BanWindow(ply)
	local Window = vgui.Create("DFrame")
    	Window:SetTitle("Tout sur le ban")
    	Window:SetDraggable( false )
    	Window:ShowCloseButton(true)
    	Window:SetBackgroundBlur( true )
    	Window:SetDrawOnTop( true )
	local InnerPanel = vgui.Create("DPanel", Window)
	   	InnerPanel:SetPaintBackground(false)
    local Text = vgui.Create("DLabel", InnerPanel)
    	Text:SetText("En train de bannir " .. ply:Nick() .. "")
    	Text:SizeToContents()
    	Text:SetContentAlignment( 5 )
    local TimePanel = vgui.Create("DPanel", Window)
    	TimePanel:SetPaintBackground(false)
    local TexteEntry = vgui.Create("DTextEntry", TimePanel)
    	TexteEntry:SetText("Raison")
    	TexteEntry.OnEnter = function()
    		Window:Close()
    		RunConsoleCommand("ulx","ban",ply:Nick(), TimePanel:GetValue(), TexteEntry:GetValue())
    	end
    local Time = vgui.Create("DNumberWang", TimePanel)
    	Time:SetDecimals(0)
    	Time:SetValue(0)
    local TimeLabel = vgui.Create("DLabel",TimePanel)
    	TimeLabel:SetText("Minutes (0 = perma):")
    	TimeLabel:SetPos(170, 0)
    	TimeLabel:SetSize( 150, 15)
    local ButtonPanel = vgui.Create("DPanel", Window)
    	ButtonPanel:SetTall(25)
    	ButtonPanel:SetPaintBackground(false)
    local ButtonOk = vgui.Create("DButton", ButtonPanel)
    	ButtonOk:SetText("OK")
    	ButtonOk:SizeToContents()
    	ButtonOk:SetTall( 20 )
    	ButtonOk:SetWide( ButtonOk:GetWide() + 20 )
    	ButtonOk:SetPos(5, 3)
    	ButtonOk.DoClick = function()
        	Window:Close()
    		RunConsoleCommand("ulx", "ban", ply:Nick(), Time:GetValue(), TexteEntry:GetValue())
    	end
    ButtonPanel:SetWide( ButtonOk:GetWide() + 5 )
    Window:SetSize( 450, 111 + 75 + 20 )
    Window:Center()
    InnerPanel:StretchToParent( 5, 25, 5, 125 )
    TimePanel:StretchToParent(5, 83, 5, 37)
    Time:SetPos(190, 20)
    Text:StretchToParent( 5, 5, 5, nil )
   	TexteEntry:StretchToParent( 5, nil, 5, nil )
    TexteEntry:AlignBottom( 5 )
    TexteEntry:RequestFocus()
    ButtonPanel:CenterHorizontal()
    ButtonPanel:AlignBottom(7)
    Window:MakePopup()
   	Window:DoModal()
   	TexteEntry:RequestFocus()
    TexteEntry:SelectAllText(true)
end

function KickWindow(ply)
	local Window = vgui.Create("DFrame")
    	Window:SetTitle("Tout sur le kick")
    	Window:SetDraggable( false )
    	Window:ShowCloseButton(true)
    	Window:SetBackgroundBlur( true )
    	Window:SetDrawOnTop( true )
	local InnerPanel = vgui.Create("DPanel", Window)
	  	InnerPanel:SetPaintBackground(false)
    local Text = vgui.Create("DLabel", InnerPanel)
    	Text:SetText("En train de botter le cul de " .. ply:Nick() .. " hors du serveur")
    	Text:SizeToContents()
    	Text:SetContentAlignment( 5 )
    local TexteEntry = vgui.Create("DTextEntry", InnerPanel)
    	TexteEntry:SetText("Raison")
    	TexteEntry.OnEnter = function()
    		Window:Close()
    		RunConsoleCommand("ulx","kick",ply:Nick(), TexteEntry:GetValue())
    	end
    local ButtonPanel = vgui.Create("DPanel", Window)
    	ButtonPanel:SetTall(25)
    	ButtonPanel:SetPaintBackground(false)
    local ButtonOk = vgui.Create("DButton", ButtonPanel)
       	ButtonOk:SetText("OK")
       	ButtonOk:SizeToContents()
       	ButtonOk:SetTall( 20 )
       	ButtonOk:SetWide( ButtonOk:GetWide() + 20 )
       	ButtonOk:SetPos(5, 3)
       	ButtonOk.DoClick = function()
           	Window:Close()
           	RunConsoleCommand("ulx", "kick", ply:Nick(), TexteEntry:GetValue())
        end
    ButtonPanel:SetWide( ButtonOk:GetWide() + 5 )
    Window:SetSize( 450, 111)
    Window:Center()
    InnerPanel:StretchToParent( 5, 25, 5, 20)
    Text:StretchToParent( 5, nil, 5, nil)
   	TexteEntry:StretchToParent( 5, nil, 5, nil)
    TexteEntry:AlignBottom( 7 )
    TexteEntry:RequestFocus()
    ButtonPanel:CenterHorizontal()
    ButtonPanel:AlignBottom(2)
    Window:MakePopup()
   	Window:DoModal()
   	TexteEntry:RequestFocus()
    TexteEntry:SelectAllText(true)
end

function CreateMenu(ply)
	local Menu = DermaMenu()
	Menu:AddOption("Ban",function()
		BanWindow(ply)
	end)
	Menu:AddOption("Kick",function()
		KickWindow(ply)
	end)
	Menu:AddOption("Slay",function()
		RunConsoleCommand("ulx","slay",ply:Nick())
	end)
	Menu:AddOption("Boom",function()
		RunConsoleCommand("ulx","boom",ply:Nick())
	end)
	Menu:AddOption("Ragdoll",function()
		RunConsoleCommand("ulx","ragdoll",ply:Nick())
	end)
	Menu:AddOption("Unragdoll",function()
		RunConsoleCommand("ulx","unragdoll",ply:Nick())
	end)
	Menu:AddOption("TP",function()
		RunConsoleCommand("ulx","teleport",ply:Nick())
	end)
	Menu:AddOption("Goto",function()
		RunConsoleCommand("ulx","goto",ply:Nick())
	end)
	Menu:Open()
end

function HUDDrawScoreBoard()

	if not GAMEMODE.ShowScoreboard then return true end

	B = {} --makes the tabs work properly


	draw.RoundedBox( 1, x + 60 - b, y - (b*2), w + 765 + (65*2), 40 + (#player.GetAll() * 15), jc_color_bg2 ) --Overall Background Bar

	draw.RoundedBox( 1, x + 62 - b, y + 2 - (b*2), w + 761 + (65*2), 36 + (#player.GetAll() * 15), jc_color_bg2 ) --Overall Background Bar #2

	draw.RoundedBox( 0, x + 65 - b, y - b, w + 755 + (65*2), 21, jc_color_bg ) --Button Background Bar
	surface.SetDrawColor( 255, 255, 255, 5 )
	surface.SetTexture(surface.GetTextureID("gui/gradient_up")) --up gradient for unselected tabs
	surface.DrawTexturedRect(x + 65 - b, y - b, w + 755 + (65*2), 20)
	--draw.SimpleTextOutlined( "", "",  ScrW()/8, ScrH()/1.05, Color( 255, 255, 255 ), 0, 0, 3, Color( 0, Pulsate(2)*255, Pulsate(3)*255, 255  ) )
	DrawTextOutlined("[Le Serveur aux hémorroïdes] DeathMatch gameplay", "SgText", ScrW()/2, y - 44, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color( 0, Pulsate(3)*255, Pulsate(3)*255, 255 ) )
	
	for i = 1, 1 do
		local Tabs = {
			"Prétendant",
		}

		draw.RoundedBox( 0, x + (65 * i), y, w, 15, bcol ) --background box
		
		surface.SetDrawColor( 25, 25, 25, 255 )
		
		if Selected != Tabs[i] then --for the tabs that are not selected
			surface.SetDrawColor( 255, 255, 255, 15 )
			surface.SetTexture(surface.GetTextureID("gui/gradient_up")) --up gradient for unselected tabs
			surface.DrawTexturedRect(x + (65 * i), y, w, 15)
		end

		if Selected == Tabs[i] then --for the tab that is selected
			surface.SetDrawColor( 255, 255, 255, 15 )
			surface.SetTexture(surface.GetTextureID("gui/gradient_down")) --down gradient for selected tab
			surface.DrawTexturedRect(x + (65 * i), y, w, 15)
		end
		
		
		DrawTextOutlined( Tabs[i] , "JcText", x + 3 + (65 * i), y-1, Color( 0, 161, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )
		
		draw.RoundedBox( 0, x + 65 - b, y + 16, w + 755 + (65*2), 10 + ( #player.GetAll()*15 ), rcol )
		
		for k,v in pairs( player.GetAll() ) do
			
			if CursorPos( x + 63, y + 5 + (k * 15), w + 747 + (65*2), 16 ) then
				draw.RoundedBox( 0, x + 64, y + 6 + (k * 15), w + 745 + (65*2), 15, Color( 255, 255, 255, 5 ) )
				-- custom code
				if input.IsMouseDown(MOUSE_LEFT) and LocalPlayer():IsAdmin() then
					CreateMenu(player.GetAll()[k])
				end
				-- end of custom
			end
			
		//	local plhrs = math.floor((v:GetUTime() + CurTime() - v:GetUTimeStart())/60/60)
			local killstreak = v:GetNetworkedInt( "dm_killstreak" )
			
			if Selected == "General" then	
				DrawTextOutlined(v:Nick(), "JcText", x + 66, (y + b - 1) + (k * 15), Color(200, 200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )

			
				
				if v:Alive() then
					DrawTextOutlined("SURVIVANT", "JcText", tx+120, (y + b - 1) + (k * 15), Color( 0, 255, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )	
				else
					DrawTextOutlined("FAIBLE", "JcText", tx+120, (y + b - 1) + (k * 15), Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )	
				end
				
				DrawTextOutlined("Frags Score: " .. killstreak, "JcText", tx+345, (y + b - 1) + (k * 15), scol, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )	
				DrawTextOutlined("Score: " .. v:Frags(), "JcText", tx+445, (y + b - 1) + (k * 15), scol, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )
				DrawTextOutlined("Morts: " .. v:Deaths(), "JcText", tx+545, (y + b - 1) + (k * 15), scol, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )
				DrawTextOutlined("Ping: " .. v:Ping(), "JcText", tx + 625, (y + b - 1) + (k * 15), scol, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255 ) )

			end	
		end
	end
end
hook.Add( "HUDDrawScoreBoard", "Draw", HUDDrawScoreBoard )
