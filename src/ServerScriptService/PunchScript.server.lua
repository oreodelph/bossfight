--https://www.youtube.com/watch?time_continue=9&v=a1eZ9gTm32M&feature=emb_logo
--https://www.roblox.com/library/3031470191/Punch-Animation
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		local sound = game.ServerStorage.Punch:Clone()
		sound.Parent = char:WaitForChild("Head")
	end)
end)

game.ReplicatedStorage.Punch.OnServerEvent:Connect(function(player, humanoid)
	if humanoid.Health >= 10 then
		humanoid.Health = humanoid.Health - 100
	elseif humanoid.Health <= 0 then
		humanoid.Health = 0
		print("Dead!")

		if humanoid.RigType == Enum.HumanoidRigType.R6 then
			--is R6
			RagdollV3(humanoid.Parent)
		else
			--is R15
			ragdollR15(humanoid.Parent)
		end

	end

	player.Character.Head.Punch:Play()
end)

function ragdollR15(char)
	print("ragdollR15 death")
	--Ragdoll script (only works for R15) - https://devforum.roblox.com/t/humanoid-breakjointsondeath/252053/16
	local d = char:GetDescendants()
	for i=1,#d do
		local desc = d[i]
		if desc:IsA("Motor6D") then
			local socket = Instance.new("BallSocketConstraint")
			local part0 = desc.Part0
			local joint_name = desc.Name
			local attachment0 = desc.Parent:FindFirstChild(joint_name.."Attachment") or desc.Parent:FindFirstChild(joint_name.."RigAttachment")
			local attachment1 = part0:FindFirstChild(joint_name.."Attachment") or part0:FindFirstChild(joint_name.."RigAttachment")
			if attachment0 and attachment1 then
				socket.Attachment0, socket.Attachment1 = attachment0, attachment1
				socket.Parent = desc.Parent
				desc:Destroy()
			end	
		end
	end
end

-- https://www.roblox.com/library/300588862/Ragdoll-Death-R6
joints = {} welds = {} fakeLimbs = {}
ragdolling = false

repeat wait() until workspace.CurrentCamera ~= nil
wait(0.001)

local cleanUpTime = 60 -- change this to whatever you want

local function NewHingePart()
	local B = Instance.new("Part")
	B.TopSurface = 0 B.BottomSurface = 0
	B.Shape = "Ball"
	B.Size = Vector3.new(1, 1, 1)
	B.Transparency = 1 B.CanCollide = true
	return B
end
local function CreateJoint(j_type, p0, p1, c0, c1)
	local nj = Instance.new(j_type)
	nj.Part0 = p0 nj.part1 = p1
	if c0 ~= nil then nj.C0 = c0 end
	if c1 ~= nil then nj.C1 = c1 end
	nj.Parent = p0
end

local AttactmentData = { --Limb socket attaching to Torso
	--["AttachmentTag"] = {part_name, part_attachment, torso_attachment, relative_position}
	["RA"] = {"Right Arm", CFrame.new(0, 0.5, 0), CFrame.new(1.5, 0.5, 0), CFrame.new(1.5, 0, 0)},
	["LA"] = {"Left Arm", CFrame.new(0, 0.5, 0), CFrame.new(-1.5, 0.5, 0), CFrame.new(-1.5, 0, 0)},
	["RL"] = {"Right Leg", CFrame.new(0, 0.5, 0), CFrame.new(0.5, -1.5, 0), CFrame.new(0.5, -2, 0)},
	["LL"] = {"Left Leg", CFrame.new(0, 0.5, 0), CFrame.new(-0.5, -1.5, 0), CFrame.new(-0.5, -2, 0)},
}

local collision_part = Instance.new("Part")
collision_part.Name = "CP"
collision_part.TopSurface = Enum.SurfaceType.Smooth
collision_part.BottomSurface = Enum.SurfaceType.Smooth
collision_part.Size = Vector3.new(1, 1.5, 1)
collision_part.Transparency = 1

local camera = workspace.CurrentCamera
local char = script.Parent


function RagdollV3(char)
	print("RagdollV3 Death!")
	char.Archivable = true
	local ragdoll = char:clone()
	char.Archivable = false

	local hdv = ragdoll:FindFirstChild("Head")

	--Clears the real character from everything but humanoid
	for _, obj in pairs(char:GetChildren()) do 
		if not obj:IsA("Humanoid") then
			obj:destroy()
		end
	end

	--set up the ragdoll
	local function scan(ch)
		for i = 1, #ch do
			scan(ch[i]:GetChildren())
			if (ch[i]:IsA("ForceField") or ch[i].Name == "HumanoidRootPart") or ((ch[i]:IsA("Weld") or ch[i]:IsA("Motor6D")) and ch[i].Name ~= "HeadWeld" and ch[i].Name ~= "AttachementWeld") then
				ch[i]:destroy()
			end
		end
	end
	scan(ragdoll:GetChildren())
	local function scanc(ch)
		for _, obj in pairs(ch:GetChildren()) do
			scanc(obj)
			if obj:IsA("Script") or obj:IsA("LocalScript") or ((obj:IsA("Weld") or obj:IsA("Motor6D")) and obj.Name ~= "AttachementWeld") or obj:IsA("ForceField") or (obj:IsA("Snap") and obj.Parent.Name == "Torso")
				or obj:IsA("ParticleEmitter")then
				obj:destroy()
			elseif obj:IsA("BasePart") then
				obj.Velocity = Vector3.new(0, 0, 0)
				obj.RotVelocity = Vector3.new(0, 0, 0)
				if obj.Parent:IsA("Accessory") then
					obj.CanCollide = false
				end
			end
		end
	end
	scanc(ragdoll)

	local f_head

	local fhum = ragdoll:FindFirstChild("Humanoid")
	fhum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	fhum.PlatformStand = true
	fhum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	fhum.Name = "RagdollHumanoid"

	local Torso = ragdoll:FindFirstChild("Torso")
	if Torso then
		Torso.Velocity = Vector3.new(math.random(), 0.0000001, math.random()).unit * 5 + (Vector3.new(0, 0.15, 0))
		local Head = ragdoll:FindFirstChild("Head")
		if Head then
			camera.CameraSubject = Head
			local Face = ragdoll:FindFirstChild("Face")
			local face = ragdoll:FindFirstChild("face")
			--local face_texture = "http://www.roblox.com/asset/?id=33328967"
			if Face then
				Head.Face.Texture = "http://www.roblox.com/asset/?id=33328967"
			elseif face then
				Head.face.Texture = "http://www.roblox.com/asset/?id=33328967"
			end
			CreateJoint("Weld", Torso, Head, CFrame.new(0, 1.5, 0))
		end

		for att_tag, att_data in pairs(AttactmentData) do
			local get_limb = ragdoll:FindFirstChild(att_data[1])
			if get_limb ~= nil then

				local att1 = Instance.new("Attachment")
				att1.Name = att_tag
				att1.CFrame = att_data[2]
				att1.Parent = get_limb

				local att2 = Instance.new("Attachment")
				att2.Name = att_tag
				att2.CFrame = att_data[3]
				att2.Parent = Torso

				local socket = Instance.new("BallSocketConstraint")
				socket.Name = att_tag .. "_SOCKET"
				socket.Attachment0 = att2
				socket.Attachment1 = att1
				socket.Radius = 0
				socket.Parent = Torso

				get_limb.CanCollide = false

				local cp = collision_part:Clone()
				local cp_weld = Instance.new("Weld")
				cp_weld.C0 = CFrame.new(0, -0.25, 0)
				cp_weld.Part0 = get_limb
				cp_weld.Part1 = cp
				cp_weld.Parent = cp
				cp.Parent = ragdoll
			end
		end
	end
	ragdoll.Parent = workspace
	game:GetService("Debris"):AddItem(ragdoll, cleanUpTime)
	fhum.MaxHealth = 100
	fhum.Health = fhum.MaxHealth
end
