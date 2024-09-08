RestoredMonsterPack = RegisterMod("Restored Monster Pack", 1)
CutMonsterPack = RestoredMonsterPack
local mod = RestoredMonsterPack
local game = Game()

--[[/////////////////////////////////////////--
	HOW TO USE BLACKLIST FUNCTIONS:

Adding / Removing entry:
AMLblacklistEntry(blacklist, Type, Variant, SubType, operation)
	there are 3 possible blacklists: "Coil", "Necromancer" and "Corpse Eater"
	the possible operations are "add" and "remove"
	if the function fails (eg. if you're trying to remove an entry that doesn't exist), it will give an error in the console and return false, otherwise it will return true
	setting the Type or Variant to -1 will include all variants or subtypes

Checking for blacklist entries:
inAMLblacklist(blacklist, checkType, checkVariant, checkSubType)
	there are 3 possible blacklists: "Coil", "Necromancer" and "Corpse Eater"
	returns true if the specified entity is in the blacklist, returns false otherwise
	setting the Type or Variant to -1 will include all variants or subtypes



	HOW TO USE CORPSE EATER EFFECT FUNCTIONS:

Adding / Removing entry:
EatenEffectEntry(Type, Variant, SubType, operation, effect)
	there are 5 possible effects: "small" (reduced effects, no projectiles), "bone", "poop", "stone", "dank" (unique projectiles)
	if an entity doesn't have an effect entry it will default to regular blood projectiles with occasional bone ones
	the possible operations are "add" and "remove"
	if the function fails (eg. if you're trying to remove an entry that doesn't exist), it will give an error in the console and return false, otherwise it will return true
	setting the Type or Variant to -1 will include all variants or subtypes

Checking for effect entries:
GetEatenEffect(checkType, checkVariant, checkSubType)
	returns the entities effect group as a string if it has an entry, returns false otherwise
	setting the Type or Variant to -1 will include all variants or subtypes
--/////////////////////////////////////////]]--


--[[--------------------------------------------------------
    Enums
--]]--------------------------------------------------------

-- Monsters
EntityType.ENTITY_CUTMONSTERS = 200
EntityType.ENTITY_DUMPLING = 800
EntityType.ENTITY_BLIND_BAT = 803
EntityType.ENTITY_STRIFER = 839
EntityType.ENTITY_NIGHTWATCH = 842
EntityType.ENTITY_CANARY = 843
EntityType.ENTITY_VESSEL = 858

-- Variants of the cut monsters entity
CutMonsterVariants = {
	SCORCHLING = 2400, -- for backwards compatibility
	DUMPLING = 2401, -- for backwards compatibility
	SKINLING = 2402, -- for backwards compatibility
	SCAB = 2403, -- for backwards compatibility
	MORTLING = 2404, -- for backwards compatibility
	GILDED_DUMPLING = 2405, -- for backwards compatibility
	TAINTED_DUMPLING = 2399, -- for backwards compatibility

	COIL = 2406,
	ECHO_BAT = 2407,
  	CHUBBY_BUNNY = 1, --subtype
	SCREAMER = 2408,
	STILLBORN = 2409,
	NECROMANCER = 2410,
	RED_TNT = 3400,
	CELL = Isaac.GetEntityVariantByName("Cell"),
	FUSEDCELLS = Isaac.GetEntityVariantByName("Fused Cells"),
	TISSUE = Isaac.GetEntityVariantByName("Tissue"),
	GRAVEROBBER = 2503,
	SPLASHY = Isaac.GetEntityVariantByName("Splashy Long Legs")
}

-- Variants of already existing entities
EntityVariant = {
	DUMPLING = 0, -- for EntityType.ENTITY_DUMPLING
    SKINLING = 1, -- for EntityType.ENTITY_DUMPLING
    SCAB = 2, -- for EntityType.ENTITY_DUMPLING
	SCORCHLING = 3, -- for EntityType.ENTITY_DUMPLING
	MORTLING = 4, -- for EntityType.ENTITY_DUMPLING
	TAINTED_DUMPLING = 5, -- for EntityType.ENTITY_DUMPLING
	GILDED_DUMPLING = 6, -- for EntityType.ENTITY_DUMPLING
	SPORELING = 7, -- for EntityType.ENTITY_DUMPLING
	FRACTURE = 801, -- for EntityType.ENTITY_HOPPER (subType)
	SWAPPER = 835, -- for EntityType.ENTITY_BABY
	BARFY = 850, -- for EntityType.ENTITY_FATTY
	VANILLA_CORPSE_EATER = 100, -- for EntityType.ENTITY_GRUB --100
	VANILLA_CARRION_RIDER = 101, -- for EntityType.ENTITY_GRUB --101
	CORPSE_EATER = Isaac.GetEntityVariantByName("​Corpse Eater"),
	CARRION_RIDER = Isaac.GetEntityVariantByName("​Carrion Rider"),
	STRIFER = Isaac.GetEntityVariantByName("​Strifer"), -- dummy strifer
}

-- Projectile variants
ProjectileVariant.PROJECTILE_ECHO = 104
ProjectileVariant.PROJECTILE_LANTERN = 106
ProjectileVariant.PROJECTILE_STAPLE = 108

-- Effect variants
EffectVariant.NIGHTWATCH_SPOTLIGHT = 842
EffectVariant.SCREAMER_AURA = 867


--[[--------------------------------------------------------
    DSS and savedata should (likely) be loaded first
--]]--------------------------------------------------------

include("scripts.deadseascrolls.savedata")
include("scripts.deadseascrolls.dssmain")
include("scripts.deadseascrolls.changelogs")
include("scripts.deadseascrolls.imgui")

--[[--------------------------------------------------------
    External monster files to require
--]]--------------------------------------------------------

include("scripts.cells")
include("scripts.graverobber")
include("scripts.splashyLongLegs")
include("scripts.fireGrimace")
include("scripts.bloodworm")
include("scripts.canary")
include("scripts.corpseEaters")
include("scripts.dumplings")
include("scripts.fracture")
include("scripts.stillborn")
include("scripts.blindBats")
include("scripts.echoBat")
include("scripts.necromancer")
include("scripts.swappers")
include("scripts.barfy")
include("scripts.strifers")
include("scripts.nightwatch")
include("scripts.vessel")
include("scripts.coils")
include("scripts.screamer")
include("scripts.redTNT")
include("scripts.palevessel")

--[[--------------------------------------------------------
    misc
--]]--------------------------------------------------------

include("scripts.revelCompat")
include("scripts.compatibility.retribution.baptismal_preloader")
include("scripts.compatibility.retribution.tc_downgrades")
include("scripts.compatibility.retribution.tc_upgrades")
include("scripts.compatibility.boiler")
if StageAPI then
	include("scripts.compatibility.fiend folio.tc_genders")
	StageAPI.AddEntities2Function(require("scripts.entities2"))
end

--[[--------------------------------------------------------
    Blacklists
--]]--------------------------------------------------------

local coil_blacklist = {
	{EntityType.ENTITY_LUMP, -1, -1},
	{EntityType.ENTITY_CUTMONSTERS, CutMonsterVariants.COIL, -1},
	{EntityType.ENTITY_CUTMONSTERS, CutMonsterVariants.RED_TNT, -1},
	{EntityType.ENTITY_GRUB, 100, 1}, -- Corpse eater body
	{EntityType.ENTITY_EVIS, 10, -1}, -- Evis cord
	{EntityType.ENTITY_NEEDLE, -1, -1},
}

local necromancer_blacklist = {
	{EntityType.ENTITY_BONY, -1, CutMonsterVariants.NECROMANCER}, -- Bonys spawned by Necromancers
	{EntityType.ENTITY_GRUB, 0, -1},
	{EntityType.ENTITY_GRUB, 100, 1}, -- Corpse eater body
	{EntityType.ENTITY_LITTLE_HORN, 1, -1}, -- Dark ball
	{EntityType.ENTITY_RAG_MEGA, 1, -1}, -- Purple ball
	{EntityType.ENTITY_BIG_BONY, 10, -1}, -- Bouncing bone
}

local corpse_eater_blacklist = {
	{EntityType.ENTITY_FLY, -1, -1},
	{EntityType.ENTITY_ATTACKFLY, -1, -1},
	{EntityType.ENTITY_VIS, 22, -1}, -- Chubber projectile
	{EntityType.ENTITY_SUCKER, 4, -1}, -- Bulb
	{EntityType.ENTITY_SUCKER, 5, -1}, -- Bloodfly
	{EntityType.ENTITY_SPIDER, -1, -1},
	{EntityType.ENTITY_CUTMONSTERS, CutMonsterVariants.NECROMANCER, -1},
	{EntityType.ENTITY_DIP, -1, -1},
	{EntityType.ENTITY_RING_OF_FLIES, -1, -1},
	{EntityType.ENTITY_BONY, -1, -1},
	{EntityType.ENTITY_GRUB, 100, -1},
	{EntityType.ENTITY_GRUB, 101, -1},
	{EntityType.ENTITY_GRUB, EntityVariant.CORPSE_EATER, -1},
	{EntityType.ENTITY_GRUB, EntityVariant.CARRION_RIDER, -1},
	{EntityType.ENTITY_DART_FLY, -1, -1},
	{EntityType.ENTITY_BLACK_BONY, -1, -1},
	{EntityType.ENTITY_SWARM, -1, -1},
	{EntityType.ENTITY_CORN_MINE, -1, -1},
	{EntityType.ENTITY_HUSH_FLY, -1, -1},
	{EntityType.ENTITY_LITTLE_HORN, 1, -1}, -- Dark ball
	{EntityType.ENTITY_PORTAL, -1, -1},
	{EntityType.ENTITY_WILLO, -1, -1},
	{EntityType.ENTITY_BIG_BONY, -1, -1},
	{EntityType.ENTITY_WILLO_L2, -1, -1},
	{EntityType.ENTITY_REVENANT, -1, -1},
	{EntityType.ENTITY_ARMYFLY, -1, -1},
	{EntityType.ENTITY_SWARM_SPIDER, -1, -1},
	{EntityType.ENTITY_CULTIST, -1, -1},
}

-- Add / remove blacklist entry
function AMLblacklistEntry(blacklist, Type, Variant, SubType, operation)
	-- Error checking
	if blacklist ~= "Coil" and blacklist ~= "Necromancer" and blacklist ~= "Corpse Eater" then
		print("[CMP] Error adding / removing blacklist entry:\n   Incorrect blacklist: " .. blacklist)
	end
	if operation ~= "add" and operation ~= "remove" then
		print("[CMP] Error adding / removing blacklist entry:\n   Unknown operation: " .. operation)
		return false
	end

	-- Get blacklist
	local checkList = {}
	if blacklist == "Coil" then
		checkList = coil_blacklist
	elseif blacklist == "Necromancer" then
		checkList = necromancer_blacklist
	elseif blacklist == "Corpse Eater" then
		checkList = corpse_eater_blacklist
	end

	-- Add / remove
	for i,entry in pairs(checkList) do
		if operation == "add" then
			if entry[1] == Type and entry[2] == Variant and entry[3] == SubType then
				print("[CMP] Error adding blacklist entry:\n   Entry already exists")
				return false
			end

		elseif operation == "remove" then
			if entry[1] == Type and entry[2] == Variant and entry[3] == SubType then
				table.remove(checkList, i)
				return true
			end
		end
	end

	if operation == "add" then
		table.insert(checkList, {Type, Variant, SubType})
		return true

	elseif operation == "remove" then
		print("[CMP] Error removing blacklist entry:\n   Entry doesn't exist")
		return false
	end
end

-- Check if the entity is in the blacklist or not
function inAMLblacklist(blacklist, checkType, checkVariant, checkSubType)
	if blacklist ~= "Coil" and blacklist ~= "Necromancer" and blacklist ~= "Corpse Eater" then
		print("[CMP] Error checking blacklist:\n   Incorrect blacklist: " .. blacklist)
		return
	end

	local checkList = {}
	if blacklist == "Coil" then
		checkList = coil_blacklist
	elseif blacklist == "Necromancer" then
		checkList = necromancer_blacklist
	elseif blacklist == "Corpse Eater" then
		checkList = corpse_eater_blacklist
	end

	for i,entry in pairs(checkList) do
		if checkType == entry[1] and (entry[2] == -1 or checkVariant == entry[2]) and (entry[3] == -1 or checkSubType == entry[3]) then
			return true
		end
	end
	return false
end



--[[--------------------------------------------------------
    Corpse eater death effects for enemies
--]]--------------------------------------------------------

local corpse_eater_effects = {
	small = {
	{EntityType.ENTITY_FLY, -1, -1},
	{EntityType.ENTITY_POOTER, -1, -1},
	{EntityType.ENTITY_ATTACKFLY, -1, -1},
	{EntityType.ENTITY_MOTER, -1, -1},
	{EntityType.ENTITY_SPIDER, -1, -1},
	{EntityType.ENTITY_BIGSPIDER, -1, -1},
	{EntityType.ENTITY_RING_OF_FLIES, -1, -1},
	{EntityType.ENTITY_DART_FLY, -1, -1},
	{EntityType.ENTITY_SWARM, -1, -1},
	{EntityType.ENTITY_HUSH_FLY, -1, -1},
	{EntityType.ENTITY_SMALL_LEECH, -1, -1},
	{EntityType.ENTITY_STRIDER, -1, -1},
	{EntityType.ENTITY_FLY_BOMB, -1, -1},
	{EntityType.ENTITY_SMALL_MAGGOT, -1, -1},
	{EntityType.ENTITY_ARMYFLY, -1, -1},
	{EntityType.ENTITY_SWARM_SPIDER, -1, -1},
	{EntityType.ENTITY_POOFER, -1, -1},
	},

	bone = {
	{EntityType.ENTITY_BOOMFLY, 4, -1}, -- Bone fly
	{EntityType.ENTITY_DEATHS_HEAD, 4, -1}, -- Red skull
	{EntityType.ENTITY_BONY, -1, -1},
	{EntityType.ENTITY_POLYCEPHALUS, 1, -1}, -- The Pile
	{EntityType.ENTITY_BLACK_BONY, -1, -1},
	{EntityType.ENTITY_MOMS_DEAD_HAND, -1, -1},
	{EntityType.ENTITY_FORSAKEN, -1, -1},
	{EntityType.ENTITY_BIG_BONY, -1, -1},
	{EntityType.ENTITY_REVENANT, -1, -1},
	{EntityType.ENTITY_NEEDLE, 1, -1}, -- Pasty
	{EntityType.ENTITY_CLICKETY_CLACK, -1, -1},
	{EntityType.ENTITY_MAZE_ROAMER, -1, -1},
	},

	stone = {
	{EntityType.ENTITY_HOST, 3, -1}, -- Hard host
	{EntityType.ENTITY_ULTRA_GREED, 1, -1}, -- Ultra Greedier
	{EntityType.ENTITY_BISHOP, -1, -1},
	{EntityType.ENTITY_ROCK_SPIDER, -1, -1},
	{EntityType.ENTITY_DANNY, 1, -1}, -- Coal boy
	{EntityType.ENTITY_BLASTER, -1, -1},
	{EntityType.ENTITY_QUAKEY, -1, -1},
	{EntityType.ENTITY_HARDY, -1, -1},
	{EntityType.ENTITY_VISAGE, -1, -1},
	},

	poop = {
	{EntityType.ENTITY_DIP, -1, -1},
	{EntityType.ENTITY_SQUIRT, 0, -1},
	{EntityType.ENTITY_DINGA, -1, -1},
	{EntityType.ENTITY_GURGLING, 2, -1}, -- Turdling
	{EntityType.ENTITY_DINGLE, -1, -1},
	{EntityType.ENTITY_CORN_MINE, -1, -1},
	{EntityType.ENTITY_BROWNIE, -1, -1},
	{EntityType.ENTITY_HENRY, -1, -1},
	{EntityType.ENTITY_DRIP, -1, -1},
	{EntityType.ENTITY_SPLURT, -1, -1},
	{EntityType.ENTITY_CLOGGY, -1, -1},
	{EntityType.ENTITY_DUMP, -1, -1},
	{EntityType.ENTITY_CLOG, -1, -1},
	{EntityType.ENTITY_COLOSTOMIA, -1, -1},
	{EntityType.ENTITY_TURDLET, -1, -1},
	},

	dank = {
	{EntityType.ENTITY_CLOTTY, 1, -1}, -- Clot
	{EntityType.ENTITY_CHARGER, 2, -1},
	{EntityType.ENTITY_GLOBIN, 2, -1},
	{EntityType.ENTITY_LEAPER, 1, -1},
	{EntityType.ENTITY_GUTS, 2, -1}, -- Slog
	{EntityType.ENTITY_MONSTRO2, 1, -1}, -- Gish
	{EntityType.ENTITY_SUCKER, 2, -1}, -- Ink
	{EntityType.ENTITY_DEATHS_HEAD, 1, -1},
	{EntityType.ENTITY_SQUIRT, 1, -1},
	{EntityType.ENTITY_TARBOY, -1, -1},
	{EntityType.ENTITY_GUSH, -1, -1},
	{EntityType.ENTITY_BUTT_SLICKER, -1, -1},
	},
}

-- Add / remove Corpse Eater effects
function EatenEffectEntry(Type, Variant, SubType, operation, effect)
	-- Error checking
	if effect ~= "small" and effect ~= "bone" and effect ~= "stone" and effect ~= "poop" and effect ~= "dank" then
		print("[CMP] Error adding / removing Corpse eater effect entry:\n   Unknown effect: " .. effect)
	end
	if operation ~= "add" and operation ~= "remove" then
		print("[CMP] Error adding / removing Corpse eater effect entry:\n   Unknown operation: " .. operation)
		return false
	end

	-- Get list
	local checkList = {}
	if effect == "small" then
		checkList = corpse_eater_effects.small
	elseif effect == "bone" then
		checkList = corpse_eater_effects.bone
	elseif effect == "stone" then
		checkList = corpse_eater_effects.stone
	elseif effect == "poop" then
		checkList = corpse_eater_effects.poop
	elseif effect == "dank" then
		checkList = corpse_eater_effects.dank
	end

	-- Add / remove
	for i,entry in pairs(checkList) do
		if operation == "add" then
			if entry[1] == Type and entry[2] == Variant and entry[3] == SubType then
				print("[CMP] Error adding effect entry:\n   Entry already exists")
				return false
			end

		elseif operation == "remove" then
			if entry[1] == Type and entry[2] == Variant and entry[3] == SubType then
				table.remove(checkList, i)
				return true
			end
		end
	end

	if operation == "add" then
		table.insert(checkList, {Type, Variant, SubType})
		return true

	elseif operation == "remove" then
		print("[CMP] Error removing effect entry:\n   Entry doesn't exist")
		return false
	end
end

-- Get Corpse eater effect
function GetEatenEffect(checkType, checkVariant, checkSubType)
	for effect,effectlist in pairs(corpse_eater_effects) do
		for i,entry in pairs(effectlist) do
			if checkType == entry[1] and (entry[2] == -1 or checkVariant == entry[2]) and (entry[3] == -1 or checkSubType == entry[3]) then
				return tostring(effect)
			end
		end
	end
	return false
end



--[[--------------------------------------------------------
    Replace entities that use an old ID or a different one in Basement Renovator
--]]--------------------------------------------------------

function mod:replaceID(Type, Variant, SubType, GridIndex, Seed)
	--[[ DUMPLINGS ]]--
	if Type == EntityType.ENTITY_CUTMONSTERS and (Variant == CutMonsterVariants.DUMPLING or Variant == CutMonsterVariants.SKINLING or Variant == CutMonsterVariants.SCAB) then
		return {EntityType.ENTITY_DUMPLING, Variant - 2401, SubType}

	elseif Type == EntityType.ENTITY_CUTMONSTERS and Variant == CutMonsterVariants.DUMPLING then
		return {EntityType.ENTITY_DUMPLING, EntityVariant.SCORCHLING, SubType}

	elseif Type == EntityType.ENTITY_CUTMONSTERS and Variant == CutMonsterVariants.MORTLING then
		return {EntityType.ENTITY_DUMPLING, EntityVariant.MORTLING, SubType}

	elseif Type == EntityType.ENTITY_CUTMONSTERS and Variant == CutMonsterVariants.TAINTED_DUMPLING then
		return {EntityType.ENTITY_DUMPLING, EntityVariant.TAINTED_DUMPLING, SubType}

	elseif Type == EntityType.ENTITY_CUTMONSTERS and Variant == CutMonsterVariants.GILDED_DUMPLING then
		return {EntityType.ENTITY_DUMPLING, EntityVariant.GILDED_DUMPLING, SubType}

	--[[ FRACTURE ]]--
	elseif Type == 801 and Variant == 0 and SubType == 0 then
		return {EntityType.ENTITY_HOPPER, 1, EntityVariant.FRACTURE}

	--[[ RED TNT ]]--
	elseif Type == EntityType.ENTITY_CUTMONSTERS and Variant == CutMonsterVariants.RED_TNT then
		return {EntityType.ENTITY_MOVABLE_TNT, CutMonsterVariants.RED_TNT}
	end
	if EntityType.ENTITY_STRIFER == Type then
		return {Type, EntityVariant.STRIFER, Variant}
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.replaceID)

function mod:replaceByDummy(Type, Variant, SubType, _, _, _, Seed)
	if mod.DummyReplace[Type] then
		if mod.DummyReplace[Type][Variant] then
			return {Type, mod.DummyReplace[Type][Variant], SubType, Seed}
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, mod.replaceByDummy)

mod.DummyReplace = {
	[EntityType.ENTITY_VESSEL] = {[0] = Isaac.GetEntityVariantByName("​Vessel (Antibirth)")}, --200},
	[EntityType.ENTITY_CANARY] = {[0] = Isaac.GetEntityVariantByName("​Canary"), --200, 
									[1] = Isaac.GetEntityVariantByName("​Foreigner")}, --201},
	[EntityType.ENTITY_EXORCIST] = {[0] = Isaac.GetEntityVariantByName("​Exorcist")}, --200},
	[EntityType.ENTITY_BLIND_BAT] = {[0] = Isaac.GetEntityVariantByName("​Blind Bat")}, --200},
	[EntityType.ENTITY_RAGE_CREEP] = {[1] = Isaac.GetEntityVariantByName("​Split Rage Creep")}, --200},
	[EntityType.ENTITY_WALL_CREEP] = {[2] = Isaac.GetEntityVariantByName("​Rag Creep")}, --200},
	[EntityType.ENTITY_NIGHTWATCH] = {[0] = Isaac.GetEntityVariantByName("​Nightwatch")},
	--[EntityType.ENTITY_STRIFER] = {[0] = Isaac.GetEntityVariantByName("​Strifer")},
	[EntityType.ENTITY_GRUB] = {[EntityVariant.CORPSE_EATER] = Isaac.GetEntityVariantByName("​Corpse Eater"),
									[EntityVariant.CARRION_RIDER] = Isaac.GetEntityVariantByName("​Carrion Rider")},
}

local ign = false
function mod:MostDumbThing(ent)
	local dumb = mod.DumbhackReplace[ent.Type]
	if dumb then
		local ovar,vvar = dumb[1], dumb[2]
		
		if not ign and ent.Variant == vvar and ent.FrameCount > 1 then
			ign = true
			local spr = ent:GetSprite()
			local pos = ent.Position/1
			local frame = spr:GetFrame()
			ent.Variant = ovar
			if frame > 0 then
				spr:SetFrame(frame-1)
			end
			ent:Update()
			ent.Variant = vvar
			ent.Position = pos
			ign = false
			return true
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, 1000, mod.MostDumbThing)
mod.DumbhackReplace = {
	[EntityType.ENTITY_RAGE_CREEP] = {1, Isaac.GetEntityVariantByName("​Split Rage Creep")},
	[EntityType.ENTITY_WALL_CREEP] = {2, Isaac.GetEntityVariantByName("​Rag Creep")},
}

mod.Nonmale = {
	{ID = {Isaac.GetEntityTypeByName("Splashy Long Legs"), Isaac.GetEntityVariantByName("Splashy Long Legs")}, Affliction = "Woman"}, --Splashy Long Legs
	{ID = {Isaac.GetEntityTypeByName("Sticky Long Legs"), Isaac.GetEntityVariantByName("Sticky Long Legs"), 1}, Affliction = "Woman"}, --Sticky Long Legs
	{ID = {Isaac.GetEntityTypeByName("Scab"), Isaac.GetEntityVariantByName("Scab")}, Affliction = "Woman"}, --Scab
	{ID = {Isaac.GetEntityTypeByName("Mortling"), Isaac.GetEntityVariantByName("Mortling")}, Affliction = "Woman"}, --Mortling
	{ID = {Isaac.GetEntityTypeByName("​Fracture"), Isaac.GetEntityVariantByName("​Fracture"), 801}, Affliction = "Woman"}, --Fracture
	{ID = {Isaac.GetEntityTypeByName("Echo Bat"), Isaac.GetEntityVariantByName("Echo Bat")}, Affliction = "Woman"}, --Echo Bat
	{ID = {Isaac.GetEntityTypeByName("​Corpse Eater"), Isaac.GetEntityVariantByName("​Corpse Eater")}, Affliction = "Woman"}, --Corpse Eater
	{ID = {Isaac.GetEntityTypeByName("​Foreigner"), Isaac.GetEntityVariantByName("​Foreigner")}, Affliction = "Woman"}, --Foreigner
	{ID = {Isaac.GetEntityTypeByName("Screamer"), Isaac.GetEntityVariantByName("Screamer")}, Affliction = "Woman"}, --Screamer
	--{ID = {Isaac.GetEntityTypeByName("Cell"), Isaac.GetEntityVariantByName("Cell")}, Affliction = "Woman"}, --Cell BC WESTRVN SAID SO ):
	{ID = {Isaac.GetEntityTypeByName("Fused Cells"), Isaac.GetEntityVariantByName("Fused Cells")}, Affliction = "Woman"}, --Fused Cell
	--{ID = {Isaac.GetEntityTypeByName("Tissue"), Isaac.GetEntityVariantByName("Tissue")}, Affliction = "Woman"}, --Tissue ALSO BC WESTRVN SAID SO ):
	{ID = {Isaac.GetEntityTypeByName("Grave Robber"), Isaac.GetEntityVariantByName("Grave Robber")}, Affliction = "Woman"}, --Grave Robber
	{ID = {Isaac.GetEntityTypeByName("​Strifer"), Isaac.GetEntityVariantByName("Strifer")}, Affliction = "Woman"}, --Strifer
	{ID = {Isaac.GetEntityTypeByName("Vessel (Anitbirth)"), Isaac.GetEntityVariantByName("Vessel (Antibirth)")}, Affliction = "Woman"}, --Vessel (rework)
}
