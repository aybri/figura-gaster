vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
renderer:shadowRadius(0)

--texture setup
models.model.Head.Head:setSecondaryTexture("custom", textures.head_eyes_e)
    :setSecondaryRenderType("NONE")
models.model.Head.HeadLayer:setSecondaryTexture("custom", textures.head_eyes_e)
    :setSecondaryRenderType("NONE")


--list of body parts
local parts = {
    {part = models.model.World.Body3, vector = vectors.vec(0,0,0), yaw = 0},
    {part = models.model.World.Body2, vector = vectors.vec(0,0,0), yaw = 0},
    {part = models.model.World.Body1, vector = vectors.vec(0,0,0), yaw = 0},
    {part = models.model.World.Body, vector = vectors.vec(0,0,0), yaw = 0},
}

--thanks katt for helping with rendering in GUIs
function events.render(delta, context)
    local trigger = context == "FIGURA_GUI" or context == "PAPERDOLL" or context == "MINECRAFT_GUI" or player:isGliding() or player:isVisuallySwimming()

    for index, part in ipairs(parts) do
        if parts[index + 1] then
            part.vector = parts[index + 1].vector
            part.yaw = parts[index + 1].yaw
        else
            part.vector = player:getPos(delta) * 16
            part.yaw = player:getRot().y
        end
        if trigger then
          part.part:setPos():setRot()
        else
          part.part:setPos(part.vector):setRot(0, -part.yaw + 180, 0)
        end
    end
    if context == "FIRST_PERSON" then
      models.model.World:setVisible(false)
    elseif trigger then
      models.model.World:setParentType("NONE"):setVisible(true)
    else
      models.model.World:setParentType("WORLD"):setVisible(true)
    end
end

--handle funny spooky eyes
local eyesKey = keybinds:newKeybind("Toggle Eyes","key.keyboard.minus")

local isEyesEnabled = false

function pings.keyToggle()
    isEyesEnabled = not isEyesEnabled

    if isEyesEnabled then
        models.model.Head.Head:setPrimaryTexture("custom", textures.head_eyes)
            :setSecondaryRenderType("EMISSIVE")
        models.model.Head.HeadLayer:setPrimaryTexture("custom", textures.head_eyes)
            :setSecondaryRenderType("EMISSIVE")
        sounds:playSound("snd_mysterygo", player:getPos(), nil, nil, false)

        log("Toggled Eyes On")
    else
        models.model.Head.Head:setPrimaryTexture("custom", textures.head)
            :setSecondaryRenderType("NONE")
        models.model.Head.HeadLayer:setPrimaryTexture("custom", textures.head)
            :setSecondaryRenderType("NONE")

        log("Toggled Eyes Off")
    end
end

eyesKey.press = pings.keyToggle
