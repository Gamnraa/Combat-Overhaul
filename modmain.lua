modimport "scripts/throwableaxeadditions"
modimport "scripts/piercingadditions"

local State = GLOBAL.State
local FRAMES = GLOBAL.FRAMES
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
require "stategraphs/commonstates"
local CommonHandlers = GLOBAL.CommonHandlers
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING
local ActionHandler = GLOBAL.ActionHandler

local THROW_AXE = AddAction("THROW_AXE", "Throw Axe", function(act)
    act.doer.componets.talker:Say("Happy Labor Day!")
end
)

local PIERCE = AddAction("PIERCE", "Piercing Attack", function(act)
    act.doer.components.talker:Say("Be mine!")
end
)
local function candoaltattack(inst, doer, target, actions, right)
    if right and doer.replica.combat and doer.replica.combat:CanTarget(target) and target.replica.combat:CanBeAttacked() then
        if inst:HasTag("throwableaxe") then
            table.insert(actions, GLOBAL.ACTIONS.THROW_AXE)
        elseif inst:HasTag("piercing") then
            table.insert(actions, GLOBAL.ACTIONS.PIERCE)
        end
    end
end

AddComponentAction("EQUIPPED", "combatalternateattack", candoaltattack)