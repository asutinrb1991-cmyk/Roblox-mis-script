-- Script Local: speed teclado
-- Fondo negro, letras blancas, botón "Speed" y control de velocidad con teclado

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedGUI"
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Fondo principal (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- Negro
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Speed Teclado"
title.TextColor3 = Color3.new(1, 1, 1) -- Blanco
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Botón "Speed"
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 100, 0, 40)
speedButton.Position = UDim2.new(0.5, -50, 0, 60)
speedButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Text = "Speed"
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextScaled = true
speedButton.BorderSizePixel = 0
speedButton.Parent = mainFrame

-- Etiqueta de velocidad actual
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 115)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: 1"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = mainFrame

-- Variables de velocidad
local currentSpeed = 1
local maxSpeed = 1000
local minSpeed = 1

-- Función para actualizar la velocidad del personaje
local function updateSpeed()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        -- Ajuste de velocidad: 16 es la velocidad base en Roblox
        humanoid.WalkSpeed = 16 + (currentSpeed - 1) * 0.5 -- Escala: 1->16, 1000->515.5
        -- También podemos afectar el JumpPower para dar más sensación
        humanoid.JumpPower = 50 + (currentSpeed - 1) * 0.2
    end
    speedLabel.Text = "Velocidad: " .. currentSpeed
end

-- Conexión para cuando el personaje aparezca
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.5)
    updateSpeed()
end)

-- Botón para resetear a velocidad 1
speedButton.MouseButton1Click:Connect(function()
    currentSpeed = 1
    updateSpeed()
    speedLabel.Text = "Velocidad: 1"
end)

-- Control con teclado (Flecha arriba/abajo y teclas + / -)
local function onKeyPress(input, gameProcessed)
    if gameProcessed then return end -- Evita conflicto con chat

    if input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.Equals then
        -- Aumentar velocidad
        currentSpeed = math.min(currentSpeed + 1, maxSpeed)
        updateSpeed()
    elseif input.KeyCode == Enum.KeyCode.Down or input.KeyCode == Enum.KeyCode.Minus then
        -- Disminuir velocidad
        currentSpeed = math.max(currentSpeed - 1, minSpeed)
        updateSpeed()
    end
end

-- Conectar el evento de teclado
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

-- Actualizar al inicio si el personaje ya existe
if game.Players.LocalPlayer.Character then
    wait(0.5)
    updateSpeed()
end

-- Instrucciones (opcional)
local instructions = Instance.new("TextLabel")
instructions.Size = UDim2.new(1, 0, 0, 25)
instructions.Position = UDim2.new(0, 0, 0, 155)
instructions.BackgroundTransparency = 1
instructions.Text = "↑/↓ o +/- para cambiar"
instructions.TextColor3 = Color3.new(0.7, 0.7, 0.7)
instructions.TextScaled = true
instructions.Font = Enum.Font.SourceSans
instructions.Parent = mainFrame