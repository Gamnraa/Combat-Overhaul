local assets =
{
    Asset("ANIM", "anim/boomerang.zip")
}

local function makeprojectile(name, bank, build)
    local function fn()
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
        --inst.components.projectile:SetLaunchOffset({x=0, y=2})
        inst.components.projectile:SetHitDist(2)
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)

        return inst
    end
    return Prefab(name, fn, assets)
end

return makeprojectile("axe_thrown", "boomerang", "boomerang"),
       makeprojectile("goldenaxe_thrown", "boomerang", "boomerang"),
       makeprojectile("moonglassaxe_thrown", "boomerang", "boomerang"),
       makeprojectile("lucy_thrown", "boomerang", "boomerang")