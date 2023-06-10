require "gramutil"

AddPrefabPostInit("whip", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("whip")
end
)