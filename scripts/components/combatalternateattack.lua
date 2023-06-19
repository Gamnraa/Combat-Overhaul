local function thrownaxe_onattack(inst, attacker, target)
    local axe = SpawnSaveRecord(inst.oldprefab)
    local x, y, z = inst.Transform:GetWorldPosition()
    axe.Transform:SetPosition(x, 1, z)

    target.components.combat:GetAttacked(attacker, axe.components.combatalternateattack.damage, axe)
    if axe.components.finiteuses then axe.components.finiteuses:Use(3) end

    inst:Remove()
end

local CombatAlternateAttack = Class(function(self, inst)
    self.inst = inst
    self.inst:AddTag("altattack")
    self.damage = 0
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
    end
end

function CombatAlternateAttack:SetDamage(damage)
    self.damage = damage
end

function CombatAlternateAttack:SetProjectile(projectile)
    self.projectile = projectile
end

function CombatAlternateAttack:SetOnAttack(fn)
    self.onattack = fn
end

function CombatAlternateAttack:OnAttack(attacker, target)
    if self.onattack then
        self.onattack(self.inst, attacker, target)
    end
end

function CombatAlternateAttack:ThrowWeapon(attacker, target)
    local projectile = SpawnPrefab(self.projectile or "axe_thrown")
    projectile.oldprefab = self.inst:GetSaveRecord()
    projectile.Transform:SetPosition(attacker.Transform:GetWorldPosition())

    projectile.components.projectile.onhit = self.onattack
    projectile.components.projectile:Throw(attacker, target, attacker)

    self.inst:Remove()
end
return CombatAlternateAttack