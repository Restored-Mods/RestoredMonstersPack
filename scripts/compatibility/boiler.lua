if FFGRACE then
    local basepath = "gfx/monsters/"

    FFGRACE.StageSkins.Boiler[EntityType.ENTITY_DUMPLING.." "..0] = {
                {{0}, basepath.."boiler/800.000_dumpling"},
            }
            
    table.insert(FFGRACE.Rooms.Boiler, include("resources.luarooms.ffg.boiler_tc"))
    table.insert(FFGRACE.Rooms.BoilerChallenge, include("resources.luarooms.ffg.boiler_tc_challenge"))
    table.insert(FFGRACE.Rooms.BoilerWhiteFire, include("resources.luarooms.ffg.boiler_tc_fire"))
    if FiendFolio then
      table.insert(FFGRACE.Rooms.Boiler, include("resources.luarooms.ffg.boiler_tc_ff"))
    end
    
    StageAPI.GetBossData("FFGRACE Creem").Rooms:AddRooms(require("resources.luarooms.ffg.bosses.boiler_tc_creem"))
end