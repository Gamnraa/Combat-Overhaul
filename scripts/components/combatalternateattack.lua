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
        self.critchance = 5
        self.critmult = 2
    elseif weapontype == "thrust" then
        self.onattack = thrust_onattack
        self.damage = 16
        self.critchange = 20
        self.critmult = 1.25
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