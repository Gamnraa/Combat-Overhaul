local function thrownaxe_onattack(inst, attacker, target, critmult)
    local axe = SpawnSaveRecord(inst.oldprefab)
    local x, y, z = inst.Transform:GetWorldPosition()
    axe.Transform:SetPosition(x, 1, z)
    local altattack = axe.components.combatalternateattack

    target.components.combat:GetAttacked(attacker, altattack.damage * critmult, axe)
    if axe.components.finiteuses then axe.components.finiteuses:Use(3) end

    inst:Remove()
end

local CombatAlternateAttack = Class(function(self, inst)
    self.inst = inst
    self.inst:AddTag("altattack")
    self.damage = 0
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
    end
end

function CombatAlternateAttack:SetDamage(damage)
    self.damage = damage
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
end

function CombatAlternateAttack:ThrowWeapon(attacker, target)
    local projectile = SpawnPrefab(self.projectile or "axe_thrown")
    projectile.oldprefab = self.inst:GetSaveRecord()
    projectile.Transform:SetPosition(attacker.Transform:GetWorldPosition())

    projectile.components.projectile.onhit = self.OnAttack
    --Remember, we're using the projectile, not combatalternateattack for this
    projectile.onattack = self.onattack
    projectile.critchance = self.critchance
    projectile.critmult = self.critmult
    projectile.components.projectile:Throw(attacker, target, attacker)

    self.inst:Remove()
end
return CombatAlternateAttack