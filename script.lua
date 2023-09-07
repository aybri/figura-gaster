vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
renderer:shadowRadius(0)

--"DEFAULT": normal status
--"DEATH": when dying, special animation
local status, last_status = "DEFAULT", "DEFAULT"

--texture setup
models.model.Head.Group.Head:setSecondaryTexture("custom", textures.head_eyes_e)
    :setSecondaryRenderType("NONE")
models.model.Head.Group.HeadLayer:setSecondaryTexture("custom", textures.head_eyes_e)
    :setSecondaryRenderType("NONE")

--handle funny spooky eyes
local eyesKey = keybinds:newKeybind("Toggle Eyes","key.keyboard.minus")

local isEyesEnabled = false

function pings.eyesToggle(isEyesEnabled)
    if isEyesEnabled then
        models.model.Head.Group.Head:setPrimaryTexture("custom", textures.head_eyes)
            :setSecondaryRenderType("EMISSIVE")
        models.model.Head.Group.HeadLayer:setPrimaryTexture("custom", textures.head_eyes)
            :setSecondaryRenderType("EMISSIVE")
        sounds:playSound("snd_mysterygo", player:getPos(), nil, nil, false)
    else
        models.model.Head.Group.Head:setPrimaryTexture("custom", textures.head)
            :setSecondaryRenderType("NONE")
        models.model.Head.Group.HeadLayer:setPrimaryTexture("custom", textures.head)
            :setSecondaryRenderType("NONE")
    end
end

function eyesKey.press()
    isEyesEnabled = not isEyesEnabled

    pings.eyesToggle(isEyesEnabled)

    if isEyesEnabled then
        log("Eyes On")
    else
        log("Eyes Off")
    end
end

--list of body parts
local parts = {
    {part = models.model.World.Body3, vector = vectors.vec(0,0,0), yaw = 0},
    {part = models.model.World.Body2, vector = vectors.vec(0,0,0), yaw = 0},
    {part = models.model.World.Body1, vector = vectors.vec(0,0,0), yaw = 0},
    {part = models.model.World.Body, vector = vectors.vec(0,0,0), yaw = 0},
}

--thanks katt for helping with rendering in GUIs
function events.render(delta, context)
    --handle status switching
    last_status = status

    if not player:isAlive() then status = "DEATH"
    else status = "DEFAULT" end

    if status == "DEFAULT" then
        if last_status ~= "DEFAULT" then
            --model type change
            models.model.Head:setParentType("HEAD")
                :setPos()
                :setRot()
                .Group:setParentType("NONE")
            models.model.LeftArm:setParentType("LEFT_ARM")
                :setPos()
                :setRot()
            models.model.RightArm:setParentType("RIGHT_ARM")
                :setPos()
                :setRot()

            if not isEyesEnabled then
                pings.eyesToggle(isEyesEnabled)
            end
        end

        --real stuff
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
    elseif status == "DEATH" then
        if last_status ~= "DEATH" then
            --model type change
            models.model.Head:setParentType("WORLD")
                :setPos(player:getPos(delta) * 16)
                :setRot(0, -player:getRot().y + 180, 0)
                .Group:setParentType("Camera")
            models.model.LeftArm:setParentType("WORLD")
                :setPos(player:getPos(delta) * 16)
                :setRot(0, -player:getBodyYaw(delta) + 180, 0)
            models.model.RightArm:setParentType("WORLD")
                :setPos(player:getPos(delta) * 16)
                :setRot(0, -player:getBodyYaw(delta) + 180, 0)

            pings.eyesToggle(true)
        end
    end
end
