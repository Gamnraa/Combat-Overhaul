require "gramutil"

AddPrefabPostInit("nightsword", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("sword")
    inst:AddTag("sword")
end
)