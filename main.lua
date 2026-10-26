--[[
    ================================================================================
    ARGON HUB | PREMIUM EMOTES & ANIMATION STUDIO (v1.0.0)
    Architecture : Modular R15/R6 Animation Controller & Dynamic Seasonal Glass UI
    Safety Policy: Zero Combat/Exploit Hooks — Pure Cosmetic & Animation Studio
    ================================================================================
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ================================================================================
-- 1. CENTRALIZED CONFIGURATION & ASSET MANIFEST
-- ================================================================================
local Config = {
    HubName = "Argon Hub",
    SubTitle = "Anim Studio • v1.0",
    ToggleKey = Enum.KeyCode.RightControl,
    AltToggleKey = Enum.KeyCode.V,
    
    -- Replace with your raw GitHub repository base URL (keep trailing slash)
    GitHubBaseURL = "https://raw.githubusercontent.com/Snecsy/ArgonHub/main/",
    CacheFolder = "ArgonHub_Cache",
    FavoritesFile = "ArgonHub_Cache/favorites.json",

    -- Relative paths inside your GitHub repo + Instant Roblox Fallback IDs
    Assets = {
        -- Seasonal Branding Logos (Your 3 Custom "A" Logos)
        Logo_Default   = { Path = "assets/branding/logo_default.png",   Fallback = "rbxassetid://10709791437" },
        Logo_Halloween = { Path = "assets/branding/logo_halloween.png", Fallback = "rbxassetid://10709791437" },
        Logo_Christmas = { Path = "assets/branding/logo_christmas.png", Fallback = "rbxassetid://10709791437" },

        -- Sidebar Navigation Icons
        Tab_Main       = { Path = "assets/icons/tab_main.png",          Fallback = "rbxassetid://10723407389" },
        Tab_Emotes     = { Path = "assets/icons/tab_emotes.png",        Fallback = "rbxassetid://10734950309" },
        Tab_Bundles    = { Path = "assets/icons/tab_bundles.png",       Fallback = "rbxassetid://10709782497" },
        Tab_Favorites  = { Path = "assets/icons/tab_favorites.png",     Fallback = "rbxassetid://10734966248" },
        Tab_Settings   = { Path = "assets/icons/tab_settings.png",      Fallback = "rbxassetid://10734950020" },

        -- Interactive UI Controls
        Search         = { Path = "assets/icons/search.png",            Fallback = "rbxassetid://10734943676" },
        Close          = { Path = "assets/icons/close.png",             Fallback = "rbxassetid://10747384394" },
        Chevron        = { Path = "assets/icons/chevron.png",           Fallback = "rbxassetid://10709790948" },
        Stop           = { Path = "assets/icons/stop.png",              Fallback = "rbxassetid://10734972621" },
        Star_Off       = { Path = "assets/icons/star_off.png",          Fallback = "rbxassetid://10734966248" },
        Star_On        = { Path = "assets/icons/star_on.png",           Fallback = "rbxassetid://10734966248" },

        -- Audio SFX
        SFX_Boot       = { Path = "assets/audio/boot.mp3",              Fallback = "rbxassetid://9125402735" },
        SFX_Tab        = { Path = "assets/audio/tab.mp3",               Fallback = "rbxassetid://6895079853" },
        SFX_Click      = { Path = "assets/audio/click.mp3",             Fallback = "rbxassetid://6042053626" },
        SFX_Pin        = { Path = "assets/audio/pin.mp3",               Fallback = "rbxassetid://3125624765" },
    },

    -- Seasonal Theme Engine Palettes
    Themes = {
        Default = {
            Name = "Default (Argon Slate)",
            LogoKey = "Logo_Default",
            BgPrimary = Color3.fromRGB(13, 15, 20),
            BgSecondary = Color3.fromRGB(19, 22, 29),
            CardBg = Color3.fromRGB(24, 28, 37),
            CardHover = Color3.fromRGB(32, 38, 50),
            Accent = Color3.fromRGB(240, 244, 255),
            AccentGlow = Color3.fromRGB(88, 166, 255),
            TextPrimary = Color3.fromRGB(245, 247, 250),
            TextDim = Color3.fromRGB(140, 148, 166),
            Stroke = Color3.fromRGB(42, 48, 62)
        },
        Halloween = {
            Name = "Halloween (Spooky Orange)",
            LogoKey = "Logo_Halloween",
            BgPrimary = Color3.fromRGB(14, 11, 16),
            BgSecondary = Color3.fromRGB(21, 16, 24),
            CardBg = Color3.fromRGB(28, 20, 32),
            CardHover = Color3.fromRGB(40, 27, 46),
            Accent = Color3.fromRGB(255, 117, 24),
            AccentGlow = Color3.fromRGB(255, 85, 0),
            TextPrimary = Color3.fromRGB(255, 245, 238),
            TextDim = Color3.fromRGB(168, 142, 156),
            Stroke = Color3.fromRGB(75, 42, 28)
        },
        Christmas = {
            Name = "Christmas (Festive Holly)",
            LogoKey = "Logo_Christmas",
            BgPrimary = Color3.fromRGB(11, 16, 15),
            BgSecondary = Color3.fromRGB(16, 24, 22),
            CardBg = Color3.fromRGB(21, 32, 29),
            CardHover = Color3.fromRGB(28, 44, 39),
            Accent = Color3.fromRGB(235, 64, 52),
            AccentGlow = Color3.fromRGB(46, 204, 113),
            TextPrimary = Color3.fromRGB(245, 255, 250),
            TextDim = Color3.fromRGB(138, 168, 154),
            Stroke = Color3.fromRGB(38, 72, 56)
        }
    }
}

-- ================================================================================
-- 2. EMOTE & MODULAR ANIMATION BUNDLE DATABASE
-- ================================================================================
local EmoteDatabase = {
    { Name = "Salute",              Id = 3360689775 },
    { Name = "Stadium",             Id = 3360686498 },
    { Name = "Tilt",                Id = 3360692915 },
    { Name = "Shrug",               Id = 3576968026 },
    { Name = "Hello",               Id = 3576686446 },
    { Name = "Point2",              Id = 3576823880 },
    { Name = "Twirl",               Id = 3716636630 },
    { Name = "Jacks",               Id = 3716633898 },
    { Name = "T",                   Id = 3762654854 },
    { Name = "Robot",               Id = 3762641826 },
    { Name = "Monkey",              Id = 3716636630 },
    { Name = "Floss Dance",         Id = 5917459365 },
    { Name = "Dolphin Dance",       Id = 5918726674 },
    { Name = "Applause",            Id = 5915693819 },
    { Name = "Louder",              Id = 5915714366 },
    { Name = "High Wave",           Id = 5915690960 },
    { Name = "Fancy Feet",          Id = 3934964619 },
    { Name = "Happy",               Id = 4841405708 },
    { Name = "Sad",                 Id = 4841407203 },
    { Name = "Dizzy",               Id = 3934966185 },
    { Name = "Shuffle",             Id = 4349242221 },
    { Name = "Bodybuilder",         Id = 3994127840 },
    { Name = "Curtsy",              Id = 4555816777 },
    { Name = "Air Guitar",          Id = 3994129128 },
    { Name = "Breakdance",          Id = 5915648917 },
    { Name = "Rock On",             Id = 5915712534 },
    { Name = "Line Dance",          Id = 4049037604 },
    { Name = "Cha Cha",             Id = 3695333486 },
    { Name = "Cower",               Id = 4940563117 },
    { Name = "Sleep",               Id = 4686925579 },
    { Name = "Godlike",             Id = 3823158750 },
    { Name = "Hero Landing",        Id = 5104344710 },
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
-- 3. CLEANUP PREVIOUS INSTANCE & STATE INITIALIZATION
-- ================================================================================
local GuiParent = (gethui and gethui()) or CoreGui
if GuiParent:FindFirstChild("ArgonHub_Studio") then
    GuiParent:FindFirstChild("ArgonHub_Studio"):Destroy()
end

local State = {
    Visible = true,
    CurrentTab = "Emotes",
    CurrentThemeKey = "Default",
    ActiveEmoteTrack = nil,
    EquippedParts = {}, -- Tracks which bundle owns Idle, Walk, Run, etc.
    Favorites = {
        Emotes = {},
        Bundles = {},
        Parts = {}
    },
    Connections = {},
    ThemeUpdaters = {}
}

-- Detect Month for Dynamic Seasonal Engine (10 = Oct/Halloween, 12 = Dec/Christmas)
local function DetectSeasonalTheme()
    local dateTable = os.date("*t")
    if dateTable and dateTable.month == 10 then
        return "Halloween"
    elseif dateTable and dateTable.month == 12 then
        return "Christmas"
    end
    return "Default"
end
State.CurrentThemeKey = DetectSeasonalTheme()

-- ================================================================================
-- 4. GITHUB ASSET DOWNLOADER & LOCAL FILESYSTEM PERSISTENCE
-- ================================================================================
local HasFileSystem = (typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function" and typeof(makefolder) == "function")
local HasCustomAsset = (typeof(getcustomasset) == "function")

local function EnsureFolders()
    if not HasFileSystem then return end
    pcall(function()
        if not isfolder(Config.CacheFolder) then makefolder(Config.CacheFolder) end
        if not isfolder(Config.CacheFolder .. "/assets") then makefolder(Config.CacheFolder .. "/assets") end
        if not isfolder(Config.CacheFolder .. "/assets/branding") then makefolder(Config.CacheFolder .. "/assets/branding") end
        if not isfolder(Config.CacheFolder .. "/assets/icons") then makefolder(Config.CacheFolder .. "/assets/icons") end
        if not isfolder(Config.CacheFolder .. "/assets/audio") then makefolder(Config.CacheFolder .. "/assets/audio") end
    end)
end
EnsureFolders()

local ResolvedAssets = {}
local function GetAsset(assetKey)
    if ResolvedAssets[assetKey] then
        return ResolvedAssets[assetKey]
    end
    local entry = Config.Assets[assetKey]
    if not entry then return "" end

    if HasFileSystem and HasCustomAsset then
        local localPath = Config.CacheFolder .. "/" .. entry.Path
        if isfile(localPath) then
            local ok, customId = pcall(getcustomasset, localPath)
            if ok and customId then
                ResolvedAssets[assetKey] = customId
                return customId
            end
        else
            -- Background fetch from GitHub so startup never hangs
            task.spawn(function()
                local ok, response = pcall(function()
                    return game:HttpGet(Config.GitHubBaseURL .. entry.Path)
                end)
                if ok and response and #response > 64 and not string.find(response, "404: Not Found") then
                    pcall(writefile, localPath, response)
                    local assetOk, customId = pcall(getcustomasset, localPath)
                    if assetOk and customId then
                        ResolvedAssets[assetKey] = customId
                    end
                end
            end)
        end
    end
    return entry.Fallback
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
            local decoded = HttpService:JSONDecode(readfile(Config.FavoritesFile))
            if type(decoded) == "table" then
                State.Favorites.Emotes  = decoded.Emotes or {}
                State.Favorites.Bundles = decoded.Bundles or {}
                State.Favorites.Parts   = decoded.Parts or {}
            end
        end
    end)
end
LoadFavorites()

-- ================================================================================
-- 5. UI SOUND ENGINE
-- ================================================================================
local SoundContainer = Instance.new("Folder")
SoundContainer.Name = "ArgonAudio"

local function PlaySFX(sfxKey, volume)
    task.spawn(function()
        local sfx = Instance.new("Sound")
        sfx.SoundId = GetAsset(sfxKey)
        sfx.Volume = volume or 0.45
        sfx.Parent = SoundContainer
        sfx:Play()
        sfx.Ended:Connect(function()
            sfx:Destroy()
        end)
    end)
end

-- ================================================================================
-- 6. ANIMATION & EMOTE CONTROLLER ENGINE
-- ================================================================================
local function StopActiveEmote()
    if State.ActiveEmoteTrack then
        pcall(function()
            State.ActiveEmoteTrack:Stop(0.2)
            State.ActiveEmoteTrack:Destroy()
        end)
        State.ActiveEmoteTrack = nil
    end
end

local function PlayCatalogEmote(emoteData)
    StopActiveEmote()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)

    task.spawn(function()
        local animInstance = nil
        -- Resolve Catalog Emote Asset ID into actual AnimationId if necessary
        local ok, objects = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(emoteData.Id))
        end)
        if ok and objects and #objects > 0 then
            local root = objects[1]
            if root:IsA("Animation") then
                animInstance = root
            else
                animInstance = root:FindFirstChildOfClass("Animation", true)
            end
        end

        if not animInstance then
            animInstance = Instance.new("Animation")
            animInstance.AnimationId = "rbxassetid://" .. tostring(emoteData.Id)
        end

        local trackOk, track = pcall(function()
            return animator:LoadAnimation(animInstance)
        end)

        if trackOk and track then
            track.Priority = Enum.AnimationPriority.Action
            track.Looped = true
            track:Play(0.15)
            State.ActiveEmoteTrack = track
        end
    end)
end

-- Apply a single animation category (e.g., "Idle", "Run", "Jump") to Character.Animate
local function ApplyAnimationPart(partName, animIds, bundleName)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animateScript = char:FindFirstChild("Animate")
    if not hum or not animateScript then return end

    -- Stop currently running tracks so the swap is immediate
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0.1)
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
    -- Pulse Humanoid state briefly to refresh Idle/Walk loop
    hum:ChangeState(Enum.HumanoidStateType.Landed)
end

local function EquipFullBundle(bundle)
    for partName, ids in pairs(bundle.Parts) do
        ApplyAnimationPart(partName, ids, bundle.Name)
    end
end

-- Re-apply equipped custom mix-and-match bundle parts upon respawn
table.insert(State.Connections, LocalPlayer.CharacterAdded:Connect(function(newChar)
    newChar:WaitForChild("Humanoid", 10)
    newChar:WaitForChild("Animate", 10)
    task.wait(0.5)
    for partName, info in pairs(State.EquippedParts) do
        ApplyAnimationPart(partName, info.Ids, info.Bundle)
    end
end))

-- ================================================================================
-- 7. GUI ARCHITECTURE (PULSE/ARGON GLASSMORPHISM LAYOUT)
-- ================================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArgonHub_Studio"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent
SoundContainer.Parent = ScreenGui

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

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 680, 0, 440)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
MainFrame.BackgroundTransparency = 0.06
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.25

RegisterThemeUpdater(function(theme)
    TweenService:Create(MainFrame, TweenInfo.new(0.35), { BackgroundColor3 = theme.BgPrimary }):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.35), { Color = theme.Stroke }):Play()
end)

-- ================================================================================
-- 8. TOP HEADER BAR (BRANDING, SEASONAL LOGO, SEARCH BAR, CLOSE)
-- ================================================================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 54)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 1, -1)
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = Header

-- Header Brand Logo (Untinted so your Halloween/Christmas colors shine!)
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 36, 0, 36)
HeaderLogo.Position = UDim2.new(0, 14, 0.5, -18)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
HeaderLogo.ScaleType = Enum.ScaleType.Fit
HeaderLogo.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 130, 0, 18)
TitleLabel.Position = UDim2.new(0, 58, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = Config.HubName
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Size = UDim2.new(0, 130, 0, 14)
SubTitleLabel.Position = UDim2.new(0, 58, 0, 28)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Font = Enum.Font.GothamMedium
SubTitleLabel.Text = Config.SubTitle
SubTitleLabel.TextSize = 11
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.Parent = Header

-- Integrated Real-Time Search Bar
local SearchContainer = Instance.new("Frame")
SearchContainer.Size = UDim2.new(0, 260, 0, 32)
SearchContainer.Position = UDim2.new(1, -310, 0.5, -16)
SearchContainer.BorderSizePixel = 0
SearchContainer.Parent = Header

Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 8)
local SearchStroke = Instance.new("UIStroke", SearchContainer)
SearchStroke.Thickness = 1

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Size = UDim2.new(0, 14, 0, 14)
SearchIcon.Position = UDim2.new(0, 10, 0.5, -7)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = GetAsset("Search")
SearchIcon.Parent = SearchContainer

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -56, 1, 0)
SearchBox.Position = UDim2.new(0, 30, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.PlaceholderText = "Search emotes, bundles, or ID..."
SearchBox.Text = ""
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchContainer

local ClearSearchBtn = Instance.new("ImageButton")
ClearSearchBtn.Size = UDim2.new(0, 14, 0, 14)
ClearSearchBtn.Position = UDim2.new(1, -22, 0.5, -7)
ClearSearchBtn.BackgroundTransparency = 1
ClearSearchBtn.Image = GetAsset("Close")
ClearSearchBtn.Visible = false
ClearSearchBtn.Parent = SearchContainer

-- Stop Active Emote Quick Button in Header
local StopEmoteHeaderBtn = Instance.new("TextButton")
StopEmoteHeaderBtn.Size = UDim2.new(0, 92, 0, 32)
StopEmoteHeaderBtn.Position = UDim2.new(1, -412, 0.5, -16)
StopEmoteHeaderBtn.Font = Enum.Font.GothamBold
StopEmoteHeaderBtn.Text = "Stop Emote"
StopEmoteHeaderBtn.TextSize = 11
StopEmoteHeaderBtn.AutoButtonColor = false
StopEmoteHeaderBtn.Parent = Header
Instance.new("UICorner", StopEmoteHeaderBtn).CornerRadius = UDim.new(0, 8)
local StopHeaderStroke = Instance.new("UIStroke", StopEmoteHeaderBtn)
StopHeaderStroke.Thickness = 1

StopEmoteHeaderBtn.MouseButton1Click:Connect(function()
    PlaySFX("SFX_Click")
    StopActiveEmote()
end)

-- Minimize / Hide Button
local CloseHubBtn = Instance.new("ImageButton")
CloseHubBtn.Size = UDim2.new(0, 20, 0, 20)
CloseHubBtn.Position = UDim2.new(1, -34, 0.5, -10)
CloseHubBtn.BackgroundTransparency = 1
CloseHubBtn.Image = GetAsset("Close")
CloseHubBtn.Parent = Header

CloseHubBtn.MouseButton1Click:Connect(function()
    PlaySFX("SFX_Click")
    State.Visible = false
    MainFrame.Visible = false
end)

RegisterThemeUpdater(function(theme)
    Header.BackgroundColor3 = theme.BgSecondary
    HeaderDivider.BackgroundColor3 = theme.Stroke
    HeaderLogo.Image = GetAsset(theme.LogoKey)
    TitleLabel.TextColor3 = theme.Accent
    SubTitleLabel.TextColor3 = theme.TextDim
    SearchContainer.BackgroundColor3 = theme.CardBg
    SearchStroke.Color = theme.Stroke
    SearchIcon.ImageColor3 = theme.TextDim
    SearchBox.TextColor3 = theme.TextPrimary
    SearchBox.PlaceholderColor3 = theme.TextDim
    ClearSearchBtn.ImageColor3 = theme.TextDim
    StopEmoteHeaderBtn.BackgroundColor3 = theme.CardBg
    StopEmoteHeaderBtn.TextColor3 = theme.Accent
    StopHeaderStroke.Color = theme.Stroke
    CloseHubBtn.ImageColor3 = theme.TextDim
end)

-- Smooth Dragging Support on Header
do
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end))
end

-- ================================================================================
-- 9. LEFT SIDEBAR NAVIGATION & PAGE CONTAINERS
-- ================================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 155, 1, -54)
Sidebar.Position = UDim2.new(0, 0, 0, 54)
Sidebar.BackgroundTransparency = 0.25
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Sidebar

local NavList = Instance.new("UIListLayout")
NavList.Padding = UDim.new(0, 6)
NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Parent = Sidebar

local NavPadding = Instance.new("UIPadding", Sidebar)
NavPadding.PaddingTop = UDim.new(0, 12)

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -155, 1, -54)
ContentArea.Position = UDim2.new(0, 155, 0, 54)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

RegisterThemeUpdater(function(theme)
    Sidebar.BackgroundColor3 = theme.BgSecondary
    SidebarDivider.BackgroundColor3 = theme.Stroke
end)

local TabButtons = {}
local TabPages = {}

local function CreateTabPage(tabName)
    local page = Instance.new("ScrollingFrame")
    page.Name = tabName .. "_Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = ContentArea

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 14)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)

    RegisterThemeUpdater(function(theme)
        page.ScrollBarImageColor3 = theme.Accent
    end)

    TabPages[tabName] = page
    return page
end

local RebuildFavoritesView -- Forward declaration

local function SwitchTab(tabName)
    State.CurrentTab = tabName
    local theme = GetTheme()
    for name, page in pairs(TabPages) do
        page.Visible = (name == tabName)
    end
    for name, btnData in pairs(TabButtons) do
        local isSelected = (name == tabName)
        TweenService:Create(btnData.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = isSelected and theme.CardHover or theme.BgSecondary,
            BackgroundTransparency = isSelected and 0 or 1
        }):Play()
        TweenService:Create(btnData.Stroke, TweenInfo.new(0.2), {
            Transparency = isSelected and 0.2 or 1,
            Color = isSelected and theme.Accent or theme.Stroke
        }):Play()
        TweenService:Create(btnData.Label, TweenInfo.new(0.2), {
            TextColor3 = isSelected and theme.TextPrimary or theme.TextDim
        }):Play()
        TweenService:Create(btnData.Icon, TweenInfo.new(0.2), {
            ImageColor3 = isSelected and theme.Accent or theme.TextDim
        }):Play()
    end
    if tabName == "Favorites" and RebuildFavoritesView then
        RebuildFavoritesView()
    end
end

local TabOrder = {
    { Name = "Main",      Icon = "Tab_Main" },
    { Name = "Emotes",    Icon = "Tab_Emotes" },
    { Name = "Bundles",   Icon = "Tab_Bundles" },
    { Name = "Favorites", Icon = "Tab_Favorites" },
    { Name = "Settings",  Icon = "Tab_Settings" }
}

for idx, tabInfo in ipairs(TabOrder) do
    CreateTabPage(tabInfo.Name)

    local btn = Instance.new("TextButton")
    btn.Name = tabInfo.Name .. "_TabBtn"
    btn.LayoutOrder = idx
    btn.Size = UDim2.new(0, 135, 0, 36)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = Sidebar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1
    stroke.Transparency = 1

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 12, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = GetAsset(tabInfo.Icon)
    icon.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Position = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Text = tabInfo.Name
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    TabButtons[tabInfo.Name] = { Button = btn, Stroke = stroke, Icon = icon, Label = lbl }

    btn.MouseButton1Click:Connect(function()
        PlaySFX("SFX_Tab")
        SwitchTab(tabInfo.Name)
    end)
end

RegisterThemeUpdater(function()
    SwitchTab(State.CurrentTab)
end)

-- ================================================================================
-- 10. TAB 1: MAIN DASHBOARD PAGE
-- ================================================================================
do
    local page = TabPages["Main"]
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 12)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local banner = Instance.new("Frame")
    banner.Size = UDim2.new(1, 0, 0, 110)
    banner.BorderSizePixel = 0
    banner.Parent = page
    Instance.new("UICorner", banner).CornerRadius = UDim.new(0, 10)
    local bannerStroke = Instance.new("UIStroke", banner)

    local bannerLogo = Instance.new("ImageLabel")
    bannerLogo.Size = UDim2.new(0, 76, 0, 76)
    bannerLogo.Position = UDim2.new(0, 18, 0.5, -38)
    bannerLogo.BackgroundTransparency = 1
    bannerLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    bannerLogo.ScaleType = Enum.ScaleType.Fit
    bannerLogo.Parent = banner

    local welcomeTitle = Instance.new("TextLabel")
    welcomeTitle.Size = UDim2.new(1, -115, 0, 24)
    welcomeTitle.Position = UDim2.new(0, 108, 0, 20)
    welcomeTitle.BackgroundTransparency = 1
    welcomeTitle.Font = Enum.Font.GothamBold
    welcomeTitle.Text = "Welcome to Argon Studio, " .. LocalPlayer.DisplayName
    welcomeTitle.TextSize = 16
    welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
    welcomeTitle.Parent = banner

    local welcomeDesc = Instance.new("TextLabel")
    welcomeDesc.Size = UDim2.new(1, -115, 0, 44)
    welcomeDesc.Position = UDim2.new(0, 108, 0, 46)
    welcomeDesc.BackgroundTransparency = 1
    welcomeDesc.Font = Enum.Font.GothamMedium
    welcomeDesc.TextWrapped = true
    welcomeDesc.Text = "Mix and match official Roblox animation bundles (Idle, Walk, Run, Jump, Fall, Climb, Swim) or trigger catalog emotes instantaneously. Seasonal Edition: " .. State.CurrentThemeKey
    welcomeDesc.TextSize = 12
    welcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
    welcomeDesc.TextYAlignment = Enum.TextYAlignment.Top
    welcomeDesc.Parent = banner

    RegisterThemeUpdater(function(theme)
        banner.BackgroundColor3 = theme.CardBg
        bannerStroke.Color = theme.Stroke
        bannerLogo.Image = GetAsset(theme.LogoKey)
        welcomeTitle.TextColor3 = theme.TextPrimary
        welcomeDesc.TextColor3 = theme.TextDim
        welcomeDesc.Text = "Mix and match official Roblox animation bundles (Idle, Walk, Run, Jump, Fall, Climb, Swim) or trigger catalog emotes instantaneously. Active Theme: " .. theme.Name
    end)
end

-- ================================================================================
-- 11. TAB 2: EMOTES TAB (GRID + FUZZY SEARCH)
-- ================================================================================
local EmoteCards = {}
do
    local page = TabPages["Emotes"]
    local grid = Instance.new("UIGridLayout", page)
    grid.CellSize = UDim2.new(0, 152, 0, 175)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.SortOrder = Enum.SortOrder.LayoutOrder

    for idx, emote in ipairs(EmoteDatabase) do
        local card = Instance.new("Frame")
        card.Name = emote.Name
        card.LayoutOrder = idx
        card.BorderSizePixel = 0
        card.Parent = page
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Thickness = 1

        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(0, 86, 0, 86)
        thumb.Position = UDim2.new(0.5, -43, 0, 12)
        thumb.BackgroundTransparency = 1
        thumb.Image = "rbxthumb://type=Asset&id=" .. tostring(emote.Id) .. "&w=150&h=150"
        thumb.Parent = card

        local starBtn = Instance.new("ImageButton")
        starBtn.Size = UDim2.new(0, 18, 0, 18)
        starBtn.Position = UDim2.new(1, -26, 0, 8)
        starBtn.BackgroundTransparency = 1
        starBtn.Parent = card

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -16, 0, 18)
        nameLbl.Position = UDim2.new(0, 8, 0, 102)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = emote.Name
        nameLbl.TextSize = 12
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.Parent = card

        local idLbl = Instance.new("TextLabel")
        idLbl.Size = UDim2.new(1, -16, 0, 14)
        idLbl.Position = UDim2.new(0, 8, 0, 118)
        idLbl.BackgroundTransparency = 1
        idLbl.Font = Enum.Font.Gotham
        idLbl.Text = "ID: " .. tostring(emote.Id)
        idLbl.TextSize = 10
        idLbl.Parent = card

        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(1, -16, 0, 28)
        playBtn.Position = UDim2.new(0, 8, 1, -36)
        playBtn.Font = Enum.Font.GothamBold
        playBtn.Text = "Play Emote"
        playBtn.TextSize = 11
        playBtn.AutoButtonColor = false
        playBtn.Parent = card
        Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)

        local function UpdateStarVisual()
            local isFav = State.Favorites.Emotes[tostring(emote.Id)] == true
            local theme = GetTheme()
            starBtn.Image = isFav and GetAsset("Star_On") or GetAsset("Star_Off")
            starBtn.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or theme.TextDim
        end

        starBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Pin")
            local key = tostring(emote.Id)
            if State.Favorites.Emotes[key] then
                State.Favorites.Emotes[key] = nil
            else
                State.Favorites.Emotes[key] = true
            end
            SaveFavorites()
            UpdateStarVisual()
        end)

        playBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            PlayCatalogEmote(emote)
        end)

        RegisterThemeUpdater(function(theme)
            card.BackgroundColor3 = theme.CardBg
            cardStroke.Color = theme.Stroke
            nameLbl.TextColor3 = theme.TextPrimary
            idLbl.TextColor3 = theme.TextDim
            playBtn.BackgroundColor3 = theme.BgSecondary
            playBtn.TextColor3 = theme.Accent
            UpdateStarVisual()
        end)

        table.insert(EmoteCards, { Frame = card, Data = emote, RefreshStar = UpdateStarVisual })
    end
end

-- ================================================================================
-- 12. TAB 3: MODULAR ANIMATION BUNDLES (FULL EQUIP + GRANULAR MIX & MATCH)
-- ================================================================================
local BundleCards = {}
local PartOrder = { "Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Swim" }

do
    local page = TabPages["Bundles"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    for idx, bundle in ipairs(BundleDatabase) do
        local expanded = false

        local container = Instance.new("Frame")
        container.Name = bundle.Name .. "_Bundle"
        container.LayoutOrder = idx
        container.Size = UDim2.new(1, 0, 0, 74)
        container.BorderSizePixel = 0
        container.ClipsDescendants = true
        container.Parent = page
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)
        local cStroke = Instance.new("UIStroke", container)
        cStroke.Thickness = 1

        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(0, 54, 0, 54)
        thumb.Position = UDim2.new(0, 10, 0, 10)
        thumb.BackgroundTransparency = 1
        thumb.Image = "rbxthumb://type=BundleThumbnail&id=" .. tostring(bundle.BundleId) .. "&w=150&h=150"
        thumb.Parent = container

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(0, 180, 0, 20)
        title.Position = UDim2.new(0, 74, 0, 16)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = bundle.Name .. " Bundle"
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = container

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(0, 220, 0, 16)
        sub.Position = UDim2.new(0, 74, 0, 38)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamMedium
        sub.Text = "7 Modular Tracks • Full or Custom Mix"
        sub.TextSize = 11
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Parent = container

        -- Star Bundle Button
        local starBtn = Instance.new("ImageButton")
        starBtn.Size = UDim2.new(0, 18, 0, 18)
        starBtn.Position = UDim2.new(1, -195, 0, 28)
        starBtn.BackgroundTransparency = 1
        starBtn.Parent = container

        -- Equip Full Bundle Button
        local equipFullBtn = Instance.new("TextButton")
        equipFullBtn.Size = UDim2.new(0, 118, 0, 32)
        equipFullBtn.Position = UDim2.new(1, -166, 0, 21)
        equipFullBtn.Font = Enum.Font.GothamBold
        equipFullBtn.Text = "Equip Full Bundle"
        equipFullBtn.TextSize = 11
        equipFullBtn.AutoButtonColor = false
        equipFullBtn.Parent = container
        Instance.new("UICorner", equipFullBtn).CornerRadius = UDim.new(0, 7)

        -- Expand Parts Dropdown Button
        local expandBtn = Instance.new("ImageButton")
        expandBtn.Size = UDim2.new(0, 28, 0, 28)
        expandBtn.Position = UDim2.new(1, -38, 0, 23)
        expandBtn.BackgroundTransparency = 1
        expandBtn.Image = GetAsset("Chevron")
        expandBtn.Parent = container

        -- Sub-Parts Grid Container (Idle, Walk, Run, Jump, Fall, Climb, Swim)
        local partsHolder = Instance.new("Frame")
        partsHolder.Size = UDim2.new(1, -20, 0, 82)
        partsHolder.Position = UDim2.new(0, 10, 0, 76)
        partsHolder.BackgroundTransparency = 1
        partsHolder.Parent = container

        local partsGrid = Instance.new("UIGridLayout", partsHolder)
        partsGrid.CellSize = UDim2.new(0, 112, 0, 34)
        partsGrid.CellPadding = UDim2.new(0, 8, 0, 8)

        for _, partName in ipairs(PartOrder) do
            local partIds = bundle.Parts[partName]
            if partIds then
                local partBtn = Instance.new("TextButton")
                partBtn.Name = partName
                partBtn.Font = Enum.Font.GothamSemibold
                partBtn.Text = "  " .. partName
                partBtn.TextSize = 12
                partBtn.TextXAlignment = Enum.TextXAlignment.Left
                partBtn.AutoButtonColor = false
                partBtn.Parent = partsHolder
                Instance.new("UICorner", partBtn).CornerRadius = UDim.new(0, 6)
                local pStroke = Instance.new("UIStroke", partBtn)
                pStroke.Thickness = 1

                local partStar = Instance.new("ImageButton")
                partStar.Size = UDim2.new(0, 14, 0, 14)
                partStar.Position = UDim2.new(1, -20, 0.5, -7)
                partStar.BackgroundTransparency = 1
                partStar.Parent = partBtn

                local favKey = bundle.Name .. "_" .. partName
                local function UpdatePartStar()
                    local isFav = State.Favorites.Parts[favKey] == true
                    local theme = GetTheme()
                    partStar.Image = isFav and GetAsset("Star_On") or GetAsset("Star_Off")
                    partStar.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or theme.TextDim
                end

                partStar.MouseButton1Click:Connect(function()
                    PlaySFX("SFX_Pin")
                    if State.Favorites.Parts[favKey] then
                        State.Favorites.Parts[favKey] = nil
                    else
                        State.Favorites.Parts[favKey] = true
                    end
                    SaveFavorites()
                    UpdatePartStar()
                end)

                partBtn.MouseButton1Click:Connect(function()
                    PlaySFX("SFX_Click")
                    ApplyAnimationPart(partName, partIds, bundle.Name)
                    sub.Text = "Equipped " .. bundle.Name .. " " .. partName .. "!"
                end)

                RegisterThemeUpdater(function(theme)
                    partBtn.BackgroundColor3 = theme.BgSecondary
                    partBtn.TextColor3 = theme.TextPrimary
                    pStroke.Color = theme.Stroke
                    UpdatePartStar()
                end)
            end
        end

        local function UpdateBundleStar()
            local isFav = State.Favorites.Bundles[bundle.Name] == true
            local theme = GetTheme()
            starBtn.Image = isFav and GetAsset("Star_On") or GetAsset("Star_Off")
            starBtn.ImageColor3 = isFav and Color3.fromRGB(255, 205, 45) or theme.TextDim
        end

        starBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Pin")
            if State.Favorites.Bundles[bundle.Name] then
                State.Favorites.Bundles[bundle.Name] = nil
            else
                State.Favorites.Bundles[bundle.Name] = true
            end
            SaveFavorites()
            UpdateBundleStar()
        end)

        equipFullBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            EquipFullBundle(bundle)
            sub.Text = "Full " .. bundle.Name .. " Bundle Active"
        end)

        expandBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            expanded = not expanded
            TweenService:Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = expanded and UDim2.new(1, 0, 0, 168) or UDim2.new(1, 0, 0, 74)
            }):Play()
            TweenService:Create(expandBtn, TweenInfo.new(0.25), {
                Rotation = expanded and 180 or 0
            }):Play()
        end)

        RegisterThemeUpdater(function(theme)
            container.BackgroundColor3 = theme.CardBg
            cStroke.Color = theme.Stroke
            title.TextColor3 = theme.TextPrimary
            sub.TextColor3 = theme.TextDim
            equipFullBtn.BackgroundColor3 = theme.BgSecondary
            equipFullBtn.TextColor3 = theme.Accent
            expandBtn.ImageColor3 = theme.TextDim
            UpdateBundleStar()
        end)

        table.insert(BundleCards, { Frame = container, Data = bundle, RefreshStar = UpdateBundleStar })
    end
end

-- ================================================================================
-- 13. TAB 4: FAVORITES TAB (LIVE SYNC WITH STARRED ITEMS)
-- ================================================================================
do
    local page = TabPages["Favorites"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    RebuildFavoritesView = function()
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local theme = GetTheme()
        local count = 0

        local function MakeFavRow(titleText, categoryText, onTrigger, onUnpin)
            count = count + 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 46)
            row.BackgroundColor3 = theme.CardBg
            row.BorderSizePixel = 0
            row.Parent = page
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", row)
            stroke.Color = theme.Stroke

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.55, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = titleText .. "  •  " .. categoryText
            lbl.TextColor3 = theme.TextPrimary
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local runBtn = Instance.new("TextButton")
            runBtn.Size = UDim2.new(0, 90, 0, 28)
            runBtn.Position = UDim2.new(1, -136, 0.5, -14)
            runBtn.BackgroundColor3 = theme.BgSecondary
            runBtn.Font = Enum.Font.GothamBold
            runBtn.Text = "Equip / Play"
            runBtn.TextColor3 = theme.Accent
            runBtn.TextSize = 11
            runBtn.AutoButtonColor = false
            runBtn.Parent = row
            Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 6)

            local unpinBtn = Instance.new("ImageButton")
            unpinBtn.Size = UDim2.new(0, 18, 0, 18)
            unpinBtn.Position = UDim2.new(1, -32, 0.5, -9)
            unpinBtn.BackgroundTransparency = 1
            unpinBtn.Image = GetAsset("Star_On")
            unpinBtn.ImageColor3 = Color3.fromRGB(255, 205, 45)
            unpinBtn.Parent = row

            runBtn.MouseButton1Click:Connect(function()
                PlaySFX("SFX_Click")
                onTrigger()
            end)

            unpinBtn.MouseButton1Click:Connect(function()
                PlaySFX("SFX_Pin")
                onUnpin()
                SaveFavorites()
                RebuildFavoritesView()
            end)
        end

        -- Populate Starred Emotes
        for _, emote in ipairs(EmoteDatabase) do
            if State.Favorites.Emotes[tostring(emote.Id)] then
                MakeFavRow(emote.Name, "Emote (" .. emote.Id .. ")", function()
                    PlayCatalogEmote(emote)
                end, function()
                    State.Favorites.Emotes[tostring(emote.Id)] = nil
                end)
            end
        end

        -- Populate Starred Full Bundles
        for _, bundle in ipairs(BundleDatabase) do
            if State.Favorites.Bundles[bundle.Name] then
                MakeFavRow(bundle.Name .. " Bundle", "Full Animation Set", function()
                    EquipFullBundle(bundle)
                end, function()
                    State.Favorites.Bundles[bundle.Name] = nil
                end)
            end
            -- Populate Starred Individual Sub-Animations
            for _, partName in ipairs(PartOrder) do
                local favKey = bundle.Name .. "_" .. partName
                if State.Favorites.Parts[favKey] then
                    MakeFavRow(bundle.Name .. " " .. partName, "Modular Track", function()
                        ApplyAnimationPart(partName, bundle.Parts[partName], bundle.Name)
                    end, function()
                        State.Favorites.Parts[favKey] = nil
                    end)
                end
            end
        end

        if count == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 120)
            empty.BackgroundTransparency = 1
            empty.Font = Enum.Font.GothamMedium
            empty.Text = "No favorites pinned yet.\nClick the Star icon on any Emote, Bundle, or Individual Track to pin it here!"
            empty.TextColor3 = theme.TextDim
            empty.TextSize = 13
            empty.Parent = page
        end
    end
end

-- ================================================================================
-- 14. TAB 5: SETTINGS & SEASONAL THEME OVERRIDE
-- ================================================================================
do
    local page = TabPages["Settings"]
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local themeCard = Instance.new("Frame")
    themeCard.Size = UDim2.new(1, 0, 0, 115)
    themeCard.BorderSizePixel = 0
    themeCard.Parent = page
    Instance.new("UICorner", themeCard).CornerRadius = UDim.new(0, 10)
    local tStroke = Instance.new("UIStroke", themeCard)

    local tTitle = Instance.new("TextLabel")
    tTitle.Size = UDim2.new(1, -24, 0, 22)
    tTitle.Position = UDim2.new(0, 14, 0, 12)
    tTitle.BackgroundTransparency = 1
    tTitle.Font = Enum.Font.GothamBold
    tTitle.Text = "Seasonal Theme & Logo Override"
    tTitle.TextSize = 14
    tTitle.TextXAlignment = Enum.TextXAlignment.Left
    tTitle.Parent = themeCard

    local tSub = Instance.new("TextLabel")
    tSub.Size = UDim2.new(1, -24, 0, 16)
    tSub.Position = UDim2.new(0, 14, 0, 34)
    tSub.BackgroundTransparency = 1
    tSub.Font = Enum.Font.GothamMedium
    tSub.Text = "Auto-detects October (Halloween) and December (Christmas), or preview any theme below:"
    tSub.TextSize = 11
    tSub.TextXAlignment = Enum.TextXAlignment.Left
    tSub.Parent = themeCard

    local btnHolder = Instance.new("Frame")
    btnHolder.Size = UDim2.new(1, -28, 0, 36)
    btnHolder.Position = UDim2.new(0, 14, 0, 62)
    btnHolder.BackgroundTransparency = 1
    btnHolder.Parent = themeCard

    local btnLayout = Instance.new("UIListLayout", btnHolder)
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.Padding = UDim.new(0, 10)

    for _, mode in ipairs({ "Default", "Halloween", "Christmas" }) do
        local mBtn = Instance.new("TextButton")
        mBtn.Size = UDim2.new(0, 148, 1, 0)
        mBtn.Font = Enum.Font.GothamBold
        mBtn.Text = mode .. " Edition"
        mBtn.TextSize = 12
        mBtn.AutoButtonColor = false
        mBtn.Parent = btnHolder
        Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 7)
        local mStroke = Instance.new("UIStroke", mBtn)

        mBtn.MouseButton1Click:Connect(function()
            PlaySFX("SFX_Click")
            State.CurrentThemeKey = mode
            RefreshAllThemes()
        end)

        RegisterThemeUpdater(function(theme)
            local active = (State.CurrentThemeKey == mode)
            mBtn.BackgroundColor3 = active and theme.CardHover or theme.BgSecondary
            mBtn.TextColor3 = active and theme.Accent or theme.TextDim
            mStroke.Color = active and theme.Accent or theme.Stroke
        end)
    end

    RegisterThemeUpdater(function(theme)
        themeCard.BackgroundColor3 = theme.CardBg
        tStroke.Color = theme.Stroke
        tTitle.TextColor3 = theme.TextPrimary
        tSub.TextColor3 = theme.TextDim
    end)
end

-- ================================================================================
-- 15. MULTI-LEVEL PROGRESSIVE SEARCH ENGINE
-- ================================================================================
local function ApplySearchFilter(query)
    local clean = string.lower((query or ""):gsub("^%s*(.-)%s*$", "%1"))
    ClearSearchBtn.Visible = (#clean > 0)

    -- Filter Emotes by prefix, substring, or numeric Asset ID
    for _, item in ipairs(EmoteCards) do
        if #clean == 0 then
            item.Frame.Visible = true
        else
            local nameLower = string.lower(item.Data.Name)
            local idStr = tostring(item.Data.Id)
            local match = (string.sub(nameLower, 1, #clean) == clean)
                or (string.find(nameLower, clean, 1, true) ~= nil)
                or (string.find(idStr, clean, 1, true) ~= nil)
            item.Frame.Visible = match
        end
    end

    -- Filter Bundles by name or bundle ID
    for _, item in ipairs(BundleCards) do
        if #clean == 0 then
            item.Frame.Visible = true
        else
            local nameLower = string.lower(item.Data.Name)
            local idStr = tostring(item.Data.BundleId)
            local match = (string.sub(nameLower, 1, #clean) == clean)
                or (string.find(nameLower, clean, 1, true) ~= nil)
                or (string.find(idStr, clean, 1, true) ~= nil)
            item.Frame.Visible = match
        end
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    ApplySearchFilter(SearchBox.Text)
end)

ClearSearchBtn.MouseButton1Click:Connect(function()
    PlaySFX("SFX_Click")
    SearchBox.Text = ""
    ApplySearchFilter("")
end)

-- ================================================================================
-- 16. KEYBIND TOGGLE (RIGHTCONTROL / V)
-- ================================================================================
table.insert(State.Connections, UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.ToggleKey or input.KeyCode == Config.AltToggleKey then
        State.Visible = not State.Visible
        MainFrame.Visible = State.Visible
    end
end))

-- ================================================================================
-- 17. CINEMATIC BOOT SEQUENCE (SCALING SEASONAL LOGO + GLOW WIPE)
-- ================================================================================
local function RunBootSequence()
    local theme = GetTheme()

    local BootOverlay = Instance.new("Frame")
    BootOverlay.Name = "BootSplash"
    BootOverlay.Size = UDim2.new(0, 320, 0, 260)
    BootOverlay.Position = UDim2.new(0.5, -160, 0.5, -130)
    BootOverlay.BackgroundColor3 = theme.BgPrimary
    BootOverlay.BackgroundTransparency = 0.04
    BootOverlay.BorderSizePixel = 0
    BootOverlay.Parent = ScreenGui
    Instance.new("UICorner", BootOverlay).CornerRadius = UDim.new(0, 16)

    local BootStroke = Instance.new("UIStroke", BootOverlay)
    BootStroke.Color = theme.Accent
    BootStroke.Thickness = 1.5
    BootStroke.Transparency = 0.3

    local BootLogo = Instance.new("ImageLabel")
    BootLogo.Size = UDim2.new(0, 20, 0, 20)
    BootLogo.Position = UDim2.new(0.5, -10, 0.42, -10)
    BootLogo.BackgroundTransparency = 1
    BootLogo.Image = GetAsset(theme.LogoKey)
    BootLogo.ImageColor3 = Color3.fromRGB(255, 255, 255) -- Preserves your Halloween/Christmas colors
    BootLogo.ImageTransparency = 1
    BootLogo.ScaleType = Enum.ScaleType.Fit
    BootLogo.Parent = BootOverlay

    local BootTitle = Instance.new("TextLabel")
    BootTitle.Size = UDim2.new(1, 0, 0, 24)
    BootTitle.Position = UDim2.new(0, 0, 0.76, 0)
    BootTitle.BackgroundTransparency = 1
    BootTitle.Font = Enum.Font.GothamBold
    BootTitle.Text = Config.HubName:upper()
    BootTitle.TextColor3 = theme.TextPrimary
    BootTitle.TextTransparency = 1
    BootTitle.TextSize = 18
    BootTitle.Parent = BootOverlay

    local BootSub = Instance.new("TextLabel")
    BootSub.Size = UDim2.new(1, 0, 0, 16)
    BootSub.Position = UDim2.new(0, 0, 0.86, 0)
    BootSub.BackgroundTransparency = 1
    BootSub.Font = Enum.Font.GothamMedium
    BootSub.Text = "Initializing " .. theme.Name .. "..."
    BootSub.TextColor3 = theme.Accent
    BootSub.TextTransparency = 1
    BootSub.TextSize = 12
    BootSub.Parent = BootOverlay

    PlaySFX("SFX_Boot", 0.6)

    -- Step 1: Exponential Scale-Up of the Argon "A" Logo
    TweenService:Create(BootLogo, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 130, 0, 130),
        Position = UDim2.new(0.5, -65, 0.42, -65),
        ImageTransparency = 0
    }):Play()

    task.wait(0.25)
    TweenService:Create(BootTitle, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
    TweenService:Create(BootSub, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()

    task.wait(1.25)

    -- Step 2: Fade Out Splash & Reveal Main Argon Studio Window
    TweenService:Create(BootOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 680, 0, 440),
        Position = UDim2.new(0.5, -340, 0.5, -220),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(BootLogo, TweenInfo.new(0.3), { ImageTransparency = 1 }):Play()
    TweenService:Create(BootTitle, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
    TweenService:Create(BootSub, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
    TweenService:Create(BootStroke, TweenInfo.new(0.3), { Transparency = 1 }):Play()

    task.wait(0.35)
    BootOverlay:Destroy()

    MainFrame.Visible = true
    RefreshAllThemes()
    SwitchTab("Emotes")
end

RunBootSequence()
