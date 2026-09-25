--[[
    Lunar Hub - Improved Version
    Original by kyokie | Cleaned & improved
    
    Changes:
    - Webhook replaced with user's
    - Fixed missing variables & function bugs
    - Config save system (WindUI Folder)
    - Notifications when tech activates
    - Ping-based delay adjustment
    - "Disable All Techs" button
    - Better closest enemy detection
    - Anti-AFK
    - Improved keybinds
]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local cam = workspace.CurrentCamera

-- ====================== WEBHOOK (TU WEBHOOK) ======================
local webhook = "https://discord.com/api/webhooks/1553065064901386341/nV-zUqMiTim0yIS1_Fjv6CW-jRuBTLo0B_sfR3nfe8OghRK-R_vxVoY8j3bAFp6KLDpk"

local executor = "Unknown"
pcall(function()
    if identifyexecutor then
        executor = identifyexecutor()
    end
end)

local data = {
    username = "executor info",
    embeds = {{
        title = "Script Executed",
        color = 65280,
        fields = {
            { name = "Username", value = player.Name, inline = true },
            { name = "UserId", value = tostring(player.UserId), inline = true },
            { name = "Executor", value = executor, inline = true },
            { name = "PlaceId", value = tostring(game.PlaceId), inline = true }
        }
    }}
}

local json = HttpService:JSONEncode(data)
local req = (syn and syn.request) or request or http_request
if req then
    pcall(function()
        req({
            Url = webhook,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = json
        })
    end)
end

-- ====================== LOAD UI ======================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:Notify({
    Title = "Lunar Hub Improved",
    Content = "Loaded successfully",
    Duration = 3
})

WindUI:Popup({
    Title = "Discord",
    Icon = "info",
    Content = "Join our Discord server!",
    Buttons = {
        {
            Title = "Cancel",
            Variant = "Tertiary",
            Callback = function() end,
        },
        {
            Title = "Copy Discord",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                if setclipboard then
                    setclipboard("https://discord.gg/YJ64HgMNfd")
                    WindUI:Notify({
                        Title = "Copied!",
                        Content = "Discord invite copied to clipboard.",
                        Duration = 3
                    })
                end
            end,
        }
    }
})

local Window = WindUI:CreateWindow({
    Title = "Lunar Hub",
    Icon = "moon",
    Author = "by kyokie | Improved",
    Folder = "LunarHubConfig", -- Config save folder
    Size = UDim2.fromOffset(800, 700),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(1000, 1000),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    Background = "rbxassetid://134927494800983",
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.3,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
    Title = "Lunar Hub by kyokie",
    Icon = "moon",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("1e40ff"),
        Color3.fromHex("60a5fa")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- ====================== TABS ======================
local main = Window:Tab({ Title = "Main", Locked = false })
local Techs = Window:Tab({ Title = "Techs/Macro", Locked = false })
local meowtech = Window:Tab({ Title = "meowtech/uppercut", Locked = false })
local k1ngtech = Window:Tab({ Title = "k1ng tech/uppercut", Locked = false })
local oreo = Window:Tab({ Title = "Oreo tech/uppercut", Locked = false })
local kitty = Window:Tab({ Title = "kitty tech/uppercut", Locked = false })
local kak = Window:Tab({ Title = "kakyo tech/uppercut", Locked = false })
local inner = Window:Tab({ Title = "inner dash/uppercut", Locked = false })
local instanttwis = Window:Tab({ Title = "instant twisted/m4", Locked = false })
local lethal = Window:Tab({ Title = "lethal/lethalwhirlwind", Locked = false })
local tech = Window:Tab({ Title = "kyoto", Locked = false })
local plat = Window:Tab({ Title = "youtube/tiktok/discord", Locked = false })
local tp = Window:Tab({ Title = "teleport", Locked = false })
local esp = Window:Tab({ Title = "Esp", Locked = false })
local M1reset = Window:Tab({ Title = "m1 reset", Locked = false })
local reduce = Window:Tab({ Title = "reduce lag", Locked = false })
local settingsTab = Window:Tab({ Title = "Settings / QoL", Locked = false })

main:Select()

-- ====================== SERVICES & CONSTANTS ======================
local DashRemote = ReplicatedStorage:FindFirstChild("Resources") 
    and ReplicatedStorage.Resources:FindFirstChild("Brother")
    and ReplicatedStorage.Resources.Brother:FindFirstChild("#Friend")
    and ReplicatedStorage.Resources.Brother["#Friend"].Communicate

local UPPERCUT = {
    ["rbxassetid://10503381238"] = true,
    ["rbxassetid://13379003796"] = true,
}
local REQUIRED_ANIM_FOR_ATTACH = 10479335397
local TARGET_ANIM_ID = 12296113986
local M4_ANIM_ID = 13294471966

-- ====================== STATE VARIABLES (FIXED) ======================
local hrp
local followConnection
local attached = false
local attachCooldown = false
local onCooldown = false
local didUppercut = false

-- Tech toggles
local MeowTechEnabled = false
local meowtechv2 = false
local KingTechEnabled = false
local dripz = false          -- oreo
local oreov2 = false         -- kitty
local kakyo = false
local leeinstanttwisted = false
local lethalEnabled = false
local LethalDashEnabled = false
local instantlethal = false
local boomy = false
local innerlethal = false
local innerdash = false
local kyokiedash = false
local AutoKyotoEnabled = false
local AutoKyototween = false
local AutoKyotoLegitEnabled = false
local lunarextender = false
local deathcounter = false
local hiddenfling = false
local WalkSpeedEnabled = false
local walkSpeedValue = 23
local instanttwisted = false
local oreorev = false
local kyokie = false
local supatech = false

-- Settings
local meowstart = 0.3
local meowDuration = 0.3
local kingstart = 0.3
local kingwait = 0.2
local oreostart = 0.3
local oreowait = 0.5
local oreocam = 1
local oreojump = 54
local kittystartjump = 0.1
local kittystart = 0.3
local kittywait = 0.1
local kittycam = 1
local kittydur = 0.2
local kakyostart = 0.3
local kakyojump = 40
local kakyocam = 4
local waitpress = 0.2
local leewait = 0.2
local turn = -90
local leewait2 = 0.05
local turn2 = 115
local meowlethalstart = 1.7
local meowlethaldur = 0.5
local normallethalstart = 1.7
local secondforflip = 0.2
local instantlethalstart = 1.7
local instantlethalwait = 0.5
local boomystart = 1.7
local boomyjump = 65
local boomywait = 0.1
local boomycam = 3
local flingPower = 10000

-- QoL Settings
local PingAdjustEnabled = true
local NotifyOnTech = true
local AntiAFKEnabled = true
local BasePing = 50 -- ms reference

-- ====================== UTILITY FUNCTIONS ======================
local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("LowerTorso")
        or char:FindFirstChild("Torso")
end

local function getPing()
    local ok, ping = pcall(function()
        return player:GetNetworkPing() * 1000
    end)
    return (ok and ping) or 50
end

-- Adjust delay based on ping
local function adj(delay)
    if not PingAdjustEnabled then return delay end
    local ping = getPing()
    local factor = math.clamp(ping / BasePing, 0.7, 2.0)
    return delay * factor
end

local function notifyTech(name)
    if NotifyOnTech then
        WindUI:Notify({
            Title = "Tech Activated",
            Content = name .. " triggered",
            Duration = 1.5,
            Icon = "zap"
        })
    end
end

-- Improved closest enemy (checks workspace.Live + Players)
local function getClosestEnemy(maxDist)
    maxDist = maxDist or 15
    if not hrp then return nil end

    local best, bestDist = nil, maxDist

    -- First try workspace.Live (game specific)
    local liveFolder = workspace:FindFirstChild("Live")
    if liveFolder then
        for _, model in ipairs(liveFolder:GetChildren()) do
            if model:IsA("Model") and model ~= player.Character then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local root = getRoot(model)
                    if root then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist < bestDist then
                            best = root
                            bestDist = dist
                        end
                    end
                end
            end
        end
    end

    -- Fallback to Players
    if not best then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local root = getRoot(plr.Character)
                    if root then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist < bestDist then
                            best = root
                            bestDist = dist
                        end
                    end
                end
            end
        end
    end

    return best
end

local function fireQ()
    if DashRemote then
        pcall(function()
            DashRemote:FireServer({
                [1] = {Dash = Enum.KeyCode.W, Key = Enum.KeyCode.Q, Goal = "KeyPress"}
            })
        end)
    end
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
end

local function autoPressQ()
    fireQ()
end

local function forceJump(height)
    height = height or 50
    local char = player.Character
    if not char then return end
    local root = getRoot(char)
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, height, root.Velocity.Z)
    end
end

local function flip()
    if cam then
        local cf = cam.CFrame
        local look = cf.LookVector
        local newLook = Vector3.new(-look.X, look.Y, -look.Z)
        cam.CFrame = CFrame.new(cf.Position, cf.Position + newLook)
    end
end

-- Attach system
local function detach()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    attached = false
end

local function attachTo(enemyHRP, duration, ignoreAnim)
    if attached then return end
    enemyHRP = getRoot(enemyHRP.Parent) or enemyHRP
    if not hrp or not enemyHRP then return end

    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if not ignoreAnim then
        local animPlaying = false
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            local animIdNumber = tonumber(track.Animation.AnimationId:match("%d+"))
            if animIdNumber == REQUIRED_ANIM_FOR_ATTACH then
                animPlaying = true
                break
            end
        end
        if not animPlaying then return end
    end

    attached = true
    local start = tick()
    followConnection = RunService.Heartbeat:Connect(function()
        if not enemyHRP or not enemyHRP.Parent then
            detach()
            return
        end
        hrp.CFrame = CFrame.new(enemyHRP.Position + Vector3.new(0, 1, 0)) * CFrame.Angles(math.rad(90), 0, 0)
        if tick() - start >= (duration or 0.3) then
            detach()
        end
    end)
end

local isAttaching = false
local attachConnection

local function attachUnderTarget(targetCharacter, duration)
    if isAttaching then return end
    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then return end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    isAttaching = true
    local endTime = os.clock() + duration

    attachConnection = RunService.RenderStepped:Connect(function()
        if os.clock() >= endTime then
            if attachConnection then attachConnection:Disconnect() end
            attachConnection = nil
            isAttaching = false
            return
        end

        if character and character:FindFirstChild("HumanoidRootPart") then
            local myHrp = character.HumanoidRootPart
            local targetHRP = targetCharacter.HumanoidRootPart
            myHrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0)) * CFrame.Angles(math.rad(90), 0, 0)
        end
    end)
end

-- Twisted function (fixed name)
local function doTwisted()
    local function getNearestPlayerTorso()
        local nearest = nil
        local shortestDistance = math.huge
        local myChar = player.Character
        local myHRP = myChar and getRoot(myChar)
        if not myHRP then return nil end

        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local torso = getRoot(otherPlayer.Character)
                if torso then
                    local distance = (torso.Position - myHRP.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearest = torso
                    end
                end
            end
        end
        return nearest
    end

    local target = getNearestPlayerTorso()
    if not target then return end

    cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
    fireQ()

    local function rotateCamera(angle)
        local cf = cam.CFrame
        local look = cf.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude == 0 then flat = Vector3.new(0, 0, 1) end
        flat = flat.Unit
        local rot = CFrame.fromAxisAngle(Vector3.yAxis, math.rad(angle))
        cam.CFrame = CFrame.new(cf.Position, cf.Position + (rot * flat + Vector3.new(0, look.Y, 0)))
    end

    rotateCamera(-70)
    task.wait(0.50)
    rotateCamera(120)
end

-- ====================== FLING ======================
local function flingLoop()
    local lp = Players.LocalPlayer
    while true do
        RunService.Heartbeat:Wait()
        if hiddenfling then
            local c = lp.Character
            local root = c and getRoot(c)
            if root then
                local vel = root.Velocity
                root.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                RunService.RenderStepped:Wait()
                if c and root then
                    root.Velocity = vel
                end
                RunService.Stepped:Wait()
                if c and root then
                    root.Velocity = vel + Vector3.new(0, 0.1, 0)
                end
            end
        end
    end
end
task.spawn(flingLoop)

-- ====================== ANTI VOID / ANTI DEATH ======================
workspace.FallenPartsDestroyHeight = 0/0
workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function()
    workspace.FallenPartsDestroyHeight = 0/0
end)

local function AntiDeath(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    local lastHealth = hum.Health

    RunService.RenderStepped:Connect(function()
        lastHealth = hum.Health
    end)

    hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 and root.Position.Y <= 0 then
            hum.Health = lastHealth
        end
    end)
end

if player.Character then AntiDeath(player.Character) end
player.CharacterAdded:Connect(AntiDeath)

-- ====================== ANTI-AFK ======================
task.spawn(function()
    while true do
        task.wait(60)
        if AntiAFKEnabled then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- ====================== CHARACTER SETUP ======================
local function setupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
    hrp = getRoot(char)

    attached = false
    attachCooldown = false
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end

    humanoid.Died:Connect(function()
        attached = false
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        hrp = nil
    end)

    humanoid.AnimationPlayed:Connect(function(track)
        local anim = track.Animation
        if not anim then return end
        local animIdNumber = tonumber(anim.AnimationId:match("%d+"))

        if UPPERCUT[anim.AnimationId] then
            didUppercut = true
            task.delay(0.6, function() didUppercut = false end)
        end

        if animIdNumber == REQUIRED_ANIM_FOR_ATTACH then
            onCooldown = true
            task.delay(5, function() onCooldown = false end)
        end

        -- ========== MEOW TECH ==========
        if MeowTechEnabled and UPPERCUT[anim.AnimationId] and not attachCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(meowstart), function()
                    fireQ()
                    attachTo(enemy, meowDuration)
                    notifyTech("MeowTech")
                end)
            end
        end

        if MeowTechEnabled and animIdNumber == REQUIRED_ANIM_FOR_ATTACH and didUppercut then
            if attached or attachCooldown then return end
            attachCooldown = true
            didUppercut = false
            task.delay(0.35, function() attachCooldown = false end)
            task.delay(0.08, function()
                local enemy = getClosestEnemy(12)
                if enemy then
                    attachTo(enemy, 0.3, true)
                    notifyTech("MeowTech Attach")
                end
            end)
        end

        if meowtechv2 and UPPERCUT[anim.AnimationId] and not onCooldown then
            local enemyHRP = getClosestEnemy(10)
            if enemyHRP then
                task.delay(adj(meowstart), function()
                    autoPressQ()
                    attachUnderTarget(enemyHRP.Parent, meowDuration)
                    notifyTech("MeowTech v2")
                end)
            end
        end

        -- ========== KING TECH ==========
        if KingTechEnabled and UPPERCUT[anim.AnimationId] and not onCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(kingstart), function()
                    autoPressQ()
                    forceJump()
                    task.delay(adj(kingwait), flip)
                    notifyTech("K1ng Tech")
                end)
            end
        end

        -- ========== OREO / DRIPZ ==========
        if dripz and UPPERCUT[anim.AnimationId] and not onCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(oreostart), function()
                    autoPressQ()
                    forceJump(oreojump)
                end)
                task.delay(adj(oreowait), function()
                    local startTime = tick()
                    local targetChar = enemy.Parent
                    local targetPart = targetChar:FindFirstChild("Right Arm") or getRoot(targetChar)
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not targetPart or not targetPart.Parent then
                            connection:Disconnect()
                            return
                        end
                        local camCF = cam.CFrame
                        local camPos = camCF.Position
                        local armCF = targetPart.CFrame
                        local backOffset = armCF:VectorToWorldSpace(Vector3.new(0, 0, -1))
                        local backPosition = armCF.Position + backOffset
                        local dir = Vector3.new(backPosition.X - camPos.X, 0, backPosition.Z - camPos.Z)
                        if dir.Magnitude > 0 then
                            dir = dir.Unit
                            local targetYaw = math.atan2(dir.Z, dir.X)
                            local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                            local newYaw = currentYaw + (targetYaw - currentYaw) * oreocam
                            local pitch = math.asin(camCF.LookVector.Y)
                            local newLook = Vector3.new(
                                math.cos(newYaw) * math.cos(pitch),
                                math.sin(pitch),
                                math.sin(newYaw) * math.cos(pitch)
                            )
                            cam.CFrame = CFrame.new(camPos, camPos + newLook)
                        end
                        if tick() - startTime >= 0.2 then
                            connection:Disconnect()
                        end
                    end)
                    notifyTech("Oreo Tech")
                end)
            end
        end

        -- ========== KITTY ==========
        if oreov2 and UPPERCUT[anim.AnimationId] and not onCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(kittystartjump), function() forceJump(60) end)
                task.delay(adj(kittystart), function()
                    autoPressQ()
                    flip()
                    task.wait(adj(kittywait))
                    local startTime = tick()
                    local targetChar = enemy.Parent
                    local targetPart = targetChar:FindFirstChild("Left Arm") or getRoot(targetChar)
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not targetPart or not targetPart.Parent then
                            connection:Disconnect()
                            return
                        end
                        local camCF = cam.CFrame
                        local camPos = camCF.Position
                        local lookCF = targetPart.CFrame
                        local dir = Vector3.new(lookCF.Position.X - camPos.X, 0, lookCF.Position.Z - camPos.Z)
                        if dir.Magnitude > 0 then
                            dir = dir.Unit
                            local targetYaw = math.atan2(dir.Z, dir.X)
                            local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                            local newYaw = currentYaw + (targetYaw - currentYaw) * kittycam
                            local pitch = math.asin(camCF.LookVector.Y)
                            local newLook = Vector3.new(
                                math.cos(newYaw) * math.cos(pitch),
                                math.sin(pitch),
                                math.sin(newYaw) * math.cos(pitch)
                            )
                            cam.CFrame = CFrame.new(camPos, camPos + newLook)
                        end
                        if tick() - startTime >= 0.2 then
                            connection:Disconnect()
                        end
                    end)
                    notifyTech("Kitty Tech")
                end)
            end
        end

        -- ========== KAKYO ==========
        if kakyo and UPPERCUT[anim.AnimationId] and not onCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(kakyostart), function()
                    forceJump(kakyojump)
                    local startTime = tick()
                    local targetChar = enemy.Parent
                    local targetPart = targetChar:FindFirstChild("Right Arm") or getRoot(targetChar)
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not targetPart or not targetPart.Parent then
                            connection:Disconnect()
                            return
                        end
                        local camCF = cam.CFrame
                        local camPos = camCF.Position
                        local armCF = targetPart.CFrame
                        local dir = Vector3.new(armCF.Position.X - camPos.X, 0, armCF.Position.Z - camPos.Z)
                        if dir.Magnitude > 0 then
                            dir = dir.Unit
                            local targetYaw = math.atan2(dir.Z, dir.X)
                            local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                            local newYaw = currentYaw + (targetYaw - currentYaw) * kakyocam
                            local pitch = math.asin(camCF.LookVector.Y)
                            local newLook = Vector3.new(
                                math.cos(newYaw) * math.cos(pitch),
                                math.sin(pitch),
                                math.sin(newYaw) * math.cos(pitch)
                            )
                            cam.CFrame = CFrame.new(camPos, camPos + newLook)
                        end
                        if tick() - startTime >= 0.3 then
                            connection:Disconnect()
                        end
                    end)
                    notifyTech("Kakyo Tech")
                end)
            end
        end

        -- ========== INNER DASH ==========
        if innerdash and UPPERCUT[anim.AnimationId] and not onCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(0.3), function()
                    fireQ()
                    local targetHRP = getRoot(enemy.Parent)
                    if targetHRP then
                        attachUnderTarget(enemy.Parent, 1)
                        notifyTech("Inner Dash")
                    end
                end)
            end
        end

        -- ========== INSTANT TWISTED ==========
        if instanttwisted and animIdNumber == M4_ANIM_ID and not onCooldown then
            local enemy = getClosestEnemy(12)
            if enemy then
                task.delay(adj(0.25), function()
                    doTwisted()
                    notifyTech("Instant Twisted")
                end)
            end
        end

        if leeinstanttwisted and animIdNumber == M4_ANIM_ID and not onCooldown then
            task.delay(adj(waitpress), function()
                fireQ()
                task.wait(adj(leewait))
                local cf = cam.CFrame
                cam.CFrame = cf * CFrame.Angles(0, math.rad(turn), 0)
                task.wait(adj(leewait2))
                cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(turn2), 0)
                notifyTech("Lee Instant Twisted")
            end)
        end

        -- ========== LETHAL VARIANTS ==========
        if lethalEnabled and animIdNumber == TARGET_ANIM_ID then
            task.spawn(function()
                task.delay(adj(meowlethalstart), function()
                    local enemy = getClosestEnemy(10)
                    if enemy then
                        fireQ()
                        attachTo(enemy, 0.5, true)
                        notifyTech("Meow + Lethal")
                    end
                end)
            end)
        end

        if LethalDashEnabled and animIdNumber == TARGET_ANIM_ID then
            task.spawn(function()
                task.delay(adj(normallethalstart), function()
                    forceJump()
                    autoPressQ()
                    task.delay(adj(secondforflip), flip)
                    notifyTech("Lethal Dash")
                end)
            end)
        end

        if instantlethal and animIdNumber == TARGET_ANIM_ID and not onCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(instantlethalstart), function()
                    autoPressQ()
                    forceJump(60)
                    notifyTech("Instant Lethal")
                end)
            end
        end

        if boomy and animIdNumber == TARGET_ANIM_ID then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(adj(boomystart), function()
                    autoPressQ()
                    flip()
                    forceJump(boomyjump)
                    notifyTech("Boomy Instant Lethal")
                end)
            end
        end

        -- ========== AUTO KYOTO ==========
        if AutoKyotoEnabled and animIdNumber == 12273188754 then
            task.delay(adj(1.6), function()
                local char = player.Character
                local root = char and getRoot(char)
                if root then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                    local look = root.CFrame.LookVector
                    local horizontalLook = Vector3.new(look.X, 0, look.Z)
                    if horizontalLook.Magnitude > 0 then
                        horizontalLook = horizontalLook.Unit
                    end
                    root.CFrame = root.CFrame + horizontalLook * 22
                    notifyTech("Auto Kyoto")
                end
            end)
        end

        if AutoKyototween and animIdNumber == 12273188754 then
            task.delay(adj(1.6), function()
                local char = player.Character
                local root = char and getRoot(char)
                if root then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                    local conn
                    conn = RunService.Heartbeat:Connect(function()
                        root.AssemblyLinearVelocity = root.CFrame.LookVector * 150
                    end)
                    task.delay(0.1, function()
                        if conn then conn:Disconnect() end
                    end)
                    notifyTech("Auto Kyoto Tween")
                end
            end)
        end

        if AutoKyotoLegitEnabled and animIdNumber == 12273188754 then
            task.delay(adj(1.6), function()
                local char = player.Character
                local root = char and getRoot(char)
                if root then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                    root.CFrame = root.CFrame + (root.CFrame.LookVector * 30)
                    notifyTech("Auto Kyoto Legit")
                end
            end)
        end

        -- ========== DEATH COUNTER ==========
        if deathcounter and animIdNumber == 11343250001 then
            local TELEPORT_DISTANCE = -10000
            local root = getRoot(player.Character)
            if root then
                local originalCFrame = root.CFrame
                local platform = Instance.new("Part")
                platform.Size = Vector3.new(10, 1, 10)
                platform.Anchored = true
                platform.Transparency = 1
                platform.CanCollide = true
                platform.Position = root.Position + Vector3.new(0, TELEPORT_DISTANCE - 0.5, 0)
                platform.Parent = workspace
                root.CFrame = platform.CFrame + Vector3.new(0, 3, 0)

                task.delay(6, function()
                    if root and originalCFrame then
                        root.CFrame = originalCFrame
                    end
                    if platform then platform:Destroy() end
                    local camera = workspace.CurrentCamera
                    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        camera.CameraSubject = hum
                        camera.CameraType = Enum.CameraType.Custom
                    end
                end)
                notifyTech("Death Counter Bypass")
            end
        end
    end)
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then
    setupCharacter(player.Character)
end

-- ====================== UI: TECHS TOGGLES ======================
Techs:Toggle({
    Title = "Enable inner dash (100%)",
    Icon = "cat",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) innerdash = state end
})

Techs:Toggle({
    Title = "Enable MeowTech",
    Icon = "cat",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) MeowTechEnabled = state end
})

Techs:Toggle({
    Title = "Enable MeowTechv2",
    Icon = "cat",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) meowtechv2 = state end
})

Techs:Toggle({
    Title = "Enable K1ng tech",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) KingTechEnabled = state end
})

Techs:Toggle({
    Title = "Enable oreo tech",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) dripz = state end
})

Techs:Toggle({
    Title = "kitty dash",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) oreov2 = state end
})

Techs:Toggle({
    Title = "kakyo under flip(new)",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) kakyo = state end
})

Techs:Toggle({
    Title = "lee instant twisted",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) leeinstanttwisted = state end
})

Techs:Toggle({
    Title = "Enable MeowTech + lethal",
    Icon = "cat",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) lethalEnabled = state end
})

Techs:Toggle({
    Title = "LethalDash Enabled",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) LethalDashEnabled = state end
})

Techs:Toggle({
    Title = "Instant lethal",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) instantlethal = state end
})

Techs:Toggle({
    Title = "booomy instant lethal",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) boomy = state end
})

Techs:Toggle({
    Title = "inner lethal(90% headglide)",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) innerlethal = state end
})

-- ====================== SETTINGS / QoL TAB ======================
settingsTab:Section({ Title = "Quality of Life" })

settingsTab:Toggle({
    Title = "Notify when Tech activates",
    Desc = "Shows a notification every time a tech triggers",
    Icon = "bell",
    Type = "Checkbox",
    Value = true,
    Callback = function(state) NotifyOnTech = state end
})

settingsTab:Toggle({
    Title = "Ping-based delay adjustment",
    Desc = "Automatically adjusts delays according to your ping",
    Icon = "activity",
    Type = "Checkbox",
    Value = true,
    Callback = function(state) PingAdjustEnabled = state end
})

settingsTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents being kicked for inactivity",
    Icon = "shield",
    Type = "Checkbox",
    Value = true,
    Callback = function(state) AntiAFKEnabled = state end
})

settingsTab:Button({
    Title = "Disable ALL Techs",
    Desc = "Turns off every combat macro at once",
    Callback = function()
        MeowTechEnabled = false
        meowtechv2 = false
        KingTechEnabled = false
        dripz = false
        oreov2 = false
        kakyo = false
        leeinstanttwisted = false
        lethalEnabled = false
        LethalDashEnabled = false
        instantlethal = false
        boomy = false
        innerlethal = false
        innerdash = false
        kyokiedash = false
        AutoKyotoEnabled = false
        AutoKyototween = false
        AutoKyotoLegitEnabled = false
        lunarextender = false
        instanttwisted = false

        WindUI:Notify({
            Title = "All Techs Disabled",
            Content = "Every combat macro has been turned off",
            Duration = 3,
            Icon = "power"
        })
    end
})

settingsTab:Divider()

settingsTab:Section({ Title = "Info" })
settingsTab:Paragraph({
    Title = "Current Ping",
    Desc = function()
        return string.format("%.0f ms", getPing())
    end
})

-- ====================== MEOW SETTINGS ======================
meowtech:Input({
    Title = "Start Time",
    Desc = "how long until the tech starts",
    Value = "0.3",
    Type = "Input",
    Placeholder = "Enter a number",
    Callback = function(input) meowstart = tonumber(input) or 0.3 end
})

meowtech:Input({
    Title = "duration",
    Desc = "how long the attach lasts",
    Value = "0.3",
    Type = "Input",
    Placeholder = "Enter a number",
    Callback = function(input) meowDuration = tonumber(input) or 0.3 end
})

-- ====================== KING SETTINGS ======================
k1ngtech:Input({
    Title = "Start Time",
    Value = "0.3",
    Type = "Input",
    Placeholder = "Enter a number",
    Callback = function(input) kingstart = tonumber(input) or 0.3 end
})

k1ngtech:Input({
    Title = "Flip Time",
    Value = "0.2",
    Type = "Input",
    Placeholder = "Enter a number",
    Callback = function(input) kingwait = tonumber(input) or 0.2 end
})

-- ====================== OREO SETTINGS ======================
oreo:Input({
    Title = "Start Time",
    Value = "0.3",
    Type = "Input",
    Callback = function(input) oreostart = tonumber(input) or 0.3 end
})

oreo:Input({
    Title = "Rotation time",
    Value = "0.5",
    Type = "Input",
    Callback = function(input) oreowait = tonumber(input) or 0.5 end
})

oreo:Input({
    Title = "camera speed",
    Value = "1",
    Type = "Input",
    Callback = function(input) oreocam = tonumber(input) or 1 end
})

oreo:Input({
    Title = "Jump height",
    Value = "54",
    Type = "Input",
    Callback = function(input) oreojump = tonumber(input) or 54 end
})

-- ====================== KITTY SETTINGS ======================
kitty:Input({
    Title = "kitty jump",
    Value = "0.1",
    Type = "Input",
    Callback = function(input) kittystartjump = tonumber(input) or 0.1 end
})

kitty:Input({
    Title = "Start Time",
    Value = "0.3",
    Type = "Input",
    Callback = function(input) kittystart = tonumber(input) or 0.3 end
})

kitty:Input({
    Title = "Rotate Time",
    Value = "0.1",
    Type = "Input",
    Callback = function(input) kittywait = tonumber(input) or 0.1 end
})

kitty:Input({
    Title = "camera speed",
    Value = "1",
    Type = "Input",
    Callback = function(input) kittycam = tonumber(input) or 1 end
})

-- ====================== KAKYO SETTINGS ======================
kak:Input({
    Title = "Start Time",
    Value = "0.3",
    Type = "Input",
    Callback = function(input) kakyostart = tonumber(input) or 0.3 end
})

kak:Input({
    Title = "kakyo jump height",
    Value = "40",
    Type = "Input",
    Callback = function(input) kakyojump = tonumber(input) or 40 end
})

kak:Input({
    Title = "camera speed",
    Value = "4",
    Type = "Input",
    Callback = function(input) kakyocam = tonumber(input) or 4 end
})

-- ====================== INSTANT TWISTED SETTINGS ======================
instanttwis:Input({
    Title = "press Q Time",
    Value = "0.2",
    Type = "Input",
    Callback = function(input) waitpress = tonumber(input) or 0.2 end
})

instanttwis:Input({
    Title = "wait",
    Value = "0.1",
    Type = "Input",
    Callback = function(input) leewait = tonumber(input) or 0.1 end
})

instanttwis:Input({
    Title = "rotate Degree",
    Value = "-90",
    Type = "Input",
    Callback = function(input) turn = tonumber(input) or -90 end
})

instanttwis:Input({
    Title = "wait2",
    Value = "0.05",
    Type = "Input",
    Callback = function(input) leewait2 = tonumber(input) or 0.05 end
})

instanttwis:Input({
    Title = "rotate Degree 2",
    Value = "110",
    Type = "Input",
    Callback = function(input) turn2 = tonumber(input) or 110 end
})

-- ====================== LETHAL SETTINGS ======================
lethal:Input({
    Title = "Start Time (meowtech + lethal)",
    Value = "1.7",
    Type = "Input",
    Callback = function(input) meowlethalstart = tonumber(input) or 1.7 end
})

lethal:Divider()

lethal:Input({
    Title = "Start Time (lethal Dash)",
    Value = "1.7",
    Type = "Input",
    Callback = function(input) normallethalstart = tonumber(input) or 1.7 end
})

lethal:Input({
    Title = "Flip Time",
    Value = "0.2",
    Type = "Input",
    Callback = function(input) secondforflip = tonumber(input) or 0.2 end
})

lethal:Divider()

lethal:Input({
    Title = "Start Time (instant Lethal)",
    Value = "1.7",
    Type = "Input",
    Callback = function(input) instantlethalstart = tonumber(input) or 1.7 end
})

lethal:Input({
    Title = "Rotate Time",
    Value = "0.5",
    Type = "Input",
    Callback = function(input) instantlethalwait = tonumber(input) or 0.5 end
})

lethal:Divider()

lethal:Input({
    Title = "Start Time (Boomy)",
    Value = "1.7",
    Type = "Input",
    Callback = function(input) boomystart = tonumber(input) or 1.7 end
})

lethal:Input({
    Title = "Jump Height",
    Value = "60",
    Type = "Input",
    Callback = function(input) boomyjump = tonumber(input) or 60 end
})

-- ====================== KYOTO ======================
tech:Toggle({
    Title = "Auto Kyoto",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) AutoKyotoEnabled = state end
})

tech:Toggle({
    Title = "Auto Kyoto tween mode",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) AutoKyototween = state end
})

tech:Toggle({
    Title = "Auto Kyoto Legit",
    Icon = "moon",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) AutoKyotoLegitEnabled = state end
})

-- ====================== SOCIAL ======================
plat:Button({
    Title = "Copy Discord Link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/n7rjmS4sNp")
            WindUI:Notify({ Title = "Copied", Content = "Discord link copied", Duration = 3 })
        end
    end
})

plat:Button({
    Title = "Copy youtube Link",
    Callback = function()
        if setclipboard then
            setclipboard("http://youtube.com/@kyokiee")
            WindUI:Notify({ Title = "Copied", Content = "YouTube link copied", Duration = 3 })
        end
    end
})

plat:Button({
    Title = "Copy tiktok Link",
    Callback = function()
        if setclipboard then
            setclipboard("http://tiktok.com/@kyokieut")
            WindUI:Notify({ Title = "Copied", Content = "TikTok link copied", Duration = 3 })
        end
    end
})

-- ====================== MAIN TAB ======================
main:Toggle({
    Title = "Enable WalkSpeed",
    Desc = "also makes you no stun",
    Icon = "cat",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        WalkSpeedEnabled = state
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = state and walkSpeedValue or 23
            end
        end
    end
})

main:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = { Min = 0, Max = 1000, Default = 23 },
    Callback = function(value)
        walkSpeedValue = value
        if WalkSpeedEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = value
                end
            end
        end
    end
})

main:Toggle({
    Title = "touch fling",
    Desc = "fling other player when touch",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) hiddenfling = v end
})

main:Toggle({
    Title = "No Dash Cooldown (new)",
    Desc = "Toggle to remove dash cooldown",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        workspace:SetAttribute("NoDashCooldown", state)
        if state then
            workspace:SetAttribute("EffectAffects", 1)
        end
    end
})

main:Toggle({
    Title = "anti death counter",
    Desc = "make u not die in deathcounter",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) deathcounter = v end
})

-- Enforce WalkSpeed
RunService.RenderStepped:Connect(function()
    if not WalkSpeedEnabled then return end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= walkSpeedValue then
            humanoid.WalkSpeed = walkSpeedValue
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    if WalkSpeedEnabled then
        humanoid.WalkSpeed = walkSpeedValue
    end
end)

-- ====================== TELEPORT ======================
local playerButtons = {}

local function teleportToPlayer(targetPlayer)
    if player.Character and targetPlayer.Character then
        local myRoot = getRoot(player.Character)
        local targetRoot = getRoot(targetPlayer.Character)
        if myRoot and targetRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 3)
        end
    end
end

local function addPlayerButton(plr)
    if plr == player then return end
    local button = tp:Button({
        Title = plr.Name,
        Desc = "Teleport to " .. plr.Name,
        Callback = function()
            teleportToPlayer(plr)
        end
    })
    playerButtons[plr] = button
end

for _, plr in ipairs(Players:GetPlayers()) do
    addPlayerButton(plr)
end

Players.PlayerAdded:Connect(addPlayerButton)
Players.PlayerRemoving:Connect(function(plr)
    playerButtons[plr] = nil
end)

-- ====================== COUNTER ESP ======================
local highlights = {}
local connections = {}
local espEnabled = false

local function addHighlight(character)
    if highlights[character] then return end
    local h = Instance.new("Highlight")
    h.Name = "CounterHighlight"
    h.FillColor = Color3.fromRGB(255, 0, 0)
    h.OutlineColor = Color3.fromRGB(255, 0, 0)
    h.FillTransparency = 0.45
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = character
    h.Parent = character
    highlights[character] = h
end

local function removeHighlight(character)
    if highlights[character] then
        highlights[character]:Destroy()
        highlights[character] = nil
    end
end

local function clearAllHighlights()
    for char, _ in pairs(highlights) do
        removeHighlight(char)
    end
end

local function hasCounterAccessory(character)
    for _, acc in ipairs(character:GetChildren()) do
        if acc:IsA("Accessory") and acc.Name == "Counter" then
            return true
        end
    end
    return false
end

local function setupCharacterWatch(character)
    if connections[character] then
        for _, conn in pairs(connections[character]) do
            conn:Disconnect()
        end
    end
    connections[character] = {}

    if hasCounterAccessory(character) then
        addHighlight(character)
    end

    connections[character].added = character.ChildAdded:Connect(function(child)
        if child:IsA("Accessory") and child.Name == "Counter" then
            addHighlight(character)
        end
    end)

    connections[character].removed = character.ChildRemoved:Connect(function(child)
        if child:IsA("Accessory") and child.Name == "Counter" then
            removeHighlight(character)
        end
    end)
end

local function cleanupCharacterWatch(character)
    removeHighlight(character)
    if connections[character] then
        for _, conn in pairs(connections[character]) do
            conn:Disconnect()
        end
        connections[character] = nil
    end
end

local function enableESP()
    espEnabled = true
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            setupCharacterWatch(plr.Character)
        end
    end
end

local function disableESP()
    espEnabled = false
    clearAllHighlights()
    for character, _ in pairs(connections) do
        if connections[character] then
            for _, conn in pairs(connections[character]) do
                conn:Disconnect()
            end
        end
    end
    connections = {}
end

local function onPlayerAdded(plr)
    if plr == player then return end
    if plr.Character and espEnabled then
        setupCharacterWatch(plr.Character)
    end
    plr.CharacterAdded:Connect(function(char)
        if espEnabled then setupCharacterWatch(char) end
    end)
    plr.CharacterRemoving:Connect(cleanupCharacterWatch)
end

for _, plr in ipairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
end
Players.PlayerAdded:Connect(onPlayerAdded)

esp:Toggle({
    Title = "Counter ESP",
    Desc = "Highlights players with death counter",
    Icon = "crosshair",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then enableESP() else disableESP() end
    end
})

-- ====================== M1 RESET ======================
local debounce = false
local dashDuration = 0.2
local dashforce = 150
local m1resetGui = nil

local function triggerDash()
    if debounce then return end
    local char = player.Character
    if not char then return end
    local root = getRoot(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    debounce = true

    local disabled = {}
    for _, v in ipairs(root:GetChildren()) do
        if v:IsA("BodyVelocity") and v.Name ~= "moveme" then
            disabled[v] = v.MaxForce
            v.MaxForce = Vector3.zero
        end
    end

    local connect = RunService.Heartbeat:Connect(function()
        root.AssemblyLinearVelocity = root.CFrame.RightVector * dashforce
    end)

    local originalCamCF = cam.CFrame
    cam.CFrame = originalCamCF * CFrame.Angles(0, math.rad(-90), 0)

    task.wait(dashDuration)

    fireQ()
    root.AssemblyLinearVelocity = Vector3.zero
    cam.CFrame = originalCamCF

    if connect then connect:Disconnect() end

    for bv, maxForce in pairs(disabled) do
        if bv and bv.Parent then
            bv.MaxForce = maxForce
        end
    end

    debounce = false
end

M1reset:Keybind({
    Title = "Dash Key",
    Desc = "Key to trigger dash",
    Value = "E",
    Callback = function()
        if m1resetGui and m1resetGui.Enabled then
            triggerDash()
        end
    end
})

M1reset:Toggle({
    Title = "M1Reset GUI",
    Desc = "Toggle dash GUI",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            if m1resetGui then m1resetGui:Destroy() end
            m1resetGui = Instance.new("ScreenGui")
            m1resetGui.Name = "m1reset"
            m1resetGui.Parent = player:WaitForChild("PlayerGui")
            m1resetGui.ResetOnSpawn = false

            local dashframe = Instance.new("Frame")
            dashframe.Name = "dashframe"
            dashframe.Parent = m1resetGui
            dashframe.BackgroundTransparency = 1
            dashframe.Size = UDim2.new(0, 150, 0, 150)
            dashframe.Position = UDim2.new(0.5, -75, 0.5, -75)
            dashframe.Active = true
            dashframe.Draggable = true

            local cat = Instance.new("ImageButton")
            cat.Name = "cat"
            cat.Parent = dashframe
            cat.BackgroundTransparency = 1
            cat.Position = UDim2.new(0.1, 0, 0.2, 0)
            cat.Size = UDim2.new(0, 79, 0, 72)
            cat.Image = "rbxassetid://124624838814157"
            cat.Activated:Connect(triggerDash)

            local idk = Instance.new("TextLabel")
            idk.Name = "idk"
            idk.Parent = dashframe
            idk.BackgroundTransparency = 0
            idk.Position = UDim2.new(0.1, 0, 0.05, 0)
            idk.Size = UDim2.new(0, 79, 0, 18)
            idk.Font = Enum.Font.SourceSans
            idk.Text = "drag"
            idk.TextColor3 = Color3.new(0, 0, 0)
            idk.TextSize = 14
        else
            if m1resetGui then
                m1resetGui:Destroy()
                m1resetGui = nil
            end
        end
    end
})

M1reset:Input({
    Title = "duration",
    Value = "0.2",
    Type = "Input",
    Callback = function(input)
        local num = tonumber(input)
        if num then dashDuration = num end
    end
})

M1reset:Input({
    Title = "dash force",
    Value = "150",
    Type = "Input",
    Callback = function(input)
        local num = tonumber(input)
        if num then dashforce = num end
    end
})

-- ====================== REDUCE LAG ======================
reduce:Button({
    Title = "potato graphics",
    Desc = "no texture",
    Callback = function()
        local function RemoveTextures(inst)
            for _, child in ipairs(inst:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
                    child:Destroy()
                end
            end
            if inst:IsA("MeshPart") then
                inst.TextureID = ""
                inst.Material = Enum.Material.SmoothPlastic
            elseif inst:IsA("Part") or inst:IsA("UnionOperation") then
                inst.Material = Enum.Material.SmoothPlastic
            end
        end

        for _, inst in ipairs(workspace:GetDescendants()) do
            RemoveTextures(inst)
        end

        workspace.DescendantAdded:Connect(RemoveTextures)
        WindUI:Notify({ Title = "Done", Content = "Textures removed", Duration = 3 })
    end
})

reduce:Button({
    Title = "reduce lag (max)",
    Callback = function()
        local KEEP_NAMES = { Floor = true, Roads = true, MainPart = true }
        local MAINPART_COLOR = Color3.fromRGB(80, 80, 80)

        local function CleanVisuals(inst)
            if inst:IsA("Decal") or inst:IsA("Texture") or inst:IsA("SurfaceAppearance") then
                inst:Destroy()
            elseif inst:IsA("MeshPart") then
                inst.Material = Enum.Material.SmoothPlastic
                inst.TextureID = ""
            elseif inst:IsA("SpecialMesh") then
                inst.TextureId = ""
            elseif inst:IsA("Part") or inst:IsA("UnionOperation") then
                inst.Material = Enum.Material.SmoothPlastic
            end
            if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Beam") then
                inst.Enabled = false
                inst:Destroy()
            end
        end

        for _, inst in ipairs(workspace:GetDescendants()) do
            CleanVisuals(inst)
        end

        local Map = workspace:FindFirstChild("Map")
        if Map then
            for _, obj in ipairs(Map:GetChildren()) do
                if not KEEP_NAMES[obj.Name] then
                    obj:Destroy()
                else
                    if obj.Name == "MainPart" then
                        if obj:IsA("BasePart") then obj.Color = MAINPART_COLOR end
                        for _, d in ipairs(obj:GetDescendants()) do
                            if d:IsA("BasePart") then d.Color = MAINPART_COLOR end
                        end
                    end
                end
            end
            Map.ChildAdded:Connect(function(obj)
                if not KEEP_NAMES[obj.Name] then obj:Destroy() end
            end)
        end

        workspace.DescendantAdded:Connect(CleanVisuals)
        WindUI:Notify({ Title = "Done", Content = "Max lag reduction applied", Duration = 3 })
    end
})

print("[Lunar Hub Improved] Loaded successfully")
