require "gramutil"


AddPrefabPostInit("axe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("axe_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("goldenaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("goldenaxe_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("moonglassaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("moonglassaxe_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst:AddTag("throwableaxe")
end
)

AddPrefabPostInit("lucy", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetProjectile("lucy_thrown")
    inst.components.combatalternateattack:SetWeaponType("throwableaxe")
    inst:AddTag("throwableaxe")
end
)