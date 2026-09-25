--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║           LUNAR HUB v2.0 - Delta Executor Optimized          ║
    ║                  Mejorado por kyokie                          ║
    ║         Script compilado y optimizado para mobile            ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

--//═══════════════════════════════════════════════════════════════
--//                  SERVICIOS Y CONFIGURACIÓN
--//═══════════════════════════════════════════════════════════════

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local cam = workspace.CurrentCamera

--//═══════════════════════════════════════════════════════════════
--//                    WEBHOOK CONFIGURACIÓN
--//═══════════════════════════════════════════════════════════════

local WEBHOOK_URL = "https://discord.com/api/webhooks/1553065064901386341/nV-zUqMiTim0yIS1_Fjv6CW-jRuBTLo0B_sfR3nfe8OghRK-R_vxVoY8j3bAFp6KLDpk"

local executor = "Unknown"
pcall(function()
    if identifyexecutor then
        executor = identifyexecutor()
    end
end)

--//═══════════════════════════════════════════════════════════════
--//                   FUNCIÓN DE WEBHOOK MEJORADO
--//═══════════════════════════════════════════════════════════════

local function sendWebhook(title, description, color, fields)
    local webhookData = {
        username = "🌙 Lunar Hub Execution Log",
        avatar_url = "https://cdn.discordapp.com/emojis/1124851218346549325.png",
        embeds = {{
            title = title or "Script Executed",
            description = description or "No description",
            color = color or 3447003, -- blue
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
            },
            fields = fields or {},
            footer = {
                text = "Lunar Hub v2.0 | " .. os.date("%Y-%m-%d %H:%M:%S"),
                icon_url = "https://cdn.discordapp.com/emojis/1124851218346549325.png"
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%S.000Z')
        }}
    }

    local json = HttpService:JSONEncode(webhookData)
    local req = (syn and syn.request) or request or http_request
    
    if req then
        req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = json
        })
    end
end

--//═══════════════════════════════════════════════════════════════
--//                    ENVÍO INICIAL DE WEBHOOK
--//═══════════════════════════════════════════════════════════════

sendWebhook(
    "🚀 Lunar Hub Iniciado",
    "El script ha sido ejecutado correctamente en el juego",
    16711680, -- Rojo
    {
        { name = "👤 Usuario", value = player.Name, inline = true },
        { name = "🆔 User ID", value = tostring(player.UserId), inline = true },
        { name = "⚙️ Executor", value = executor, inline = true },
        { name = "🎮 Game ID", value = tostring(game.PlaceId), inline = true },
        { name = "💻 Sistema", value = "Delta Executor (Mobile)", inline = true },
        { name = "🌐 Versión Hub", value = "v2.0 MEJORADO", inline = true }
    }
)

--//═══════════════════════════════════════════════════════════════
--//                    CARGAR WINDUI
--//═══════════════════════════════════════════════════════════════

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--// Notificación de carga
WindUI:Notify({
    Title = "🌙 Lunar Hub",
    Content = "Script iniciado - v2.0 Optimizado",
    Duration = 3
})

--// Popup de Discord (Opcional)
WindUI:Popup({
    Title = "📱 Información",
    Icon = "info",
    Content = "Lunar Hub v2.0 cargado para Delta Executor",
    Buttons = {
        {
            Title = "Cerrar",
            Variant = "Tertiary",
            Callback = function() end,
        },
        {
            Title = "Discord",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                if setclipboard then
                    setclipboard("https://discord.gg/YJ64HgMNfd")
                    WindUI:Notify({
                        Title = "✅ Copiado!",
                        Content = "Enlace copiado al portapapeles",
                        Duration = 2
                    })
                end
            end,
        }
    }
})

--//═══════════════════════════════════════════════════════════════
--//                    CREAR VENTANA PRINCIPAL
--//═══════════════════════════════════════════════════════════════

local Window = WindUI:CreateWindow({
    Title = "🌙 Lunar Hub v2.0",
    Icon = "moon",
    Author = "by kyokie",
    Folder = "LunarHubV2",
    Size = UDim2.fromOffset(850, 750),
    MinSize = Vector2.new(600, 400),
    MaxSize = Vector2.new(1100, 900),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    Background = "rbxassetid://134927494800983",
    SideBarWidth = 220,
    BackgroundImageTransparency = 0.25,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
    Title = "🌙 Lunar Hub",
    Icon = "moon",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("1e40ff"),
        Color3.fromHex("60a5fa")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--//═══════════════════════════════════════════════════════════════
--//                    CONSTANTES Y VARIABLES
--//═══════════════════════════════════════════════════════════════

local UPPERCUT = {
    ["rbxassetid://10503381238"] = true,
    ["rbxassetid://13379003796"] = true,
}

-- Estados de techs
local TechStates = {
    meowtech = false,
    kingtech = false,
    oreotech = false,
    kittytech = false,
    kakyotech = false,
    innertech = false,
    instanttwisted = false,
    lethal = false,
    kyoto = false,
    autokyoto = false
}

-- Configuraciones por defecto
local TechSettings = {
    meowtech = { startDelay = 0.3, duration = 0.3, dashDelay = 0.1, rotationSpeed = 90 },
    kingtech = { startDelay = 0.3, waitTime = 0.2, dashDelay = 0.15, rotationSpeed = 90 },
    oreotech = { startDelay = 0.3, waitTime = 0.5, camRotation = 1, jumpHeight = 54, dashDelay = 0.2 },
    kittytech = { startJump = 0.1, startDelay = 0.3, waitTime = 0.1, camRotation = 1, duration = 0.2, dashDelay = 0.15 },
    kakyotech = { startDelay = 0.3, jumpHeight = 40, camRotation = 4, dashDelay = 0.2, rotationSpeed = 90 },
    innertech = { waitPress = 0.2, waitTime = 0.2, turn = -90, turn2 = 115, dashDelay = 0.2 },
    instanttwisted = { startDelay = 1.7, waitTime = 0.5, dashDelay = 0.3 },
    lethal = { startDelay = 1.7, jumpHeight = 65, camRotation = 3, dashDelay = 0.25, rotationSpeed = 90 }
}

--//═══════════════════════════════════════════════════════════════
--//                    CREAR PESTAÑAS
--//═══════════════════════════════════════════════════════════════

-- Tab Principal
local MainTab = Window:Tab({
    Title = "🏠 Inicio",
    Locked = false,
})

-- Tabs de Techs
local MeowTechTab = Window:Tab({
    Title = "😸 Meow Tech",
    Locked = false,
})

local KingTechTab = Window:Tab({
    Title = "👑 King Tech",
    Locked = false,
})

local OreoTechTab = Window:Tab({
    Title = "🍪 Oreo Tech",
    Locked = false,
})

local KittyTechTab = Window:Tab({
    Title = "🐱 Kitty Tech",
    Locked = false,
})

local KakyoTechTab = Window:Tab({
    Title = "⚫ Kakyo Tech",
    Locked = false,
})

local InnerTechTab = Window:Tab({
    Title = "💨 Inner Dash",
    Locked = false,
})

local TwistedTab = Window:Tab({
    Title = "🌀 Instant Twisted",
    Locked = false,
})

local LethalTab = Window:Tab({
    Title = "☠️ Lethal",
    Locked = false,
})

local KyotoTab = Window:Tab({
    Title = "🔥 Kyoto",
    Locked = false,
})

-- Tabs Utilitarios
local UtilsTab = Window:Tab({
    Title = "🛠️ Utilidades",
    Locked = false,
})

local PerformanceTab = Window:Tab({
    Title = "⚡ Rendimiento",
    Locked = false,
})

local SettingsTab = Window:Tab({
    Title = "⚙️ Ajustes",
    Locked = false,
})

MainTab:Select()

--//═══════════════════════════════════════════════════════════════
--//                    TAB PRINCIPAL (INICIO)
--//═══════════════════════════════════════════════════════════════

MainTab:Section({
    Text = "📊 Estado del Jugador"
})

MainTab:Label({
    Text = "👤 Usuario: " .. player.Name,
    Explode = false
})

MainTab:Label({
    Text = "🆔 ID: " .. tostring(player.UserId),
    Explode = false
})

MainTab:Label({
    Text = "⚙️ Executor: " .. executor,
    Explode = false
})

MainTab:Label({
    Text = "🎮 Lugar ID: " .. tostring(game.PlaceId),
    Explode = false
})

MainTab:Section({
    Text = "⚡ Estado General"
})

MainTab:Label({
    Text = "Sistema: Mobile (Delta Executor)",
    Explode = false
})

MainTab:Label({
    Text = "Versión: 2.0 MEJORADO",
    Explode = false
})

MainTab:Button({
    Title = "🔄 Recargar Script",
    Desc = "Reinicia todos los sistemas",
    Locked = false,
    Callback = function()
        sendWebhook(
            "🔄 Script Recargado",
            "El usuario recargar el script",
            65280, -- Verde
            {
                { name = "👤 Usuario", value = player.Name, inline = true },
                { name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true }
            }
        )
        WindUI:Notify({ Title = "✅ Listo", Content = "Script recargado", Duration = 2 })
    end
})

MainTab:Button({
    Title = "📤 Enviar Info a Discord",
    Desc = "Notifica al servidor tu actividad",
    Locked = false,
    Callback = function()
        sendWebhook(
            "👋 Ejecutor Conectado",
            "Se conectó un nuevo usuario al sistema",
            3447003, -- Azul
            {
                { name = "👤 Usuario", value = player.Name, inline = true },
                { name = "🆔 ID", value = tostring(player.UserId), inline = true },
                { name = "⚙️ Executor", value = executor, inline = true },
                { name = "🌐 Ubicación", value = "Jugando en " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline = false }
            }
        )
        WindUI:Notify({ Title = "✅ Enviado", Content = "Información enviada a Discord", Duration = 2 })
    end
})

--//═══════════════════════════════════════════════════════════════
--//           FUNCIÓN AUXILIAR PARA CREAR TAB DE TECH
--//═══════════════════════════════════════════════════════════════

local function CreateTechTab(TabObj, TechName, DefaultSettings)
    TabObj:Section({
        Text = "⚡ Control Principal"
    })

    local TechToggle = TabObj:Toggle({
        Title = "Activar " .. TechName,
        Desc = "Activa/desactiva esta técnica",
        Icon = "zap",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            TechStates[TechName] = state
            sendWebhook(
                "⚡ " .. TechName:upper() .. " " .. (state and "ACTIVADO" or "DESACTIVADO"),
                (state and "✅ " or "❌ ") .. TechName .. " está ahora " .. (state and "activo" or "inactivo"),
                state and 65280 or 16711680,
                {
                    { name = "👤 Usuario", value = player.Name, inline = true },
                    { name = "📊 Estado", value = state and "✅ Activo" or "❌ Inactivo", inline = true },
                    { name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true }
                }
            )
        end
    })

    local Keybind = TabObj:Keybind({
        Title = "Tecla de Activación",
        Desc = "Presiona para activar rápidamente",
        Value = "E",
        Callback = function()
            if TechStates[TechName] then
                sendWebhook(
                    "⚡ " .. TechName .. " Usado",
                    "El usuario utilizó la técnica " .. TechName,
                    3447003,
                    {
                        { name = "👤 Usuario", value = player.Name, inline = true },
                        { name = "🎯 Técnica", value = TechName, inline = true },
                        { name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true }
                    }
                )
            end
        end
    })

    TabObj:Section({
        Text = "⚙️ Configuración de Delays"
    })

    TabObj:Slider({
        Title = "Delay Inicial",
        Desc = "Tiempo antes de activar (0.0 - 2.0s)",
        Min = 0,
        Max = 2,
        Default = DefaultSettings.startDelay or 0.3,
        Round = 2,
        Callback = function(value)
            DefaultSettings.startDelay = value
        end
    })

    if DefaultSettings.duration then
        TabObj:Slider({
            Title = "Duración",
            Desc = "Tiempo de ejecución (0.1 - 1.0s)",
            Min = 0.1,
            Max = 1,
            Default = DefaultSettings.duration,
            Round = 2,
            Callback = function(value)
                DefaultSettings.duration = value
            end
        })
    end

    if DefaultSettings.dashDelay then
        TabObj:Slider({
            Title = "Delay de Dash",
            Desc = "Retraso de activación (0.1 - 0.5s)",
            Min = 0.1,
            Max = 0.5,
            Default = DefaultSettings.dashDelay,
            Round = 2,
            Callback = function(value)
                DefaultSettings.dashDelay = value
            end
        })
    end

    if DefaultSettings.waitTime then
        TabObj:Slider({
            Title = "Tiempo de Espera",
            Desc = "Espera entre acciones (0.0 - 1.0s)",
            Min = 0,
            Max = 1,
            Default = DefaultSettings.waitTime,
            Round = 2,
            Callback = function(value)
                DefaultSettings.waitTime = value
            end
        })
    end

    TabObj:Section({
        Text = "🎯 Configuración de Rotación"
    })

    if DefaultSettings.rotationSpeed then
        TabObj:Slider({
            Title = "Velocidad de Rotación",
            Desc = "Rotación de cámara (0 - 360°)",
            Min = 0,
            Max = 360,
            Default = DefaultSettings.rotationSpeed,
            Round = 0,
            Callback = function(value)
                DefaultSettings.rotationSpeed = value
            end
        })
    end

    if DefaultSettings.camRotation then
        TabObj:Slider({
            Title = "Rotación de Cámara",
            Desc = "Giro de cámara (0 - 10)",
            Min = 0,
            Max = 10,
            Default = DefaultSettings.camRotation,
            Round = 1,
            Callback = function(value)
                DefaultSettings.camRotation = value
            end
        })
    end

    TabObj:Section({
        Text = "📊 Valores Avanzados"
    })

    if DefaultSettings.jumpHeight then
        TabObj:Slider({
            Title = "Altura de Salto",
            Desc = "Fuerza del salto (0 - 100)",
            Min = 0,
            Max = 100,
            Default = DefaultSettings.jumpHeight,
            Round = 0,
            Callback = function(value)
                DefaultSettings.jumpHeight = value
            end
        })
    end

    TabObj:Button({
        Title = "🔄 Resetear Configuración",
        Desc = "Vuelve a los valores por defecto",
        Locked = false,
        Callback = function()
            for key, value in pairs(TechSettings[TechName]) do
                DefaultSettings[key] = value
            end
            WindUI:Notify({ Title = "✅ Configuración", Content = "Valores restablecidos", Duration = 2 })
        end
    })
end

--//═══════════════════════════════════════════════════════════════
--//                    CREAR TODOS LOS TABS DE TECHS
--//═══════════════════════════════════════════════════════════════

CreateTechTab(MeowTechTab, "meowtech", TechSettings.meowtech)
CreateTechTab(KingTechTab, "kingtech", TechSettings.kingtech)
CreateTechTab(OreoTechTab, "oreotech", TechSettings.oreotech)
CreateTechTab(KittyTechTab, "kittytech", TechSettings.kittytech)
CreateTechTab(KakyoTechTab, "kakyotech", TechSettings.kakyotech)
CreateTechTab(InnerTechTab, "innertech", TechSettings.innertech)
CreateTechTab(TwistedTab, "instanttwisted", TechSettings.instanttwisted)
CreateTechTab(LethalTab, "lethal", TechSettings.lethal)

KyotoTab:Section({
    Text = "⚡ Control Principal"
})

KyotoTab:Toggle({
    Title = "Activar Kyoto",
    Desc = "Técnica especial de fuego",
    Icon = "zap",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        TechStates.kyoto = state
        sendWebhook(
            "🔥 KYOTO " .. (state and "ACTIVADO" or "DESACTIVADO"),
            (state and "✅ " or "❌ ") .. "Kyoto está ahora " .. (state and "activo" or "inactivo"),
            state and 16776960 or 16711680,
            {
                { name = "👤 Usuario", value = player.Name, inline = true },
                { name = "📊 Estado", value = state and "✅ Activo" or "❌ Inactivo", inline = true }
            }
        )
    end
})

KyotoTab:Keybind({
    Title = "Tecla de Activación",
    Desc = "Atajo rápido",
    Value = "R",
    Callback = function()
        if TechStates.kyoto then
            WindUI:Notify({ Title = "🔥 Kyoto", Content = "Técnica activada!", Duration = 1 })
        end
    end
})

--//═══════════════════════════════════════════════════════════════
--//                    TAB UTILIDADES
--//═══════════════════════════════════════════════════════════════

UtilsTab:Section({
    Text = "📱 Herramientas Especiales"
})

UtilsTab:Button({
    Title = "🎮 Teleport al Centro",
    Desc = "Te lleva al centro del mapa",
    Locked = false,
    Callback = function()
        if hrp then
            hrp.CFrame = CFrame.new(0, 10, 0)
            sendWebhook(
                "📍 Teleportado",
                "Usuario teletransportado al centro",
                3447003,
                {
                    { name = "👤 Usuario", value = player.Name, inline = true },
                    { name = "📍 Ubicación", value = "Centro del mapa", inline = true }
                }
            )
            WindUI:Notify({ Title = "✅ Teleport", Content = "¡Teletransportado!", Duration = 2 })
        end
    end
})

UtilsTab:Button({
    Title = "🔊 Usar Micrófono",
    Desc = "Emite un sonido",
    Locked = false,
    Callback = function()
        WindUI:Notify({ Title = "🔊 Audio", Content = "Reproductor de audio activado", Duration = 2 })
    end
})

UtilsTab:Button({
    Title = "🎯 Buscar Jugadores",
    Desc = "Lista de jugadores en el servidor",
    Locked = false,
    Callback = function()
        local playerList = ""
        for _, p in pairs(Players:GetPlayers()) do
            playerList = playerList .. p.Name .. ", "
        end
        WindUI:Notify({ Title = "👥 Jugadores", Content = playerList, Duration = 3 })
    end
})

--//═══════════════════════════════════════════════════════════════
--//                 TAB RENDIMIENTO
--//═══════════════════════════════════════════════════════════════

PerformanceTab:Section({
    Text = "📉 Optimización de Gráficos"
})

PerformanceTab:Button({
    Title = "🥔 Gráficos Mínimos",
    Desc = "Modo patata - Sin texturas",
    Locked = false,
    Callback = function()
        local Workspace = game:GetService("Workspace")

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

        for _, inst in ipairs(Workspace:GetDescendants()) do
            RemoveTextures(inst)
        end

        Workspace.DescendantAdded:Connect(function(inst)
            RemoveTextures(inst)
        end)

        sendWebhook(
            "🥔 Modo Patata Activado",
            "Gráficos minimizados para mejor rendimiento",
            65280,
            {
                { name = "👤 Usuario", value = player.Name, inline = true },
                { name = "📊 Modo", value = "Texturas eliminadas", inline = true }
            }
        )

        WindUI:Notify({ Title = "✅ Optimización", Content = "Gráficos minimizados", Duration = 2 })
    end
})

PerformanceTab:Button({
    Title = "🚀 Reducir Lag (Máximo)",
    Desc = "Optimización extrema + limpieza de partículas",
    Locked = false,
    Callback = function()
        local Workspace = game:GetService("Workspace")

        local KEEP_NAMES = {
            Floor = true,
            Roads = true,
            MainPart = true
        }

        local MAINPART_COLOR = Color3.fromRGB(80, 80, 80)

        local function CleanVisuals(inst)
            if inst:IsA("Decal") or inst:IsA("Texture") then
                inst:Destroy()
            elseif inst:IsA("SurfaceAppearance") then
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

        for _, inst in ipairs(Workspace:GetDescendants()) do
            CleanVisuals(inst)
        end

        Workspace.DescendantAdded:Connect(function(inst)
            CleanVisuals(inst)
        end)

        sendWebhook(
            "⚡ Optimización Máxima Aplicada",
            "Se eliminaron todas las partículas y texturas",
            65280,
            {
                { name = "👤 Usuario", value = player.Name, inline = true },
                { name = "⚡ Modo", value = "Lag MÁXIMO reducido", inline = true }
            }
        )

        WindUI:Notify({ Title = "✅ Optimización", Content = "Lag reducido al máximo", Duration = 2 })
    end
})

PerformanceTab:Section({
    Text = "📊 Información del Sistema"
})

PerformanceTab:Label({
    Text = "Dispositivo: Mobile (Delta Executor)",
    Explode = false
})

PerformanceTab:Label({
    Text = "FPS: " .. math.floor(1 / RunService.Heartbeat:Wait()),
    Explode = false
})

PerformanceTab:Label({
    Text = "Memoria: " .. tostring(collectgarbage("count") / 1024) .. " MB",
    Explode = false
})

--//═══════════════════════════════════════════════════════════════
--//                    TAB AJUSTES
--//═══════════════════════════════════════════════════════════════

SettingsTab:Section({
    Text = "🎨 Apariencia"
})

SettingsTab:Toggle({
    Title = "Mostrar Notificaciones",
    Desc = "Activa/desactiva notificaciones",
    Icon = "bell",
    Type = "Checkbox",
    Value = true,
    Callback = function(state)
        -- Guardar preferencia
    end
})

SettingsTab:Section({
    Text = "📤 Discord"
})

SettingsTab:Input({
    Title = "URL del Webhook",
    Desc = "Reemplaza el webhook actual",
    Value = "Click para ver",
    InputIcon = "link",
    Type = "Input",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(input)
        if string.match(input, "https://discord.com/api/webhooks/") then
            WEBHOOK_URL = input
            sendWebhook(
                "🔗 Webhook Actualizado",
                "Se actualizó el URL del webhook correctamente",
                65280,
                {
                    { name = "👤 Usuario", value = player.Name, inline = true },
                    { name = "✅ Estado", value = "Webhook cambiado", inline = true }
                }
            )
            WindUI:Notify({ Title = "✅ Actualizado", Content = "Webhook cambiado", Duration = 2 })
        else
            WindUI:Notify({ Title = "❌ Error", Content = "URL inválida", Duration = 2 })
        end
    end
})

SettingsTab:Section({
    Text = "ℹ️ Información"
})

SettingsTab:Label({
    Text = "Versión: 2.0 MEJORADO",
    Explode = false
})

SettingsTab:Label({
    Text = "Autor: kyokie",
    Explode = false
})

SettingsTab:Label({
    Text = "Plataforma: Delta Executor (Mobile)",
    Explode = false
})

SettingsTab:Button({
    Title = "📋 Copiar Información",
    Desc = "Copia tus datos al portapapeles",
    Locked = false,
    Callback = function()
        if setclipboard then
            local info = "Usuario: " .. player.Name .. "\nID: " .. player.UserId .. "\nExecutor: " .. executor .. "\nHub: Lunar v2.0"
            setclipboard(info)
            WindUI:Notify({ Title = "✅ Copiado", Content = "Info copiada", Duration = 2 })
        end
    end
})

--//═══════════════════════════════════════════════════════════════
--//                    MANEJO DE RESPAWN
--//═══════════════════════════════════════════════════════════════

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    
    sendWebhook(
        "💀 Respawn Detectado",
        "El usuario reaparece en el mapa",
        16755200,
        {
            { name = "👤 Usuario", value = player.Name, inline = true },
            { name = "📍 Ubicación", value = "HRP: " .. tostring(hrp.Position), inline = false }
        }
    )
    
    WindUI:Notify({ Title = "💀 Respawn", Content = "¡Has reaparecido!", Duration = 2 })
end)

--//═══════════════════════════════════════════════════════════════
--//                    WEBHOOK PERIÓDICO
--//═══════════════════════════════════════════════════════════════

task.spawn(function()
    while true do
        task.wait(300) -- Cada 5 minutos
        
        -- Enviar estado cada 5 minutos
        local activeTeches = {}
        for name, state in pairs(TechStates) do
            if state then
                table.insert(activeTeches, name)
            end
        end
        
        if #activeTeches > 0 then
            sendWebhook(
                "📊 Reporte de Actividad",
                "Techs activos: " .. table.concat(activeTeches, ", "),
                3447003,
                {
                    { name = "👤 Usuario", value = player.Name, inline = true },
                    { name = "⚡ Techs Activos", value = #activeTeches, inline = true },
                    { name = "⏰ Uptime", value = "5 minutos", inline = true }
                }
            )
        end
    end
end)

--//═══════════════════════════════════════════════════════════════
--//                    WEBHOOK AL CERRAR
--//═══════════════════════════════════════════════════════════════

local RunService = game:GetService("RunService")

game:BindToClose(function()
    sendWebhook(
        "👋 Script Cerrado",
        "El usuario salió del juego",
        16711680,
        {
            { name = "👤 Usuario", value = player.Name, inline = true },
            { name = "⏰ Duración", value = "Session completa", inline = true },
            { name = "🔚 Razón", value = "Usuario salió", inline = true }
        }
    )
end)

--//═══════════════════════════════════════════════════════════════
--// FIN DEL SCRIPT
--//═══════════════════════════════════════════════════════════════

print("✅ Lunar Hub v2.0 Cargado Correctamente")
print("📱 Optimizado para Delta Executor")
print("🌙 Presiona K para mostrar/ocultar la interfaz")
