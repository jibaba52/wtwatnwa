-- 🌱 Grow a Garden ESP + Randomizer Script (Ultimate Edition)
-- ✅ Shows exact pet inside each egg, supports all eggs, live updates ESP on randomization
-- ⚠️ Intended for testing & educational purposes only

-- ⚙️ PET DATABASE (expandable)
local EggPets = {
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
}

-- 🎨 ESP SYSTEM
local function createESP(egg, petName)
    if egg:FindFirstChild("_esp") then egg._esp:Destroy() end
    local head = egg:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "_esp"
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = egg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Pet: " .. (petName or "Unknown")
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
end

-- 🎲 RANDOMIZER SYSTEM
local function getRandomPet(eggType)
    local list = EggPets[eggType]
    if not list then return "Unknown" end
    local roll = math.random() * 100
    local accum = 0
    for _, entry in ipairs(list) do
        accum += entry.chance
        if roll <= accum then return entry.name end
    end
    return list[#list].name -- fallback
end

-- 🧠 MAIN INTERFACE
local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "PetESP_GUI"

local function createButton(text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0, 160, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = ScreenGui
    btn.MouseButton1Click:Connect(callback)
end

-- 🔍 ESP BUTTON
createButton("🔍 Show ESP", UDim2.new(0, 20, 0, 100), function()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            local contents = egg:FindFirstChild("Contents")
            local name = contents and contents:IsA("StringValue") and contents.Value or "Unknown"
            createESP(egg, name)
        end
    end
end)

-- 🎲 RANDOMIZE BUTTON
createButton("🎲 Randomize Eggs", UDim2.new(0, 20, 0, 150), function()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and EggPets[egg.Name] then
            local chosen = getRandomPet(egg.Name)
            if egg:FindFirstChild("Contents") then
                egg.Contents.Value = chosen
            else
                local contents = Instance.new("StringValue")
                contents.Name = "Contents"
                contents.Value = chosen
                contents.Parent = egg
            end
            createESP(egg, chosen)
        end
    end
end)

print("✅ Ultimate Egg ESP + Randomizer Loaded")
