Text = require("Text")
Condition = require("TextCondition");

function ConversationText:new()
    local instance = {
		textLines = {}, 	-- A vector with all the Text'1
		transitions = {} 	-- Each transition will hold the next text block and the condition to go that
    }
    lang.instanceof(instance, Character)

    return instance
end


function ConversationText:conversationDraw()
	dprint('Opa coleguinha, precisa desenhar esse texto empolgante e maneiro aqui')
end


return ConversationText
