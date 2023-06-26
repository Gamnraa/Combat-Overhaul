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
        inst.AnimState:PlayAnimation("dial_loop")
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
AddStategraphState("wilson", spear_charge_pre)

local spear_charge_loop = State({
    name = "spear_charge_loop",
    tags = {"attack", "busy", "temp_invincible", "autopredict"},

    onenter = function(inst, data)
        --inst.AnimState:PlayAnimation("lunge_loop") --NOTE: this anim NOT a loop yo
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
        inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_shadow_med_sharp")
        inst.Physics:ClearCollidesWith(GLOBAL.COLLISION.GIANTS)
       -- GLOBAL.ToggleOffCharacterCollisions(inst)

       inst.sg.statemem.hittargets = {}

        if data ~= nil then
            if data.target ~= nil and data.target:IsValid() then
                inst.sg.statemem.target = data.target
                inst:ForceFacePoint(data.target.Transform:GetWorldPosition())
            elseif data.targetpos ~= nil then
                inst:ForceFacePoint(data.targetpos)
            end
        end
        inst.Physics:SetMotorVelOverride(25, 0, 0)

        inst.sg:SetTimeout(12 * FRAMES)
    end,

    onupdate = function(inst)
        if inst.sg.statemem.attackdone then
            return
        end
        local target = inst.sg.statemem.target
        
        local pos = inst:GetPosition()
        local targets = GLOBAL.TheSim:FindEntities(pos.x, pos.y, pos.z, 1, {"_combat", "hostile"}, {"player", "companion"})
        local weapon = inst.components.combat:GetWeapon()
        for _, v in pairs(targets) do
            print(v)
            if not inst.sg.statemem.hittargets[v] then
                --inst.components.combat:DoAttack(v)
                weapon.components.combatalternateattack:OnAttack(inst, v)
                inst.sg.statemem.hittargets[v] = true
            end
        end
    end,

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                if inst.sg.statemem.attackdone or inst.sg.statemem.target == nil then
                    inst.sg.statemem.lunge = true
                    inst.sg:GoToState("lunge_pst", inst.sg.statemem.target)
                    return
                end
                inst.sg.statemem.animdone = true
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg.statemem.lunge = true
        inst.sg:GoToState("spear_charge_pst")
    end,

    onexit = function(inst)
        inst.components.combat:SetRange(2)
        if not inst.sg.statemem.lunge then
            inst.Physics:CollidesWith(GLOBAL.COLLISION.GIANTS)
          --triggered  GLOBAL.ToggleOnCharacterCollisions(inst)
        end
    end,
})
AddStategraphState("wilson", spear_charge_loop)

local spear_charge_pst = (State{
    name = "spear_charge_pst",
    tags = { "busy", "noattack", "temp_invincible"},

    onenter = function(inst, target)
        inst.AnimState:PlayAnimation("dial_loop")
        inst.Physics:SetMotorVelOverride(12, 0, 0)
        inst.sg.statemem.target = target
    end,

    onupdate = function(inst)
        inst.Physics:SetMotorVelOverride(inst.Physics:GetMotorVel() * .8, 0, 0)
    end,

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.Physics:CollidesWith(GLOBAL.COLLISION.GIANTS)
        --GLOBAL.ToggleOnCharacterCollisions(inst)
    end,
})
AddStategraphState("wilson", spear_charge_pst)