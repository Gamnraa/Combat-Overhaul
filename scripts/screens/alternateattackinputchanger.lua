local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"


local AlternateAttackInputChanger = Class(Screen, function(self, inst)
    self.inst = inst
    self.listenforkeys = false
    self.buttonconfig = KEY_V

    Screen._ctor(self, "alternateattackinputchanger")

    self.buttonopener = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    self.buttonopener:SetVAnchor(ANCHOR_BOTTOM)
    self.buttonopener:SetHAnchor(ANCHOR_LEFT)
    self.buttonopener:SetScale(.8)
    self.buttonopener:SetOnClick(function() self:DoInit() end)
    
    self.bgfade = self:AddChild(Image("images/global.xml", "square.text"))
    self.bgfade:SetVRegPoint(ANCHOR_MIDDLE)
    self.bgfade:SetHRegPoint(ANCHOR_MIDDLE)
    self.bgfade:SetVAnchor(ANCHOR_MIDDLE)
    self.bgfade:SetHAnchor(ANCHOR_MIDDLE)
    self.bgfade:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.bgfade:SetTint(0, 0, 0, 0)
    
end
)

function AlternateAttackInputChanger:DoInit()
    self.bgfade:SetTint(0, 0, 0, .75)

    self.prompt =  self:AddChild(Text(BODYTEXTFONT, 50, "Press any key to set your Special Attack input:", UICOLOURS.WHITE))
    self.prompt:SetVAnchor(ANCHOR_MIDDLE)
    self.prompt:SetHAnchor(ANCHOR_MIDDLE)

    self.listenforkeys = true
end

function AlternateAttackInputChanger:OnClose()
    print("OnClose")
    local screen = TheFrontEnd:GetActiveScreen()
    if screen and not screen.name:find("HUD") then
        TheFrontEnd:PopScreen()
    end
    self.listenforkeys = false
    TheFrontEnd:GetSound():PlaySound("donstarve/HUD/click_move")
end

function AlternateAttackInputChanger:OnRawKey(key, down)
    print("rawkey")
    if down and self.listenforkeys then
        --In the future we might want to check and make sure the key pressed is not assigned to another control
        self.buttonconfig = key
        self:OnClose()
        return true
    end
end

return AlternateAttackInputChanger