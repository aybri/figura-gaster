local action = action_wheel:newAction()
    :setTitle("Hat Disabled")
    :setTexture(textures["textures.toggles"], 30, 0, 15, 16)
    :setToggleTitle("Hat Enabled")
    :setToggleTexture(textures["textures.toggles"], 45, 0, 15, 16)

function pings.hatToggle(isHatEnabled)
    models.model.Head.Hat:setVisible(isHatEnabled)
end

local startup = true

action:setOnToggle(function(state, action)
    config:save("HAT", state)

    pings.hatToggle(state)

    if not startup then
        if state then
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Hat Enabled"}]')
        else
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Hat Disabled"}]')
        end
    end
end)

action.toggle(config:load("HAT"), action)
action:setToggled(config:load("HAT"))

local startup = nil

local counter = 0
function events.TICK()
    counter = counter + 1
    if counter >= 600 then
        pings.hatToggle(config:load("HAT"))
        counter = 0
    end
end

return action