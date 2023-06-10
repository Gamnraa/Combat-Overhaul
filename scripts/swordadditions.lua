require "gramutil"

AddPrefabPostInit("nightsword", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("sword")
end
)