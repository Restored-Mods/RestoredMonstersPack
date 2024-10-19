local mod = RestoredMonsterPack
if FFGRACE then
    local basepath = "gfx/monsters/"


    --boiler
    FFGRACE.StageSkins.Boiler[EntityType.ENTITY_DUMPLING.." "..0] = {
                {{0}, basepath.."boiler/dumpling_boiler"},
            }

    table.insert(FFGRACE.Rooms.Boiler, include("resources.luarooms.ffg.boiler_rm"))
    table.insert(FFGRACE.Rooms.BoilerChallenge, include("resources.luarooms.ffg.boiler_rm_challenge"))
    table.insert(FFGRACE.Rooms.BoilerWhiteFire, include("resources.luarooms.ffg.boiler_rm_fire"))
    if FiendFolio then
      table.insert(FFGRACE.Rooms.Boiler, include("resources.luarooms.ffg.boiler_rm_ff"))
    end

    StageAPI.GetBossData("FFGRACE Creem").Rooms:AddRooms(require("resources.luarooms.ffg.bosses.boiler_rm_creem"))


    --grotto
    table.insert(FFGRACE.Rooms.Grotto, include("resources.luarooms.ffg.grotto_rm"))
    table.insert(FFGRACE.Rooms.GrottoChallenge, include("resources.luarooms.ffg.grotto_rm_challenge"))
    table.insert(FFGRACE.Rooms.GrottoRailButton, include("resources.luarooms.ffg.grotto_rm_button"))
    table.insert(FFGRACE.Rooms.GrottoMineshaftEntrance, include("resources.luarooms.ffg.grotto_rm_mineshaft_entrance"))



    --if an enemy is transformable by spores in grotto, used for sporelings
    mod.sporeTransformable = {
      {EntityType.ENTITY_ONE_TOOTH, -1, -1},
      {EntityType.ENTITY_FAT_BAT, -1, -1},
      {EntityType.ENTITY_BOOMFLY, 3, -1}, --dragon fly

      {EntityType.ENTITY_CUTMONSTERS, CutMonsterVariants.ECHO_BAT, 0},
      {EntityType.ENTITY_BLIND_BAT, 200, -1},

      {FFGRACE.ENT.POPCAP_CLUSTER.id, FFGRACE.ENT.POPCAP_CLUSTER.variant, -1},
      {FFGRACE.ENT.MUD_FLY.id, FFGRACE.ENT.MUD_FLY.variant, -1},
      {FFGRACE.ENT.ROBERT.id, FFGRACE.ENT.ROBERT.variant, -1},
      {FFGRACE.ENT.BUMBLEBAT.id, FFGRACE.ENT.BUMBLEBAT.variant, -1},

      {160, 320, -1}, --ff milk tooth, im not adding specific code to check if ff is installed just use the enums
      {666, 40, -1}, --ff foamy

    }

    FFGRACE.SkeeterEntData["RestoredMonsterPack"] = {
      [EntityType.ENTITY_CUTMONSTERS.." "..CutMonsterVariants.STILLBORN] = "Hard",
      [EntityType.ENTITY_BRIMSTONE_HEAD.." "..EntityVariant.FIRE_GRIMACE] = "Hard",

      -- [EntityType.ENTITY_CUTMONSTERS.." "..CutMonsterVariants.SPLASHY.." "..CutMonsterVariants.STICKY] = "Tar", --doesnt accept subtype yet

      [EntityType.ENTITY_DUMPLING.." "..CutMonsterVariants.SCORCHLING] = "Fire",

      -- [EntityType.ENTITY_CUTMONSTERS.." "..CutMonsterVariants.ECHO_BAT.." "..CutMonsterVariants.CHUBBY_BUNNY] = "Spore",
      [EntityType.ENTITY_CUTMONSTERS.." "..CutMonsterVariants.ECHO_BAT] = "Spore",  --doesnt accept subtype yet
      [EntityType.ENTITY_BLIND_BAT.." "..EntityVariant.BEARD_BAT] = "Spore",
      [EntityType.ENTITY_DUMPLING.." "..EntityVariant.SPORELING] = "Spore",

      [EntityType.ENTITY_CUTMONSTERS.." "..CutMonsterVariants.RED_TNT] = "Blacklisted",
    }
    for key, entry in pairs(FFGRACE.SkeeterEntData["RestoredMonsterPack"]) do
      FFGRACE.SkeeterEntData[key] = entry
    end

  else
    mod.CompatibilityReplace = {
      [EntityType.ENTITY_DUMPLING.." "..EntityVariant.SPORELING] = {EntityType.ENTITY_DUMPLING, EntityVariant.SKINLING, -1},
      [EntityType.ENTITY_CUTMONSTERS.." "..CutMonsterVariants.ECHO_BAT.." "..CutMonsterVariants.CHUBBY_BUNNY] = {EntityType.ENTITY_CUTMONSTERS, CutMonsterVariants.ECHO_BAT, -1},
      [EntityType.ENTITY_BLIND_BAT.." "..EntityVariant.BEARD_BAT] = {EntityType.ENTITY_BLIND_BAT, 200, -1},
    }
  end