require "gramutil"

AddPrefabPostInit("spear", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("thrust")
end
)