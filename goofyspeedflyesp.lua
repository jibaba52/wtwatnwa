-- 📜 Grow a Garden: Egg ESP + Randomizer GUI Script (Supports All Known Eggs & Pets)
-- ⚠️ This script is intended for testing/educational use. Do not use to violate game TOS.

-- CONFIG: List of pets for each egg with drop chances
local eggPets = {
    ["Common Egg"] = {
        {name = "Dog", chance = 33.3},
        {name = "Bunny", chance = 33.3},
        {name = "Golden Lab", chance = 33.3},
    },
    ["Uncommon Egg"] = {
        {name = "Cat", chance = 25},
        {name = "Chicken", chance = 25},
        {name = "Black Bunny", chance = 25},
        {name = "Deer", chance = 25},
    },
    ["Rare Egg"] = {
        {name = "Orange Tabby", chance = 33},
        {name = "Spotted Deer", chance = 25},
        {name = "Pig", chance = 16},
        {name = "Rooster", chance = 16},
        {name = "Monkey", chance = 10},
    },
    ["Legendary Egg"] = {
        {name = "Cow", chance = 42.5},
        {name = "Silver Monkey", chance = 42.5},
        {name = "Sea Otter", chance = 10.6},
        {name = "Turtle", chance = 2.1},
        {name = "Polar Bear", chance = 2.1},
    },
    ["Mythical Egg"] = {
        {name = "Grey Mouse", chance = 35.7},
        {name = "Brown Mouse", chance = 26.7},
        {name = "Squirrel", chance = 26.8},
        {name = "Red Giant Ant", chance = 8.9},
        {name = "Red Fox", chance = 1.8},
    },
    ["Common Summer Egg"] = {
        {name = "Starfish", chance = 50},
        {name = "Seagull", chance = 25},
        {name = "Crab", chance = 25},
    },
    ["Rare Summer Egg"] = {
        {name = "Flamingo", chance = 30},
        {name = "Toucan", chance = 25},
        {name = "Sea Turtle", chance = 20},
        {name = "Orangutan", chance = 15},
        {name = "Seal", chance = 10},
    },
    ["Bee Egg"] = {
        {name = "Bee", chance = 65},
        {name = "Honey Bee", chance = 25},
        {name = "Bear Bee", chance = 5},
        {name = "Petal Bee", chance = 4},
        {name = "Queen Bee", chance = 1},
    },
    ["Anti Bee Egg"] = {
        {name = "Wasp", chance = 55},
        {name = "Tarantula Hawk", chance = 30},
        {name = "Moth", chance = 13.75},
        {name = "Butterfly", chance = 1},
        {name = "Disco Bee", chance = 0.25},
    },
    ["Paradise Egg"] = {
        {name = "Ostrich", chance = 40},
        {name = "Peacock", chance = 30},
        {name = "Capybara", chance = 21},
        {name = "Scarlet Macaw", chance = 8},
        {name = "Mimic Octopus", chance = 1},
    },
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "EggToolGUI"

local function createButton(name, pos, callback)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Text = name
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
end

-- ESP Function
local function addESPToEgg(egg)
    local head = egg:FindFirstChildWhichIsA("BasePart")
    if not head or egg:FindFirstChild("_esp") then return end

    local gui = Instance.new("BillboardGui", egg)
    gui.Name = "_esp"
    gui.Adornee = head
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Text = "Pet: " .. (egg:FindFirstChild("Contents") and egg.Contents.Value or "Unknown")
end

-- Randomize Function
local function randomizeEgg(egg)
    local eggType = egg.Name
    local petList = eggPets[eggType]
    if petList and egg:FindFirstChild("Contents") then
        local rand = math.random() * 100
        local total = 0
        for _, entry in ipairs(petList) do
            total = total + entry.chance
            if rand <= total then
                egg.Contents.Value = entry.name
                break
            end
        end
        local esp = egg:FindFirstChild("_esp")
        if esp then
            esp.TextLabel.Text = "Pet: " .. egg.Contents.Value
        end
    end
end

-- Main Buttons
createButton("🔍 ESP All Eggs", UDim2.new(0, 20, 0, 100), function()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            addESPToEgg(egg)
        end
    end
end)

createButton("🎲 Randomize Eggs", UDim2.new(0, 20, 0, 150), function()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            randomizeEgg(egg)
        end
    end
end)

print("✅ Egg ESP + Randomizer loaded.")
