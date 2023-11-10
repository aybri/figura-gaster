--set starting stuff
vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
renderer:shadowRadius(0)

--handle action wheel
local page = action_wheel:newPage("Main")
action_wheel:setPage(page)
page:setAction(-1, require("scripts.wheel.eyes"))
    :setAction(-1, require("scripts.wheel.hat"))
    :setAction(-1, require("scripts.wheel.sounds"))
    :setAction(-1, require("scripts.wheel.outline"))

--list of body parts
local parts = require("scripts.parts")

--thanks katt for helping with rendering in GUIs
function events.render(delta, context)
    if not player:isLoaded() then return end

    --real stuff
    local trigger = context == "FIGURA_GUI" or context == "PAPERDOLL" or context == "MINECRAFT_GUI" or player:isGliding() or player:isVisuallySwimming() or player:getGamemode() == "SPECTATOR" or player:isInvisible()

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
