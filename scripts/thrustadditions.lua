require "gramutil"
local State = GLOBAL.State
local FRAMES = GLOBAL.FRAMES
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
require "stategraphs/commonstates"
local CommonHandlers = GLOBAL.CommonHandlers

AddPrefabPostInit("spear", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("thrust")
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("spear_wathrithr", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("thrust")
    inst.components.combatalternateattack:SetDamage(22)
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("fence_rotator", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("thrust")
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("pitchfork", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("thrust")
    inst.components.combatalternateattack:SetDamage(10)
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("goldenpitchfork", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("thrust")
    inst.components.combatalternateattack:SetDamage(14)
    inst:AddTag("thrust")
end
)

local spear_charge_pre = State({
    --Basing this off of Shadow Duelist's lunge attack
    name = "spear_charge_pre",
    tags = {"attack, busy, autopredict"},

    onenter = function(inst, target)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("attack_pre")
        inst.components.combat:StartAttack()

        if not target then target = inst.components.combat.target end

        if target and target:IsValid() then
            inst.sg.statemem.target = target
			inst.sg.statemem.targetpos = target:GetPosition()
			inst:ForceFacePoint(inst.sg.statemem.targetpos:Get())
        else
            target = nil
        end
    end,

    onupdate = function(inst)
        if inst.sg.statemem.target ~= nil then
            if inst.sg.statemem.target:IsValid() then
                inst.sg.statemem.targetpos = inst.sg.statemem.target:GetPosition()
            else
                inst.sg.statemem.target = nil
            end
        end
    end,

    events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg.statemem.lunge = true
					inst.sg:GoToState("spear_charge_loop", { target = inst.sg.statemem.target, targetpos = inst.sg.statemem.targetpos })
				end
			end),
		},

     onexit = function(inst)
		if not inst.sg.statemem.lunge then
			inst.components.combat:CancelAttack()
		end
	end,
})

local spear_charge_loop = State({
    name = "spear_charge_loop",
    tags = {"attack", "busy", "temp_invincible", "autopredict"},
})