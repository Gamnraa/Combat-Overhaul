local assets =
{
    Asset("ANIM", "anim/boomerang.zip")
}

local function makeprojectile(prefab, bank, build, damage)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("spin_loop", true)

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddTag("projectile")
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(30)
	inst.components.projectile:SetLaunchOffset({x=0, y=2})
	inst.components.projectile:SetHitDist(2)
    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(damage)

    return inst
end

return makeprojectile("axe_thrown", "boomerang", "boomerang", 10),
       makeprojectile("goldenaxe_thrown", "boomerang", "boomerang", 15),
       makeprojectile("moonglassaxe_thrown", "boomerang", "boomerang", 25),
       makeprojectile("lucy_thrown", "boomerang", "boomerang", 12)