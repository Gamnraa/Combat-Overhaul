modimport "scripts/throwableaxeadditions"
modimport "scripts/piercingadditions"
modimport "scripts/strongbluntadditions"
modimport "scripts/weakbluntadditions"
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
local TheInput = GLOBAL.TheInput
local TheFrontEnd = GLOBAL.TheFrontEnd
local ThePlayer = GLOBAL.ThePlayer
local TheWorld = GLOBAL.TheWorld

local THROW_AXE = AddAction("THROW_AXE", "Throw Axe", function(act)
    act.doer.components.talker:Say("Happy Labor Day!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.THROW_AXE, "attack"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.THROW_AXE, "attack"))



local PIERCE = AddAction("PIERCE", "Piercing Attack", function(act)
    act.doer.components.talker:Say("Be mine!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.PIERCE, "attack"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.PIERCE, "attack"))



local HEAVY_SWING = AddAction("HEAVY_SWING", "Heavy Swing", function(act)
    act.doer.componets.talker:Say("Let's get into the swing of things!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.HEAVY_SWING, "attack"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.HEAVY_SWING, "attack"))



local POWER_SWING = AddAction("POWER_SWING", "Power Swing", function(act)
    act.doer.components.talker:Say("It's all in the technique!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.POWER_SWING, "attack"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.POWER_SWING, "attack"))



--NOTE: Might want to change this one to Point Action
local SPEAR_CHARGE = AddAction("SPEAR_CHARGE", "Spear Charge", function(act)
    act.doer.componets.talker:Say("Chaaaarge!!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.SPEAR_CHARGE, "attack"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.SPEAR_CHARGE, "attack"))



local RAPID_SLASH = AddAction("RAPID_SLASH", "Rapid Slash", function(act)
    act.doer.components.talker:Say("A flurry of blows!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.RAPID_SLASH, "attack"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.RAPID_SLASH, "attack"))



local POWER_WHIP = AddAction("POWER_WHIP", "Power Whip", function(act)
    act.doer.componets.talker:Say("Let's whip you into shape!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.POWER_WHIP, "attack"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.POWER_WHIP, "attack"))

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

AddPlayerPostInit(function(inst)
    inst.altattack = GLOBAL.KEY_V
end
)

local altattackchanger = require "screens/alternateattackinputchanger"
local ImageButton = require "widgets/imagebutton"
--local altattackchanger = require "screens/alternateattackinputchanger"
AddClassPostConstruct("widgets/statusdisplays", function(self)
    self.altattackbutton = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    self.altattackbutton:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)
    self.altattackbutton:SetHAnchor(GLOBAL.ANCHOR_LEFT)
    self.altattackbutton:SetOnClick(function() GLOBAL.TheFrontEnd:PushScreen(altattackchanger(self.owner)) end)
end
)

AddSimPostInit(function()
    TheInput:AddKeyHandler(function(key, down)
        if down and GLOBAL.ThePlayer.altattack == key then
            print("Player alternate attack")
            if GLOBAL.TheWorld.ismastersim then
                GLOBAL.BufferedAction(GLOBAL.ThePlayer, GLOBAL.ThePlayer, GLOBAL.ACTIONS.THROW_AXE):Do()
            else
                --SendModRPCToServer
            end
        end
    end
    )
end
)