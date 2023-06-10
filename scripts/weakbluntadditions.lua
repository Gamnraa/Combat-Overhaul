require "gramutil"

AddPrefabPostInit("shovel", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("weakblunt")
end
)

AddPrefabPostInit("goldenshovel", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("weakblunt")
end
)

AddPrefabPostInit("hambat", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("weakblunt")
end
)