require "gramutil"

AddPrefabPostInit("hammer", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("strongblunt")
end
)