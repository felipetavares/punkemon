function Text:new ()
	local instance = {
		text = ''
		emotion = { x = 0, y = 0, h = 0, w = 0}
		}
	}
	
	lang.instanceof(instance, Text)
end