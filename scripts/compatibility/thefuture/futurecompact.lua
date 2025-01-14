local mod = RestoredMonsterPack

local FutureRooms = require("resources.luarooms.thefuture.future_rm")
local FutureChallengeRooms = require("resources.luarooms.thefuture.future_challenge_rm")
local FutureBeggarRooms = require("resources.luarooms.thefuture.future_stevenbeggars_rm")

function mod:DelayedInit()
    mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, mod.DelayedInit)
if TheFuture then

    mod.ScreenwrapWhitelist = {
        {ID = 839}, --strifer grrr
    }
    
    TheFuture.WarpPipeEdible[839] = {[201] = true}

    table.insert(TheFuture.ScreenwrapWhitelist, {ID = 839, Var=201})
    
    table.insert(TheFuture.Rooms.Future, FutureRooms)
    table.insert(TheFuture.Rooms.FutureChallenge, FutureChallengeRooms)
    table.insert(TheFuture.Rooms.FutureBeggar, FutureBeggarRooms)
end

end
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.DelayedInit)