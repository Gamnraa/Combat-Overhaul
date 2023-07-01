--Code modified from baseball_bat_ness_common.lua to be more fitting in different circumstances
local State = GLOBAL.State
local FRAMES = GLOBAL.FRAMES
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
require "stategraphs/commonstates"
local CommonHandlers = GLOBAL.CommonHandlers

local newAnims = {
	["spider"] = Asset("ANIM", "anim/spiderknockback.zip"),
	["hound"] = Asset("ANIM", "anim/houndknockback.zip"),
	["rabbit"] = Asset("ANIM", "anim/rabbitknockback.zip"),
	["birchnutdrake"] = Asset("ANIM", "anim/treedrakeknockback.zip"),
	["buzzard"] = Asset("ANIM", "anim/buzzardknockback.zip"),
	["catcoon"] = Asset("ANIM", "anim/catcoonknockback.zip"),
	["frog"] = Asset("ANIM", "anim/frogknockback.zip"),
	["fruitdragon"] = Asset("ANIM", "anim/fruitdragonknockback.zip"),
	["grassgekko"] = Asset("ANIM", "anim/grassgeckoknockback.zip"),
	["knight"] = Asset("ANIM", "anim/knightknockback.zip"),
	["lightninggoat"] = Asset("ANIM", "anim/lightninggoatknockback.zip"),
	["powder_monkey"] = Asset("ANIM", "anim/monkeysmallknockback.zip"),
	["mushgnome"] = Asset("ANIM", "anim/mushgnomeknockback.zip"),
	["spider_moon"] = Asset("ANIM", "anim/spidermoonknockback.zip"),
	["penguin"] = Asset("ANIM", "anim/penguinknockback.zip"),
	--["perd"] = Asset("ANIM", "anim/perdknockback.zip"), --Needs to be fixed
	["pigman"] = Asset("ANIM", "anim/ds_pig_elite.zip"),
	["werepig"] = Asset("ANIM", "anim/ds_pig_elite.zip"),
	["walrus"] = Asset("ANIM", "anim/walrusknockback.zip"), 
}

--These mobs have smacked animations already
local validAnims = {
	["pig"] = true,
	["pigguard"] = true,
	["moonpig"] = true,
	["werepig"] = true,
	["merm"] = true,
	["spider_warrior"] = true,
	["spider_dropper"] = true,
	["spider_healer"] = true,
	["prime_mate"] = true,
	["knight_nightmare"] = true,
	["icehound"] = true,
	["firehound"] = true,
	["hedgehound"] = true,
	["clayhound"] = true,
	["moonhound"] = true,
	["mutatedhound"] = true,
	["mutated_penguin"] = true,
}

local oldRegisterPrefabsImpl = GLOBAL.RegisterPrefabsImpl
GLOBAL.RegisterPrefabsImpl = function(prefab, ...)
	if newAnims[prefab.name] then
		table.insert(prefab.assets, newAnims[prefab.name])
	end
	oldRegisterPrefabsImpl(prefab, ...)
end


--Copy paste from SGpigelite.lua	
local knockback = State{
        name = "gramknockback",
        tags = {"busy", "nosleep", "nofreeze", "jumping" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
			inst.SoundEmitter:PlaySound("dontstarve/creatures/" .. (inst.soundgroup or inst.prefab) .. "/hurt")
			if not inst.components.health:IsDead() then
				if newAnims[inst.prefab] or validAnims[inst.prefab] then
					inst.AnimState:PlayAnimation("smacked")
				else
					inst.AnimState:PlayAnimation("hit")
				end
			end
			
            if data.radius ~= nil and data.knocker ~= nil and data.knocker:IsValid() then
                local x, y, z = data.knocker.Transform:GetWorldPosition()
                local distsq = inst:GetDistanceSqToPoint(x, y, z)
                local rangesq = data.radius * data.radius
                local rot = inst.Transform:GetRotation()
                local rot1 = distsq > 0 and inst:GetAngleToPoint(x, y, z) or data.knocker.Transform:GetRotation() + 180
                local drot = math.abs(rot - rot1)
                while drot > 180 do
                    drot = math.abs(drot - 360)
                end
                local k = distsq < rangesq and .3 * distsq / rangesq - 1 or -.7
                inst.sg.statemem.speed = (data.strengthmult or 1) * 10 * k
				inst.components.locomotor:EnableGroundSpeedMultiplier(false)
				inst.Physics:SetDamping(0)
                inst.sg.statemem.dspeed = 0
                if drot > 90 then
                    inst.sg.statemem.reverse = true
                    inst.Transform:SetRotation(rot1 + 180)
					--inst.Physics:SetVel(-inst.sg.statemem.speed, 0, 0)
                    inst.Physics:SetMotorVelOverride(-inst.sg.statemem.speed, 0, 0)
                else
                    inst.Transform:SetRotation(rot1)
					--inst.Physics:SetVel(inst.sg.statemem.speed, 0, 0)
                    inst.Physics:SetMotorVelOverride(inst.sg.statemem.speed, 0, 0)
                end
			end
        end,

        onupdate = function(inst)
            if inst.sg.statemem.speed ~= nil then
                inst.sg.statemem.speed = inst.sg.statemem.speed + inst.sg.statemem.dspeed
                if inst.sg.statemem.speed < 0 then
                    inst.sg.statemem.dspeed = inst.sg.statemem.dspeed + .075
                    inst.Physics:SetMotorVelOverride(inst.sg.statemem.reverse and -inst.sg.statemem.speed or inst.sg.statemem.speed, inst.sg.statemem.speed, 0)
                else
                    inst.sg.statemem.speed = nil
                    inst.sg.statemem.dspeed = nil
                    inst.Physics:Stop()
                end
            end
        end,

        timeline =
        {
            --TimeEvent(3 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/pig/scream") end),
            TimeEvent(12 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt") end),
            TimeEvent(14 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nofreeze")
            end),
            TimeEvent(32 * FRAMES, function(inst)
				if inst.components.sleeper then
					inst.components.sleeper:WakeUp()
				end
                inst.sg:RemoveStateTag("nosleep")
            end),
            TimeEvent(35 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            --CommonHandlers.OnNoSleepAnimOver("idle"),
			 EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() and not inst.components.health:IsDead() then
					inst.sg:GoToState("idle")
				end
			end)
        },

        onexit = function(inst)
			inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            if inst.sg.statemem.speed ~= nil then
                inst.Physics:Stop()
            end
        end,
    }
	
local function BaseballKnockbackEvent(inst, data)
	inst.sg:GoToState("gramknockback", {knocker = data.knocker, radius = data.radius, strengthmult = data.strengthmult})
end

function MassAddStategraphEvent(entityStates, event, eventFunction)
	for k, v in pairs(entityStates) do
		AddStategraphEvent(k, EventHandler(event, function(inst, data)
			eventFunction(inst, data)
		end))
	end
end

--Helps with clutter
--Also key values are used to determine if the mob can be knocked back
GLOBAL.GRAM_KNOCKBACK_WEIGHTS = {
	["bat"] = 3.3,
	["bee"] = 4.0,
	["SGBeeguard"] = 2.5,
	["birchnutdrake"] = 2.7,
	["bird"] = 3.3,
	["bird_mutant"] = 3.2,
	["pig"] = 1.5,
	["butterfly"] = 5.0,
	["buzzard"] = 1.7, --Will fly away after landing if not engaged in combat
	["catcoon"] = 2.0,
	["dustmoth"] = 2.2,
	["eyeofterror_mini"] = 2.2,
	["frog"] = 2.7,
	["fruit_dragon"] = 2.0,
	["fruitfly"] = 4.0,
	["grassgekko"] = 2.0,
	["hound"] = 1.5,
	["knight"] = 1.1,
	["lavae"] = 2.7,
	["lightcrab"] = 2.0,
	["lightninggoat"] = 1.5,
	["merm"] = 1.5,
	["monkey"] = 1.8,
	["moonpig"] = 1.5,
	["mushgnome"] = 1.9,
	["penguin"] = 2.2,
	["perd"] = 2.0,
	["pigelite"] = 1.5,
	["powdermonkey"] = 1.8,
	["primemate"] = 1.5,
	["rabbit"] = 3.2,
	["slurper"] = 2.5,
	["spider"] = 2.0,
	["walrus"] = 1.5,
	["werepig"] = 1.3,
	["bunnyman"] = 1.4
}

MassAddStategraphEvent(GLOBAL.GRAM_KNOCKBACK_WEIGHTS, "gramknockback", BaseballKnockbackEvent)
for k, v in pairs(GLOBAL.GRAM_KNOCKBACK_WEIGHTS) do
	AddStategraphState(k, knockback)
end

--Mobs that share a stategraph but still need a weight defined so our baseball bat can detect them
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["spider_warrior"] = 2.0
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["killerbee"] = 4.0
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["spider_dropper"] = 2.0
--GLOBAL.GRAM_KNOCKBACK_WEIGHTS["spider_moon"] = 2.0
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["spider_healer"] = 2.0
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["fruitdragon"] = 2.0 --WHY KLEI
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["powder_monkey"] = 1.8 --STOOOOPPP
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["prime_mate"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["pigguard"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["pigman"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["knight_nightmare"] = 1.1
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["icehound"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["firehound"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["moonhound"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["clayhound"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["mutatedhound"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["hedgehound"] = 1.5
GLOBAL.GRAM_KNOCKBACK_WEIGHTS["mutated_penguin"] = 2.2