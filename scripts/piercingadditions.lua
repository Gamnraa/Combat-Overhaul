require "gramutil"

AddPrefabPostInit("pickaxe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("piercing")
end
)