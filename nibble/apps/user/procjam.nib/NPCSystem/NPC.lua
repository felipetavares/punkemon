
function NPC:new()
    local instance = {
		dworldPosition = { x = 0, y = 0}, -- Draw position for world sprite
		dtalkPosition =  { x = 0, y = 0}, -- Draw position for conversation sprite
		
		startText = {} -- The first text 
		currentText = {} -- The actual text
		textLine = 0 -- The actual text line
		
		emotions = {} -- Put all emotions sprite positions here
    }

    lang.instanceof(instance, NPC)

    return instance
end


function NPC:worldDraw()
	dprint('Opa coleguinha, precisa desenhar esse NPC maneiro aqui')
end


function NPC:conversationDraw()
	dprint('Opa coleguinha, precisa desenhar esse NPC falante e maneiro aqui')
end


return NPC
