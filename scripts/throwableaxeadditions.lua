require "gramutil"
local State = GLOBAL.State
local FRAMES = GLOBAL.FRAMES
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
require "stategraphs/commonstates"
local CommonHandlers = GLOBAL.CommonHandlers

AddPrefabPostInit("axe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("axe_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst.components.combatalternateattack:SetDamage(10)
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("goldenaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("goldenaxe_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst.components.combatalternateattack:SetDamage(15)
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("moonglassaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("moonglassaxe_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst.components.combatalternateattack:SetDamage(25)
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("lucy", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("lucy_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst.components.combatalternateattack:SetDamage(12)
    inst:AddTag("throwableaxe")
end
)

local throw_axe = State({
    name = "throw_axe",
    tags = {"attack", "notalking", "abouttoattack", "autopredict"},
    
    onenter = function(inst)
        if inst.components.combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil

        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("axe_throw") 

        inst.sg:SetTimeout(math.max(28 * FRAMES, inst.components.combat.min_attack_period))
        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
            inst.sg.statemem.retarget = target
        end

    end,

    timeline = 
    {
        TimeEvent(18 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end),

        TimeEvent(19 * FRAMES, function(inst)
            if inst:PerformBufferedAction() then
                inst.sg.statemem.thrown = true
            end
            inst.sg:RemoveStateTag("abouttoattack")
            inst.AnimState:ClearOverrideSymbol("swap_object")
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")
        end),

        TimeEvent(28 * FRAMES, function(inst)
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end)
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events = 
    {
        --EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        --EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
    end,
})
AddStategraphState("wilson", throw_axe)


local throw_axe_client = State({
    name = "throw_axe",
    tags = { "attack", "notalking", "abouttoattack" },

    onenter = function(inst)
        local combat = inst.replica.combat
        if combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end

        combat:StartAttack()
        inst.sg:SetTimeout(math.max(28 * FRAMES, inst.components.combat.min_attack_period))
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("axe_throw")

        local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                    inst.sg.statemem.retarget = buffaction.target
                end
            end
        end,

    timeline =
    {
        TimeEvent(19 * FRAMES, function(inst)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
            inst.AnimState:ClearOverrideSymbol("swap_object")
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")
        end),

        TimeEvent(28 * FRAMES, function(inst)
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end)
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
		EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
		if inst.sg:HasStateTag("abouttoattack") then
            inst.replica.combat:CancelAttack()
        end
    end,
})

AddStategraphState("wilson_client", throw_axe_client)