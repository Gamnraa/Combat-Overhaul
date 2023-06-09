require "gramutil.lua"

AddPrefabPostInit("axe", function(inst)
    inst:AddComponent("combatalternateattack")
    inst:AddTag("throwableaxe")
end
)