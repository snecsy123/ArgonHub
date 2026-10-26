--[[
    ================================================================================
    ARGON HUB | PULSE-EDITION ANIMATION & EMOTE STUDIO (v2.0)
    GitHub Repo  : https://github.com/snecsy123/ArgonHub
    Fixes        : Fixed Sidebar UIListLayout bug, Official Catalog Emote Thumbnails,
                   Movement Auto-Cancel + "Move While Emoting" Pill Switch,
                   Live Async GitHub PNG Loader & True Pulse Hub Aesthetic
    ================================================================================
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ================================================================================
-- 1. CENTRALIZED CONFIGURATION (MATCHED TO YOUR GITHUB REPO: snecsy123/ArgonHub)
-- ================================================================================
local Config = {
    HubName = "Argon Hub",
    SubTitle = "Anim Studio - v2.0",
    ToggleKey = Enum.KeyCode.RightControl,
    AltToggleKey = Enum.KeyCode.V,

    -- Matched directly to your GitHub screenshot (snecsy123/ArgonHub)
    GitHubBaseURL = "https://raw.githubusercontent.com/snecsy123/ArgonHub/main/",
    CacheFolder = "ArgonHub_CacheV2",
    FavoritesFile = "ArgonHub_CacheV2/favorites.json",

    Assets = {
        Logo_Default   = { Path = "assets/branding/logo_default.png",   Fallback = "rbxassetid://10709791437" },
        Logo_Halloween = { Path = "assets/branding/logo_halloween.png", Fallback = "rbxassetid://10709791437" },
        Logo_Christmas = { Path = "assets/branding/logo_christmas.png", Fallback = "rbxassetid://10709791437" },

        Tab_Main       = { Path = "assets/icons/tab_main.png",          Fallback = "rbxassetid://10723407389" },
        Tab_Emotes     = { Path = "assets/icons/tab_emotes.png",        Fallback = "rbxassetid://10734950309" },
        Tab_Bundles    = { Path = "assets/icons/tab_bundles.png",       Fallback = "rbxassetid://10709782497" },
        Tab_Favorites  = { Path = "assets/icons/tab_favorites.png",     Fallback = "rbxassetid://10734966248" },
        Tab_Settings   = { Path = "assets/icons/tab_settings.png",      Fallback = "rbxassetid://10734950020" },

        Search         = { Path = "assets/icons/search.png",            Fallback = "rbxassetid://10734943676" },
        Close          = { Path = "assets/icons/close.png",             Fallback = "rbxassetid://10747384394" },
        Chevron        = { Path = "assets/icons/chevron.png",           Fallback = "rbxassetid://10709790948" },
        Star_Off       = { Path = "assets/icons/star_off.png",          Fallback = "rbxassetid://10734966248" },
        Star_On        = { Path = "assets/icons/star_on.png",           Fallback = "rbxassetid://10734966248" },

        SFX_Boot       = { Path = "assets/audio/boot.mp3",              Fallback = "rbxassetid://9125402735" },
        SFX_Tab        = { Path = "assets/audio/tab.mp3",               Fallback = "rbxassetid://6895079853" },
        SFX_Click      = { Path = "assets/audio/click.mp3",             Fallback = "rbxassetid://6042053626" },
        SFX_Pin        = { Path = "assets/audio/pin.mp3",               Fallback = "rbxassetid://3125624765" },
    },

    -- True Pulse Hub Dark Charcoal & Crisp Accent Palettes
    Themes = {
        Default = {
            Name = "Pulse Dark (Default)",
            LogoKey = "Logo_Default",
            BgMain = Color3.fromRGB(16, 17, 22),
            BgSidebar = Color3.fromRGB(13, 14, 18),
            BgHeader = Color3.fromRGB(13, 14, 18),
            CardBg = Color3.fromRGB(22, 24, 30),
            CardHover = Color3.fromRGB(30, 33, 42),
            TabActive = Color3.fromRGB(36, 39, 48),
            Accent = Color3.fromRGB(59, 130, 246),      -- Pulse Blue
            ToggleOn = Color3.fromRGB(46, 213, 115),   -- Pulse Emerald Green
            ToggleOff = Color3.fromRGB(48, 52, 64),
            TextPrimary = Color3.fromRGB(242, 244, 248),
            TextDim = Color3.fromRGB(138, 144, 160),
            Stroke = Color3.fromRGB(34, 37, 46)
        },
        Halloween = {
            Name = "Halloween Edition",
            LogoKey = "Logo_Halloween",
            BgMain = Color3.fromRGB(16, 15, 19),
            BgSidebar = Color3.fromRGB(12, 11, 15),
            BgHeader = Color3.fromRGB(12, 11, 15),
            CardBg = Color3.fromRGB(23, 20, 27),
            CardHover = Color3.fromRGB(33, 28, 39),
            TabActive = Color3.fromRGB(40, 32, 46),
            Accent = Color3.fromRGB(255, 117, 24),      -- Pumpkin Neon Orange
            ToggleOn = Color3.fromRGB(255, 117, 24),
            ToggleOff = Color3.fromRGB(50, 42, 56),
            TextPrimary = Color3.fromRGB(248, 244, 242),
            TextDim = Color3.fromRGB(152, 140, 158),
            Stroke = Color3.fromRGB(46, 36, 52)
        },
        Christmas = {
            Name = "Christmas Edition",
            LogoKey = "Logo_Christmas",
            BgMain = Color3.fromRGB(14, 18, 20),
            BgSidebar = Color3.fromRGB(11, 14, 16),
            BgHeader = Color3.fromRGB(11, 14, 16),
            CardBg = Color3.fromRGB(20, 26, 29),
            CardHover = Color3.fromRGB(28, 37, 41),
            TabActive = Color3.fromRGB(32, 44, 48),
            Accent = Color3.fromRGB(46, 213, 115),      -- Festive Holly Emerald
            ToggleOn = Color3.fromRGB(235, 77, 75),     -- Candy Cane Red
            ToggleOff = Color3.fromRGB(42, 54, 58),
            TextPrimary = Color3.fromRGB(242, 250, 246),
            TextDim = Color3.fromRGB(136, 158, 150),
            Stroke = Color3.fromRGB(34, 48, 52)
        }
    }
}

-- ================================================================================
-- 2. VERIFIED CATALOG EMOTES (100% REAL SILHOUETTE THUMBNAILS — NO CLAPPERBOARDS!)
-- ================================================================================
-- CatalogId = Official Roblox Marketplace Asset ID (gives crisp white silhouette icon)
-- AnimId    = Actual R15 Animation Track ID played on Humanoid
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
    { Name = "Monkey",            CatalogId = 3716636630, AnimId = 3333499508 },
    { Name = "Godlike",           CatalogId = 3823158750, AnimId = 3337994105 },
    { Name = "Bodybuilder",       CatalogId = 3994127840, AnimId = 3994127840 },
    { Name = "Air Guitar",        CatalogId = 3994129128, AnimId = 3994129128 },
    { Name = "Cha Cha",           CatalogId = 3695333486, AnimId = 3695333486 },
    { Name = "Line Dance",        CatalogId = 4049037604, AnimId = 4049037604 },
    { Name = "Idol",              CatalogId = 4102315500, AnimId = 4102315500 },
    { Name = "Around Town",       CatalogId = 3576717965, AnimId = 3303391864 },
    { Name = "Top Rock",          CatalogId = 3570535774, AnimId = 3361276673 },
    { Name = "Fashionable",       CatalogId = 3576745472, AnimId = 3333331310 },
    { Name = "Heel Click",        CatalogId = 3716632249, AnimId = 3319602808 },
    { Name = "Happy",             CatalogId = 4841405708, AnimId = 4841397952 },
    { Name = "Sad",               CatalogId = 4841407203, AnimId = 4841403964 },
    { Name = "Sleep",             CatalogId = 4686925579, AnimId = 4686925579 },
    { Name = "Cower",             CatalogId = 4940563117, AnimId = 4940563117 },
    { Name = "Hero Landing",      CatalogId = 5104344710, AnimId = 5104341999 },
    { Name = "Confused",          CatalogId = 4940561610, AnimId = 4940561610 },
    { Name = "Jumping Wave",      CatalogId = 4940564896, AnimId = 4940564896 },
    { Name = "Keeping Time",      CatalogId = 4555808220, AnimId = 4555782893 },
    { Name = "Dorky Dance",       CatalogId = 4212455378, AnimId = 4212455378 },
}

local BundleDatabase = {
    {
        Name = "Mage",
        BundleId = 39,
        Parts = {
            Idle  = { 707742142, 707855907 },
            Walk  = { 707897309 },
            Run   = { 707861613 },
            Jump  = { 707853694 },
            Fall  = { 707829716 },
            Climb = { 707826056 },
            Swim  = { 707876443 }
        }
    },
    {
        Name = "Levitation",
        BundleId = 47,
        Parts = {
            Idle  = { 616006778, 616008087 },
            Walk  = { 616013216 },
            Run   = { 616010382 },
            Jump  = { 616008936 },
            Fall  = { 616005863 },
            Climb = { 616003713 },
            Swim  = { 616011509 }
        }
    },
    {
        Name = "Ninja",
        BundleId = 43,
        Parts = {
            Idle  = { 656117400, 656118341 },
            Walk  = { 656121766 },
            Run   = { 656118852 },
            Jump  = { 656117878 },
            Fall  = { 656115606 },
            Climb = { 656114359 },
            Swim  = { 656119721 }
        }
    },
    {
        Name = "Toy",
        BundleId = 55,
        Parts = {
            Idle  = { 782841498, 782845736 },
            Walk  = { 782843345 },
            Run   = { 782842708 },
            Jump  = { 782847020 },
            Fall  = { 782846423 },
            Climb = { 782843869 },
            Swim  = { 782844582 }
        }
    },
    {
        Name = "Superhero",
        BundleId = 49,
        Parts = {
            Idle  = { 616111295, 616113536 },
            Walk  = { 616122287 },
            Run   = { 616117076 },
            Jump  = { 616115533 },
            Fall  = { 616108001 },
            Climb = { 616104706 },
            Swim  = { 616119360 }
        }
    },
    {
        Name = "Vampire",
        BundleId = 57,
        Parts = {
            Idle  = { 1083445855, 1083450166 },
            Walk  = { 1083473930 },
            Run   = { 1083462077 },
            Jump  = { 1083455352 },
            Fall  = { 1083443587 },
            Climb = { 1083439238 },
            Swim  = { 1083464683 }
        }
    },
    {
        Name = "Zombie",
        BundleId = 51,
        Parts = {
            Idle  = { 616158929, 616160636 },
            Walk  = { 616168032 },
            Run   = { 616163682 },
            Jump  = { 616161997 },
            Fall  = { 616157476 },
            Climb = { 616156119 },
            Swim  = { 616165109 }
        }
    },
    {
        Name = "Werewolf",
        BundleId = 59,
        Parts = {
            Idle  = { 1083195517, 1083214717 },
            Walk  = { 1083178339 },
            Run   = { 1083216690 },
            Jump  = { 1083218792 },
            Fall  = { 1083189019 },
            Climb = { 1083182000 },
            Swim  = { 1083222527 }
        }
    },
    {
        Name = "Cartoony",
        BundleId = 35,
        Parts = {
            Idle  = { 742637544, 742638445 },
            Walk  = { 742640026 },
            Run   = { 742638842 },
            Jump  = { 742637942 },
            Fall  = { 742637151 },
            Climb = { 742636889 },
            Swim  = { 742639220 }
        }
    },
    {
        Name = "Astronaut",
        BundleId = 31,
        Parts = {
            Idle  = { 891621366, 891633237 },
            Walk  = { 891667138 },
            Run   = { 891636393 },
            Jump  = { 891627522 },
            Fall  = { 891617961 },
            Climb = { 891609353 },
            Swim  = { 891639666 }
        }
    }
}

-- ================================================================================
-- 3. CLEANUP OLD UI & INITIALIZE STATE
-- ================================================================================
local GuiParent = (gethui and gethui()) or CoreGui
for _, oldName in ipairs({ "ArgonHub_Studio", "ArgonHub_V2" }) do
    if GuiParent:FindFirstChild(oldName) then
        GuiParent:FindFirstChild(oldName):Destroy()
    end
end

local State = {
    Visible = true,
    CurrentTab = "Main",
    CurrentThemeKey = "Default",
    StopEmoteOnMove = true,      -- Default: moving automatically stops emote
    LoopEmotes = true,           -- Loop emotes continuously
    EmoteSpeed = 1.0,
    ActiveEmoteTrack = nil,
    ActiveEmoteName = nil,
    EquippedParts = {},
    Favorites = { Emotes = {}, Bundles = {}, Parts = {} },
    Connections = {},
    ThemeUpdaters = {},
    LogoElements = {}
}

local function DetectSeasonalTheme()
    local d = os.date("*t")
    if d and d.month == 10 then return "Halloween" end
    if d and d.month == 12 then return "Christmas" end
    return "Default"
end
State.CurrentThemeKey = DetectSeasonalTheme()

-- ================================================================================
-- 4. LIVE ASYNC GITHUB ASSET ENGINE (AUTO-UPDATES LOGOS WHEN DOWNLOAD COMPLETES)
-- ================================================================================
local HasFileSystem = (typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function" and typeof(makefolder) == "function")
local HasCustomAsset = (typeof(getcustomasset) == "function")

if HasFileSystem then
    pcall(function()
        if not isfolder(Config.CacheFolder) then makefolder(Config.CacheFolder) end
        if not isfolder(Config.CacheFolder .. "/assets") then makefolder(Config.CacheFolder .. "/assets") end
        if not isfolder(Config.CacheFolder .. "/assets/branding") then makefolder(Config.CacheFolder .. "/assets/branding") end
        if not isfolder(Config.CacheFolder .. "/assets/icons") then makefolder(Config.CacheFolder .. "/assets/icons") end
        if not isfolder(Config.CacheFolder .. "/assets/audio") then makefolder(Config.CacheFolder .. "/assets/audio") end
    end)
end

local ResolvedAssets = {}

local function BindAssetToImage(imageLabel, assetKey)
    local entry = Config.Assets[assetKey]
    if not entry then return end

    if ResolvedAssets[assetKey] then
        imageLabel.Image = ResolvedAssets[assetKey]
        return
    end

    imageLabel.Image = entry.Fallback

    if HasFileSystem and HasCustomAsset then
        local localPath = Config.CacheFolder .. "/" .. entry.Path
        if isfile(localPath) then
            local ok, cid = pcall(getcustomasset, localPath)
            if ok and cid then
                ResolvedAssets[assetKey] = cid
                imageLabel.Image = cid
                return
            end
        end

        task.spawn(function()
            local ok, data = pcall(function()
                return game:HttpGet(Config.GitHubBaseURL .. entry.Path)
            end)
            if ok and data and #data > 100 and not string.find(data, "404: Not Found") then
                pcall(writefile, localPath, data)
                local cOk, cid = pcall(getcustomasset, localPath)
                if cOk and cid then
                    ResolvedAssets[assetKey] = cid
                    if imageLabel and imageLabel.Parent then
                        imageLabel.Image = cid
                    end
                end
            end
        end)
    end
end

local function GetAssetImmediate(assetKey)
    if ResolvedAssets[assetKey] then return ResolvedAssets[assetKey] end
    local entry = Config.Assets[assetKey]
    return entry and entry.Fallback or ""
end

local function SaveFavorites()
    if not HasFileSystem then return end
    pcall(function()
        writefile(Config.FavoritesFile, HttpService:JSONEncode(State.Favorites))
    end)
end

local function LoadFavorites()
    if not HasFileSystem then return end
    pcall(function()
        if isfile(Config.FavoritesFile) then
            local data = HttpService:JSONDecode(readfile(Config.FavoritesFile))
            if type(data) == "table" then
                State.Favorites.Emotes  = data.Emotes or {}
                State.Favorites.Bundles = data.Bundles or {}
                State.Favorites.Parts   = data.Parts or {}
            end
        end
    end)
end
LoadFavorites()

-- ================================================================================
-- 5. UI SOUND ENGINE & ANIMATION / MOVEMENT CONTROLLER
-- ================================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArgonHub_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

local SoundFolder = Instance.new("Folder", ScreenGui)
SoundFolder.Name = "Audio"

local function PlaySFX(key, vol)
    task.spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = GetAssetImmediate(key)
        s.Volume = vol or 0.4
        s.Parent = SoundFolder
        s:Play()
        s.Ended:Connect(function() s:Destroy() end)
    end)
end

local UpdateFloatingStopBar -- Forward reference

local function StopActiveEmote()
    if State.ActiveEmoteTrack then
        pcall(function()
            State.ActiveEmoteTrack:Stop(0.2)
            State.ActiveEmoteTrack:Destroy()
        end)
        State.ActiveEmoteTrack = nil
        State.ActiveEmoteName = nil
    end
    if UpdateFloatingStopBar then
        UpdateFloatingStopBar()
    end
end

local function PlayEmote(emoteData)
    StopActiveEmote()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)

    task.spawn(function()
        local animObj = nil
        -- Try loading from CatalogId first in case executor supports GetObjects, otherwise direct AnimId
        local ok, objs = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(emoteData.CatalogId))
        end)
        if ok and objs and #objs > 0 then
            local root = objs[1]
            animObj = root:IsA("Animation") and root or root:FindFirstChildOfClass("Animation", true)
        end

        if not animObj then
            animObj = Instance.new("Animation")
            animObj.AnimationId = "rbxassetid://" .. tostring(emoteData.AnimId or emoteData.CatalogId)
        end

        local loadOk, track = pcall(function()
            return animator:LoadAnimation(animObj)
        end)

        if loadOk and track then
            track.Priority = Enum.AnimationPriority.Action
            track.Looped = State.LoopEmotes
            track:Play(0.15)
            track:AdjustSpeed(State.EmoteSpeed)
            State.ActiveEmoteTrack = track
            State.ActiveEmoteName = emoteData.Name
            if UpdateFloatingStopBar then
                UpdateFloatingStopBar()
            end
        end
    end)
end

-- Automatic Movement / Jump Emote Cancel Listener
table.insert(State.Connections, RunService.RenderStepped:Connect(function()
    if State.ActiveEmoteTrack and State.StopEmoteOnMove then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.MoveDirection.Magnitude > 0.08 or hum.Jump then
                StopActiveEmote()
            end
        end
    end
end))

local function ApplyAnimationPart(partName, animIds, bundleName)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animateScript = char:FindFirstChild("Animate")
    if not hum or not animateScript then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            t:Stop(0.1)
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
    hum:ChangeState(Enum.HumanoidStateType.Landed)
end

local function EquipFullBundle(bundle)
    for partName, ids in pairs(bundle.Parts) do
        ApplyAnimationPart(partName, ids, bundle.Name)
    end
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
-- 6. PULSE HUB WINDOW & THEME ENGINE
-- ================================================================================
local function GetTheme()
    return Config.Themes[State.CurrentThemeKey] or Config.Themes.Default
end

local function RegisterThemeUpdater(fn)
    table.insert(State.ThemeUpdaters, fn)
    fn(GetTheme())
end

local function RefreshAllThemes()
    local theme = GetTheme()
    for _, fn in ipairs(State.ThemeUpdaters) do
        task.spawn(fn, theme)
    end
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "PulseWindow"
MainFrame.Size = UDim2.new(0, 690, 0, 440)
MainFrame.Position = UDim2.new(0.5, -345, 0.5, -220)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1

RegisterThemeUpdater(function(theme)
    MainFrame.BackgroundColor3 = theme.BgMain
    MainStroke.Color = theme.Stroke
end)

-- ================================================================================
-- 7. PULSE HUB HEADER (CLEAN LOGO + SEARCH BAR + CLOSE — NO UGLY STOP BUTTON!)
-- ================================================================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderBorder = Instance.new("Frame")
HeaderBorder.Size = UDim2.new(1, 0, 0, 1)
HeaderBorder.Position = UDim2.new(0, 0, 1, -1)
HeaderBorder.BorderSizePixel = 0
HeaderBorder.Parent = Header

local BrandBadge = Instance.new("Frame")
BrandBadge.Size = UDim2.new(0, 32, 0, 32)
BrandBadge.Position = UDim2.new(0, 14, 0.5, -16)
BrandBadge.BorderSizePixel = 0
BrandBadge.Parent = Header
Instance.new("UICorner", BrandBadge).CornerRadius = UDim.new(1, 0)

local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 26, 0, 26)
HeaderLogo.Position = UDim2.new(0.5, -13, 0.5, -13)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
HeaderLogo.ScaleType = Enum.ScaleType.Fit
HeaderLogo.Parent = BrandBadge

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(0, 120, 0, 16)
HubTitle.Position = UDim2.new(0, 54, 0, 11)
HubTitle.BackgroundTransparency = 1
HubTitle.Font = Enum.Font.GothamBold
HubTitle.Text = Config.HubName
HubTitle.TextSize = 13
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.Parent = Header

local HubSubTitle = Instance.new("TextLabel")
HubSubTitle.Size = UDim2.new(0, 120, 0, 14)
HubSubTitle.Position = UDim2.new(0, 54, 0, 26)
HubSubTitle.BackgroundTransparency = 1
HubSubTitle.Font = Enum.Font.GothamMedium
HubSubTitle.Text = Config.SubTitle
HubSubTitle.TextSize = 11
HubSubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubSubTitle.Parent = Header

-- Search Input Bar (Styled directly like Pulse Hub reference)
local SearchBar = Instance.new("Frame")
SearchBar.Size = UDim2.new(0, 220, 0, 30)
SearchBar.Position = UDim2.new(1, -264, 0.5, -15)
SearchBar.BorderSizePixel = 0
SearchBar.Parent = Header
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 6)
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Thickness = 1

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Size = UDim2.new(0, 13, 0, 13)
SearchIcon.Position = UDim2.new(0, 10, 0.5, -6)
SearchIcon.BackgroundTransparency = 1
BindAssetToImage(SearchIcon, "Search")
SearchIcon.Parent = SearchBar

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -50, 1, 0)
SearchBox.Position = UDim2.new(0, 28, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.PlaceholderText = "Search..."
SearchBox.Text = ""
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchBar

local ClearSearchBtn = Instance.new("ImageButton")
ClearSearchBtn.Size = UDim2.new(0, 12, 0, 12)
ClearSearchBtn.Position = UDim2.new(1, -20, 0.5, -6)
ClearSearchBtn.BackgroundTransparency = 1
BindAssetToImage(ClearSearchBtn, "Close")
ClearSearchBtn.Visible = false
ClearSearchBtn.Parent = SearchBar

local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0, 16, 0, 16)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -8)
CloseBtn.BackgroundTransparency = 1
BindAssetToImage(CloseBtn, "Close")
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    PlaySFX("SFX_Click")
    State.Visible = false
    MainFrame.Visible = false
end)

RegisterThemeUpdater(function(theme)
    Header.BackgroundColor3 = theme.BgHeader
    HeaderBorder.BackgroundColor3 = theme.Stroke
    BrandBadge.BackgroundColor3 = theme.CardBg
    BindAssetToImage(HeaderLogo, theme.LogoKey)
    HubTitle.TextColor3 = theme.Accent
    HubSubTitle.TextColor3 = theme.TextDim
    SearchBar.BackgroundColor3 = theme.CardBg
    SearchStroke.Color = theme.Stroke
    SearchIcon.ImageColor3 = theme.TextDim
    SearchBox.TextColor3 = theme.TextPrimary
    SearchBox.PlaceholderColor3 = theme.TextDim
    ClearSearchBtn.ImageColor3 = theme.TextDim
    CloseBtn.ImageColor3 = theme.TextDim
end)

-- Smooth Dragging on Header
do
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    table.insert(State.Connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end

-- ================================================================================
-- 8. LEFT SIDEBAR NAVIGATION (FIXED! DIVIDER SEPARATED FROM UILISTLAYOUT)
-- ================================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 156, 1, -52)
Sidebar.Position = UDim2.new(0, 0, 0, 52)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Vertical border parented to MainFrame (NOT Sidebar!) so UIListLayout never breaks
local SidebarBorder = Instance.new("Frame")
SidebarBorder.Name = "SidebarBorder"
SidebarBorder.Size = UDim2.new(0, 1, 1, -52)
SidebarBorder.Position = UDim2.new(0, 156, 0, 52)
SidebarBorder.BorderSizePixel = 0
SidebarBorder.Parent = MainFrame

local NavList = Instance.new("UIListLayout")
NavList.Padding = UDim.new(0, 4)
NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Parent = Sidebar

local NavPad = Instance.new("UIPadding", Sidebar)
NavPad.PaddingTop = UDim.new(0, 12)

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.Size = UDim2.new(1, -157, 1, -52)
ContentHolder.Position = UDim2.new(0, 157, 0, 52)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = MainFrame

-- Context-Aware Bottom Stop Emote Bar (ONLY visible when "Move While Emoting" is ON and an emote is playing)
local FloatingStopBar = Instance.new("Frame")
FloatingStopBar.Size = UDim2.new(1, -24, 0, 36)
FloatingStopBar.Position = UDim2.new(0, 12, 1, -46)
FloatingStopBar.BackgroundColor3 = Color3.fromRGB(28, 18, 22)
FloatingStopBar.BorderSizePixel = 0
FloatingStopBar.Visible = false
FloatingStopBar.ZIndex = 10
FloatingStopBar.Parent = ContentHolder
Instance.new("UICorner", FloatingStopBar).CornerRadius = UDim.new(0, 8)
local fStroke = Instance.new("UIStroke", FloatingStopBar)
fStroke.Color = Color3.fromRGB(235, 77, 75)
fStroke.Thickness = 1

local fLabel = Instance.new("TextLabel")
fLabel.Size = UDim2.new(1, -120, 1, 0)
fLabel.Position = UDim2.new(0, 14, 0, 0)
fLabel.BackgroundTransparency = 1
fLabel.Font = Enum.Font.GothamSemibold
fLabel.Text = "Playing Emote..."
fLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
fLabel.TextSize = 12
fLabel.TextXAlignment = Enum.TextXAlignment.Left
fLabel.ZIndex = 11
fLabel.Parent = FloatingStopBar

local fStopBtn = Instance.new("TextButton")
fStopBtn.Size = UDim2.new(0, 96, 0, 26)
fStopBtn.Position = UDim2.new(1, -104, 0.5, -13)
fStopBtn.BackgroundColor3 = Color3.fromRGB(235, 77, 75)
fStopBtn.Font = Enum.Font.GothamBold
fStopBtn.Text = "Stop Emote"
fStopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fStopBtn.TextSize = 11
fStopBtn.AutoButtonColor = false
fStopBtn.ZIndex = 11
fStopBtn.Parent = FloatingStopBar
Instance.new("UICorner", fStopBtn).CornerRadius = UDim.new(0, 6)

fStopBtn.MouseButton1Click:Connect(function()
    PlaySFX("SFX_Click")
    StopActiveEmote()
end)

UpdateFloatingStopBar = function()
    if State.ActiveEmoteTrack and not State.StopEmoteOnMove then
        fLabel.Text = "Active Emote: " .. tostring(State.ActiveEmoteName or "Playing") .. " (Move Lock Off)"
        FloatingStopBar.Visible = true
    else
        FloatingStopBar.Visible = false
    end
end

RegisterThemeUpdater(function(theme)
    Sidebar.BackgroundColor3 = theme.BgSidebar
    SidebarBorder.BackgroundColor3 = theme.Stroke
end)

local TabButtons = {}
local TabPages = {}
local RebuildFavoritesView

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name .. "_Page"
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.Parent = ContentHolder

    local pad = Instance.new("UIPadding", p)
    pad.PaddingTop = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 52)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)

    RegisterThemeUpdater(function(theme)
        p.ScrollBarImageColor3 = theme.Accent
    end)

    TabPages[name] = p
    return p
end

local function SwitchTab(tabName)
    State.CurrentTab = tabName
    local theme = GetTheme()
    for name, page in pairs(TabPages) do
        page.Visible = (name == tabName)
    end
    for name, item in pairs(TabButtons) do
        local active = (name == tabName)
        TweenService:Create(item.Btn, TweenInfo.new(0.18), {
            BackgroundColor3 = theme.TabActive,
            BackgroundTransparency = active and 0 or 1
        }):Play()
        TweenService:Create(item.Icon, TweenInfo.new(0.18), {
            ImageColor3 = active and theme.TextPrimary or theme.TextDim
        }):Play()
        TweenService:Create(item.Title, TweenInfo.new(0.18), {
            TextColor3 = active and theme.TextPrimary or theme.TextDim
        }):Play()
        item.Arrow.TextColor3 = active and theme.TextPrimary or theme.TextDim
    end
    if tabName == "Favorites" and RebuildFavoritesView then
        RebuildFavoritesView()
    end
end

local TabsList = {
    { Name = "Main",      Icon = "Tab_Main" },
    { Name = "Emotes",    Icon = "Tab_Emotes" },
    { Name = "Bundles",   Icon = "Tab_Bundles" },
    { Name = "Favorites", Icon = "Tab_Favorites" },
    { Name = "Settings",  Icon = "Tab_Settings" }
}

for idx, info in ipairs(TabsList) do
    CreatePage(info.Name)

    local btn = Instance.new("TextButton")
    btn.Name = info.Name .. "_Nav"
    btn.LayoutOrder = idx
    btn.Size = UDim2.new(0, 136, 0, 34)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local icn = Instance.new("ImageLabel")
    icn.Size = UDim2.new(0, 15, 0, 15)
    icn.Position = UDim2.new(0, 11, 0.5, -7)
    icn.BackgroundTransparency = 1
    BindAssetToImage(icn, info.Icon)
    icn.Parent = btn

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -50, 1, 0)
    ttl.Position = UDim2.new(0, 34, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Font = Enum.Font.GothamMedium
    ttl.Text = info.Name
    ttl.TextSize = 12
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = btn

    -- Subtle right chevron arrow matching Pulse Hub sidebar
    local arr = Instance.new("TextLabel")
    arr.Size = UDim2.new(0, 12, 1, 0)
    arr.Position = UDim2.new(1, -18, 0, 0)
    arr.BackgroundTransparency = 1
    arr.Font = Enum.Font.GothamBold
    arr.Text = "›"
    arr.TextSize = 14
    arr.Parent = btn

    TabButtons[info.Name] = { Btn = btn, Icon = icn, Title = ttl, Arrow = arr }

    btn.MouseButton1Click:Connect(function()
        PlaySFX("SFX_Tab")
        SwitchTab(info.Name)
    end)
end

RegisterThemeUpdater(function()
    SwitchTab(State.CurrentTab)
end)

-- ================================================================================
-- 9. PULSE HUB COMPONENT BUILDER (PILL SWITCHES & TWO-COLUMN SECTIONS)
-- ================================================================================
local function CreatePulseToggleRow(parent, labelText, defaultState, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = labelText
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local pill = Instance.new("TextButton")
    pill.Size = UDim2.new(0, 40, 0, 20)
    pill.Position = UDim2.new(1, -40, 0.5, -10)
    pill.Text = ""
    pill.AutoButtonColor = false
    pill.Parent = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local enabled = defaultState

    local function UpdateVisual()
        local theme = GetTheme()
        lbl.TextColor3 = enabled and theme.TextPrimary or theme.TextDim
        TweenService:Create(pill, TweenInfo.new(0.18), {
            BackgroundColor3 = enabled and theme.ToggleOn or theme.ToggleOff
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        }):Play()
    end

    pill.MouseButton1Click:Connect(function()
        PlaySFX("SFX_Click")
        enabled = not enabled
        UpdateVisual()
        callback(enabled)
    end)

    RegisterThemeUpdater(UpdateVisual)
    return row
end

-- ================================================================================
-- 10. TAB 1: MAIN TAB (TWO-COLUMN PULSE HUB CONTROLLER LAYOUT)
-- ================================================================================
do
    local page = TabPages["Main"]

    local twoCol = Instance.new("Frame")
    twoCol.Size = UDim2.new(1, 0, 0, 340)
    twoCol.BackgroundTransparency = 1
    twoCol.Parent = page

    -- Left Column: Emote Behavior & Movement Controls
    local leftCol = Instance.new("Frame")
    leftCol.Size = UDim2.new(0.485, 0, 1, 0)
    leftCol.BackgroundTransparency = 1
    leftCol.Parent = twoCol
    local leftList = Instance.new("UIListLayout", leftCol)
    leftList.Padding = UDim.new(0, 8)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Vertical Divider between columns (Just like Pulse Hub screenshot)
    local colDiv = Instance.new("Frame")
    colDiv.Size = UDim2.new(0, 1, 1, 0)
    colDiv.Position = UDim2.new(0.5, 0, 0, 0)
    colDiv.BorderSizePixel = 0
    colDiv.Parent = twoCol

    -- Right Column: Quick Animation Presets & Studio Status
    local rightCol = Instance.new("Frame")
    rightCol.Size = UDim2.new(0.485, 0, 1, 0)
    rightCol.Position = UDim2.new(0.515, 0, 0, 0)
    rightCol.BackgroundTransparency = 1
    rightCol.Parent = twoCol
    local rightList = Instance.new("UIListLayout", rightCol)
    rightList.Padding = UDim.new(0, 8)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder

    local function MakeSectionHeader(parent, text)
        local h = Instance.new("TextLabel")
        h.Size = UDim2.new(1, 0, 0, 22)
        h.BackgroundTransparency = 1
        h.Font = Enum.Font.GothamBold
        h.Text = text
        h.TextSize = 13
        h.TextXAlignment = Enum.TextXAlignment.Left
        h.Parent = parent
        RegisterThemeUpdater(function(theme)
            h.TextColor3 = theme.TextPrimary
        end)
        return h
    end

    -- LEFT COLUMN CONTROLS
    MakeSectionHeader(leftCol, "Emote Movement")

    CreatePulseToggleRow(leftCol, "Stop Emote When Moving", true, function(val)
        State.StopEmoteOnMove = val
        UpdateFloatingStopBar()
    end)

    CreatePulseToggleRow(leftCol, "Move While Emoting (Walk Lock)", false, function(val)
        State.StopEmoteOnMove = not val
        UpdateFloatingStopBar()
    end)

    CreatePulseToggleRow(leftCol, "Loop Emotes Continuously", true, function(val)
        State.LoopEmotes = val
        if State.ActiveEmoteTrack then
            State.ActiveEmoteTrack.Looped = val
        end
    end)

    MakeSectionHeader(leftCol, "Playback Speed")

    for _, spd in ipairs({
        { Label = "0.5x Slow-Mo Speed", Speed = 0.5 },
        { Label = "1.0x Normal Speed",  Speed = 1.0 },
        { Label = "1.5x Turbo Speed",   Speed = 1.5 },
        { Label = "2.0x Hyper Speed",   Speed = 2.0 },
    }) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Font = Enum.Font.GothamSemibold
        btn.Text = spd.Label
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.Parent = leftCol
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", btn)
        st.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            State.EmoteSpeed = spd.Speed
            if State.ActiveEmoteTrack then
                State.ActiveEmoteTrack:AdjustSpeed(spd.Speed)
            end
        end)

        RegisterThemeUpdater(function(theme)
            btn.BackgroundColor3 = theme.CardBg
            btn.TextColor3 = theme.TextPrimary
            st.Color = theme.Stroke
        end)
    end

    -- RIGHT COLUMN CONTROLS
    MakeSectionHeader(rightCol, "Quick Bundle Combos")

    local QuickCombos = {
        { Name = "Equip Tryhard Combo (Toy Idle + Ninja Run)", Action = function()
            ApplyAnimationPart("Idle", BundleDatabase[4].Parts.Idle, "Toy")
            ApplyAnimationPart("Walk", BundleDatabase[3].Parts.Walk, "Ninja")
            ApplyAnimationPart("Run",  BundleDatabase[3].Parts.Run,  "Ninja")
            ApplyAnimationPart("Jump", BundleDatabase[2].Parts.Jump, "Levitation")
        end },
        { Name = "Equip Korblox/Headless Style (Mage + Vampire)", Action = function()
            ApplyAnimationPart("Idle", BundleDatabase[1].Parts.Idle, "Mage")
            ApplyAnimationPart("Walk", BundleDatabase[6].Parts.Walk, "Vampire")
            ApplyAnimationPart("Run",  BundleDatabase[6].Parts.Run,  "Vampire")
            ApplyAnimationPart("Jump", BundleDatabase[5].Parts.Jump, "Superhero")
        end },
        { Name = "Equip Floaty God Combo (Levitation + Hero)", Action = function()
            ApplyAnimationPart("Idle", BundleDatabase[2].Parts.Idle, "Levitation")
            ApplyAnimationPart("Walk", BundleDatabase[2].Parts.Walk, "Levitation")
            ApplyAnimationPart("Run",  BundleDatabase[5].Parts.Run,  "Superhero")
        end },
        { Name = "Stop Current Emote Immediately", Action = function()
            StopActiveEmote()
        end }
    }

    for _, combo in ipairs(QuickCombos) do
        local cBtn = Instance.new("TextButton")
        cBtn.Size = UDim2.new(1, 0, 0, 34)
        cBtn.Font = Enum.Font.GothamSemibold
        cBtn.Text = combo.Name
        cBtn.TextSize = 11
        cBtn.AutoButtonColor = false
        cBtn.Parent = rightCol
        Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 6)
        local cSt = Instance.new("UIStroke", cBtn)
        cSt.Thickness = 1

        cBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            combo.Action()
        end)

        RegisterThemeUpdater(function(theme)
            cBtn.BackgroundColor3 = theme.CardBg
            cBtn.TextColor3 = theme.TextPrimary
            cSt.Color = theme.Stroke
        end)
    end

    RegisterThemeUpdater(function(theme)
        colDiv.BackgroundColor3 = theme.Stroke
    end)
end

-- ================================================================================
-- 11. TAB 2: EMOTES TAB (CLEAN 3-COLUMN GRID + REAL SILHOUETTE THUMBNAILS)
-- ================================================================================
local EmoteCards = {}
do
    local page = TabPages["Emotes"]

    -- Quick top toggle inside Emotes tab as well for instant access
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BorderSizePixel = 0
    topBar.Parent = page
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)
    local topStroke = Instance.new("UIStroke", topBar)

    local pad = Instance.new("UIPadding", topBar)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)

    CreatePulseToggleRow(topBar, "Auto-Stop Emote When Walking / Jumping", true, function(val)
        State.StopEmoteOnMove = val
        UpdateFloatingStopBar()
    end)

    local gridHolder = Instance.new("Frame")
    gridHolder.Size = UDim2.new(1, 0, 0, 0)
    gridHolder.Position = UDim2.new(0, 0, 0, 46)
    gridHolder.AutomaticSize = Enum.AutomaticSize.Y
    gridHolder.BackgroundTransparency = 1
    gridHolder.Parent = page

    local grid = Instance.new("UIGridLayout", gridHolder)
    grid.CellSize = UDim2.new(0, 158, 0, 162)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.SortOrder = Enum.SortOrder.LayoutOrder

    for idx, emote in ipairs(EmoteDatabase) do
        local card = Instance.new("Frame")
        card.Name = emote.Name
        card.LayoutOrder = idx
        card.BorderSizePixel = 0
        card.Parent = gridHolder
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local cStroke = Instance.new("UIStroke", card)
        cStroke.Thickness = 1

        -- Official Catalog Silhouette Thumbnail
        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(0, 76, 0, 76)
        thumb.Position = UDim2.new(0.5, -38, 0, 10)
        thumb.BackgroundTransparency = 1
        thumb.Image = "rbxthumb://type=Asset&id=" .. tostring(emote.CatalogId) .. "&w=150&h=150"
        thumb.Parent = card

        local starBtn = Instance.new("ImageButton")
        starBtn.Size = UDim2.new(0, 16, 0, 16)
        starBtn.Position = UDim2.new(1, -24, 0, 8)
        starBtn.BackgroundTransparency = 1
        starBtn.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -16, 0, 16)
        title.Position = UDim2.new(0, 8, 0, 92)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = emote.Name
        title.TextSize = 12
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.Parent = card

        local idLabel = Instance.new("TextLabel")
        idLabel.Size = UDim2.new(1, -16, 0, 12)
        idLabel.Position = UDim2.new(0, 8, 0, 108)
        idLabel.BackgroundTransparency = 1
        idLabel.Font = Enum.Font.Gotham
        idLabel.Text = "ID: " .. tostring(emote.CatalogId)
        idLabel.TextSize = 10
        idLabel.Parent = card

        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(1, -16, 0, 26)
        playBtn.Position = UDim2.new(0, 8, 1, -34)
        playBtn.Font = Enum.Font.GothamSemibold
        playBtn.Text = "Play Emote"
        playBtn.TextSize = 11
        playBtn.AutoButtonColor = false
        playBtn.Parent = card
        Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)

        local function UpdateStar()
            local isFav = State.Favorites.Emotes[tostring(emote.CatalogId)] == true
            local theme = GetTheme()
            BindAssetToImage(starBtn, isFav and "Star_On" or "Star_Off")
            starBtn.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or theme.TextDim
        end

        starBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Pin")
            local k = tostring(emote.CatalogId)
            State.Favorites.Emotes[k] = not State.Favorites.Emotes[k] or nil
            SaveFavorites()
            UpdateStar()
        end)

        playBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            PlayEmote(emote)
        end)

        RegisterThemeUpdater(function(theme)
            topBar.BackgroundColor3 = theme.CardBg
            topStroke.Color = theme.Stroke
            card.BackgroundColor3 = theme.CardBg
            cStroke.Color = theme.Stroke
            title.TextColor3 = theme.TextPrimary
            idLabel.TextColor3 = theme.TextDim
            playBtn.BackgroundColor3 = theme.BgSidebar
            playBtn.TextColor3 = theme.Accent
            UpdateStar()
        end)

        table.insert(EmoteCards, { Frame = card, Data = emote })
    end
end

-- ================================================================================
-- 12. TAB 3: MODULAR BUNDLES TAB (FULL EQUIP + EXPANDABLE 7-PART MIXER)
-- ================================================================================
local BundleCards = {}
local PartOrder = { "Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Swim" }

do
    local page = TabPages["Bundles"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    for idx, bundle in ipairs(BundleDatabase) do
        local expanded = false

        local card = Instance.new("Frame")
        card.Name = bundle.Name
        card.LayoutOrder = idx
        card.Size = UDim2.new(1, 0, 0, 68)
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = page
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local cStroke = Instance.new("UIStroke", card)
        cStroke.Thickness = 1

        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(0, 48, 0, 48)
        thumb.Position = UDim2.new(0, 10, 0, 10)
        thumb.BackgroundTransparency = 1
        thumb.Image = "rbxthumb://type=BundleThumbnail&id=" .. tostring(bundle.BundleId) .. "&w=150&h=150"
        thumb.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(0, 180, 0, 18)
        title.Position = UDim2.new(0, 68, 0, 15)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = bundle.Name .. " Animation Pack"
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card

        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(0, 220, 0, 14)
        status.Position = UDim2.new(0, 68, 0, 35)
        status.BackgroundTransparency = 1
        status.Font = Enum.Font.GothamMedium
        status.Text = "Click arrow to mix individual tracks"
        status.TextSize = 11
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Parent = card

        local starBtn = Instance.new("ImageButton")
        starBtn.Size = UDim2.new(0, 16, 0, 16)
        starBtn.Position = UDim2.new(1, -184, 0, 26)
        starBtn.BackgroundTransparency = 1
        starBtn.Parent = card

        local equipBtn = Instance.new("TextButton")
        equipBtn.Size = UDim2.new(0, 112, 0, 28)
        equipBtn.Position = UDim2.new(1, -156, 0, 20)
        equipBtn.Font = Enum.Font.GothamSemibold
        equipBtn.Text = "Equip Full Pack"
        equipBtn.TextSize = 11
        equipBtn.AutoButtonColor = false
        equipBtn.Parent = card
        Instance.new("UICorner", equipBtn).CornerRadius = UDim.new(0, 6)

        local expandBtn = Instance.new("ImageButton")
        expandBtn.Size = UDim2.new(0, 24, 0, 24)
        expandBtn.Position = UDim2.new(1, -34, 0, 22)
        expandBtn.BackgroundTransparency = 1
        BindAssetToImage(expandBtn, "Chevron")
        expandBtn.Parent = card

        local partsGridFrame = Instance.new("Frame")
        partsGridFrame.Size = UDim2.new(1, -20, 0, 76)
        partsGridFrame.Position = UDim2.new(0, 10, 0, 68)
        partsGridFrame.BackgroundTransparency = 1
        partsGridFrame.Parent = card

        local pGrid = Instance.new("UIGridLayout", partsGridFrame)
        pGrid.CellSize = UDim2.new(0, 114, 0, 32)
        pGrid.CellPadding = UDim2.new(0, 8, 0, 8)

        for _, partName in ipairs(PartOrder) do
            local ids = bundle.Parts[partName]
            if ids then
                local pBtn = Instance.new("TextButton")
                pBtn.Font = Enum.Font.GothamMedium
                pBtn.Text = "  " .. partName
                pBtn.TextSize = 11
                pBtn.TextXAlignment = Enum.TextXAlignment.Left
                pBtn.AutoButtonColor = false
                pBtn.Parent = partsGridFrame
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
                local pSt = Instance.new("UIStroke", pBtn)
                pSt.Thickness = 1

                local pStar = Instance.new("ImageButton")
                pStar.Size = UDim2.new(0, 13, 0, 13)
                pStar.Position = UDim2.new(1, -18, 0.5, -6)
                pStar.BackgroundTransparency = 1
                pStar.Parent = pBtn

                local favKey = bundle.Name .. "_" .. partName
                local function UpdatePStar()
                    local isFav = State.Favorites.Parts[favKey] == true
                    local theme = GetTheme()
                    BindAssetToImage(pStar, isFav and "Star_On" or "Star_Off")
                    pStar.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or theme.TextDim
                end

                pStar.MouseButton1Click:Connect(function()
                    PlaySFX("SFX_Pin")
                    State.Favorites.Parts[favKey] = not State.Favorites.Parts[favKey] or nil
                    SaveFavorites()
                    UpdatePStar()
                end)

                pBtn.MouseButton1Click:Connect(function()
                    PlaySFX("SFX_Click")
                    ApplyAnimationPart(partName, ids, bundle.Name)
                    status.Text = "Equipped " .. bundle.Name .. " " .. partName
                end)

                RegisterThemeUpdater(function(theme)
                    pBtn.BackgroundColor3 = theme.BgSidebar
                    pBtn.TextColor3 = theme.TextPrimary
                    pSt.Color = theme.Stroke
                    UpdatePStar()
                end)
            end
        end

        local function UpdateBStar()
            local isFav = State.Favorites.Bundles[bundle.Name] == true
            local theme = GetTheme()
            BindAssetToImage(starBtn, isFav and "Star_On" or "Star_Off")
            starBtn.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or theme.TextDim
        end

        starBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Pin")
            State.Favorites.Bundles[bundle.Name] = not State.Favorites.Bundles[bundle.Name] or nil
            SaveFavorites()
            UpdateBStar()
        end)

        equipBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            EquipFullBundle(bundle)
            status.Text = "Equipped Full " .. bundle.Name .. " Pack!"
        end)

        expandBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            expanded = not expanded
            TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = expanded and UDim2.new(1, 0, 0, 154) or UDim2.new(1, 0, 0, 68)
            }):Play()
            TweenService:Create(expandBtn, TweenInfo.new(0.22), {
                Rotation = expanded and 180 or 0
            }):Play()
        end)

        RegisterThemeUpdater(function(theme)
            card.BackgroundColor3 = theme.CardBg
            cStroke.Color = theme.Stroke
            title.TextColor3 = theme.TextPrimary
            status.TextColor3 = theme.TextDim
            equipBtn.BackgroundColor3 = theme.BgSidebar
            equipBtn.TextColor3 = theme.Accent
            expandBtn.ImageColor3 = theme.TextDim
            UpdateBStar()
        end)

        table.insert(BundleCards, { Frame = card, Data = bundle })
    end
end

-- ================================================================================
-- 13. TAB 4: FAVORITES TAB
-- ================================================================================
do
    local page = TabPages["Favorites"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    RebuildFavoritesView = function()
        for _, ch in ipairs(page:GetChildren()) do
            if ch:IsA("Frame") or ch:IsA("TextLabel") then ch:Destroy() end
        end

        local theme = GetTheme()
        local total = 0

        local function AddRow(titleTxt, subTxt, onPlay, onRemove)
            total = total + 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 42)
            row.BackgroundColor3 = theme.CardBg
            row.BorderSizePixel = 0
            row.Parent = page
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", row)
            st.Color = theme.Stroke

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamSemibold
            lbl.Text = titleTxt .. "  •  " .. subTxt
            lbl.TextColor3 = theme.TextPrimary
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local actBtn = Instance.new("TextButton")
            actBtn.Size = UDim2.new(0, 88, 0, 26)
            actBtn.Position = UDim2.new(1, -128, 0.5, -13)
            actBtn.BackgroundColor3 = theme.BgSidebar
            actBtn.Font = Enum.Font.GothamBold
            actBtn.Text = "Equip / Play"
            actBtn.TextColor3 = theme.Accent
            actBtn.TextSize = 11
            actBtn.AutoButtonColor = false
            actBtn.Parent = row
            Instance.new("UICorner", actBtn).CornerRadius = UDim.new(0, 6)

            local unpin = Instance.new("ImageButton")
            unpin.Size = UDim2.new(0, 16, 0, 16)
            unpin.Position = UDim2.new(1, -28, 0.5, -8)
            unpin.BackgroundTransparency = 1
            BindAssetToImage(unpin, "Star_On")
            unpin.ImageColor3 = Color3.fromRGB(255, 205, 45)
            unpin.Parent = row

            actBtn.MouseButton1Click:Connect(function()
                PlaySFX("SFX_Click")
                onPlay()
            end)
            unpin.MouseButton1Click:Connect(function()
                PlaySFX("SFX_Pin")
                onRemove()
                SaveFavorites()
                RebuildFavoritesView()
            end)
        end

        for _, em in ipairs(EmoteDatabase) do
            if State.Favorites.Emotes[tostring(em.CatalogId)] then
                AddRow(em.Name, "Catalog Emote", function() PlayEmote(em) end, function()
                    State.Favorites.Emotes[tostring(em.CatalogId)] = nil
                end)
            end
        end

        for _, b in ipairs(BundleDatabase) do
            if State.Favorites.Bundles[b.Name] then
                AddRow(b.Name .. " Pack", "Full Bundle", function() EquipFullBundle(b) end, function()
                    State.Favorites.Bundles[b.Name] = nil
                end)
            end
            for _, pName in ipairs(PartOrder) do
                local k = b.Name .. "_" .. pName
                if State.Favorites.Parts[k] then
                    AddRow(b.Name .. " " .. pName, "Single Track", function()
                        ApplyAnimationPart(pName, b.Parts[pName], b.Name)
                    end, function()
                        State.Favorites.Parts[k] = nil
                    end)
                end
            end
        end

        if total == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 100)
            empty.BackgroundTransparency = 1
            empty.Font = Enum.Font.GothamMedium
            empty.Text = "No favorites saved yet. Click the star on any Emote or Bundle to pin it here."
            empty.TextColor3 = theme.TextDim
            empty.TextSize = 12
            empty.Parent = page
        end
    end
end

-- ================================================================================
-- 14. TAB 5: SETTINGS TAB (THEME SWITCHER & KEYBIND INFO)
-- ================================================================================
do
    local page = TabPages["Settings"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 110)
    card.BorderSizePixel = 0
    card.Parent = page
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", card)

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -24, 0, 20)
    ttl.Position = UDim2.new(0, 14, 0, 12)
    ttl.BackgroundTransparency = 1
    ttl.Font = Enum.Font.GothamBold
    ttl.Text = "Pulse Theme & Seasonal Logo Switcher"
    ttl.TextSize = 13
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = card

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -24, 0, 16)
    sub.Position = UDim2.new(0, 14, 0, 32)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.GothamMedium
    sub.Text = "Switch between the clean Pulse Dark theme, Halloween Orange, or Christmas Edition:"
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = card

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -28, 0, 34)
    row.Position = UDim2.new(0, 14, 0, 58)
    row.BackgroundTransparency = 1
    row.Parent = card

    local rLayout = Instance.new("UIListLayout", row)
    rLayout.FillDirection = Enum.FillDirection.Horizontal
    rLayout.Padding = UDim.new(0, 10)

    for _, mode in ipairs({ "Default", "Halloween", "Christmas" }) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 154, 1, 0)
        b.Font = Enum.Font.GothamSemibold
        b.Text = (mode == "Default" and "Pulse Dark (Default)" or mode .. " Edition")
        b.TextSize = 11
        b.AutoButtonColor = false
        b.Parent = row
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local bSt = Instance.new("UIStroke", b)

        b.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            State.CurrentThemeKey = mode
            RefreshAllThemes()
        end)

        RegisterThemeUpdater(function(theme)
            local active = (State.CurrentThemeKey == mode)
            b.BackgroundColor3 = active and theme.TabActive or theme.BgSidebar
            b.TextColor3 = active and theme.TextPrimary or theme.TextDim
            bSt.Color = active and theme.Accent or theme.Stroke
        end)
    end

    RegisterThemeUpdater(function(theme)
        card.BackgroundColor3 = theme.CardBg
        st.Color = theme.Stroke
        ttl.TextColor3 = theme.TextPrimary
        sub.TextColor3 = theme.TextDim
    end)
end

-- ================================================================================
-- 15. REAL-TIME SEARCH FILTER & KEYBIND TOGGLE
-- ================================================================================
local function FilterByQuery(q)
    local clean = string.lower((q or ""):gsub("^%s*(.-)%s*$", "%1"))
    ClearSearchBtn.Visible = (#clean > 0)

    for _, item in ipairs(EmoteCards) do
        if #clean == 0 then
            item.Frame.Visible = true
        else
            local n = string.lower(item.Data.Name)
            local idStr = tostring(item.Data.CatalogId)
            item.Frame.Visible = (string.find(n, clean, 1, true) ~= nil) or (string.find(idStr, clean, 1, true) ~= nil)
        end
    end

    for _, item in ipairs(BundleCards) do
        if #clean == 0 then
            item.Frame.Visible = true
        else
            local n = string.lower(item.Data.Name)
            item.Frame.Visible = (string.find(n, clean, 1, true) ~= nil)
        end
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    FilterByQuery(SearchBox.Text)
end)

ClearSearchBtn.MouseButton1Click:Connect(function()
    PlaySFX("SFX_Click")
    SearchBox.Text = ""
    FilterByQuery("")
end)

table.insert(State.Connections, UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Config.ToggleKey or inp.KeyCode == Config.AltToggleKey then
        State.Visible = not State.Visible
        MainFrame.Visible = State.Visible
    end
end))

-- ================================================================================
-- 16. SLEEK BOOT SPLASH & LAUNCH
-- ================================================================================
local function Boot()
    local theme = GetTheme()
    local splash = Instance.new("Frame")
    splash.Size = UDim2.new(0, 280, 0, 220)
    splash.Position = UDim2.new(0.5, -140, 0.5, -110)
    splash.BackgroundColor3 = theme.BgMain
    splash.BorderSizePixel = 0
    splash.Parent = ScreenGui
    Instance.new("UICorner", splash).CornerRadius = UDim.new(0, 12)
    local spStroke = Instance.new("UIStroke", splash)
    spStroke.Color = theme.Stroke

    local spLogo = Instance.new("ImageLabel")
    spLogo.Size = UDim2.new(0, 20, 0, 20)
    spLogo.Position = UDim2.new(0.5, -10, 0.42, -10)
    spLogo.BackgroundTransparency = 1
    spLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    spLogo.ScaleType = Enum.ScaleType.Fit
    BindAssetToImage(spLogo, theme.LogoKey)
    spLogo.Parent = splash

    local spTitle = Instance.new("TextLabel")
    spTitle.Size = UDim2.new(1, 0, 0, 22)
    spTitle.Position = UDim2.new(0, 0, 0.76, 0)
    spTitle.BackgroundTransparency = 1
    spTitle.Font = Enum.Font.GothamBold
    spTitle.Text = Config.HubName
    spTitle.TextColor3 = theme.TextPrimary
    spTitle.TextSize = 16
    spTitle.Parent = splash

    PlaySFX("SFX_Boot", 0.5)

    TweenService:Create(spLogo, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 96, 0, 96),
        Position = UDim2.new(0.5, -48, 0.42, -48)
    }):Play()

    task.wait(0.85)
    splash:Destroy()

    MainFrame.Visible = true
    RefreshAllThemes()
    SwitchTab("Main")
end

Boot()
