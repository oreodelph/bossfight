wait()
h = script.Parent:findFirstChild("Humanoid")
if h ~= nil then
	while h:findFirstChild("creator") do
		h.creator:Destroy()
	end
	tag = script.creator:clone()
	tag.Parent = h
	game.Debris:AddItem(tag,5)
	h:TakeDamage(script.Damage.Value)
end
script:remove()