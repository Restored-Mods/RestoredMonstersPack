local mod = RestoredMonsterPack
if TheFuture then

    mod.ScreenwrapWhitelist = {
        {ID = 839}, --strifer grrr
    }

    table.insert(TheFuture.Rooms.Future,include("resources.luarooms.thefuture.future_cvs"))
    table.insert(TheFuture.ScreenwrapWhitelist, {ID = 839, Var=200})

    print("Future Rooms Compat Loaded")
end