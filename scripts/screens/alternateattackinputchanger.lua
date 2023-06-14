local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"


local AlternateAttackInputChanger = Class(Screen, function(self, owner)
    self.owner = owner
    self.iskeycontrol = false
    Screen._ctor(self, "AlternateAttackInputChanger")

	--darken everything behind the dialog
    self.black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    self.black.image:SetVRegPoint(ANCHOR_MIDDLE)
    self.black.image:SetHRegPoint(ANCHOR_MIDDLE)
    self.black.image:SetVAnchor(ANCHOR_MIDDLE)
    self.black.image:SetHAnchor(ANCHOR_MIDDLE)
    self.black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.black.image:SetTint(0,0,0,.5) -- invisible, but clickable!

    self.black:SetHelpTextMessage("")
	self.black:SetOnClick(function() end)

    self.prompt = self:AddChild(Text(BODYTEXTFONT, 44, "Press any key to set your Special Attack input:", UICOLOURS.WHITE))
    self.prompt:SetVAnchor(ANCHOR_MIDDLE)
    self.prompt:SetHAnchor(ANCHOR_MIDDLE)

    self.default_focus = self.black
end)

function AlternateAttackInputChanger:OnDestroy()
    AlternateAttackInputChanger._base.OnDestroy(self)
end

function AlternateAttackInputChanger:OnBecomeInactive()
    AlternateAttackInputChanger._base.OnBecomeInactive(self)
end

function AlternateAttackInputChanger:OnBecomeActive()
    AlternateAttackInputChanger._base.OnBecomeActive(self)
    self.black:SetFocus()
    TheFrontEnd:LockFocus(true)
end

function AlternateAttackInputChanger:OnControl(control, down)
    print(control)
    self.iskeycontrol = true
end

function AlternateAttackInputChanger:OnRawKey(key, down)
    print(key)
    if down and not self.iskeycontrol then
        self.owner.altattack = key
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        return true
    end
    self.iskeycontrol = false
    return false
end

return AlternateAttackInputChanger