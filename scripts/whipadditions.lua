require "gramutil"

AddPrefabPostInit("whip", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("whip")
    inst:AddTag("whip")
end
)