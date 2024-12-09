local mod = RestoredMonsterPack

function mod:DelayedInit()
    mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, mod.DelayedInit)
if TheFuture then

    mod.ScreenwrapWhitelist = {
        {ID = 839}, --strifer grrr
    }

    table.insert(TheFuture.Rooms.Future,include("resources.luarooms.thefuture.future_cvs"))
    table.insert(TheFuture.ScreenwrapWhitelist, {ID = 839, Var=201})
    
    print("Future Rooms Compat Loaded")
end

end
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.DelayedInit)