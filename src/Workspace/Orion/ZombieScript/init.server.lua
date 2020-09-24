-- Script found in https://www.roblox.com/library/1113572592/Forerunner-Threat

wait(1.5)
local sp = script.Parent
local Humanoid = sp:WaitForChild("Zombie")
local Head = sp:WaitForChild("Head")
local Torso = sp:WaitForChild("Torso")
local Animation = script:WaitForChild("AttackAnim")
local Hit1 = Instance.new("Sound",Torso)
Hit1.Volume = 1
Hit1.SoundId = " "
Hit1.Pitch = 0.15
local Hit2 = Instance.new("Sound",Torso)
Hit2.Volume = 1
Hit2.SoundId = " "
Hit2.Pitch = 0.15

local AttackEnabled = true

function wait(TimeToWait)
	if TimeToWait ~= nil then
		local TotalTime = 0
		TotalTime = TotalTime + game:GetService("RunService").Heartbeat:wait()
		while TotalTime < TimeToWait do
			TotalTime = TotalTime + game:GetService("RunService").Heartbeat:wait()
		end
	else
		game:GetService("RunService").Heartbeat:wait()
	end
end

function DamageTag(parent,damage)
	local DmgTag = script.DamageTag:clone()
	DmgTag.Damage.Value = damage
	DmgTag.creator.Value = game.Players.LocalPlayer
	DmgTag.Disabled = false
	DmgTag.Parent = parent
end

local Anim = Humanoid:LoadAnimation(Animation)
function Hit(hit)
	local TargetHum = hit.Parent:FindFirstChild("Humanoid")
	if TargetHum ~= nil and TargetHum:IsA("Humanoid") and AttackEnabled == true and TargetHum ~= Humanoid then
		AttackEnabled = false
		Delay(0.5,function() AttackEnabled = true end)
		if Anim then Anim:Play(nil,nil,1.5) end
		DamageTag(TargetHum.Parent,6.5)
		Hit1:Play()
		Hit2:Play()
	end
end

for _, Child in pairs(script.Parent:GetChildren()) do
	if Child:IsA("Part") or Child:IsA("WedgePart") or Child:IsA("CornerWedgePart") then
		Child.Touched:connect(Hit)
	end
end 
