--https://www.youtube.com/watch?time_continue=9&v=a1eZ9gTm32M&feature=emb_logo
--https://www.roblox.com/library/3031470191/Punch-Animation
local player = game.Players.LocalPlayer
local db = true
local damaged = false

local anim = Instance.new("Animation")
anim.AnimationId = "http://www.roblox.com/asset?id=5705413709"

game.Players.LocalPlayer.Character:WaitForChild("RightHand").Touched:Connect(function(hit)
	if hit.Parent:FindFirstChild("Humanoid") and not db and not damaged and hit.Parent.Humanoid ~= game.Players.LocalPlayer.Character.Humanoid then
		if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
			damaged = true
			game.ReplicatedStorage.Punch:FireServer(hit.Parent.Humanoid)
		end
	end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, event)
	if input.KeyCode == Enum.KeyCode.F and db then
		db = false
		local playAnim = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(anim)
		playAnim:Play()
		wait(0.8)
		damaged = false
		db = true
	end
end)