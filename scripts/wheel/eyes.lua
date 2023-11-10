local action = action_wheel:newAction()
    :setTitle("Sleeping")
    :setTexture(textures["textures.toggles"], 0, 0, 15, 16)
    :setToggleTitle("Awake")
    :setToggleTexture(textures["textures.toggles"], 15, 0, 15, 16)

models.model.Head.Head:setSecondaryTexture("custom", textures["textures.head_eyes"])

function pings.eyesToggle(isEyesEnabled, playAudio)
    if isEyesEnabled then
        models.model.Head.Head:setPrimaryTexture("custom", textures["textures.head_eyes"])
            :setSecondaryRenderType("EMISSIVE")
        models.model.Head.HeadLayer:setPrimaryTexture("custom", textures["textures.head_eyes"])
        if playAudio then
            sounds:playSound("sounds.snd_mysterygo", player:getPos(), nil, nil, false)
        end
    else
        models.model.Head.Head:setPrimaryTexture("custom", textures["textures.head"])
            :setSecondaryRenderType("NONE")
        models.model.Head.HeadLayer:setPrimaryTexture("custom", textures["textures.head"])
    end
end

local startup = true

action:setOnToggle(function(state, action)
    config:save("EYES", state)

    local sounds
    if startup then sounds = false
    else sounds = config:load("SOUNDS")
    end

    pings.eyesToggle(state, config:load("SOUNDS"))

    if not startup then
        if state then
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Set To \\"Awake Face\\""}]')
        else
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Set To \\"Sleeping Face\\""}]')
        end
    end
end)

action.toggle(config:load("EYES"), action)
action:setToggled(config:load("EYES"))

local startup = nil

local counter = 0
function events.TICK()
    counter = counter + 1
    if counter >= 600 then
        pings.eyesToggle(config:load("EYES"), false)
        counter = 0
    end
end

return action