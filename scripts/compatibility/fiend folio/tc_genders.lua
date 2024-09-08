local mod = RestoredMonsterPack

if FiendFolio then

function mod:SpecialEnt(name)
	return {Isaac.GetEntityTypeByName(name), Isaac.GetEntityVariantByName(name)} --no repentagon fuck it
end


RestoredMonsterPack.Nonmale = {
	{ID = mod:SpecialEnt("Splashy Long Legs"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Sticky Long Legs"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Dumpling"), Affliction = "Ace"},
	{ID = mod:SpecialEnt("Tainted Dumpling"), Affliction = "Woman"}, --fuck it
	{ID = mod:SpecialEnt("Scab"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Mortling"), Affliction = "Ace"},
	{ID = mod:SpecialEnt("Fracture"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Echo Bat"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Corpse Eater"), Affliction = "Bi"},
	{ID = mod:SpecialEnt("Foreigner"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Screamer"), Affliction = "Trans"},
	--{ID = {Isaac.GetEntityTypeByName("Cell"), Isaac.GetEntityVariantByName("Cell")}, Affliction = "Woman"}, --Cell BC WESTRVN SAID SO ):
	{ID = mod:SpecialEnt("Fused Cell"), Affliction = "Woman"},
	--{ID = {Isaac.GetEntityTypeByName("Tissue"), Isaac.GetEntityVariantByName("Tissue")}, Affliction = "Woman"}, --Tissue ALSO BC WESTRVN SAID SO ):
	{ID = mod:SpecialEnt("Grave Robber"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Strifer"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Vessel (Antibirth)"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Gilded Dumpling"), Affliction = "Gay"}, --bc pandora said they're gay as actual fuck
	-- {ID = mod:SpecialEnt("Sporeling"), Affliction = "Ace"}, uncomment this when its are added to entities2.lua
	-- {ID = mod:SpecialEnt("Chubby Bunny"), Affliction = "Trans"},  uncomment this when its are added to entities2.lua
}

function mod:MixTables(input, table)
    if input and table then
        for k, v in pairs(table) do
            if type(input[k]) == "table" and type(v) == "table" then
                mod:MixTables(input[k], v)
            else
                input[k] = v
            end
        end
    end
end

function mod.MixFiendFolioStuff()
	mod:MixTables(FiendFolio.Nonmale, RestoredMonsterPack.Nonmale)
	mod.fiendfolioTablesMixed = true
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if not mod.fiendfolioTablesMixed then
		mod.MixFiendFolioStuff()
	end
end)

end

