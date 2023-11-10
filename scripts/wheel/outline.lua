local action = action_wheel:newAction()
    :setTitle("Outline Disabled")
    :setTexture(textures["textures.toggles"], 15*6, 0, 15, 16)
    :setToggleTitle("Outline Enabled")
    :setToggleTexture(textures["textures.toggles"], 15*7, 0, 15, 16)

local outlineList = {
    models.model.Head.Outline,
    models.model.Head.Hat.Outline,
    models.model.Head.Hat.Outline1,
    models.model.World.Body.Outline,
    models.model.World.Body1.Outline,
    models.model.World.Body2.Outline,
    models.model.World.Body3.Outline,
    models.model.LeftArm.Outline,
    models.model.RightArm.Outline
}

for _, part in ipairs(outlineList) do
    part:setPrimaryRenderType("TRANSLUCENT_CULL")
end

function pings.outlineToggle(isOutlineEnabled)
    for _, part in ipairs(outlineList) do
        part:setVisible(isOutlineEnabled)
    end
end

local startup = true

action:setOnToggle(function(state, action)
    config:save("OUTLINE", state)

    pings.outlineToggle(state)

    if not startup then
        if state then
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Outline Enabled"}]')
        else
            printJson('["",{"text":"[GASTER] ","color":"#666666"},{"text":"Outline Disabled"}]')
        end
    end
end)

action.toggle(config:load("OUTLINE"), action)
action:setToggled(config:load("OUTLINE"))

local startup = nil

local counter = 0
function events.TICK()
    counter = counter + 1
    if counter >= 600 then
        pings.outlineToggle(config:load("OUTLINE"))
        counter = 0
    end
end

return action