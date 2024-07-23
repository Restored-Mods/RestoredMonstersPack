local mod = RestoredMonsterPack
local game = Game()
local json = require("json")

local DSSModName = "RestoredMonsterPack Mod DSS Menu"

local DSSCoreVersion = 7

local MenuProvider = {}

function MenuProvider.SaveSaveData()
	mod:SaveModData()
end

function MenuProvider.GetPaletteSetting()
	return RestoredMonsterPack.savedata.MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
	RestoredMonsterPack.savedata.MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
	if not REPENTANCE then
		return RestoredMonsterPack.savedata.HudOffset
	else
		return Options.HUDOffset * 10
	end
end

function MenuProvider.SaveHudOffsetSetting(var)
	if not REPENTANCE then
		RestoredMonsterPack.savedata.HudOffset = var
	end
end

function MenuProvider.GetGamepadToggleSetting()
	return RestoredMonsterPack.savedata.GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
	RestoredMonsterPack.savedata.GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
	return RestoredMonsterPack.savedata.MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
	RestoredMonsterPack.savedata.MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
	return RestoredMonsterPack.savedata.MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
	RestoredMonsterPack.savedata.MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
	return RestoredMonsterPack.savedata.MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
	RestoredMonsterPack.savedata.MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
	return RestoredMonsterPack.savedata.MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
	RestoredMonsterPack.savedata.MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
	return RestoredMonsterPack.savedata.MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
	RestoredMonsterPack.savedata.MenusPoppedUp = var
end
local DSSInitializerFunction = include("scripts.deadseascrolls.dssmenucore")
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)


local restoreddirectory = {
    main = {
        title = 'restored monsters',

        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'settings', dest = 'settings',tooltip = {strset = {'---','play around', 'with what', 'you like and', 'do not like', '---'}}},
            dssmod.changelogsButton,
            {str = '', nosel = true},
            {str = 'restored monster pack:',fsize=2, nosel = true},
            {str = 'bringing back your', fsize=2,nosel = true},
            {str = 'favorite foes since 2023', fsize=2,nosel = true},
            {str = '', fsize=2,nosel = true},
            {str = 'play us with', fsize=2,nosel = true},
            {str = 'fiend folio, the future', fsize=2,nosel = true},
            {str = 'revelations, and more!', fsize=2,nosel = true},
        },
        tooltip = dssmod.menuOpenToolTip,
    },

    settings =  {
            title = 'settings',
                buttons = {
                    {str = 'enemies', nosel = true},
                    {str = '----------', fsize=2, nosel = true},
                    {str = 'vessels', nosel = true},
                    {
                        str = 'vessel type',
                        fsize=2,
                        choices = {'normal', 'legacy'},
                        variable = "vesselType",
                        setting = 1,
                        load = function()
                            return mod.vesselType or 1
                        end,
                        store = function(var)
                            mod.vesselType = var
                        end,
                        tooltip = {strset = {'replaces', 'vessels with', 'their legacy', 'version','','disabled by', 'default'}}
        
                    },
                    {str = '', fsize=2, nosel = true},
                    {str = 'echo bat', nosel = true},
                    {
                        str = 'scream effect',
                        fsize=2,
                        increment = 1, max = 5,
                        variable = "blindBatScreamInc",
                        slider = true,
                        setting = 3,
                        load = function()
                            return mod.blindBatScreamInc or 3
                        end,
                        store = function(var)
                            mod.blindBatScreamInc = var
                        end,
                        tooltip = {strset = {'changes how', 'strong the', 'blind bat','effect is','','at 3 by', 'default'}}
        
                    },
                }
    },

}

local restoreddirectorykey = {
    Item = restoreddirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Restored Monsters", {Run = dssmod.runMenu, Open = dssmod.openMenu, Close = dssmod.closeMenu, Directory = restoreddirectory, DirectoryKey = restoreddirectorykey})



function mod:IsSettingOn(setting)
	if setting == 1 then
		return true
	else
		return false
	end
end