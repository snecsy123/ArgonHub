--[[
    ================================================================================
    ARGON HUB v3.0 | NEXT-GEN MULTI-LAYOUT ANIMATION & EMOTE STUDIO
    Repository : https://github.com/snecsy123/ArgonHub
    Audio Sync : assets/audio/startup.mp3
    Layouts    : 1. Top Ribbon (Drawing 1) | 2. Floating Dock (Drawing 2) | 3. Split Studio (Drawing 3)
    ================================================================================
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ================================================================================
-- 1. CENTRALIZED CONFIGURATION (MATCHED TO snecsy123/ArgonHub)
-- ================================================================================
local Config = {
    HubName = "ARGON",
    Version = "STUDIO v3.0",
    ToggleKey = Enum.KeyCode.RightControl,
    AltToggleKey = Enum.KeyCode.V,

    GitHubBaseURL = "https://raw.githubusercontent.com/snecsy123/ArgonHub/main/",
    CacheFolder = "ArgonHub_V3_Cache",
    SaveFile = "ArgonHub_V3_Cache/settings_and_favs.json",

    Assets = {
        -- Branding Logos inside assets/branding/
        Logo_Default   = { Path = "assets/branding/logo_default.png",   Fallback = "rbxassetid://10709791437" },
        Logo_Halloween = { Path = "assets/branding/logo_halloween.png", Fallback = "rbxassetid://10709791437" },
        Logo_Christmas = { Path = "assets/branding/logo_christmas.png", Fallback = "rbxassetid://10709791437" },

        -- Startup Audio inside assets/audio/startup.mp3 (Matched to your GitHub screenshot!)
        SFX_Startup    = { Path = "assets/audio/startup.mp3",           Fallback = "rbxassetid://9125402735" },
        SFX_Click      = { Path = "assets/audio/click.mp3",             Fallback = "rbxassetid://6895079853" },
        SFX_Hover      = { Path = "assets/audio/tab.mp3",               Fallback = "rbxassetid://6042053626" },
        SFX_Pin        = { Path = "assets/audio/pin.mp3",               Fallback = "rbxassetid://3125624765" },

        -- Crisp Vector Icons
        Icon_Home      = { Path = "assets/icons/tab_main.png",          Fallback = "rbxassetid://10723407389" },
        Icon_Emotes    = { Path = "assets/icons/tab_emotes.png",        Fallback = "rbxassetid://10734950309" },
        Icon_Bundles   = { Path = "assets/icons/tab_bundles.png",       Fallback = "rbxassetid://10709782497" },
        Icon_Favs      = { Path = "assets/icons/tab_favorites.png",     Fallback = "rbxassetid://10734966248" },
        Icon_Settings  = { Path = "assets/icons/tab_settings.png",      Fallback = "rbxassetid://10734950020" },
        Icon_Search    = { Path = "assets/icons/search.png",            Fallback = "rbxassetid://10734943676" },
        Icon_Star      = { Path = "assets/icons/star_on.png",           Fallback = "rbxassetid://10734966248" },
        Icon_Chevron   = { Path = "assets/icons/chevron.png",           Fallback = "rbxassetid://10709790948" }
    },

    Themes = {
        Default = {
            Name = "Argon Obsidian",
            LogoKey = "Logo_Default",
            BgOuter = Color3.fromRGB(9, 10, 14),
            BgSurface = Color3.fromRGB(14, 16, 22),
            BgInset = Color3.fromRGB(11, 12, 17),
            CardBg = Color3.fromRGB(19, 22, 30),
            CardHover = Color3.fromRGB(26, 30, 42),
            Accent = Color3.fromRGB(245, 247, 255),
            AccentSecondary = Color3.fromRGB(99, 102, 241),
            Glow = Color3.fromRGB(129, 140, 248),
            TextPrimary = Color3.fromRGB(248, 250, 252),
            TextDim = Color3.fromRGB(130, 138, 158),
            Stroke = Color3.fromRGB(36, 40, 54),
            StrokeBright = Color3.fromRGB(75, 85, 115)
        },
        Halloween = {
            Name = "Halloween Phantom",
            LogoKey = "Logo_Halloween",
            BgOuter = Color3.fromRGB(10, 8, 12),
            BgSurface = Color3.fromRGB(16, 12, 20),
            BgInset = Color3.fromRGB(12, 9, 15),
            CardBg = Color3.fromRGB(22, 16, 27),
            CardHover = Color3.fromRGB(32, 22, 38),
            Accent = Color3.fromRGB(255, 115, 22),
            AccentSecondary = Color3.fromRGB(168, 85, 247),
            Glow = Color3.fromRGB(255, 100, 0),
            TextPrimary = Color3.fromRGB(255, 247, 240),
            TextDim = Color3.fromRGB(156, 136, 150),
            Stroke = Color3.fromRGB(52, 32, 46),
            StrokeBright = Color3.fromRGB(255, 115, 22)
        },
        Christmas = {
            Name = "Winter Aurora",
            LogoKey = "Logo_Christmas",
            BgOuter = Color3.fromRGB(8, 13, 15),
            BgSurface = Color3.fromRGB(12, 19, 22),
            BgInset = Color3.fromRGB(9, 15, 18),
            CardBg = Color3.fromRGB(17, 26, 30),
            CardHover = Color3.fromRGB(24, 37, 42),
            Accent = Color3.fromRGB(46, 213, 115),
            AccentSecondary = Color3.fromRGB(235, 77, 75),
            Glow = Color3.fromRGB(56, 189, 248),
            TextPrimary = Color3.fromRGB(242, 252, 248),
            TextDim = Color3.fromRGB(132, 158, 152),
            Stroke = Color3.fromRGB(30, 50, 54),
            StrokeBright = Color3.fromRGB(46, 213, 115)
        }
    }
}

-- ================================================================================
-- 2. COMPLETE ALL-BUNDLES & VERIFIED EMOTE MASTER REGISTRY
-- ================================================================================
local BundleDatabase = {
    { Name = "Astronaut",     BundleId = 31,  Parts = { Idle = {891621366, 891633237}, Walk = {891667138}, Run = {891636393}, Jump = {891627522}, Fall = {891617961}, Climb = {891609353}, Swim = {891639666} } },
    { Name = "Bubbly",        BundleId = 33,  Parts = { Idle = {910004836, 910009958}, Walk = {910034870}, Run = {910025107}, Jump = {910016857}, Fall = {910001910}, Climb = {909997997}, Swim = {910028158} } },
    { Name = "Cartoony",      BundleId = 35,  Parts = { Idle = {742637544, 742638445}, Walk = {742640026}, Run = {742638842}, Jump = {742637942}, Fall = {742637151}, Climb = {742636889}, Swim = {742639220} } },
    { Name = "Elder",         BundleId = 37,  Parts = { Idle = {845397899, 845400520}, Walk = {845403856}, Run = {845386501}, Jump = {845398858}, Fall = {845396048}, Climb = {845392038}, Swim = {845401742} } },
    { Name = "Knight",        BundleId = 41,  Parts = { Idle = {657595757, 657568135}, Walk = {657552124}, Run = {657564596}, Jump = {658409194}, Fall = {657600338}, Climb = {658360781}, Swim = {657560551} } },
    { Name = "Levitation",    BundleId = 47,  Parts = { Idle = {616006778, 616008087}, Walk = {616013216}, Run = {616010382}, Jump = {616008936}, Fall = {616005863}, Climb = {616003713}, Swim = {616011509} } },
    { Name = "Mage",          BundleId = 39,  Parts = { Idle = {707742142, 707855907}, Walk = {707897309}, Run = {707861613}, Jump = {707853694}, Fall = {707829716}, Climb = {707826056}, Swim = {707876443} } },
    { Name = "Ninja",         BundleId = 43,  Parts = { Idle = {656117400, 656118341}, Walk = {656121766}, Run = {656118852}, Jump = {656117878}, Fall = {656115606}, Climb = {656114359}, Swim = {656119721} } },
    { Name = "OldSchool",     BundleId = 667, Parts = { Idle = {5319828216, 5319831086}, Walk = {5319847204}, Run = {5319844329}, Jump = {5319841935}, Fall = {5319839762}, Climb = {5319816685}, Swim = {5319850266} } },
    { Name = "Pirate",        BundleId = 45,  Parts = { Idle = {750781874, 750782770}, Walk = {750785693}, Run = {750783738}, Jump = {750782230}, Fall = {750780242}, Climb = {750779899}, Swim = {750784579} } },
    { Name = "Robot",         BundleId = 53,  Parts = { Idle = {616088211, 616089559}, Walk = {616095330}, Run = {616091570}, Jump = {616090535}, Fall = {616087089}, Climb = {616086039}, Swim = {616092998} } },
    { Name = "Rthro",         BundleId = 238, Parts = { Idle = {2510196951, 2510197257}, Walk = {2510202577}, Run = {2510198475}, Jump = {2510197830}, Fall = {2510195892}, Climb = {2510192778}, Swim = {2510199791} } },
    { Name = "Stylish",       BundleId = 61,  Parts = { Idle = {616136790, 616138447}, Walk = {616146177}, Run = {616140816}, Jump = {616139451}, Fall = {616134815}, Climb = {616133594}, Swim = {616143378} } },
    { Name = "Superhero",     BundleId = 49,  Parts = { Idle = {616111295, 616113536}, Walk = {616122287}, Run = {616117076}, Jump = {616115533}, Fall = {616108001}, Climb = {616104706}, Swim = {616119360} } },
    { Name = "Toy",           BundleId = 55,  Parts = { Idle = {782841498, 782845736}, Walk = {782843345}, Run = {782842708}, Jump = {782847020}, Fall = {782846423}, Climb = {782843869}, Swim = {782844582} } },
    { Name = "Vampire",       BundleId = 57,  Parts = { Idle = {1083445855, 1083450166}, Walk = {1083473930}, Run = {1083462077}, Jump = {1083455352}, Fall = {1083443587}, Climb = {1083439238}, Swim = {1083464683} } },
    { Name = "Werewolf",      BundleId = 59,  Parts = { Idle = {1083195517, 1083214717}, Walk = {1083178339}, Run = {1083216690}, Jump = {1083218792}, Fall = {1083189019}, Climb = {1083182000}, Swim = {1083222527} } },
    { Name = "Zombie",        BundleId = 51,  Parts = { Idle = {616158929, 616160636}, Walk = {616168032}, Run = {616163682}, Jump = {616161997}, Fall = {616157476}, Climb = {616156119}, Swim = {616165109} } },
    { Name = "Confident",     BundleId = 598, Parts = { Idle = {1069977950, 1069987858}, Walk = {1070017263}, Run = {1070001516}, Jump = {1069984524}, Fall = {1069973677}, Climb = {1069946257}, Swim = {1070009914} } },
    { Name = "Popstar",       BundleId = 602, Parts = { Idle = {1212900985, 1212900985}, Walk = {1212980338}, Run = {1212980348}, Jump = {1212954642}, Fall = {1212900995}, Climb = {1213044953}, Swim = {1212852603} } },
    { Name = "Princess",      BundleId = 604, Parts = { Idle = {941003647, 941013098}, Walk = {941028902}, Run = {941015281}, Jump = {941008832}, Fall = {941000007}, Climb = {940996062}, Swim = {941018893} } },
    { Name = "Patrol",        BundleId = 600, Parts = { Idle = {1149612882, 1150842221}, Walk = {1151231493}, Run = {1150967949}, Jump = {1150944216}, Fall = {1148863382}, Climb = {1148811837}, Swim = {1151204998} } },
    { Name = "Sneakerhead",   BundleId = 606, Parts = { Idle = {1132473842, 1132477671}, Walk = {1132510133}, Run = {1132494274}, Jump = {1132489853}, Fall = {1132469004}, Climb = {1132461372}, Swim = {1132500520} } },
    { Name = "Bold",          BundleId = 1925,Parts = { Idle = {16738333868, 16738334710}, Walk = {16738340646}, Run = {16738337225}, Jump = {16738336650}, Fall = {16738333171}, Climb = {16738332169}, Swim = {16738339158} } }
}

local EmoteDatabase = {
    { Name = "Salute",            CatalogId = 3360689775, AnimId = 3333474484 },
    { Name = "Stadium",           CatalogId = 3360686498, AnimId = 3333136415 },
    { Name = "Tilt",              CatalogId = 3360692915, AnimId = 3334538554 },
    { Name = "Shrug",             CatalogId = 3576968026, AnimId = 3334392772 },
    { Name = "Hello",             CatalogId = 3576686446, AnimId = 3344650532 },
    { Name = "Point2",            CatalogId = 3576823880, AnimId = 3344585679 },
    { Name = "Twirl",             CatalogId = 3716636630, AnimId = 3334968680 },
    { Name = "Jacks",             CatalogId = 3716633898, AnimId = 3338066331 },
    { Name = "T Pose",            CatalogId = 3762654854, AnimId = 3338010159 },
    { Name = "Robot",             CatalogId = 3762641826, AnimId = 3338025566 },
    { Name = "Godlike",           CatalogId = 3823158750, AnimId = 3337994105 },
    { Name = "Bodybuilder",       CatalogId = 3994127840, AnimId = 3338042785 },
    { Name = "Air Guitar",        CatalogId = 3994129128, AnimId = 3695300085 },
    { Name = "Cha Cha",           CatalogId = 3695333486, AnimId = 3695322025 },
    { Name = "Line Dance",        CatalogId = 4049037604, AnimId = 4049037604 },
    { Name = "Idol",              CatalogId = 4102315500, AnimId = 4101966434 },
    { Name = "Around Town",       CatalogId = 3576717965, AnimId = 3303391864 },
    { Name = "Top Rock",          CatalogId = 3570535774, AnimId = 3361276673 },
    { Name = "Fashionable",       CatalogId = 3576745472, AnimId = 3333331310 },
    { Name = "Heel Click",        CatalogId = 3716632249, AnimId = 3319602808 },
    { Name = "Happy",             CatalogId = 4841405708, AnimId = 4841397952 },
    { Name = "Sad",               CatalogId = 4841407203, AnimId = 4841403964 },
    { Name = "Dizzy",             CatalogId = 3934966185, AnimId = 3361426436 },
    { Name = "Sleep",             CatalogId = 4686925579, AnimId = 4686925579 },
    { Name = "Cower",             CatalogId = 4940563117, AnimId = 4940563117 },
    { Name = "Hero Landing",      CatalogId = 5104344710, AnimId = 5104341999 },
    { Name = "Confused",          CatalogId = 4940561610, AnimId = 4940561610 },
    { Name = "Jumping Wave",      CatalogId = 4940564896, AnimId = 4940564896 },
    { Name = "Keeping Time",      CatalogId = 4555808220, AnimId = 4555782893 },
    { Name = "Dorky Dance",       CatalogId = 4212455378, AnimId = 4212455378 },
    { Name = "Floss Dance",       CatalogId = 5917570207, AnimId = 5917459365 },
    { Name = "Dolphin Dance",     CatalogId = 5937558680, AnimId = 5918726674 },
    { Name = "Applause",          CatalogId = 5915779043, AnimId = 5915693819 },
    { Name = "Country Line",      CatalogId = 5915781665, AnimId = 5915712534 },
    { Name = "Panini Dance",      CatalogId = 5915773155, AnimId = 5915713518 },
    { Name = "Rodeo Dance",       CatalogId = 5918728267, AnimId = 5918728267 },
    { Name = "Holiday Dance",     CatalogId = 5937560570, AnimId = 5937560570 },
    { Name = "Rock On",           CatalogId = 5915782672, AnimId = 5915714366 },
    { Name = "V Pose",            CatalogId = 10214406616, AnimId = 10214311282 },
    { Name = "Hype Dance",        CatalogId = 10714360164, AnimId = 10713981723 },
    { Name = "sturdy Dance",      CatalogId = 12507097350, AnimId = 12507085924 },
    { Name = "Griddy / Victory",  CatalogId = 13071993910, AnimId = 13071993910 },
    { Name = "Frosty Flair",      CatalogId = 10214418283, AnimId = 10214319518 },
    { Name = "Elton John Piano",  CatalogId = 11453096488, AnimId = 11453096488 },
    { Name = " Tommy Hilfiger",   CatalogId = 10275057230, AnimId = 10275057230 },
    { Name = "Sidekicks",         CatalogId = 10370362157, AnimId = 10370362157 },
    { Name = "Floor Rock",        CatalogId = 10714340543, AnimId = 10714340543 },
    { Name = "samba",             CatalogId = 6869813008,  AnimId = 6869766134 }
}

-- ================================================================================
-- 3. CLEANUP PREVIOUS INSTANCES & INITIALIZE STATE
-- ================================================================================
local GuiParent = (gethui and gethui()) or CoreGui
for _, old in ipairs({ "ArgonHub_Studio", "ArgonHub_V2", "ArgonHub_V3" }) do
    if GuiParent:FindFirstChild(old) then
        GuiParent:FindFirstChild(old):Destroy()
    end
end
if Lighting:FindFirstChild("ArgonDepthBlur") then
    Lighting:FindFirstChild("ArgonDepthBlur"):Destroy()
end

local State = {
    IsOpen = false,
    IsAnimating = false,
    CurrentLayout = 1, -- 1 = Top Ribbon (Drawing 1), 2 = Floating Dock (Drawing 2), 3 = Split Studio (Drawing 3)
    CurrentTab = "Emotes",
    CurrentThemeKey = "Default",
    StopEmoteOnMove = true,
    LoopEmotes = true,
    EmoteSpeed = 1.0,
    ActiveEmoteTrack = nil,
    ActiveEmoteName = "None",
    ActiveBundleSummary = "Default R15",
    EquippedParts = {},
    Favorites = { Emotes = {}, Bundles = {}, Parts = {} },
    Connections = {},
    ThemeUpdaters = {},
    LayoutUpdaters = {}
}

local function DetectSeason()
    local d = os.date("*t")
    if d and d.month == 10 then return "Halloween" end
    if d and d.month == 12 then return "Christmas" end
    return "Default"
end
State.CurrentThemeKey = DetectSeason()

-- ================================================================================
-- 4. SYNCHRONOUS GITHUB ASSET CACHER & SAVE MANAGER
-- ================================================================================
local HasFS = (typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function" and typeof(makefolder) == "function")
local HasCustomAsset = (typeof(getcustomasset) == "function")

if HasFS then
    pcall(function()
        for _, dir in ipairs({
            Config.CacheFolder,
            Config.CacheFolder .. "/assets",
            Config.CacheFolder .. "/assets/branding",
            Config.CacheFolder .. "/assets/audio",
            Config.CacheFolder .. "/assets/icons"
        }) do
            if not isfolder(dir) then makefolder(dir) end
        end
    end)
end

local ResolvedAssets = {}

local function DownloadAndResolveAsset(key)
    if ResolvedAssets[key] then return ResolvedAssets[key] end
    local entry = Config.Assets[key]
    if not entry then return "" end

    if HasFS and HasCustomAsset then
        local localPath = Config.CacheFolder .. "/" .. entry.Path
        if not isfile(localPath) then
            local ok, body = pcall(function()
                return game:HttpGet(Config.GitHubBaseURL .. entry.Path)
            end)
            if ok and body and #body > 128 and not string.find(body, "404: Not Found") then
                pcall(writefile, localPath, body)
            end
        end
        if isfile(localPath) then
            local ok, customId = pcall(getcustomasset, localPath)
            if ok and customId then
                ResolvedAssets[key] = customId
                return customId
            end
        end
    end

    ResolvedAssets[key] = entry.Fallback
    return entry.Fallback
end

local function SaveState()
    if not HasFS then return end
    pcall(function()
        writefile(Config.SaveFile, HttpService:JSONEncode({
            Layout = State.CurrentLayout,
            Theme = State.CurrentThemeKey,
            Favorites = State.Favorites
        }))
    end)
end

local function LoadState()
    if not HasFS then return end
    pcall(function()
        if isfile(Config.SaveFile) then
            local d = HttpService:JSONDecode(readfile(Config.SaveFile))
            if type(d) == "table" then
                if d.Layout then State.CurrentLayout = d.Layout end
                if d.Favorites then
                    State.Favorites.Emotes  = d.Favorites.Emotes or {}
                    State.Favorites.Bundles = d.Favorites.Bundles or {}
                    State.Favorites.Parts   = d.Favorites.Parts or {}
                end
            end
        end
    end)
end
LoadState()

-- ================================================================================
-- 5. DEPTH-OF-FIELD BLUR & AUDIO ENGINE
-- ================================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArgonHub_V3"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "ArgonDepthBlur"
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

local SoundFolder = Instance.new("Folder", ScreenGui)
SoundFolder.Name = "ArgonSFX"

local function PlaySound(key, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = DownloadAndResolveAsset(key)
    s.Volume = vol or 0.5
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundFolder
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
    return s
end

-- ================================================================================
-- 6. ANIMATION & EMOTE CONTROLLER + AUTO-MOVEMENT DETECTION
-- ================================================================================
local UpdateTelemetryUI -- Forward declaration

local function StopActiveEmote()
    if State.ActiveEmoteTrack then
        pcall(function()
            State.ActiveEmoteTrack:Stop(0.22)
            State.ActiveEmoteTrack:Destroy()
        end)
        State.ActiveEmoteTrack = nil
        State.ActiveEmoteName = "None"
    end
    if UpdateTelemetryUI then UpdateTelemetryUI() end
end

local function PlayEmote(emoteData)
    StopActiveEmote()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)

    task.spawn(function()
        local animInstance = nil
        local ok, objs = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(emoteData.CatalogId or emoteData.AnimId))
        end)
        if ok and objs and #objs > 0 then
            local root = objs[1]
            animInstance = root:IsA("Animation") and root or root:FindFirstChildOfClass("Animation", true)
        end

        if not animInstance then
            animInstance = Instance.new("Animation")
            animInstance.AnimationId = "rbxassetid://" .. tostring(emoteData.AnimId or emoteData.CatalogId)
        end

        local loadOk, track = pcall(function()
            return animator:LoadAnimation(animInstance)
        end)

        if loadOk and track then
            track.Priority = Enum.AnimationPriority.Action
            track.Looped = State.LoopEmotes
            track:Play(0.18)
            track:AdjustSpeed(State.EmoteSpeed)
            State.ActiveEmoteTrack = track
            State.ActiveEmoteName = emoteData.Name
            if UpdateTelemetryUI then UpdateTelemetryUI() end
        end
    end)
end

-- Movement Auto-Cancel Hook
table.insert(State.Connections, RunService.RenderStepped:Connect(function()
    if State.ActiveEmoteTrack and State.StopEmoteOnMove then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and (hum.MoveDirection.Magnitude > 0.08 or hum.Jump) then
            StopActiveEmote()
        end
    end
end))

local function ApplyAnimationPart(partName, animIds, bundleName)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local animateScript = char and char:FindFirstChild("Animate")
    if not hum or not animateScript then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            t:Stop(0.12)
        end
    end

    local lowerKey = string.lower(partName)
    local trackFolder = animateScript:FindFirstChild(lowerKey)
    if trackFolder then
        if lowerKey == "idle" then
            local a1 = trackFolder:FindFirstChild("Animation1")
            local a2 = trackFolder:FindFirstChild("Animation2")
            if a1 and animIds[1] then a1.AnimationId = "http://www.roblox.com/asset/?id=" .. tostring(animIds[1]) end
            if a2 and (animIds[2] or animIds[1]) then a2.AnimationId = "http://www.roblox.com/asset/?id=" .. tostring(animIds[2] or animIds[1]) end
        else
            for _, child in ipairs(trackFolder:GetChildren()) do
                if child:IsA("Animation") and animIds[1] then
                    child.AnimationId = "http://www.roblox.com/asset/?id=" .. tostring(animIds[1])
                end
            end
        end
    end

    State.EquippedParts[partName] = { Bundle = bundleName, Ids = animIds }
    State.ActiveBundleSummary = bundleName .. " (" .. partName .. ")"
    hum:ChangeState(Enum.HumanoidStateType.Landed)
    if UpdateTelemetryUI then UpdateTelemetryUI() end
end

local function EquipFullBundle(bundle)
    for partName, ids in pairs(bundle.Parts) do
        ApplyAnimationPart(partName, ids, bundle.Name)
    end
    State.ActiveBundleSummary = bundle.Name .. " (Full Set)"
    if UpdateTelemetryUI then UpdateTelemetryUI() end
end

table.insert(State.Connections, LocalPlayer.CharacterAdded:Connect(function(newChar)
    newChar:WaitForChild("Humanoid", 10)
    newChar:WaitForChild("Animate", 10)
    task.wait(0.5)
    for partName, info in pairs(State.EquippedParts) do
        ApplyAnimationPart(partName, info.Ids, info.Bundle)
    end
end))

-- ================================================================================
-- 7. THEME & MULTI-LAYOUT ARCHITECTURE (YOUR 3 DRAWINGS)
-- ================================================================================
local function GetTheme()
    return Config.Themes[State.CurrentThemeKey] or Config.Themes.Default
end

local function RegisterTheme(fn)
    table.insert(State.ThemeUpdaters, fn)
    fn(GetTheme())
end

local function RefreshThemes()
    local t = GetTheme()
    for _, fn in ipairs(State.ThemeUpdaters) do
        task.spawn(fn, t)
    end
end

-- Master Container that scales during Open/Close Animations
local HubRoot = Instance.new("Frame")
HubRoot.Name = "HubRoot"
HubRoot.Size = UDim2.new(0, 780, 0, 490)
HubRoot.Position = UDim2.new(0.5, 0, 0.5, 0)
HubRoot.AnchorPoint = Vector2.new(0.5, 0.5)
HubRoot.BackgroundTransparency = 1
HubRoot.Visible = false
HubRoot.Parent = ScreenGui

local RootScale = Instance.new("UIScale", HubRoot)
RootScale.Scale = 1

-- Primary Window Shell (Used by Layout 1 & Layout 3; in Layout 2 it becomes the lower canvas)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(1, 0, 1, 0)
MainWindow.Position = UDim2.new(0, 0, 0, 0)
MainWindow.BorderSizePixel = 0
MainWindow.Parent = HubRoot

local WindowCorner = Instance.new("UICorner", MainWindow)
WindowCorner.CornerRadius = UDim.new(0, 22)

local WindowStroke = Instance.new("UIStroke", MainWindow)
WindowStroke.Thickness = 1.6

-- Subtle Ambient Top Glow Gradient inside MainWindow
local WindowGradient = Instance.new("UIGradient", MainWindow)
WindowGradient.Rotation = 90
WindowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 215))
})

-- ================================================================================
-- LAYOUT-SPECIFIC STRUCTURAL ELEMENTS (DRAWING 1, DRAWING 2, DRAWING 3)
-- ================================================================================

-- [A] DRAWING 1: TOP RIBBON HEADER ("HERE THE TABS" / Line / "HERE THE STUFF")
local L1_TopBar = Instance.new("Frame")
L1_TopBar.Name = "Layout1_TopBar"
L1_TopBar.Size = UDim2.new(1, 0, 0, 68)
L1_TopBar.BackgroundTransparency = 1
L1_TopBar.Parent = MainWindow

local L1_Divider = Instance.new("Frame")
L1_Divider.Size = UDim2.new(1, -36, 0, 1)
L1_Divider.Position = UDim2.new(0, 18, 1, -1)
L1_Divider.BorderSizePixel = 0
L1_Divider.Parent = L1_TopBar

local L1_Logo = Instance.new("ImageLabel")
L1_Logo.Size = UDim2.new(0, 38, 0, 38)
L1_Logo.Position = UDim2.new(0, 22, 0.5, -19)
L1_Logo.BackgroundTransparency = 1
L1_Logo.ScaleType = Enum.ScaleType.Fit
L1_Logo.Parent = L1_TopBar

local L1_BrandText = Instance.new("TextLabel")
L1_BrandText.Size = UDim2.new(0, 110, 0, 20)
L1_BrandText.Position = UDim2.new(0, 68, 0, 16)
L1_BrandText.BackgroundTransparency = 1
L1_BrandText.Font = Enum.Font.GothamBlack
L1_BrandText.Text = Config.HubName
L1_BrandText.TextSize = 16
L1_BrandText.TextXAlignment = Enum.TextXAlignment.Left
L1_BrandText.Parent = L1_TopBar

local L1_SubText = Instance.new("TextLabel")
L1_SubText.Size = UDim2.new(0, 110, 0, 14)
L1_SubText.Position = UDim2.new(0, 68, 0, 35)
L1_SubText.BackgroundTransparency = 1
L1_SubText.Font = Enum.Font.GothamMedium
L1_SubText.Text = Config.Version
L1_SubText.TextSize = 10
L1_SubText.TextXAlignment = Enum.TextXAlignment.Left
L1_SubText.Parent = L1_TopBar

local L1_TabsHolder = Instance.new("Frame")
L1_TabsHolder.Size = UDim2.new(0, 420, 0, 42)
L1_TabsHolder.Position = UDim2.new(0.5, -180, 0.5, -21)
L1_TabsHolder.BackgroundTransparency = 1
L1_TabsHolder.Parent = L1_TopBar

local L1_TabsLayout = Instance.new("UIListLayout", L1_TabsHolder)
L1_TabsLayout.FillDirection = Enum.FillDirection.Horizontal
L1_TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
L1_TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
L1_TabsLayout.Padding = UDim.new(0, 8)

-- [B] DRAWING 2: FLOATING ISLAND DOCK CAPSULE WITH SQUARE TILES + CORNER ACCENTS
local L2_FloatingDock = Instance.new("Frame")
L2_FloatingDock.Name = "Layout2_FloatingDock"
L2_FloatingDock.Size = UDim2.new(0, 460, 0, 76)
L2_FloatingDock.Position = UDim2.new(0.5, -230, 0, 0)
L2_FloatingDock.BorderSizePixel = 0
L2_FloatingDock.Visible = false
L2_FloatingDock.Parent = HubRoot

Instance.new("UICorner", L2_FloatingDock).CornerRadius = UDim.new(0, 24)
local L2_DockStroke = Instance.new("UIStroke", L2_FloatingDock)
L2_DockStroke.Thickness = 1.8

local L2_DockList = Instance.new("UIListLayout", L2_FloatingDock)
L2_DockList.FillDirection = Enum.FillDirection.Horizontal
L2_DockList.HorizontalAlignment = Enum.HorizontalAlignment.Center
L2_DockList.VerticalAlignment = Enum.VerticalAlignment.Center
L2_DockList.Padding = UDim.new(0, 14)

-- Drawing 2 Corner Diagonal Glow Accents around the main box
local L2_CornerAccents = {}
for idx, cInfo in ipairs({
    { Pos = UDim2.new(0, -10, 0, 84),  Rot = -25 },
    { Pos = UDim2.new(1, -22, 0, 84),  Rot = 25 },
    { Pos = UDim2.new(0, -10, 1, -14), Rot = 35 },
    { Pos = UDim2.new(1, -22, 1, -14), Rot = -35 }
}) do
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 32, 0, 3)
    bar.Position = cInfo.Pos
    bar.Rotation = cInfo.Rot
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.Parent = HubRoot
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    table.insert(L2_CornerAccents, bar)
end

-- [C] DRAWING 3: SPLIT INFORMATION SIDEBAR + INSET ROUNDED VIEWPORT + WINDOW CONTROLS
local L3_LeftPanel = Instance.new("Frame")
L3_LeftPanel.Name = "Layout3_LeftInfoPanel"
L3_LeftPanel.Size = UDim2.new(0, 215, 1, -24)
L3_LeftPanel.Position = UDim2.new(0, 14, 0, 12)
L3_LeftPanel.BackgroundTransparency = 1
L3_LeftPanel.Visible = false
L3_LeftPanel.Parent = MainWindow

local L3_InfoHeader = Instance.new("TextLabel")
L3_InfoHeader.Size = UDim2.new(1, -10, 0, 28)
L3_InfoHeader.Position = UDim2.new(0, 8, 0, 8)
L3_InfoHeader.BackgroundTransparency = 1
L3_InfoHeader.Font = Enum.Font.GothamBlack
L3_InfoHeader.Text = "INFORMATION"
L3_InfoHeader.TextSize = 15
L3_InfoHeader.TextXAlignment = Enum.TextXAlignment.Left
L3_InfoHeader.Parent = L3_LeftPanel

local L3_InfoLine = Instance.new("Frame")
L3_InfoLine.Size = UDim2.new(1, -12, 0, 2)
L3_InfoLine.Position = UDim2.new(0, 6, 0, 38)
L3_InfoLine.BorderSizePixel = 0
L3_InfoLine.Parent = L3_LeftPanel

-- Live Player & Active Animation Telemetry Card inside Layout 3 Left Panel
local L3_TelemetryCard = Instance.new("Frame")
L3_TelemetryCard.Size = UDim2.new(1, -12, 0, 134)
L3_TelemetryCard.Position = UDim2.new(0, 6, 0, 50)
L3_TelemetryCard.BorderSizePixel = 0
L3_TelemetryCard.Parent = L3_LeftPanel
Instance.new("UICorner", L3_TelemetryCard).CornerRadius = UDim.new(0, 14)
local L3_TelStroke = Instance.new("UIStroke", L3_TelemetryCard)

local L3_AvatarImg = Instance.new("ImageLabel")
L3_AvatarImg.Size = UDim2.new(0, 46, 0, 46)
L3_AvatarImg.Position = UDim2.new(0, 12, 0, 12)
L3_AvatarImg.BackgroundTransparency = 1
L3_AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
L3_AvatarImg.Parent = L3_TelemetryCard
Instance.new("UICorner", L3_AvatarImg).CornerRadius = UDim.new(1, 0)

local L3_PlayerName = Instance.new("TextLabel")
L3_PlayerName.Size = UDim2.new(1, -70, 0, 18)
L3_PlayerName.Position = UDim2.new(0, 66, 0, 16)
L3_PlayerName.BackgroundTransparency = 1
L3_PlayerName.Font = Enum.Font.GothamBold
L3_PlayerName.Text = LocalPlayer.DisplayName
L3_PlayerName.TextSize = 13
L3_PlayerName.TextXAlignment = Enum.TextXAlignment.Left
L3_PlayerName.TextTruncate = Enum.TextTruncate.AtEnd
L3_PlayerName.Parent = L3_TelemetryCard

local L3_SubName = Instance.new("TextLabel")
L3_SubName.Size = UDim2.new(1, -70, 0, 14)
L3_SubName.Position = UDim2.new(0, 66, 0, 34)
L3_SubName.BackgroundTransparency = 1
L3_SubName.Font = Enum.Font.GothamMedium
L3_SubName.Text = "@" .. LocalPlayer.Name
L3_SubName.TextSize = 11
L3_SubName.TextXAlignment = Enum.TextXAlignment.Left
L3_SubName.TextTruncate = Enum.TextTruncate.AtEnd
L3_SubName.Parent = L3_TelemetryCard

local L3_StatusText = Instance.new("TextLabel")
L3_StatusText.Size = UDim2.new(1, -24, 0, 56)
L3_StatusText.Position = UDim2.new(0, 12, 0, 68)
L3_StatusText.BackgroundTransparency = 1
L3_StatusText.Font = Enum.Font.GothamMedium
L3_StatusText.TextWrapped = true
L3_StatusText.TextSize = 11
L3_StatusText.TextXAlignment = Enum.TextXAlignment.Left
L3_StatusText.TextYAlignment = Enum.TextYAlignment.Top
L3_StatusText.Parent = L3_TelemetryCard

UpdateTelemetryUI = function()
    L3_StatusText.Text = string.format(
        "Emote : %s\nPack  : %s\nMoveCancel : %s",
        tostring(State.ActiveEmoteName),
        tostring(State.ActiveBundleSummary),
        State.StopEmoteOnMove and "Enabled" or "Walk Lock"
    )
end
UpdateTelemetryUI()

local L3_NavHolder = Instance.new("Frame")
L3_NavHolder.Size = UDim2.new(1, -12, 1, -198)
L3_NavHolder.Position = UDim2.new(0, 6, 0, 194)
L3_NavHolder.BackgroundTransparency = 1
L3_NavHolder.Parent = L3_LeftPanel

local L3_NavList = Instance.new("UIListLayout", L3_NavHolder)
L3_NavList.Padding = UDim.new(0, 7)
L3_NavList.SortOrder = Enum.SortOrder.LayoutOrder

-- Top-Right Window Controls (Minimize '—', Cycle Layout '□', Close '✕' from Drawing 3)
local WindowControls = Instance.new("Frame")
WindowControls.Size = UDim2.new(0, 104, 0, 30)
WindowControls.Position = UDim2.new(1, -120, 0, 18)
WindowControls.BackgroundTransparency = 1
WindowControls.ZIndex = 20
WindowControls.Parent = MainWindow

local WC_List = Instance.new("UIListLayout", WindowControls)
WC_List.FillDirection = Enum.FillDirection.Horizontal
WC_List.HorizontalAlignment = Enum.HorizontalAlignment.Right
WC_List.VerticalAlignment = Enum.VerticalAlignment.Center
WC_List.Padding = UDim.new(0, 8)

local function MakeWindowControlBtn(symbol, onClick)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 28, 0, 28)
    b.Font = Enum.Font.GothamBold
    b.Text = symbol
    b.TextSize = 13
    b.AutoButtonColor = false
    b.ZIndex = 21
    b.Parent = WindowControls
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", b)
    st.Thickness = 1

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { Size = UDim2.new(0, 30, 0, 30) }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { Size = UDim2.new(0, 28, 0, 28) }):Play()
    end)
    b.MouseButton1Click:Connect(function()
        PlaySound("SFX_Click", 0.45)
        onClick()
    end)

    RegisterTheme(function(theme)
        b.BackgroundColor3 = theme.CardBg
        b.TextColor3 = theme.TextPrimary
        st.Color = theme.Stroke
    end)
    return b
end

-- Content Viewport Inset Container ("HERE THE STUFF" / Right Inset Box)
local ContentViewport = Instance.new("Frame")
ContentViewport.Name = "ContentViewport"
ContentViewport.BorderSizePixel = 0
ContentViewport.ClipsDescendants = true
ContentViewport.Parent = MainWindow

local ViewportCorner = Instance.new("UICorner", ContentViewport)
ViewportCorner.CornerRadius = UDim.new(0, 18)
local ViewportStroke = Instance.new("UIStroke", ContentViewport)
ViewportStroke.Thickness = 1.2

-- Universal Search & Filter Bar inside top of ContentViewport
local FilterBar = Instance.new("Frame")
FilterBar.Size = UDim2.new(1, -28, 0, 42)
FilterBar.Position = UDim2.new(0, 14, 0, 12)
FilterBar.BorderSizePixel = 0
FilterBar.ZIndex = 5
FilterBar.Parent = ContentViewport
Instance.new("UICorner", FilterBar).CornerRadius = UDim.new(0, 12)
local FilterStroke = Instance.new("UIStroke", FilterBar)
FilterStroke.Thickness = 1

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.Position = UDim2.new(0, 14, 0.5, -8)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = DownloadAndResolveAsset("Icon_Search")
SearchIcon.ZIndex = 6
SearchIcon.Parent = FilterBar

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -175, 1, 0)
SearchBox.Position = UDim2.new(0, 38, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.PlaceholderText = "Search any Emote, Bundle, or paste any Roblox Anim ID..."
SearchBox.Text = ""
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.ZIndex = 6
SearchBox.Parent = FilterBar

local PlayRawIdBtn = Instance.new("TextButton")
PlayRawIdBtn.Size = UDim2.new(0, 122, 0, 28)
PlayRawIdBtn.Position = UDim2.new(1, -130, 0.5, -14)
PlayRawIdBtn.Font = Enum.Font.GothamBold
PlayRawIdBtn.Text = "Play Custom ID"
PlayRawIdBtn.TextSize = 11
PlayRawIdBtn.AutoButtonColor = false
PlayRawIdBtn.ZIndex = 6
PlayRawIdBtn.Parent = FilterBar
Instance.new("UICorner", PlayRawIdBtn).CornerRadius = UDim.new(0, 8)

PlayRawIdBtn.MouseButton1Click:Connect(function()
    PlaySound("SFX_Click")
    local digits = string.match(SearchBox.Text, "%d+")
    if digits then
        PlayEmote({ Name = "Custom ID (" .. digits .. ")", CatalogId = tonumber(digits), AnimId = tonumber(digits) })
    end
end)

-- Context-Aware Floating Stop Bar (Only shows when Walk-Lock is enabled and an emote is active)
local StopBanner = Instance.new("Frame")
StopBanner.Size = UDim2.new(0, 280, 0, 38)
StopBanner.Position = UDim2.new(0.5, -140, 1, -48)
StopBanner.BackgroundColor3 = Color3.fromRGB(24, 14, 18)
StopBanner.BorderSizePixel = 0
StopBanner.Visible = false
StopBanner.ZIndex = 15
StopBanner.Parent = ContentViewport
Instance.new("UICorner", StopBanner).CornerRadius = UDim.new(1, 0)
local sbStroke = Instance.new("UIStroke", StopBanner)
sbStroke.Color = Color3.fromRGB(235, 77, 75)
sbStroke.Thickness = 1.4

local sbStopBtn = Instance.new("TextButton")
sbStopBtn.Size = UDim2.new(1, 0, 1, 0)
sbStopBtn.BackgroundTransparency = 1
sbStopBtn.Font = Enum.Font.GothamBold
sbStopBtn.Text = "■  STOP ACTIVE EMOTE"
sbStopBtn.TextColor3 = Color3.fromRGB(255, 110, 110)
sbStopBtn.TextSize = 12
sbStopBtn.ZIndex = 16
sbStopBtn.Parent = StopBanner

sbStopBtn.MouseButton1Click:Connect(function()
    PlaySound("SFX_Click")
    StopActiveEmote()
end)

RunService.RenderStepped:Connect(function()
    StopBanner.Visible = (State.ActiveEmoteTrack ~= nil and not State.StopEmoteOnMove)
end)

-- ================================================================================
-- 8. MULTI-LAYOUT ENGINE (MORPHS BETWEEN YOUR 3 DRAWINGS INSTANTLY)
-- ================================================================================
local ApplyLayoutMode
ApplyLayoutMode = function(mode, animate)
    State.CurrentLayout = mode
    SaveState()
    local dur = animate and 0.35 or 0
    local ease = TweenInfo.new(dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if mode == 1 then
        -- DRAWING 1: TOP RIBBON ("HERE THE TABS" / "HERE THE STUFF")
        L1_TopBar.Visible = true
        L2_FloatingDock.Visible = false
        L3_LeftPanel.Visible = false
        for _, bar in ipairs(L2_CornerAccents) do bar.Visible = false end

        TweenService:Create(MainWindow, ease, {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(ContentViewport, ease, {
            Size = UDim2.new(1, -28, 1, -84),
            Position = UDim2.new(0, 14, 0, 72)
        }):Play()
        WindowControls.Position = UDim2.new(1, -120, 0, 19)

    elseif mode == 2 then
        -- DRAWING 2: FLOATING ISLAND DOCK ABOVE MAIN CONTENT WINDOW
        L1_TopBar.Visible = false
        L2_FloatingDock.Visible = true
        L3_LeftPanel.Visible = false
        for _, bar in ipairs(L2_CornerAccents) do bar.Visible = true end

        TweenService:Create(MainWindow, ease, {
            Size = UDim2.new(1, 0, 1, -92),
            Position = UDim2.new(0, 0, 0, 92)
        }):Play()
        TweenService:Create(ContentViewport, ease, {
            Size = UDim2.new(1, -24, 1, -24),
            Position = UDim2.new(0, 12, 0, 12)
        }):Play()
        WindowControls.Position = UDim2.new(1, -118, 0, 24)

    elseif mode == 3 then
        -- DRAWING 3: SPLIT LEFT INFORMATION PANEL + RIGHT INSET STUDIO VIEWPORT
        L1_TopBar.Visible = false
        L2_FloatingDock.Visible = false
        L3_LeftPanel.Visible = true
        for _, bar in ipairs(L2_CornerAccents) do bar.Visible = false end

        TweenService:Create(MainWindow, ease, {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(ContentViewport, ease, {
            Size = UDim2.new(1, -248, 1, -68),
            Position = UDim2.new(0, 234, 0, 54)
        }):Play()
        WindowControls.Position = UDim2.new(1, -120, 0, 14)
    end
end

-- ================================================================================
-- 9. INSANE CINEMATIC OPEN / CLOSE ANIMATION (FOV + BLUR + ELASTIC UNFOLD)
-- ================================================================================
local DefaultFOV = Camera and Camera.FieldOfView or 70

local function ToggleMenu(forceState)
    if State.IsAnimating then return end
    local target = (forceState ~= nil) and forceState or (not State.IsOpen)
    if target == State.IsOpen then return end

    State.IsAnimating = true
    State.IsOpen = target

    if target then
        HubRoot.Visible = true
        RootScale.Scale = 0.72
        HubRoot.Position = UDim2.new(0.5, 0, 0.54, 0)

        TweenService:Create(BlurEffect, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = 16
        }):Play()
        if Camera then
            TweenService:Create(Camera, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                FieldOfView = DefaultFOV - 6
            }):Play()
        end
        TweenService:Create(RootScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
        TweenService:Create(HubRoot, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()

        task.wait(0.45)
    else
        TweenService:Create(BlurEffect, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = 0
        }):Play()
        if Camera then
            TweenService:Create(Camera, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                FieldOfView = DefaultFOV
            }):Play()
        end
        TweenService:Create(RootScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0.75
        }):Play()
        TweenService:Create(HubRoot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0.54, 0)
        }):Play()

        task.wait(0.3)
        HubRoot.Visible = false
    end

    State.IsAnimating = false
end

-- Create the 3 Window Control Buttons (Minimize '—', Cycle Layout '□', Close '✕')
MakeWindowControlBtn("—", function()
    ToggleMenu(false)
end)
MakeWindowControlBtn("□", function()
    local nextLayout = (State.CurrentLayout % 3) + 1
    ApplyLayoutMode(nextLayout, true)
end)
MakeWindowControlBtn("✕", function()
    ToggleMenu(false)
end)

-- Smooth Dragging on MainWindow and FloatingDock
local function EnableDragging(handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = HubRoot.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)
    table.insert(State.Connections, UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - dragStart
            TweenService:Create(HubRoot, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end))
end
EnableDragging(MainWindow)
EnableDragging(L2_FloatingDock)

-- ================================================================================
-- 10. NAVIGATION TABS ACROSS ALL 3 LAYOUTS + PAGE CONTAINERS
-- ================================================================================
local TabList = {
    { Id = "Emotes",    Label = "Emotes",    Icon = "Icon_Emotes" },
    { Id = "Bundles",   Label = "Bundles",   Icon = "Icon_Bundles" },
    { Id = "Controller",Label = "Studio",    Icon = "Icon_Home" },
    { Id = "Favorites", Label = "Favorites", Icon = "Icon_Favs" },
    { Id = "Settings",  Label = "Settings",  Icon = "Icon_Settings" }
}

local Pages = {}
local NavWidgets = { L1 = {}, L2 = {}, L3 = {} }
local RebuildFavoritesPage

for _, tab in ipairs(TabList) do
    local page = Instance.new("ScrollingFrame")
    page.Name = tab.Id .. "_Page"
    page.Size = UDim2.new(1, -24, 1, -70)
    page.Position = UDim2.new(0, 12, 0, 62)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = ContentViewport

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 54)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 8)

    RegisterTheme(function(theme)
        page.ScrollBarImageColor3 = theme.Accent
    end)

    Pages[tab.Id] = page
end

local function SwitchTab(tabId)
    State.CurrentTab = tabId
    local theme = GetTheme()

    for id, page in pairs(Pages) do
        if id == tabId then
            page.Visible = true
            page.Position = UDim2.new(0, 12, 0, 74)
            TweenService:Create(page, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 12, 0, 62)
            }):Play()
        else
            page.Visible = false
        end
    end

    -- Sync Layout 1 Ribbon Buttons
    for id, w in pairs(NavWidgets.L1) do
        local on = (id == tabId)
        TweenService:Create(w.Btn, TweenInfo.new(0.22), {
            BackgroundColor3 = on and theme.CardHover or theme.CardBg,
            BackgroundTransparency = on and 0 or 0.45
        }):Play()
        TweenService:Create(w.Stroke, TweenInfo.new(0.22), {
            Color = on and theme.Accent or theme.Stroke,
            Transparency = on and 0.15 or 0.6
        }):Play()
        w.Label.TextColor3 = on and theme.TextPrimary or theme.TextDim
        w.Icon.ImageColor3 = on and theme.Accent or theme.TextDim
    end

    -- Sync Layout 2 Square Dock Tiles (Drawing 2)
    for id, w in pairs(NavWidgets.L2) do
        local on = (id == tabId)
        TweenService:Create(w.Btn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = on and UDim2.new(0, 56, 0, 56) or UDim2.new(0, 48, 0, 48),
            BackgroundColor3 = on and theme.CardHover or theme.CardBg
        }):Play()
        TweenService:Create(w.Stroke, TweenInfo.new(0.22), {
            Color = on and theme.Accent or theme.Stroke,
            Thickness = on and 2 or 1.2
        }):Play()
        w.Icon.ImageColor3 = on and theme.Accent or theme.TextDim
    end

    -- Sync Layout 3 Left Sidebar Buttons (Drawing 3)
    for id, w in pairs(NavWidgets.L3) do
        local on = (id == tabId)
        TweenService:Create(w.Btn, TweenInfo.new(0.22), {
            BackgroundColor3 = on and theme.CardHover or theme.CardBg,
            BackgroundTransparency = on and 0 or 0.35
        }):Play()
        TweenService:Create(w.Stroke, TweenInfo.new(0.22), {
            Color = on and theme.Accent or theme.Stroke
        }):Play()
        w.Label.TextColor3 = on and theme.TextPrimary or theme.TextDim
        w.Icon.ImageColor3 = on and theme.Accent or theme.TextDim
    end

    if tabId == "Favorites" and RebuildFavoritesPage then
        RebuildFavoritesPage()
    end
end

-- Populate Navigation Controls for all 3 Layouts
for idx, tab in ipairs(TabList) do
    -- 1. Layout 1 Top Pill Button
    local b1 = Instance.new("TextButton")
    b1.Size = UDim2.new(0, 82, 0, 34)
    b1.Text = ""
    b1.AutoButtonColor = false
    b1.Parent = L1_TabsHolder
    Instance.new("UICorner", b1).CornerRadius = UDim.new(0, 10)
    local s1 = Instance.new("UIStroke", b1)

    local i1 = Instance.new("ImageLabel")
    i1.Size = UDim2.new(0, 14, 0, 14)
    i1.Position = UDim2.new(0, 10, 0.5, -7)
    i1.BackgroundTransparency = 1
    i1.Image = DownloadAndResolveAsset(tab.Icon)
    i1.Parent = b1

    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, -28, 1, 0)
    t1.Position = UDim2.new(0, 28, 0, 0)
    t1.BackgroundTransparency = 1
    t1.Font = Enum.Font.GothamBold
    t1.Text = tab.Label
    t1.TextSize = 11
    t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.Parent = b1

    b1.MouseButton1Click:Connect(function() PlaySound("SFX_Click") SwitchTab(tab.Id) end)
    NavWidgets.L1[tab.Id] = { Btn = b1, Stroke = s1, Icon = i1, Label = t1 }

    -- 2. Layout 2 Floating Dock Square Tile (Drawing 2)
    local b2 = Instance.new("TextButton")
    b2.Size = UDim2.new(0, 48, 0, 48)
    b2.Text = ""
    b2.AutoButtonColor = false
    b2.Parent = L2_FloatingDock
    Instance.new("UICorner", b2).CornerRadius = UDim.new(0, 14)
    local s2 = Instance.new("UIStroke", b2)

    local i2 = Instance.new("ImageLabel")
    i2.Size = UDim2.new(0, 22, 0, 22)
    i2.Position = UDim2.new(0.5, -11, 0.5, -11)
    i2.BackgroundTransparency = 1
    i2.Image = DownloadAndResolveAsset(tab.Icon)
    i2.Parent = b2

    b2.MouseButton1Click:Connect(function() PlaySound("SFX_Click") SwitchTab(tab.Id) end)
    NavWidgets.L2[tab.Id] = { Btn = b2, Stroke = s2, Icon = i2 }

    -- 3. Layout 3 Left Sidebar Row (Drawing 3)
    local b3 = Instance.new("TextButton")
    b3.LayoutOrder = idx
    b3.Size = UDim2.new(1, 0, 0, 38)
    b3.Text = ""
    b3.AutoButtonColor = false
    b3.Parent = L3_NavHolder
    Instance.new("UICorner", b3).CornerRadius = UDim.new(0, 10)
    local s3 = Instance.new("UIStroke", b3)

    local i3 = Instance.new("ImageLabel")
    i3.Size = UDim2.new(0, 16, 0, 16)
    i3.Position = UDim2.new(0, 12, 0.5, -8)
    i3.BackgroundTransparency = 1
    i3.Image = DownloadAndResolveAsset(tab.Icon)
    i3.Parent = b3

    local t3 = Instance.new("TextLabel")
    t3.Size = UDim2.new(1, -40, 1, 0)
    t3.Position = UDim2.new(0, 36, 0, 0)
    t3.BackgroundTransparency = 1
    t3.Font = Enum.Font.GothamBold
    t3.Text = tab.Label
    t3.TextSize = 12
    t3.TextXAlignment = Enum.TextXAlignment.Left
    t3.Parent = b3

    b3.MouseButton1Click:Connect(function() PlaySound("SFX_Click") SwitchTab(tab.Id) end)
    NavWidgets.L3[tab.Id] = { Btn = b3, Stroke = s3, Icon = i3, Label = t3 }
end

RegisterTheme(function(theme)
    MainWindow.BackgroundColor3 = theme.BgOuter
    WindowStroke.Color = theme.StrokeBright
    L1_Divider.BackgroundColor3 = theme.Stroke
    L1_Logo.Image = DownloadAndResolveAsset(theme.LogoKey)
    L1_BrandText.TextColor3 = theme.TextPrimary
    L1_SubText.TextColor3 = theme.Accent

    L2_FloatingDock.BackgroundColor3 = theme.BgOuter
    L2_DockStroke.Color = theme.StrokeBright
    for _, bar in ipairs(L2_CornerAccents) do
        bar.BackgroundColor3 = theme.Accent
    end

    L3_InfoHeader.TextColor3 = theme.TextPrimary
    L3_InfoLine.BackgroundColor3 = theme.Accent
    L3_TelemetryCard.BackgroundColor3 = theme.CardBg
    L3_TelStroke.Color = theme.Stroke
    L3_PlayerName.TextColor3 = theme.TextPrimary
    L3_SubName.TextColor3 = theme.Accent
    L3_StatusText.TextColor3 = theme.TextDim

    ContentViewport.BackgroundColor3 = theme.BgInset
    ViewportStroke.Color = theme.Stroke
    FilterBar.BackgroundColor3 = theme.CardBg
    FilterStroke.Color = theme.Stroke
    SearchIcon.ImageColor3 = theme.TextDim
    SearchBox.TextColor3 = theme.TextPrimary
    SearchBox.PlaceholderColor3 = theme.TextDim
    PlayRawIdBtn.BackgroundColor3 = theme.BgSurface
    PlayRawIdBtn.TextColor3 = theme.Accent

    SwitchTab(State.CurrentTab)
end)

-- ================================================================================
-- 11. EMOTES PAGE + LIVE ROBLOX MARKETPLACE EMOTE SCRAPER
-- ================================================================================
local EmoteCards = {}
local AddedEmoteIds = {}

local EmoteGrid = Instance.new("UIGridLayout", Pages["Emotes"])
EmoteGrid.CellSize = UDim2.new(0, 156, 0, 172)
EmoteGrid.CellPadding = UDim2.new(0, 10, 0, 10)
EmoteGrid.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateEmoteCard(emote, orderIndex)
    local keyStr = tostring(emote.CatalogId)
    if AddedEmoteIds[keyStr] then return end
    AddedEmoteIds[keyStr] = true

    local card = Instance.new("Frame")
    card.Name = emote.Name
    card.LayoutOrder = orderIndex
    card.BorderSizePixel = 0
    card.Parent = Pages["Emotes"]
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
    local cStroke = Instance.new("UIStroke", card)
    cStroke.Thickness = 1.2

    local cardScale = Instance.new("UIScale", card)
    cardScale.Scale = 1

    local thumbBg = Instance.new("Frame")
    thumbBg.Size = UDim2.new(1, -20, 0, 86)
    thumbBg.Position = UDim2.new(0, 10, 0, 10)
    thumbBg.BorderSizePixel = 0
    thumbBg.Parent = card
    Instance.new("UICorner", thumbBg).CornerRadius = UDim.new(0, 10)

    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(0, 74, 0, 74)
    thumb.Position = UDim2.new(0.5, -37, 0.5, -37)
    thumb.BackgroundTransparency = 1
    -- Official Bundle/Asset Thumbnail endpoint that never shows clapperboards
    thumb.Image = emote.IsBundle
        and ("rbxthumb://type=BundleThumbnail&id=" .. keyStr .. "&w=150&h=150")
        or ("rbxthumb://type=Asset&id=" .. keyStr .. "&w=150&h=150")
    thumb.Parent = thumbBg

    local starBtn = Instance.new("ImageButton")
    starBtn.Size = UDim2.new(0, 18, 0, 18)
    starBtn.Position = UDim2.new(1, -24, 0, 6)
    starBtn.BackgroundTransparency = 1
    starBtn.Image = DownloadAndResolveAsset("Icon_Star")
    starBtn.Parent = thumbBg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 18)
    title.Position = UDim2.new(0, 10, 0, 102)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = emote.Name
    title.TextSize = 12
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -20, 0, 14)
    sub.Position = UDim2.new(0, 10, 0, 118)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.GothamMedium
    sub.Text = "ID • " .. keyStr
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = card

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(1, -20, 0, 28)
    playBtn.Position = UDim2.new(0, 10, 1, -36)
    playBtn.Font = Enum.Font.GothamBold
    playBtn.Text = "Play Emote"
    playBtn.TextSize = 11
    playBtn.AutoButtonColor = false
    playBtn.Parent = card
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 8)

    local function SyncStar()
        local isFav = State.Favorites.Emotes[keyStr] == true
        local t = GetTheme()
        starBtn.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or t.TextDim
    end

    card.MouseEnter:Connect(function()
        local t = GetTheme()
        TweenService:Create(cardScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.035 }):Play()
        TweenService:Create(cStroke, TweenInfo.new(0.18), { Color = t.Accent }):Play()
    end)
    card.MouseLeave:Connect(function()
        local t = GetTheme()
        TweenService:Create(cardScale, TweenInfo.new(0.18), { Scale = 1 }):Play()
        TweenService:Create(cStroke, TweenInfo.new(0.18), { Color = t.Stroke }):Play()
    end)

    starBtn.MouseButton1Click:Connect(function()
        PlaySound("SFX_Pin")
        State.Favorites.Emotes[keyStr] = not State.Favorites.Emotes[keyStr] or nil
        SaveState()
        SyncStar()
    end)

    playBtn.MouseButton1Click:Connect(function()
        PlaySound("SFX_Click")
        PlayEmote(emote)
    end)

    RegisterTheme(function(theme)
        card.BackgroundColor3 = theme.CardBg
        cStroke.Color = theme.Stroke
        thumbBg.BackgroundColor3 = theme.BgOuter
        title.TextColor3 = theme.TextPrimary
        sub.TextColor3 = theme.TextDim
        playBtn.BackgroundColor3 = theme.BgOuter
        playBtn.TextColor3 = theme.Accent
        SyncStar()
    end)

    table.insert(EmoteCards, { Frame = card, Data = emote })
end

for idx, emote in ipairs(EmoteDatabase) do
    CreateEmoteCard(emote, idx)
end

-- Background Live Catalog Scraper: Automatically pulls extra official Roblox Emotes
task.spawn(function()
    local ok, pages = pcall(function()
        local params = CatalogSearchParams.new()
        params.AssetTypes = { Enum.AvatarAssetType.EmoteAnimation }
        params.SortType = Enum.CatalogSortType.MostFavorited
        params.Limit = 120
        return AvatarEditorService and AvatarEditorService:SearchCatalog(params)
    end)
    if ok and pages then
        local count = #EmoteDatabase
        pcall(function()
            for _, item in ipairs(pages:GetCurrentPage()) do
                if item.Id and item.Name then
                    count = count + 1
                    local entry = { Name = item.Name, CatalogId = item.Id, AnimId = item.Id }
                    table.insert(EmoteDatabase, entry)
                    CreateEmoteCard(entry, count)
                end
            end
        end)
    end
end)

-- ================================================================================
-- 12. BUNDLES PAGE (ALL 24+ PACKS + GRANULAR 7-TRACK MIXER)
-- ================================================================================
local BundleCards = {}
local PartOrder = { "Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Swim" }

do
    local page = Pages["Bundles"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    for idx, bundle in ipairs(BundleDatabase) do
        local expanded = false

        local card = Instance.new("Frame")
        card.Name = bundle.Name
        card.LayoutOrder = idx
        card.Size = UDim2.new(1, 0, 0, 74)
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = page
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
        local cStroke = Instance.new("UIStroke", card)
        cStroke.Thickness = 1.2

        local thumbBg = Instance.new("Frame")
        thumbBg.Size = UDim2.new(0, 54, 0, 54)
        thumbBg.Position = UDim2.new(0, 10, 0, 10)
        thumbBg.BorderSizePixel = 0
        thumbBg.Parent = card
        Instance.new("UICorner", thumbBg).CornerRadius = UDim.new(0, 10)

        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(1, -6, 1, -6)
        thumb.Position = UDim2.new(0, 3, 0, 3)
        thumb.BackgroundTransparency = 1
        thumb.Image = "rbxthumb://type=BundleThumbnail&id=" .. tostring(bundle.BundleId) .. "&w=150&h=150"
        thumb.Parent = thumbBg

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(0, 220, 0, 20)
        title.Position = UDim2.new(0, 76, 0, 16)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = bundle.Name .. " Animation Bundle"
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(0, 240, 0, 16)
        sub.Position = UDim2.new(0, 76, 0, 38)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamMedium
        sub.Text = "Bundle ID: " .. tostring(bundle.BundleId) .. " • 7 Mixable Tracks"
        sub.TextSize = 11
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Parent = card

        local starBtn = Instance.new("ImageButton")
        starBtn.Size = UDim2.new(0, 18, 0, 18)
        starBtn.Position = UDim2.new(1, -196, 0, 28)
        starBtn.BackgroundTransparency = 1
        starBtn.Image = DownloadAndResolveAsset("Icon_Star")
        starBtn.Parent = card

        local equipBtn = Instance.new("TextButton")
        equipBtn.Size = UDim2.new(0, 122, 0, 34)
        equipBtn.Position = UDim2.new(1, -166, 0, 20)
        equipBtn.Font = Enum.Font.GothamBold
        equipBtn.Text = "Equip Full Pack"
        equipBtn.TextSize = 11
        equipBtn.AutoButtonColor = false
        equipBtn.Parent = card
        Instance.new("UICorner", equipBtn).CornerRadius = UDim.new(0, 9)

        local expandBtn = Instance.new("ImageButton")
        expandBtn.Size = UDim2.new(0, 26, 0, 26)
        expandBtn.Position = UDim2.new(1, -36, 0, 24)
        expandBtn.BackgroundTransparency = 1
        expandBtn.Image = DownloadAndResolveAsset("Icon_Chevron")
        expandBtn.Parent = card

        local partsTray = Instance.new("Frame")
        partsTray.Size = UDim2.new(1, -24, 0, 80)
        partsTray.Position = UDim2.new(0, 12, 0, 76)
        partsTray.BackgroundTransparency = 1
        partsTray.Parent = card

        local pGrid = Instance.new("UIGridLayout", partsTray)
        pGrid.CellSize = UDim2.new(0, 114, 0, 34)
        pGrid.CellPadding = UDim2.new(0, 8, 0, 8)

        for _, partName in ipairs(PartOrder) do
            local ids = bundle.Parts[partName]
            if ids then
                local pBtn = Instance.new("TextButton")
                pBtn.Font = Enum.Font.GothamSemibold
                pBtn.Text = "   " .. partName
                pBtn.TextSize = 11
                pBtn.TextXAlignment = Enum.TextXAlignment.Left
                pBtn.AutoButtonColor = false
                pBtn.Parent = partsTray
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 8)
                local pSt = Instance.new("UIStroke", pBtn)

                local pStar = Instance.new("ImageButton")
                pStar.Size = UDim2.new(0, 14, 0, 14)
                pStar.Position = UDim2.new(1, -20, 0.5, -7)
                pStar.BackgroundTransparency = 1
                pStar.Image = DownloadAndResolveAsset("Icon_Star")
                pStar.Parent = pBtn

                local favKey = bundle.Name .. "_" .. partName
                local function SyncPStar()
                    local isFav = State.Favorites.Parts[favKey] == true
                    local t = GetTheme()
                    pStar.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or t.TextDim
                end

                pStar.MouseButton1Click:Connect(function()
                    PlaySound("SFX_Pin")
                    State.Favorites.Parts[favKey] = not State.Favorites.Parts[favKey] or nil
                    SaveState()
                    SyncPStar()
                end)

                pBtn.MouseButton1Click:Connect(function()
                    PlaySound("SFX_Click")
                    ApplyAnimationPart(partName, ids, bundle.Name)
                    sub.Text = "Equipped " .. bundle.Name .. " → " .. partName
                end)

                RegisterTheme(function(theme)
                    pBtn.BackgroundColor3 = theme.BgOuter
                    pBtn.TextColor3 = theme.TextPrimary
                    pSt.Color = theme.Stroke
                    SyncPStar()
                end)
            end
        end

        local function SyncBStar()
            local isFav = State.Favorites.Bundles[bundle.Name] == true
            local t = GetTheme()
            starBtn.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or t.TextDim
        end

        starBtn.MouseButton1Click:Connect(function()
            PlaySound("SFX_Pin")
            State.Favorites.Bundles[bundle.Name] = not State.Favorites.Bundles[bundle.Name] or nil
            SaveState()
            SyncBStar()
        end)

        equipBtn.MouseButton1Click:Connect(function()
            PlaySound("SFX_Click")
            EquipFullBundle(bundle)
            sub.Text = "Active Full Set: " .. bundle.Name
        end)

        expandBtn.MouseButton1Click:Connect(function()
            PlaySound("SFX_Click")
            expanded = not expanded
            TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = expanded and UDim2.new(1, 0, 0, 166) or UDim2.new(1, 0, 0, 74)
            }):Play()
            TweenService:Create(expandBtn, TweenInfo.new(0.25), {
                Rotation = expanded and 180 or 0
            }):Play()
        end)

        RegisterTheme(function(theme)
            card.BackgroundColor3 = theme.CardBg
            cStroke.Color = theme.Stroke
            thumbBg.BackgroundColor3 = theme.BgOuter
            title.TextColor3 = theme.TextPrimary
            sub.TextColor3 = theme.TextDim
            equipBtn.BackgroundColor3 = theme.BgOuter
            equipBtn.TextColor3 = theme.Accent
            expandBtn.ImageColor3 = theme.TextDim
            SyncBStar()
        end)

        table.insert(BundleCards, { Frame = card, Data = bundle })
    end
end

-- ================================================================================
-- 13. STUDIO CONTROLLER PAGE (MOVEMENT TOGGLES, SPEED, PRO COMBOS)
-- ================================================================================
local function CreateSleekToggle(parent, titleText, descText, defaultVal, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BorderSizePixel = 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke", card)

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -80, 0, 20)
    tLbl.Position = UDim2.new(0, 16, 0, 10)
    tLbl.BackgroundTransparency = 1
    tLbl.Font = Enum.Font.GothamBold
    tLbl.Text = titleText
    tLbl.TextSize = 13
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -80, 0, 16)
    dLbl.Position = UDim2.new(0, 16, 0, 30)
    dLbl.BackgroundTransparency = 1
    dLbl.Font = Enum.Font.GothamMedium
    dLbl.Text = descText
    dLbl.TextSize = 11
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local pill = Instance.new("TextButton")
    pill.Size = UDim2.new(0, 46, 0, 24)
    pill.Position = UDim2.new(1, -62, 0.5, -12)
    pill.Text = ""
    pill.AutoButtonColor = false
    pill.Parent = card
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local stateVal = defaultVal
    local function Refresh()
        local theme = GetTheme()
        card.BackgroundColor3 = theme.CardBg
        st.Color = theme.Stroke
        tLbl.TextColor3 = theme.TextPrimary
        dLbl.TextColor3 = theme.TextDim
        TweenService:Create(pill, TweenInfo.new(0.2), {
            BackgroundColor3 = stateVal and theme.Accent or theme.BgOuter
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = stateVal and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = stateVal and theme.BgOuter or theme.TextDim
        }):Play()
    end

    pill.MouseButton1Click:Connect(function()
        PlaySound("SFX_Click")
        stateVal = not stateVal
        Refresh()
        callback(stateVal)
    end)

    RegisterTheme(Refresh)
end

do
    local page = Pages["Controller"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    CreateSleekToggle(
        page,
        "Auto-Cancel Emote When Walking / Jumping",
        "When enabled, moving your character immediately stops the emote naturally. Turn OFF to walk while emoting!",
        true,
        function(val)
            State.StopEmoteOnMove = val
            UpdateTelemetryUI()
        end
    )

    CreateSleekToggle(
        page,
        "Loop Emote Tracks Seamlessly",
        "Keeps dance and pose emotes repeating infinitely until you move or stop them.",
        true,
        function(val)
            State.LoopEmotes = val
            if State.ActiveEmoteTrack then
                State.ActiveEmoteTrack.Looped = val
            end
        end
    )

    -- Speed Bar
    local speedRow = Instance.new("Frame")
    speedRow.Size = UDim2.new(1, 0, 0, 50)
    speedRow.BackgroundTransparency = 1
    speedRow.Parent = page

    local sGrid = Instance.new("UIGridLayout", speedRow)
    sGrid.CellSize = UDim2.new(0.235, 0, 0, 42)
    sGrid.CellPadding = UDim2.new(0.02, 0, 0, 0)

    for _, spd in ipairs({
        { Text = "0.5x Slow-Mo", Val = 0.5 },
        { Text = "1.0x Normal",  Val = 1.0 },
        { Text = "1.5x Fast",    Val = 1.5 },
        { Text = "2.5x Hyper",   Val = 2.5 }
    }) do
        local b = Instance.new("TextButton")
        b.Font = Enum.Font.GothamBold
        b.Text = spd.Text
        b.TextSize = 12
        b.AutoButtonColor = false
        b.Parent = speedRow
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", b)

        b.MouseButton1Click:Connect(function()
            PlaySound("SFX_Click")
            State.EmoteSpeed = spd.Val
            if State.ActiveEmoteTrack then
                State.ActiveEmoteTrack:AdjustSpeed(spd.Val)
            end
        end)

        RegisterTheme(function(theme)
            b.BackgroundColor3 = theme.CardBg
            b.TextColor3 = theme.TextPrimary
            st.Color = theme.Stroke
        end)
    end
end

-- ================================================================================
-- 14. FAVORITES PAGE
-- ================================================================================
do
    local page = Pages["Favorites"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    RebuildFavoritesPage = function()
        for _, ch in ipairs(page:GetChildren()) do
            if ch:IsA("Frame") or ch:IsA("TextLabel") then ch:Destroy() end
        end

        local theme = GetTheme()
        local count = 0

        local function MakeFavRow(titleTxt, tagTxt, onTrigger, onUnpin)
            count = count + 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 48)
            row.BackgroundColor3 = theme.CardBg
            row.BorderSizePixel = 0
            row.Parent = page
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
            local st = Instance.new("UIStroke", row)
            st.Color = theme.Stroke

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Position = UDim2.new(0, 16, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = titleTxt .. "   •   " .. tagTxt
            lbl.TextColor3 = theme.TextPrimary
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local playBtn = Instance.new("TextButton")
            playBtn.Size = UDim2.new(0, 96, 0, 30)
            playBtn.Position = UDim2.new(1, -138, 0.5, -15)
            playBtn.BackgroundColor3 = theme.BgOuter
            playBtn.Font = Enum.Font.GothamBold
            playBtn.Text = "Equip / Play"
            playBtn.TextColor3 = theme.Accent
            playBtn.TextSize = 11
            playBtn.AutoButtonColor = false
            playBtn.Parent = row
            Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 8)

            local unpinBtn = Instance.new("ImageButton")
            unpinBtn.Size = UDim2.new(0, 18, 0, 18)
            unpinBtn.Position = UDim2.new(1, -30, 0.5, -9)
            unpinBtn.BackgroundTransparency = 1
            unpinBtn.Image = DownloadAndResolveAsset("Icon_Star")
            unpinBtn.ImageColor3 = Color3.fromRGB(255, 205, 45)
            unpinBtn.Parent = row

            playBtn.MouseButton1Click:Connect(function() PlaySound("SFX_Click") onTrigger() end)
            unpinBtn.MouseButton1Click:Connect(function()
                PlaySound("SFX_Pin")
                onUnpin()
                SaveState()
                RebuildFavoritesPage()
            end)
        end

        for _, em in ipairs(EmoteDatabase) do
            local k = tostring(em.CatalogId)
            if State.Favorites.Emotes[k] then
                MakeFavRow(em.Name, "Emote", function() PlayEmote(em) end, function() State.Favorites.Emotes[k] = nil end)
            end
        end

        for _, b in ipairs(BundleDatabase) do
            if State.Favorites.Bundles[b.Name] then
                MakeFavRow(b.Name .. " Bundle", "Full Pack", function() EquipFullBundle(b) end, function() State.Favorites.Bundles[b.Name] = nil end)
            end
            for _, pName in ipairs(PartOrder) do
                local k = b.Name .. "_" .. pName
                if State.Favorites.Parts[k] then
                    MakeFavRow(b.Name .. " → " .. pName, "Modular Track", function()
                        ApplyAnimationPart(pName, b.Parts[pName], b.Name)
                    end, function() State.Favorites.Parts[k] = nil end)
                end
            end
        end

        if count == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 110)
            empty.BackgroundTransparency = 1
            empty.Font = Enum.Font.GothamMedium
            empty.Text = "No favorites pinned yet. Click the Star on any Emote, Bundle, or Track!"
            empty.TextColor3 = theme.TextDim
            empty.TextSize = 13
            empty.Parent = page
        end
    end
end

-- ================================================================================
-- 15. SETTINGS PAGE (3 LAYOUT DRAWINGS SWITCHER + 3 SEASONAL THEMES)
-- ================================================================================
do
    local page = Pages["Settings"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 12)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    -- 1. Layout Selector Card (Your 3 Drawings!)
    local layoutCard = Instance.new("Frame")
    layoutCard.Size = UDim2.new(1, 0, 0, 122)
    layoutCard.BorderSizePixel = 0
    layoutCard.Parent = page
    Instance.new("UICorner", layoutCard).CornerRadius = UDim.new(0, 14)
    local lcStroke = Instance.new("UIStroke", layoutCard)

    local lcTitle = Instance.new("TextLabel")
    lcTitle.Size = UDim2.new(1, -28, 0, 22)
    lcTitle.Position = UDim2.new(0, 16, 0, 14)
    lcTitle.BackgroundTransparency = 1
    lcTitle.Font = Enum.Font.GothamBlack
    lcTitle.Text = "STUDIO ARCHITECTURE LAYOUT (3 CUSTOM PRESETS)"
    lcTitle.TextSize = 13
    lcTitle.TextXAlignment = Enum.TextXAlignment.Left
    lcTitle.Parent = layoutCard

    local lcSub = Instance.new("TextLabel")
    lcSub.Size = UDim2.new(1, -28, 0, 16)
    lcSub.Position = UDim2.new(0, 16, 0, 36)
    lcSub.BackgroundTransparency = 1
    lcSub.Font = Enum.Font.GothamMedium
    lcSub.Text = "Switch live between your 3 custom concept drawings (or click '□' in the top-right corner):"
    lcSub.TextSize = 11
    lcSub.TextXAlignment = Enum.TextXAlignment.Left
    lcSub.Parent = layoutCard

    local lcRow = Instance.new("Frame")
    lcRow.Size = UDim2.new(1, -32, 0, 44)
    lcRow.Position = UDim2.new(0, 16, 0, 62)
    lcRow.BackgroundTransparency = 1
    lcRow.Parent = layoutCard

    local lcGrid = Instance.new("UIGridLayout", lcRow)
    lcGrid.CellSize = UDim2.new(0.32, 0, 1, 0)
    lcGrid.CellPadding = UDim2.new(0.02, 0, 0, 0)

    for _, lInfo in ipairs({
        { Id = 1, Name = "Layout 1 • Top Ribbon" },
        { Id = 2, Name = "Layout 2 • Floating Dock" },
        { Id = 3, Name = "Layout 3 • Split Info Studio" }
    }) do
        local b = Instance.new("TextButton")
        b.Font = Enum.Font.GothamBold
        b.Text = lInfo.Name
        b.TextSize = 11
        b.AutoButtonColor = false
        b.Parent = lcRow
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        local bSt = Instance.new("UIStroke", b)

        b.MouseButton1Click:Connect(function()
            PlaySound("SFX_Click")
            ApplyLayoutMode(lInfo.Id, true)
            RefreshThemes()
        end)

        RegisterTheme(function(theme)
            local active = (State.CurrentLayout == lInfo.Id)
            b.BackgroundColor3 = active and theme.CardHover or theme.BgOuter
            b.TextColor3 = active and theme.Accent or theme.TextDim
            bSt.Color = active and theme.Accent or theme.Stroke
            bSt.Thickness = active and 1.6 or 1
        end)
    end

    -- 2. Seasonal Theme Selector Card
    local themeCard = Instance.new("Frame")
    themeCard.Size = UDim2.new(1, 0, 0, 118)
    themeCard.BorderSizePixel = 0
    themeCard.Parent = page
    Instance.new("UICorner", themeCard).CornerRadius = UDim.new(0, 14)
    local tcStroke = Instance.new("UIStroke", themeCard)

    local tcTitle = Instance.new("TextLabel")
    tcTitle.Size = UDim2.new(1, -28, 0, 22)
    tcTitle.Position = UDim2.new(0, 16, 0, 14)
    tcTitle.BackgroundTransparency = 1
    tcTitle.Font = Enum.Font.GothamBlack
    tcTitle.Text = "SEASONAL THEME & BRANDING ENGINE"
    tcTitle.TextSize = 13
    tcTitle.TextXAlignment = Enum.TextXAlignment.Left
    tcTitle.Parent = themeCard

    local tcRow = Instance.new("Frame")
    tcRow.Size = UDim2.new(1, -32, 0, 44)
    tcRow.Position = UDim2.new(0, 16, 0, 54)
    tcRow.BackgroundTransparency = 1
    tcRow.Parent = themeCard

    local tcGrid = Instance.new("UIGridLayout", tcRow)
    tcGrid.CellSize = UDim2.new(0.32, 0, 1, 0)
    tcGrid.CellPadding = UDim2.new(0.02, 0, 0, 0)

    for _, mode in ipairs({ "Default", "Halloween", "Christmas" }) do
        local b = Instance.new("TextButton")
        b.Font = Enum.Font.GothamBold
        b.Text = Config.Themes[mode].Name
        b.TextSize = 11
        b.AutoButtonColor = false
        b.Parent = tcRow
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        local bSt = Instance.new("UIStroke", b)

        b.MouseButton1Click:Connect(function()
            PlaySound("SFX_Click")
            State.CurrentThemeKey = mode
            SaveState()
            RefreshThemes()
        end)

        RegisterTheme(function(theme)
            local active = (State.CurrentThemeKey == mode)
            b.BackgroundColor3 = active and theme.CardHover or theme.BgOuter
            b.TextColor3 = active and theme.Accent or theme.TextDim
            bSt.Color = active and theme.Accent or theme.Stroke
            bSt.Thickness = active and 1.6 or 1
        end)
    end

    RegisterTheme(function(theme)
        layoutCard.BackgroundColor3 = theme.CardBg
        lcStroke.Color = theme.Stroke
        lcTitle.TextColor3 = theme.TextPrimary
        lcSub.TextColor3 = theme.TextDim

        themeCard.BackgroundColor3 = theme.CardBg
        tcStroke.Color = theme.Stroke
        tcTitle.TextColor3 = theme.TextPrimary
    end)
end

-- ================================================================================
-- 16. REAL-TIME FUZZY SEARCH & KEYBIND HOOK
-- ================================================================================
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower((SearchBox.Text or ""):gsub("^%s*(.-)%s*$", "%1"))
    for _, item in ipairs(EmoteCards) do
        if #q == 0 then
            item.Frame.Visible = true
        else
            local n = string.lower(item.Data.Name)
            local idStr = tostring(item.Data.CatalogId)
            item.Frame.Visible = (string.find(n, q, 1, true) ~= nil) or (string.find(idStr, q, 1, true) ~= nil)
        end
    end
    for _, item in ipairs(BundleCards) do
        if #q == 0 then
            item.Frame.Visible = true
        else
            local n = string.lower(item.Data.Name)
            item.Frame.Visible = (string.find(n, q, 1, true) ~= nil)
        end
    end
end)

table.insert(State.Connections, UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Config.ToggleKey or inp.KeyCode == Config.AltToggleKey then
        ToggleMenu()
    end
end))

-- ================================================================================
-- 17. TRUE ASSET PRELOADER + EXACT `startup.mp3` CINEMATIC BOOT SEQUENCE
-- ================================================================================
local function RunCinematicPreloaderAndBoot()
    local theme = GetTheme()

    local BootScreen = Instance.new("Frame")
    BootScreen.Name = "CinematicBoot"
    BootScreen.Size = UDim2.new(1, 0, 1, 0)
    BootScreen.BackgroundColor3 = Color3.fromRGB(6, 7, 10)
    BootScreen.BackgroundTransparency = 0.12
    BootScreen.ZIndex = 100
    BootScreen.Parent = ScreenGui

    TweenService:Create(BlurEffect, TweenInfo.new(0.4), { Size = 22 }):Play()

    local BootCard = Instance.new("Frame")
    BootCard.Size = UDim2.new(0, 380, 0, 270)
    BootCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    BootCard.AnchorPoint = Vector2.new(0.5, 0.5)
    BootCard.BackgroundColor3 = theme.BgOuter
    BootCard.BorderSizePixel = 0
    BootCard.ZIndex = 101
    BootCard.Parent = BootScreen
    Instance.new("UICorner", BootCard).CornerRadius = UDim.new(0, 22)

    local BootStroke = Instance.new("UIStroke", BootCard)
    BootStroke.Color = theme.Accent
    BootStroke.Thickness = 1.6
    BootStroke.Transparency = 0.25

    -- Pulsing Orbital Ring behind the Argon Logo
    local PulseRing = Instance.new("Frame")
    PulseRing.Size = UDim2.new(0, 90, 0, 90)
    PulseRing.Position = UDim2.new(0.5, 0, 0.38, 0)
    PulseRing.AnchorPoint = Vector2.new(0.5, 0.5)
    PulseRing.BackgroundTransparency = 1
    PulseRing.ZIndex = 102
    PulseRing.Parent = BootCard
    Instance.new("UICorner", PulseRing).CornerRadius = UDim.new(1, 0)
    local RingStroke = Instance.new("UIStroke", PulseRing)
    RingStroke.Color = theme.Accent
    RingStroke.Thickness = 2
    RingStroke.Transparency = 0.4

    local BootLogo = Instance.new("ImageLabel")
    BootLogo.Size = UDim2.new(0, 10, 0, 10)
    BootLogo.Position = UDim2.new(0.5, 0, 0.38, 0)
    BootLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    BootLogo.BackgroundTransparency = 1
    BootLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    BootLogo.ScaleType = Enum.ScaleType.Fit
    BootLogo.ZIndex = 103
    BootLogo.Parent = BootCard

    local BootTitle = Instance.new("TextLabel")
    BootTitle.Size = UDim2.new(1, -40, 0, 24)
    BootTitle.Position = UDim2.new(0, 20, 0, 168)
    BootTitle.BackgroundTransparency = 1
    BootTitle.Font = Enum.Font.GothamBlack
    BootTitle.Text = "ARGON STUDIO"
    BootTitle.TextColor3 = theme.TextPrimary
    BootTitle.TextSize = 18
    BootTitle.ZIndex = 103
    BootTitle.Parent = BootCard

    local BootStatus = Instance.new("TextLabel")
    BootStatus.Size = UDim2.new(1, -40, 0, 16)
    BootStatus.Position = UDim2.new(0, 20, 0, 194)
    BootStatus.BackgroundTransparency = 1
    BootStatus.Font = Enum.Font.GothamMedium
    BootStatus.Text = "Syncing GitHub assets & startup.mp3..."
    BootStatus.TextColor3 = theme.TextDim
    BootStatus.TextSize = 11
    BootStatus.ZIndex = 103
    BootStatus.Parent = BootCard

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -64, 0, 6)
    BarBg.Position = UDim2.new(0, 32, 0, 224)
    BarBg.BackgroundColor3 = theme.CardBg
    BarBg.BorderSizePixel = 0
    BarBg.ZIndex = 103
    BarBg.Parent = BootCard
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = theme.Accent
    BarFill.BorderSizePixel = 0
    BarFill.ZIndex = 104
    BarFill.Parent = BarBg
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    -- Step 1: Synchronously fetch GitHub Logos & `assets/audio/startup.mp3` FIRST
    local githubKeys = { "Logo_Default", "Logo_Halloween", "Logo_Christmas", "SFX_Startup" }
    for i, k in ipairs(githubKeys) do
        BootStatus.Text = string.format("Fetching GitHub Asset (%d/%d): %s", i, #githubKeys, k)
        DownloadAndResolveAsset(k)
        TweenService:Create(BarFill, TweenInfo.new(0.15), {
            Size = UDim2.new((i / #githubKeys) * 0.4, 0, 1, 0)
        }):Play()
    end

    BootLogo.Image = DownloadAndResolveAsset(theme.LogoKey)

    -- Step 2: Preload all UI Thumbnails so no pictures are blank when menu opens
    local preloadTargets = { BootLogo }
    for _, item in ipairs(EmoteCards) do
        local img = item.Frame:FindFirstChildWhichIsA("ImageLabel", true)
        if img then table.insert(preloadTargets, img) end
    end
    for _, item in ipairs(BundleCards) do
        local img = item.Frame:FindFirstChildWhichIsA("ImageLabel", true)
        if img then table.insert(preloadTargets, img) end
    end

    local totalAssets = #preloadTargets
    local batchSize = 12
    for i = 1, totalAssets, batchSize do
        local batch = {}
        for j = i, math.min(i + batchSize - 1, totalAssets) do
            table.insert(batch, preloadTargets[j])
        end
        pcall(function()
            ContentProvider:PreloadAsync(batch)
        end)
        local pct = math.min(1, (i + batchSize) / totalAssets)
        BootStatus.Text = string.format("Preloading Catalog Thumbnails... %d%%", math.floor(pct * 100))
        TweenService:Create(BarFill, TweenInfo.new(0.12), {
            Size = UDim2.new(0.4 + (pct * 0.6), 0, 1, 0)
        }):Play()
    end

    -- Step 3: Trigger `startup.mp3` + Cinematic Logo Scale & Shockwave Ring
    BootStatus.Text = "Ready • Launching " .. theme.Name
    PlaySound("SFX_Startup", 0.75, 1)

    TweenService:Create(BootLogo, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 108, 0, 108)
    }):Play()

    TweenService:Create(PulseRing, TweenInfo.new(0.85, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 185, 0, 185)
    }):Play()
    TweenService:Create(RingStroke, TweenInfo.new(0.85), {
        Transparency = 1
    }):Play()

    task.wait(1.35)

    -- Step 4: Implode Boot Card & Unfold Selected Layout
    TweenService:Create(BootCard, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 200, 0, 120)
    }):Play()
    TweenService:Create(BootScreen, TweenInfo.new(0.35), {
        BackgroundTransparency = 1
    }):Play()

    task.wait(0.32)
    BootScreen:Destroy()

    ApplyLayoutMode(State.CurrentLayout, false)
    RefreshThemes()
    SwitchTab("Emotes")
    ToggleMenu(true)
end

RunCinematicPreloaderAndBoot()
