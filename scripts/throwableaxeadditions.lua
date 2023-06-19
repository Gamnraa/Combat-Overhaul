require "gramutil"

local function thrownaxe_onattack(inst, attacker, target)
    local axe = GLOBAL.SpawnSaveRecord(inst.oldprefab)
    axe.Transform:SetPostion(inst:GetPosition():Get())

    target.components.combat:GetAttack(attacker, inst.components.weapon:GetDamage(attacker, target), axe)
    if axe.components.finiteuses then axe.components.finiteuses:Use(3) end

    inst:Remove()
end


AddPrefabPostInit("axe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("axe_thrown")
    inst.components.combatalternateattack:SetOnAttack(thrownaxe_onattack)
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("goldenaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("goldenaxe_thrown")
    inst.components.combatalternateattack:SetOnAttack(thrownaxe_onattack)
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("moonglassaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("moonglassaxe_thrown")
    inst.components.combatalternateattack:SetOnAttack(thrownaxe_onattack)
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("lucy", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("lucy_thrown")
    inst.components.combatalternateattack:SetOnAttack(thrownaxe_onattack)
    inst:AddTag("throwableaxe")
end
)