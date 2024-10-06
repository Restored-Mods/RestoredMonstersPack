local mod = RestoredMonsterPack

if FiendFolio then

function mod:SpecialEnt(name)
	return {Isaac.GetEntityTypeByName(name), Isaac.GetEntityVariantByName(name), Isaac.GetEntitySubTypeByName(name)} --no repentagon fuck it
end


RestoredMonsterPack.Nonmale = {
	{ID = mod:SpecialEnt("Splashy Long Legs"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Sticky Long Legs"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Tainted Dumpling"), Affliction = "Woman"}, --fuck it
	{ID = mod:SpecialEnt("Scab"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Mortling"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Fracture"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Echo Bat"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Foreigner"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Screamer"), Affliction = "Trans"},
	--{ID = {Isaac.GetEntityTypeByName("Cell"), Isaac.GetEntityVariantByName("Cell")}, Affliction = "Woman"}, --Cell BC WESTRVN SAID SO ):
	{ID = mod:SpecialEnt("Fused Cell"), Affliction = "Woman"},
	--{ID = {Isaac.GetEntityTypeByName("Tissue"), Isaac.GetEntityVariantByName("Tissue")}, Affliction = "Woman"}, --Tissue ALSO BC WESTRVN SAID SO ):
	{ID = mod:SpecialEnt("Grave Robber"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Strifer"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Vessel (Antibirth)"), Affliction = "Woman"},
	{ID = mod:SpecialEnt("Chubby Bunny"), Affliction = "Woman"},
	-- {ID = mod:SpecialEnt("Beard Bat"), Affliction = "Non-Binary"},
}

RestoredMonsterPack.LGBTQIA = {
	{ID = mod:SpecialEnt("Dumpling"), Affliction = "Ace"},
	{ID = mod:SpecialEnt("Mortling"), Affliction = "Ace"},
	{ID = mod:SpecialEnt("Corpse Eater"), Affliction = "Bi"},
	{ID = mod:SpecialEnt("Gilded Dumpling"), Affliction = "Gay"}, --bc pandora said they're gay as actual fuck
	{ID = mod:SpecialEnt("Sporeling"), Affliction = "Ace"},
	{ID = mod:SpecialEnt("Chubby Bunny"), Affliction = "Trans"},
	-- {ID = mod:SpecialEnt("Beard Bat"), Affliction = "Trans"},
}

function mod.MixFiendFolioStuff()
	mod:MixTables(FiendFolio.Nonmale, RestoredMonsterPack.Nonmale)
	mod:MixTables(FiendFolio.LGBTQIA, RestoredMonsterPack.LGBTQIA)
	mod.fiendfolioTablesMixed = true
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if not mod.fiendfolioTablesMixed then
		mod.MixFiendFolioStuff()
	end
end)

-- mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
-- 	for i = 1, #FiendFolio.LGBTQIA do
-- 		if FiendFolio.LGBTQIA[i].ID
-- 		and (npc.Type == FiendFolio.LGBTQIA[i].ID[1])
-- 		and ((not FiendFolio.LGBTQIA[i].ID[2]) or npc.Variant == FiendFolio.LGBTQIA[i].ID[2])
-- 		and ((not FiendFolio.LGBTQIA[i].ID[3]) or npc.SubType == FiendFolio.LGBTQIA[i].ID[3])
-- 		then
-- 			Isaac.RenderText(FiendFolio.LGBTQIA[i].Affliction, Isaac.WorldToScreen(npc.Position).X - 15,Isaac.WorldToScreen(npc.Position).Y-10,1,.3,1,1)
-- 		end
-- 	end
-- 	for i = 1, #FiendFolio.Nonmale do
-- 		if FiendFolio.Nonmale[i].ID
-- 		and (npc.Type == FiendFolio.Nonmale[i].ID[1])
-- 		and ((not FiendFolio.Nonmale[i].ID[2]) or npc.Variant == FiendFolio.Nonmale[i].ID[2])
-- 		and ((not FiendFolio.Nonmale[i].ID[3]) or npc.SubType == FiendFolio.Nonmale[i].ID[3])
-- 		then
-- 			Isaac.RenderText(FiendFolio.Nonmale[i].Affliction, Isaac.WorldToScreen(npc.Position).X - 15,Isaac.WorldToScreen(npc.Position).Y,1,.3,1,1)
-- 		end
-- 	end
-- end)

end