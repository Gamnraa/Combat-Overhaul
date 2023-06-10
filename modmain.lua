modimport "scripts/throwableaxeadditions"
modimport "scripts/piercingadditions"
modimport "scripts/strongbluntadditions"
modimport "scripts/weakadditions"
modimport "scripts/thrustadditions"
modimport "scripts/swordadditions"
modimport "scripts/whipadditions"

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

local HEAVY_SWING = AddAction("HEAVY_SWING", "Heavy Swing", function(act)
    act.doer.componets.talker:Say("Let's get into the swing of things!")
end
)

local POWER_SWING = AddAction("POWER_SWING", "Power Swing", function(act)
    act.doer.components.talker:Say("It's all in the technique!")
end
)
--NOTE: Might want to change this one to Point Action
local SPEAR_CHARGE = AddAction("SPEAR_CHARGE", "Spear Charge", function(act)
    act.doer.componets.talker:Say("Chaaaarge!!")
end
)

local RAPID_SLASH = AddAction("RAPID_SLASH", "Rapid Slash", function(act)
    act.doer.components.talker:Say("A flurry of blows!")
end
)

local POWER_WHIP = AddAction("POWER_WHIP", "Throw Axe", function(act)
    act.doer.componets.talker:Say("Let's whip you into shap!")
end
)

local function candoaltattack(inst, doer, target, actions, right)
    if right and doer.replica.combat and doer.replica.combat:CanTarget(target) and target.replica.combat:CanBeAttacked() then
        if inst:HasTag("throwableaxe") then
            table.insert(actions, GLOBAL.ACTIONS.THROW_AXE)
        elseif inst:HasTag("piercing") then
            table.insert(actions, GLOBAL.ACTIONS.PIERCE)
        elseif inst:HasTag("strongblunt") then
            table.insert(actions, GLOBAL.ACTIONS.HEAVY_SWING)
        elseif inst:HasTag("weakblunt") then
            table.insert(actions, GLOBAL.ACTIONS.POWER_SWING)
        elseif inst:HasTag("thrust") then
            table.insert(actions, GLOBAL.ACTIONS.SPEAR_CHARGE)
        elseif inst:HasTag("sword") then
            table.insert(actions, GLOBAL.ACTIONS.RAPID_SLASH)
        elseif inst:HasTag("whip") then
            table.insert(actions, GLOBAL.ACTIONS.POWER_WHIP)
        end
    end
end

AddComponentAction("EQUIPPED", "combatalternateattack", candoaltattack)