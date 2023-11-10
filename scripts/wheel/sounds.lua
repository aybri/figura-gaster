local action = action_wheel:newAction()
    :setTitle("Sounds Disabled")
    :setTexture(textures["textures.toggles"], 15*4, 0, 15, 16)
    :setToggleTitle("Sounds Enabled (OTHERS CAN HEAR)")
    :setToggleTexture(textures["textures.toggles"], 15*5, 0, 15, 16)

local startup = true

action:setOnToggle(function(state, action)
    config:save("SOUNDS", state)

    if not startup then
        if state then
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Sounds Enabled"}]')
        else
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Sounds Disabled"}]')
        end
    end
end)

action.toggle(config:load("SOUNDS"), action)
action:setToggled(config:load("SOUNDS"))

local startup = nil

return action