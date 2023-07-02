require "gramutil"

AddPrefabPostInit("shovel", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("weakblunt")
    inst.components.combatalternateattack:SetDamage(24)
    inst:AddTag("weakblunt")
end
)

AddPrefabPostInit("goldenshovel", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("weakblunt")
    inst:AddTag("weakblunt")
end
)

AddPrefabPostInit("hambat", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("weakblunt")
    inst.components.combatalternateattack:SetDamage(76)
    inst:AddTag("weakblunt")
end
)