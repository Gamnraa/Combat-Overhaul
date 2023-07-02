require "gramutil"

AddPrefabPostInit("hammer", function(inst)
    inst:AddComponent("combatalternateattack")
    inst.components.combatalternateattack:SetWeaponType("strongblunt")
    inst:AddTag("strongblunt")
end
)