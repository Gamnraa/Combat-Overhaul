local CombatAlternateAttack = Class(function(self, inst)
    self.inst = inst
    self.inst:AddTag("altattack")
    self.projectile = nil
    self.onattack = nil

 end,
 nil
)

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
    if self.projectile then
        local projectile = SpawnPrefab(self.projectile)
        projectile.oldprefab = self.inst:GetSaveRecord()
        projectile.Transform:SetPosition(attacker.Transform:GetWorldPosition())

        projectile.components.projectile.onhit = self.onattack
        projectile.components.projectile:Throw(attacker, target, attacker)

        self.inst:Remove()
    end
end
return CombatAlternateAttack