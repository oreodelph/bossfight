
Parent = script.Parent
debounce = true

function onTouched(hit)
	    debounce = false
        Parent.Blood.Transparency = 0
        Parent.Stab.Playing = true
        Parent.CanCollide = false
        wait(5.5)
        Parent.CanCollide = true
        wait(35)
        Parent.Blood.Transparency = 1
        debounce = true
 end


script.Parent.Touched:connect(onTouched)
