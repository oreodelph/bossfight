local damage = 5 
local slash_damage = 10 
local lunge_damage = 30 
sword = script.Parent.Handle 
Tool = script.Parent 
enabled = true 
connection = nil 

SlashSound = sword:findFirstChild("SlashSound") 
if SlashSound == nil then 
SlashSound = Instance.new("Sound") 
SlashSound.SoundId = "rbxasset://sounds\\swordslash.wav" 
SlashSound.Name = "SlashSound" 
SlashSound.Parent = sword 
SlashSound.Volume = 0
end 

UnsheathSound = sword:findFirstChild("UnsheathSound") 
if UnsheathSound == nil then 
UnsheathSound = Instance.new("Sound") 
UnsheathSound.SoundId = "rbxasset://sounds\\unsheath.wav" 
UnsheathSound.Name = "UnsheathSound" 
UnsheathSound.Parent = sword 
UnsheathSound.Volume = 0 
end 

function blow(hit) 
if game.Players:playerFromCharacter(hit.Parent) == nil then return end 
local humanoid = hit.Parent:findFirstChild("Humanoid") 
local vCharacter = Tool.Parent 
local vPlayer = game.Players:playerFromCharacter(vCharacter) 
local hum = vCharacter:findFirstChild("Humanoid") 
if humanoid~=nil and humanoid ~= hum and hum ~= nil then 
local right_arm = vCharacter:FindFirstChild("Right Arm") 
if (right_arm ~= nil) then 
local joint = right_arm:FindFirstChild("RightGrip") 
if (joint ~= nil and (joint.Part0 == sword or joint.Part1 == sword)) then 
tagHumanoid(humanoid, vPlayer) 
humanoid:TakeDamage(damage) 
wait(1) 
untagHumanoid(humanoid) 
end 
end 
end 
end 

function tagHumanoid(humanoid, player) 
local creator_tag = Instance.new("ObjectValue") 
creator_tag.Value = player 
creator_tag.Name = "creator" 
creator_tag.Parent = humanoid 
end 

function untagHumanoid(humanoid) 
if humanoid ~= nil then 
local tag = humanoid:findFirstChild("creator") 
if tag ~= nil then 
tag.Parent = nil 
end 
end 
end 

function attack() 
damage = slash_damage 
SlashSound:play() 
local anim = Instance.new("StringValue") 
anim.Name = "toolanim" 
anim.Value = "Slash" 
anim.Parent = Tool 
end 

script.Parent.Activated:connect(function() 
if enabled == false then 
return 
end 
enabled = false 
local character = Tool.Parent 
local humanoid = character.Humanoid 
if humanoid == nil then return end 
attack() 
wait(0.6) 
enabled = true 
end) 

script.Parent.Equipped:connect(function() 
UnsheathSound:play() 
connection = sword.Touched:connect(blow) 
end) 

script.Parent.Unequipped:connect(function() 
if connection ~= nil then 
connection:disconnect() 
end 
end) 
