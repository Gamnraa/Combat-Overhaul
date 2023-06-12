local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"


local AlternateAttackInputChanger = Class(Screen, function(self, owner)
    self.owner = owner
    Screen._ctor(self, "AlternateAttackInputChanger")

	--darken everything behind the dialog
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black:SetTint(0,0,0,.75)

    self.prompt = self.black:AddChild(Text(BODYTEXTFONT, 44, "Press any key to set your Special Attack input:", UICOLOURS.WHITE))
    self.prompt:SetPosition(0, 50)
end)

function AlternateAttackInputChanger:OnDestroy()
    POPUPS.ALT_ATTACK_CHANGER:Close(self.owner)
    AlternateAttackInputChanger._base.OnDestroy(self)
end

function AlternateAttackInputChanger:OnBecomeInactive()
    AlternateAttackInputChanger._base.OnBecomeInactive(self)
end

function AlternateAttackInputChanger:OnBecomeActive()
    AlternateAttackInputChanger._base.OnBecomeActive(self)
end

function AlternateAttackInputChanger:OnRawKey(key, down)
    print(key)
    if down then
        self.owner.altattack = key
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        return true
    end
    return false
end

return AlternateAttackInputChanger