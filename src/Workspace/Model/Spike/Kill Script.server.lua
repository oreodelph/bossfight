-- useless comment

function onTouched(hit)
	if not hit or not hit.Parent then return end
	local human = hit.Parent:findFirstChild("Humanoid")
	if human and human:IsA("Humanoid") then
		human:TakeDamage(1000)
	end
end

script.Parent.Touched:connect(onTouched)