local mod = RestoredMonsterPack
local game = Game()

---@param ta table
---@param tb table
---@param recurse? boolean
local function MixTables(ta, tb, recurse) --from Revelations
	if ta == nil then
        error("mixin: ta nil", 2)
    elseif tb == nil then
        error("mixin: tb nil", 2)
    end

    for k, v in pairs(tb) do
        if recurse 
        and type(ta[k]) == "table"
        and type(v) == "table"
        then
			MixTables(ta[k], v, true)
        else
            ta[k] = v
        end
    end
end

mod.Rooms = {
  {Name = "Glacier", Rooms = require("resources.luarooms.revelations.glacier_tc")},
  {Name = "GlacierSpecial", Rooms = require("resources.luarooms.revelations.glacier_special_tc")},
  {Name = "GlacierChallenge", Rooms = require("resources.luarooms.revelations.glacier_challenge_tc")},
}

mod.BossRooms = {
  {Name = "Stalagmight", Rooms = require("resources.luarooms.revelations.glacier_boss_tc")},
  {Name = "Prong", Rooms = require("resources.luarooms.revelations.glacier_boss_tc")},
  {Name = "Freezer Burn", Rooms = require("resources.luarooms.revelations.glacier_boss_tc")},
  {Name = "Wendy", Rooms = require("resources.luarooms.revelations.glacier_boss_tc")},
  {Name = "Williwaw", Rooms = require("resources.luarooms.revelations.glacier_boss_tc")},
  
  {Name = "Chuck", Rooms = require("resources.luarooms.revelations.glacier_chuck_tc")},
  
  {Name = "Punker", Rooms = require("resources.luarooms.revelations.punker_tc")},
  {Name = "Raging Long Legs", Rooms = require("resources.luarooms.revelations.raging_long_legs_tc")}, 
}

function mod.RoomInit()
	if REVEL then 
    -- Add non-boss rooms
  for _,roomlist in ipairs(mod.Rooms) do
  REVEL.RoomLists[roomlist.Name]:AddRooms({Name = "[TC] " .. roomlist.Name, Rooms = roomlist.Rooms})
    -- Add boss rooms
  end
  for _,bossrooms in ipairs(mod.BossRooms) do
    StageAPI.GetBossData(bossrooms.Name).Rooms:AddRooms(bossrooms.Rooms)
  end

mod:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED,mod.RoomInit)
end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE ,mod.RoomInit)

mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.IMPORTANT, function ()
	if not REVEL then return end
	MixTables(REVEL.EntityReplacements["Glacier"].Replacements, {

		[EntityType.ENTITY_HOPPER] = {
			[1] = {
				[EntityVariant.FRACTURE] = {
					SPRITESHEET = {
						[0] = "fracture_glacier",
					}
				}
			}
		},
        [EntityType.ENTITY_CUTMONSTERS] = {
            [CutMonsterVariants.GRAVEROBBER] = {
                SPRITESHEET = {
                    [0] = "graverobber_body_glacier",
                    [1] = "graverobber_body_glacier",
                    [2] = "graverobber_glacier",
                    [3] = "graverobber_glacier",
                }
            }
        },
        [800] = {
            [0] = {
                SPRITESHEET = {
                    [0] = "dumpling_glacier",
                }
            },
        },
	}, true)

    MixTables(REVEL.EntityReplacements["Tomb"].Replacements, {
        
        [800] = {
            [0] = {
                SPRITESHEET = {
                    [0] = "dumpling_tomb",
                }
            },
            [1] = {
                SPRITESHEET = {
                    [0] = "skinling_tomb",
                }
            }
        },
    }, true)

end)
