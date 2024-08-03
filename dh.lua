local git = true 
local Library
if git then
	Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/koliaX/allrequired/main/kxguilib.lua"))()
else
	Library = loadstring(readfile('kxguilib/kxguilib.lua'))()
end


local Window = Library:CreateWindow("Main")

local plys = Window:AddFolder"Players"
local dan = Window:AddFolder"Danger"
local serv = Window:AddFolder"Server"

local tweenservice = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local jsonen = false

local plrs = game.Players
local lp = plrs.LocalPlayer
local twtp = false
local ptarget = lp
local ltarget
local slot = "Slot_1"
local heart = {}
local srs = {}
local clipping = false
local autododge
	local MOUSE = lp:GetMouse()
	local CONTROL = {F = 0,B = 0,L = 0,R = 0}
	local speed = 100
	local BV = nil
local flyen = false
local dsc
local depr = {['rbxassetid://14398795317']=true,['rbxassetid://14398798790']=true}
local autoparry = false
local origname = false

function tpt(targ)
	if twtp == false then
		lp.Character.HumanoidRootPart.CFrame = targ
	else
		a = tweenservice:Create(lp.Character.HumanoidRootPart, TweenInfo.new(0.5 +(lp.Character.HumanoidRootPart.Position - targ.Position).Magnitude / 1000) , { CFrame = targ + Vector3.new(0,5,0) })
		a:Play()
		return a
	end
end


-- function serversupd()
	-- servers:Clear()
	-- for i,v in pairs(game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data) do
		-- servers:AddValue(v.playing .. "/".. v.maxPlayers .. " " .. v.ping .." ".. v.id)
	-- end
-- end
function pllistupd()
	pllist:Clear()
	for i,v in pairs(game.Players:GetPlayers()) do
		if origname then
			pllist:AddValue(v)
		else
			pllist:AddValue(v,v.Character:GetAttribute("Name"))
		end
	end
end
local function quedh()
	queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/koliaX/dh/main/dh.lua"))
end

	local function flystart()
		spawn(function ()
			while wait() do
				local crb = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
				if BV ~= nil then
					BV.velocity = crb
				else
					break
				end
			end
		end)
	end

	MOUSE.KeyDown:connect(function(KEY)
		if flyen then
			if KEY:lower() == 'w' then
				CONTROL.F = 1
			elseif KEY:lower() == 's' then
				CONTROL.B = -1
			elseif KEY:lower() == 'a' then
				CONTROL.L = -1 
			elseif KEY:lower() == 'd' then 
				CONTROL.R = 1
			elseif KEY:lower() == 'e' then 
				speed = speed * 3
			elseif KEY:lower() == 'p' then 
				if BV ~= nil then
					BV:Destroy()
					BV = nil
				else
					local torso = lp.Character:FindFirstChild("UpperTorso") or lp.Character:FindFirstChild("Torso")
					BV = Instance.new("BodyVelocity", torso)
					flystart()
				end
			end
		end
		if noclipen and KEY:lower() == 'l' then
			clipping = not clipping
			for i,v in game.Players.LocalPlayer.Character:GetChildren() do
				if v:IsA("BasePart") then
					v.CanCollide = clipping
				end
			end
		end
	end)
	 
	MOUSE.KeyUp:connect(function(KEY)
		if flyen then
			if KEY:lower() == 'w' then
				CONTROL.F = 0
			elseif KEY:lower() == 's' then
				CONTROL.B = 0
			elseif KEY:lower() == 'a' then
				CONTROL.L = 0
			elseif KEY:lower() == 'd' then
				CONTROL.R = 0
			elseif KEY:lower() == 'e' then 
				speed = speed / 3
			end
		end
	end)
--
-- function toglanti(a)
-- 	game:GetService("Players").LocalPlayer.PlayerScripts.Effects.Disabled = a
-- 	game:GetService("Players").LocalPlayer.PlayerScripts["Anti Exploit"].Disabled = a
-- end
plys:AddToggle({text = "Safe tp", flag = "toggle", state = false, callback = function(a) twtp = a end})
-- safe:AddToggle({text = "Disable AntiCheat", flag = "toggle", state = false, callback = function(a) toglanti( a) end})

--

plys:AddToggle({text = "Display original name", flag = "toggle", state = false, callback = function(a)
	origname = a
end})
pllist = plys:AddList({text = "Player", flag = "list", value = '',values = '', callback = function(a) 
	ptarget = a 
	pllistupd() 
end})


plys:AddButton({text = "TP to target", flag = "button", callback = function() tpt(ptarget.Character.HumanoidRootPart.CFrame) end})
plys:AddButton({text = "TP to Muzan (inf castle)", flag = "button", callback = function() tpt(CFrame.new(-3.5478880405426025, 365.1489562988281, 389.9491271972656)) end})

plys:AddToggle({text = "Auto parry", flag = "toggle", state = false, callback = function(a)
	autoparry = a
	if autoparry then
		while autoparry do
			if (lp.Character.HumanoidRootPart.Position - ptarget.Character.HumanoidRootPart.Position ).Magnitude <10 then
				for i,v in ptarget.Character.Humanoid.Animator:GetPlayingAnimationTracks() do 
					if not depr[v.Animation.AnimationId] and v.Length > 0.5 then
						--print(v.Animation.AnimationId, v.Priority,v.Length)
						if (v.Priority == Enum.AnimationPriority.Action or v.Priority == Enum.AnimationPriority.Action2)  then
							print(v.Animation.AnimationId, v.Priority,v.Length)
							--task.wait(v.Length-0.75)
							game.ReplicatedStorage.EVENTS.Block:FireServer()
						end
					end
				end
			end
			task.wait(1/60)
		end
	end
end})
--


--




dan:AddToggle({text = "Fly p", flag = "toggle", state = false, callback = function(a)
	flyen = a
end})
dan:AddToggle({text = "Noclip", flag = "toggle", state = false, callback = function(a)
	noclipen = a
end})
dan:AddToggle({text = "Dodge spam", flag = "toggle", state = false, callback = function(a)
	autododge = a
	if autododge then
		while autododge do
			game:GetService("ReplicatedStorage").playerEvents.dash:FireServer("Back", 0.35)
			task.wait(0.2)
		end
	end
end})
dan:AddToggle({text = "Remove dodge sound", flag = "toggle", state = false, callback = function(a)
	if dsc then
		dsc:Disconnect()
	end
	if a then
		dsc = lp.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
			--print(child)
			if child.Name == "Dash" or child.Name == "Jump" then child.Volume = 0 end end)
	end
end})
dan:AddButton({text = "Immortality", flag = "button", callback = function()
	game.ReplicatedStorage.playerEvents.dash:FireServer(false)
end})


--
local selserv = game.JobId
serv:AddButton({text = "Join to server (Server id box)", flag = "button", callback = function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, selserv, lp)
end})
serv:AddButton({text = "Change Server", flag = "button", callback = function()
	TeleportService:Teleport(game.PlaceId, lp)
end})
if jsonen then
	function serversupd()
		servers:Clear()
		for i,v in pairs(game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data) do
			servers:AddValue(v.playing .. "/".. v.maxPlayers .. " " .. v.ping .." ".. v.id)
		end
	end
	servers = serv:AddList({text = "Servers", flag = "list", value = '',values = '', callback = function(a) 
		setclipboard(a)
		serversupd()
	end})
end
sidcheck  = serv:AddButton({text = "Get Current Server id", flag = "button", callback = function()
	sid:SetValue(game.JobId)
	selserv = game.JobId
end})
sid = serv:AddBox({text = "Server id ", flag = "button", value = selserv, callback = function(a)
	selserv = a
end})




--

Library:Init()

pllistupd()
if jsonen then
	serversupd()
end
quedh()

-- serversupd()
-- print("Toggle is currently:", Library.flags["toggle"])

