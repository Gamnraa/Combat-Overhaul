require "gramutil"

AddPrefabPostInit("shovel", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("weakblunt")
end
)