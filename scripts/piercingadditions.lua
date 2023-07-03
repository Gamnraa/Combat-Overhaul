require "gramutil"

AddPrefabPostInit("pickaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("piercing")
    inst:AddTag("piercing")
end
)

AddPrefabPostInit("goldenpickaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("piercing")
    inst.components.combatalternateattack:SetDamage(27)
    inst:AddTag("piercing")
end
)