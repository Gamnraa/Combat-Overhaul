require "gramutil"

AddPrefabPostInit("spear", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("spear_wathrithr", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("fence_rotator", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("pitchfork", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("thrust")
end
)

AddPrefabPostInit("goldenpitchfork", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("thrust")
end
)