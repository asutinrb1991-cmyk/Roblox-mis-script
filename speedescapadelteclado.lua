-- Script Local: speed teclado (con arrastre, cierre y botón flotante)
-- Colocar en un LocalScript dentro de StarterPlayerScripts o StarterGui

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== CREAR EL PANEL PRINCIPAL =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "SpeedPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Barra superior (arrastrable)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Título (dentro de la barra)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Speed Teclado"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = topBar

-- Botón Cerrar (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 1, -4)
closeButton.Position = UDim2.new(1, -35, 0, 2)
closeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.BorderSizePixel = 0
closeButton.Parent = topBar

-- Contenido del panel
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Botón "Speed" (reset a 1)
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 100, 0, 40)
speedButton.Position = UDim2.new(0.5, -50, 0, 20)
speedButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Text = "Speed"
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextScaled = true
speedButton.BorderSizePixel = 0
speedButton.Parent = content

-- Etiqueta de velocidad actual
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 75)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: 1"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = content

-- Instrucciones
local instructions = Instance.new("TextLabel")
instructions.Size = UDim2.new(1, 0, 0, 25)
instructions.Position = UDim2.new(0, 0, 0, 115)
instructions.BackgroundTransparency = 1
instructions.Text = "↑/↓ o +/- para cambiar"
instructions.TextColor3 = Color3.new(0.7, 0.7, 0.7)
instructions.TextScaled = true
instructions.Font = Enum.Font.SourceSans
instructions.Parent = content

-- ===== BOTÓN FLOTANTE PARA ABRIR (visible solo cuando el panel está cerrado) =====
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 80, 0, 40)
openButton.Position = UDim2.new(0.5, -40, 0.9, 0) -- Abajo centrado
openButton.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Text = "Speed"
openButton.Font = Enum.Font.SourceSansBold
openButton.TextScaled = true
openButton.BorderSizePixel = 0
openButton.Visible = false -- Inicialmente oculto
openButton.Parent = gui

-- ===== VARIABLES DE VELOCIDAD =====
local currentSpeed = 1
local maxSpeed = 1000
local minSpeed = 1

-- Función para actualizar velocidad del personaje
local function updateSpeed()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid.WalkSpeed = 16 + (currentSpeed - 1) * 0.5
        humanoid.JumpPower = 50 + (currentSpeed - 1) * 0.2
    end
    speedLabel.Text = "Velocidad: " .. currentSpeed
end

-- Actualizar cuando el personaje aparezca
player.CharacterAdded:Connect(function()
    wait(0.5)
    updateSpeed()
end)

-- Si ya existe personaje, actualizar
if player.Character then
    wait(0.5)
    updateSpeed()
end

-- ===== FUNCIONES DE ABRIR/CERRAR =====
local function openPanel()
    mainFrame.Visible = true
    openButton.Visible = false
end

local function closePanel()
    mainFrame.Visible = false
    openButton.Visible = true
end

-- Eventos de los botones
closeButton.MouseButton1Click:Connect(closePanel)
openButton.MouseButton1Click:Connect(openPanel)

-- Botón Speed (reset)
speedButton.MouseButton1Click:Connect(function()
    currentSpeed = 1
    updateSpeed()
end)

-- ===== CONTROL POR TECLADO =====
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    local key = input.KeyCode
    if key == Enum.KeyCode.Up or key == Enum.KeyCode.Equals then
        currentSpeed = math.min(currentSpeed + 1, maxSpeed)
        updateSpeed()
    elseif key == Enum.KeyCode.Down or key == Enum.KeyCode.Minus then
        currentSpeed = math.max(currentSpeed - 1, minSpeed)
        updateSpeed()
    end
end)

-- ===== ARRASTRE DEL PANEL (con la barra superior) =====
local dragging = false
local dragStart, frameStart

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)