local CombatAlternateAttack = Class(function(self, inst, type)
    self.inst = inst
    if type then self.inst:SetTag(type) end

 end,
 nil
)

return CombatAlternateAttack