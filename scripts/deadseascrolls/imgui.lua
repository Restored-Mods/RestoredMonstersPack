if not REPENTOGON then return end
local mod = RestoredMonsterPack

-- ImGui menu
if not ImGui.ElementExists("RestoredMods") then
    ImGui.CreateMenu("RestoredMods", "Restored Mods")
end

-- Restored Monsters menu
if not ImGui.ElementExists("RRestoredMonsters") then
    ImGui.AddElement("RestoredMods", "RRestoredMonsters", ImGuiElement.MenuItem, "Restored Monsters")
end

-- Restored Monsters window
if not ImGui.ElementExists("RRestoredMonstersWindow") then
    ImGui.CreateWindow("RRestoredMonstersWindow", "Restored Monsters")
end
ImGui.LinkWindowToElement("RRestoredMonstersWindow", "RRestoredMonsters")

-- Check for existing tab bar
if ImGui.ElementExists("RRestoredMonstersTabs") then
    ImGui.RemoveElement("RRestoredMonstersTabs")
end

-- Restred Monsters tab bar
ImGui.AddTabBar("RRestoredMonstersWindow", "RRestoredMonstersTabs")

-- Vessels tab
ImGui.AddTab("RRestoredMonstersTabs", "RRestoredMonstersTabVessel", "Vessels")

-- Vessel type
ImGui.AddCombobox("RRestoredMonstersTabVessel", "RRestoredMonstersTabVesselType", "Vessel type", 
function(index, str)
    mod.vesselType = index + 1
end, {"Normal", "Legacy"}, 0, true)
ImGui.SetHelpmarker("RRestoredMonstersTabVesselType", "Replaces vessels with their legacy version.\nDisabled by default.")

-- Echo bats tab
ImGui.AddTab("RRestoredMonstersTabs", "RRestoredMonstersTabBlindBat", "Echo bats")

ImGui.AddSliderInteger("RRestoredMonstersTabBlindBat", "RRestoredMonstersTabBlindBatScream", "Scream effect",
function(val)
    mod.blindBatScreamInc = val
end, 3, 1, 5)

ImGui.SetHelpmarker("RRestoredMonstersTabBlindBatScream", "Changes how strong the blind bat effect is.\nAt 3 by default.")

ImGui.AddCallback("RRestoredMonstersWindow", ImGuiCallback.Render, function()
    ImGui.UpdateData("RRestoredMonstersTabVesselType", ImGuiData.Value, mod.vesselType - 1)
    ImGui.UpdateData("RRestoredMonstersTabBlindBatScream", ImGuiData.Value, mod.blindBatScreamInc)
end)