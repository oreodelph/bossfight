-- Script found in https://www.roblox.com/library/1113572592/Forerunner-Threat
wait()
zombieParent = false

while zombieParent == false do

	wait()
	if script.Parent.Name == "Orion" then
		zombieParent = true
	end

end

local larm = script.Parent:FindFirstChild("Left Arm")
local rarm = script.Parent:FindFirstChild("Right Arm")
local waitTimer = 0
local orgPos = script.Parent.Torso.Position

function findNearestPlayer(pos)
	--https://devforum.roblox.com/t/what-is-the-quickest-way-to-see-which-player-is-closest-to-a-position/342962/6
	local closestPlayer, smallestMagnitude = nil,math.huge

	for _, player in pairs(game.Players:GetPlayers()) do
		local distance = player:DistanceFromCharacter(pos)
		if distance < smallestMagnitude then
			smallestMagnitude = distance
			closestPlayer = player
			if closestPlayer.Character.Humanoid.Health >= 1 then 
				script.Parent.Range.Value = true 
			else 
				script.Parent.Range.Value = false 
			end 
		end
	end
	repeat wait() until closestPlayer
	
	return closestPlayer
end

function findTorso(char)
	local torso = nil
	if char.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
		--is R6
		torso = char.Character.Torso
	else
		--is R15
		torso = char.Character.UpperTorso
	end
	return torso
end

function findNearestTorso(pos)
	local list = game.Workspace:children()
	local torso = nil
	local dist = 10000
	local temp = nil
	local human = nil
	local temp2 = nil
	for x = 1, #list do
		temp2 = list[x]
		if (temp2.className == "Model") and (temp2 ~= script.Parent) then
			temp = temp2:findFirstChild("Torso")
			human = temp2:findFirstChild("Humanoid")
			if (temp ~= nil) and (human ~= nil) and (human.Health > 0) then
				if (temp.Position - pos).magnitude < dist then
					torso = temp
					script.Parent.Target.Value = temp
					dist = (temp.Position - pos).magnitude

					if human.Health >= 1 then 
					script.Parent.Range.Value = true 
					else 
					script.Parent.Range.Value = false 
					end 
				end
			end
			if dist < 10 then 
				script.Parent.Attack.Value = true 
			else 
				script.Parent.Attack.Value = false 
			end 
		end
	end
	return torso
end

function Sit()
	if script.Parent.Zombie.Sit == true then 
		script.Parent.Zombie.Jump = true 
		print("Anti Seat Putter!!!")
	end 
end 

script.Parent.Zombie.Changed:connect(Sit)

function touch(hit)
if hit and hit.Parent then
if hit.Parent.Name == "Ballista" or  hit.Parent.Name == "Brotherhood Of Scythe" or hit.Parent.Name == "Jump" then
script.Parent.Zombie.Jump = true
end
end
end

script.Parent["Right Leg"].Touched:connect(touch)

script.Parent["Left Leg"].Touched:connect(touch)

while true do
	wait(1)
	--local target = findNearestTorso(script.Parent.Torso.Position)
	local closestPlayer = findNearestPlayer(script.Parent.Torso.Position)
	local distanceFromOrg = closestPlayer:DistanceFromCharacter(orgPos)
	local distanceFromCurrent = closestPlayer:DistanceFromCharacter(script.Parent.Torso.Position)
	local torso = findTorso(closestPlayer)
	
	if torso ~= nil then
		rx = math.random(-3,3)
		ry = math.random(0,0)
		rz = math.random(-3,3)
		if distanceFromOrg < 50 or distanceFromCurrent < 15 then
			script.Parent.Zombie:MoveTo(torso.Position+Vector3.new(rx,ry,rz), torso)
		else
			script.Parent.Zombie:MoveTo(orgPos)
		end
	else 
		script.Parent.Range.Value = false 
		script.Parent.Attack.Value = false 
	end
end
