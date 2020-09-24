function onPlayerEntered(player)
	repeat wait () until player.Character ~= nil
	local s = script.SprintScript:clone()
	s.Parent = player.Character
	s.Disabled = false
	player.CharacterAdded:connect(function (char)
		local s = script.SprintScript:clone()
		s.Parent = char
		s.Disabled = false		
	end)
end

game.Players.PlayerAdded:connect(onPlayerEntered)