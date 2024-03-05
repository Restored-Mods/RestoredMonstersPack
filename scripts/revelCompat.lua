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

mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.IMPORTANT, function ()
	if not REVEL then return end
	MixTables(REVEL.EntityReplacements["Glacier"].Replacements, {

		[EntityType.ENTITY_HOPPER] = {
			[1] = {
				[EntityVariant.FRACTURE] = {
					SPRITESHEET = {
						[0] = "801.000_fracture_glacier",
					}
				}
			}
		},
        [EntityType.ENTITY_CUTMONSTERS] = {
            [CutMonsterVariants.GRAVEROBBER] = {
                SPRITESHEET = {
                    [0] = "837.000_graverobber_body_glacier",
                    [1] = "837.000_graverobber_body_glacier",
                    [2] = "837.000_graverobber_glacier",
                    [3] = "837.000_graverobber_glacier",
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