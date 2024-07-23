local mod = RestoredMonsterPack
local json = require("json")

--who tf didn't think of this
RestoredMonsterPack.savedata = RestoredMonsterPack.savedata or {}
function RestoredMonsterPack.SaveModData()
    RestoredMonsterPack.savedata.config = {
        vesselType = RestoredMonsterPack.vesselType,
        blindBatScreamInc = RestoredMonsterPack.blindBatScreamInc,
    }
    Isaac.SaveModData(mod, json.encode(RestoredMonsterPack.savedata))
end

function RestoredMonsterPack.LoadModData()
    if not mod:HasData() then
        RestoredMonsterPack.SaveModData()
        print("Restored Monster Pack Data Initialized! Have a wonderful run!!")
    else
        RestoredMonsterPack.savedata = json.decode(mod:LoadData())

        local config = RestoredMonsterPack.savedata.config
        if config then
            RestoredMonsterPack.vesselType = config.vesselType or RestoredMonsterPack.vesselType
            RestoredMonsterPack.blindBatScreamInc = config.blindBatScreamInc or RestoredMonsterPack.blindBatScreamInc
        end
    end
end

RestoredMonsterPack.LoadModData()

RestoredMonsterPack:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	Isaac.DebugString("RestoredMonsterPack: PreExitPreSave")
    RestoredMonsterPack.SaveModData()
	Isaac.DebugString("RestoredMonsterPack: PreExitPostSave")
    RestoredMonsterPack.gamestarted = true
end)

RestoredMonsterPack:AddCallback(ModCallbacks.MC_POST_GAME_END, function()
    RestoredMonsterPack.gamestarted = false
end)

RestoredMonsterPack:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if RestoredMonsterPack.gamestarted then --so that we dont fuck up saves across floors
        RestoredMonsterPack.SaveModData() 
    end
end)