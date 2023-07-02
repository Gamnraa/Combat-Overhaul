local function applycomponentdatatoinst(altattack, inst)
    inst.damage = altattack.damage
    inst.flatdamage = altattack.flatdamage
    inst.critchance = altattack.critchance
    inst.critmult = altattack.critmult
    inst.onattack = altattack.onattack
end

local function thrownaxe_onattack(inst, attacker, target, critmult)
    local axe = SpawnSaveRecord(inst.oldprefab)
    local x, y, z = inst.Transform:GetWorldPosition()
    axe.Transform:SetPosition(x, 1, z)
    local altattack = axe.components.combatalternateattack

    target.components.combat:GetAttacked(attacker, altattack.damage * critmult, axe)
    if axe.components.finiteuses then axe.components.finiteuses:Use(3) end

    inst:Remove()
end

local function thrust_onattack(inst, attacker, target, critmult)
    local altattack = inst.components.combatalternateattack
    target.components.combat:GetAttacked(attacker, altattack.damage * critmult, inst)

    if inst.components.finiteuses then inst.components.finiteuses:Use(2) end
end

local function strongblunt_onattack(inst, attacker, target, critmult)
    local altattack = inst.components.combatalternateattack
    --Bad at geometry bear with me
    --We want to get all entities in an arc in x degress left from our target, right from our target
    --Our radius is just the distance between us and our target
    --So, get the angle the player is facing, then offset that angle by x in both directions
    local hittargets = {}
    local arc = 20
    local x, y, z = attacker.Transform:GetWorldPosition()
    local angle = attacker.Transform:GetRotation() + 180
    local radius = 1
    print(angle)

    for i = angle, angle + arc, 1 do
        print(i)
        local offset_x = x + radius * math.cos(i * DEGREES)
        local offset_z = z + radius * math.sin(i * DEGREES)


        local ents = TheSim:FindEntities(offset_x, 0, offset_z, 1.25, {"_combat"}, {"companion"})
        for _, v in pairs(ents) do
            if not (hittargets[v] or v == attacker) then
                v.components.combat:GetAttacked(attacker, altattack.damage * critmult, inst)
                if not v:HasTag("player") then v:PushEvent("gramknockback", {knocker = attacker, radius = 1.7, strength = GRAM_KNOCKBACK_WEIGHTS[target.prefab] or 1.5})
                else v:PushEvent("knockback", {knocker = attacker, radius = 1.7, strength = 1.25}) end
                hittargets[v] = true
            end
        end
    end

    for i = angle, angle - arc, -1 do
        local offset_z = z + radius * math.cos(i * DEGREES)
        local offset_x = x + radius * math.sin(i * DEGREES)

        local ents = TheSim:FindEntities(offset_x, 0, offset_z, 1.25, {"_combat",}, {"companion"})
        for _, v in pairs(ents) do
            if not (hittargets[v] or v == attacker) then
                v.components.combat:GetAttacked(attacker, altattack.damage * critmult, inst)
                if not v:HasTag("player") then v:PushEvent("gramknockback", {knocker = attacker, radius = 1.7, strength = GRAM_KNOCKBACK_WEIGHTS[target.prefab] or 1.5})
                else v:PushEvent("knockback", {knocker = attacker, radius = 1.7, strength = 1.25}) end
                hittargets[v] = true
            end
        end
    end
end

local function weakblunt_onattack(inst, attacker, target, critmult)
    local altattack = inst.components.combatalternateattack
    target.components.combat:GetAttacked(attacker, altattack.damage * critmult, inst)
    if not target:HasTag("player") then target:PushEvent("gramknockback", {knocker = attacker, radius = 1.7, strength = GRAM_KNOCKBACK_WEIGHTS[target.prefab] or 1.5})
    else target:PushEvent("knockback", {knocker = attacker, radius = 1.7, strength = 1.25}) end
end


local CombatAlternateAttack = Class(function(self, inst)
    self.inst = inst
    self.inst:AddTag("altattack")
    self.damage = 0
    self.flatdamage = 0
    self.critchance = 10
    self.critmult = 1.5
    self.projectile = nil
    self.onattack = nil
 end,
 nil
)

function CombatAlternateAttack:SetWeaponType(weapontype)
    if weapontype == "throwableaxe" then
        self.onattack = thrownaxe_onattack
        self.projectile = "axe_thrown"
        self.damage = 10
        self.critchance = 10
        self.critmult = 2
    elseif weapontype == "thrust" then
        self.onattack = thrust_onattack
        self.damage = 16
        self.critchange = 20
        self.critmult = 1.25
    elseif weapontype == "strongblunt" then
        self.onattack = strongblunt_onattack
        self.damage = 45
        self.critchance = 5
        self.critmult = 2
    elseif weapontype == "weakblunt" then
        self.onattack = weakblunt_onattack
        self.damage = 30
        self.critchance = 15
        self.critmult = 1.34
    end
end

function CombatAlternateAttack:SetDamage(damage)
    self.damage = damage
end

function CombatAlternateAttack:SetFlatDamage(damage)
    self.flatdamage = damage
end

function CombatAlternateAttack:SetCritChance(percentchance)
    self.critchance = percentchance
end

function CombatAlternateAttack:SetCritMultiplier(multiplier)
    self.critmult = multiplier
end

function CombatAlternateAttack:SetProjectile(projectile)
    self.projectile = projectile
end

function CombatAlternateAttack:SetOnAttack(fn)
    self.onattack = fn
end

function CombatAlternateAttack:OnAttack(attacker, target)
    local critmult = math.random(100) <= self.critchance and self.critmult or 1

    if self.onattack then
        --For projectiles, self.inst is actually self because of how we handle them
        self.onattack(self.inst or self, attacker, target, critmult)
    end

    if target.components.heatlh and not target.components.heatlh:IsDead() then
        target.components.heatlh:DoDelta(-self.flatdamage)
    end
end

function CombatAlternateAttack:ThrowWeapon(attacker, target)
    local projectile = SpawnPrefab(self.projectile or "axe_thrown")
    projectile.oldprefab = self.inst:GetSaveRecord()
    projectile.Transform:SetPosition(attacker.Transform:GetWorldPosition())

    projectile.components.projectile.onhit = self.OnAttack
    --Remember, we're using the projectile, not combatalternateattack for this
    applycomponentdatatoinst(self, projectile)
    projectile.components.projectile:Throw(attacker, target, attacker)

    self.inst:Remove()
end

return CombatAlternateAttack