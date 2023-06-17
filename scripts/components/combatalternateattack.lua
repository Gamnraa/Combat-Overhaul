local CombatAlternateAttack = Class(function(self, inst)
    self.inst = inst
    self.inst:AddTag("altattack")

 end,
 nil
)

return CombatAlternateAttack