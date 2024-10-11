local c = include("scripts.compatibility.retribution.rm_entities")
local vc = include("scripts.compatibility.retribution.vanilla_entities")



local data = {
    {c.Dumpling,		c.Skinling},
    {c.Dumpling,		c.Scorchling},
    {c.Skinling,		c.Scab},
    {c.Scab,		c.Mortling},
    {c.Mortling,		c.TaintedDumpling},
    {c.Scorchling,		c.Skinling},
    {vc.Level2Spider,          c.FractureRM},
    {c.FractureRM,          vc.Ragling},
    {c.FractureRM,          vc.Blister},
    {vc.Baby,          c.Stillborn},
    {vc.OneTooth,          c.EchoBat},
    {vc.FatBat,          c.EchoBat},
    {vc.Fanatic,          c.Necromancer},
    {c.Swapper,          vc.AngelicBaby},
    {vc.BigBony,          c.Barfy},
    {vc.Quakey,          c.Barfy},
    {c.Barfy,          vc.GuttedFatty},
    {vc.LooseKnight,          c.Screamer},
    {vc.SelflessKnight,          c.Screamer},
    {c.Cell,          c.FusedCells},
    {c.FusedCells,          vc.Poofer},
    {vc.CrazyLongLegs,          c.SplashyLongLegs},
    {c.SplashyLongLegs,          c.StickyLongLegs},
    {vc.BigBony,          c.VesselRM},
    {c.VesselRM,          vc.GuttedFatty},
    -- {c.CorpseEater,        c.CarrionRider}, Too wacky
    -- {vc.Grub,        c.CorpseEater},
    {vc.RageCreep,          c.SplitRageCreep},
    {vc.WallCreep,          c.RagCreep},
    {c.BlindBat,          vc.FatBat},
    {c.Strifer,          vc.MazeRoamer},
    {vc.Cyclopia,          c.Strifer},
    {c.VesselAntibirth,          c.GildedDumpling},
    
}

for _, dataset in pairs(data) do
    BaptismalPreloader.AddAntibaptismalData(dataset[1], {BaptismalPreloader.GenerateTransformationDataset(dataset[2])})
end