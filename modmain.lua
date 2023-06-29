PrefabFiles = {
    "axeprojectile"
}


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

local function altattackactionhandler_server(inst, action)
    inst.sg.mem.localchainattack = not action.forced or nil
    local playercontroller = inst.components.playercontroller
    local attack_tag =
				playercontroller ~= nil and
				playercontroller.remote_authority and
				playercontroller.remote_predicting and
				"abouttoattack" or
				"attack"

    if not (inst.sg:HasStateTag(attack_tag) and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
        print("attack")
        return "attack"
    end
end

local function altattackactionhandler_client(inst, action)
    if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or GLOBAL.IsEntityDead(inst)) then
        return "attack"
    end
end

local THROW_AXE = AddAction("THROW_AXE", "Throw Axe", function(act)
    act.doer.components.talker:Say("Happy Labor Day!")
    act.invobject.components.combatalternateattack:ThrowWeapon(act.doer, act.target)
    return true
end
)
THROW_AXE.distance = 10
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.THROW_AXE, altattackactionhandler_server))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.THROW_AXE, altattackactionhandler_client))



local PIERCE = AddAction("PIERCE", "Piercing Attack", function(act)
    act.doer.components.talker:Say("Be mine!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.PIERCE, altattackactionhandler_server))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.PIERCE, altattackactionhandler_client))



local HEAVY_SWING = AddAction("HEAVY_SWING", "Heavy Swing", function(act)
    act.doer.components.talker:Say("Let's get into the swing of things!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.HEAVY_SWING, altattackactionhandler_server))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.HEAVY_SWING, altattackactionhandler_client))



local POWER_SWING = AddAction("POWER_SWING", "Power Swing", function(act)
    act.doer.components.talker:Say("It's all in the technique!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.POWER_SWING, altattackactionhandler_server))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.POWER_SWING, altattackactionhandler_client))



--NOTE: Might want to change this one to Point Action
local SPEAR_CHARGE = AddAction("SPEAR_CHARGE", "Spear Charge", function(act)
    act.invobject.components.combatalternateattack:OnAttack(act.doer, act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.SPEAR_CHARGE, "spear_charge_pre"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.SPEAR_CHARGE, "spear_charge_pre"))
SPEAR_CHARGE.distance = 5


local RAPID_SLASH = AddAction("RAPID_SLASH", "Rapid Slash", function(act)
    act.doer.components.talker:Say("A flurry of blows!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.RAPID_SLASH, altattackactionhandler_server))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.RAPID_SLASH, altattackactionhandler_client))



local POWER_WHIP = AddAction("POWER_WHIP", "Power Whip", function(act)
    act.doer.components.talker:Say("Let's whip you into shape!")
    act.doer.components.combat:DoAttack(act.target)
    return true
end
)
AddStategraphActionHandler("wilson",        ActionHandler(GLOBAL.ACTIONS.POWER_WHIP, altattackactionhandler_server))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.POWER_WHIP, altattackactionhandler_client))

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

ALT_ATTACKS = {
    ["throwableaxe"]    = GLOBAL.ACTIONS.THROW_AXE,
    ["piercing"]        = GLOBAL.ACTIONS.PIERCE,
    ["strongblunt"]     = GLOBAL.ACTIONS.HEAVY_SWING,
    ["weakblunt"]       = GLOBAL.ACTIONS.POWER_SWING,
    ["thrust"]          = GLOBAL.ACTIONS.SPEAR_CHARGE,
    ["sword"]           = GLOBAL.ACTIONS.RAPID_SLASH,
    ["whip"]            = GLOBAL.ACTIONS.POWER_WHIP
}

AddPlayerPostInit(function(inst)
    inst.altattack = GLOBAL.KEY_V
end
)

local altattackchanger = require "screens/alternateattackinputchanger"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
--local altattackchanger = require "screens/alternateattackinputchanger"
AddClassPostConstruct("widgets/statusdisplays", function(self)
    self.altattackbutton = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    self.altattackbutton:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)
    self.altattackbutton:SetHAnchor(GLOBAL.ANCHOR_LEFT)
    self.altattackbutton:SetScale(.667)
    self.altattackbutton:SetPosition(30, 55)
    self.altattackbutton:SetOnClick(function() GLOBAL.TheFrontEnd:PushScreen(altattackchanger(self.owner)) end)

    self.altattacksignifier = self:AddChild(Text(GLOBAL.DEFAULTFONT, 20, STRINGS.UI.CONTROLSSCREEN.INPUTS[1][self.owner.altattack]))
    self.altattacksignifier:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)
    self.altattacksignifier:SetHAnchor(GLOBAL.ANCHOR_LEFT)
    self.altattacksignifier:SetPosition(30, 20)

    self.owner:ListenForEvent("altattackinputchanged", function() self.altattacksignifier:SetString(STRINGS.UI.CONTROLSSCREEN.INPUTS[1][self.owner.altattack]) end)
end
)



function TryToPerformAltAttack(player, weapontype, range)
    local function IsTargetHostile(inst, target)
        if inst.HostileTest then return inst:HostileTest(target) end
        if target.HostileToPlayerTest then return target:HostileToPlayerTest(inst) end
        return target:HasTag("hostile")
    end
    
    local function CanAttack(inst, target)
        return IsTargetHostile(inst, target) and target.replica.combat and inst.replica.combat:CanTarget(target) and not inst.replica.combat:InCooldown()
    end

    local target = GLOBAL.FindEntity(player, range, function(target) return CanAttack(player, target) end, nil, {"wall"})
    if target then
        local act = GLOBAL.BufferedAction(player, target, ALT_ATTACKS[weapontype])
        player.components.playercontroller:DoAction(act)
    end
end

AddSimPostInit(function()
    local function IsTargetHostile(inst, target)
        if inst.HostileTest then return inst:HostileTest(target) end
        if target.HostileToPlayerTest then return target:HostileToPlayerTest(inst) end
        return target:HasTag("hostile")
    end
    
    local function CanAttack(inst, target)
        return IsTargetHostile(inst, target) and target.replica.combat and inst.replica.combat:CanTarget(target) and not inst.replica.combat:InCooldown()
    end

    TheInput:AddKeyHandler(function(key, down)
        local theplayer = GLOBAL.ThePlayer
        if down and theplayer.altattack == key then
            local weapon = theplayer.replica.combat:GetWeapon()
            if not weapon then return end
            if not weapon:HasTag("altattack") then return end

            local attack = ""
            if weapon:HasTag("throwableaxe") then
                attack = "throwableaxe"
            elseif weapon:HasTag("piercing") then
                attack = "piercing"
            elseif weapon:HasTag("strongblunt") then
                attack = "strongblunt"
            elseif weapon:HasTag("weakblunt") then
                attack = "weakblunt"
            elseif weapon:HasTag("thrust") then
                attack = "thrust"
            elseif weapon:HasTag("sword") then
                attack = "sword"
            elseif weapon:HasTag("whip") then
                attack = "whip"
            end

            local target = GLOBAL.FindEntity(theplayer, 12, function(target) return CanAttack(theplayer, target) end, nil, {"wall"})
            if target then
                local x, y, z = theplayer.Transform:GetWorldPosition()
                local test = theplayer.components.playercontroller
                
                local act = GLOBAL.BufferedAction(theplayer, target, ALT_ATTACKS[attack], weapon)
                --print(theplayer.components.playercontroller.actionbuttonoverride(target))
                GLOBAL.SendRPCToServer(GLOBAL.RPC.RightClick, act.action.code, x, z, target, 0, false, nil, nil, act.action.mod_name)
                
                theplayer.components.playercontroller:DoAction(act)
            end
        end
    end
    )
end
)