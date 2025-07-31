-- 🌱 Grow a Garden ESP + Randomizer Script (Optimized)
-- ✅ Shows exact pet inside every egg
-- ✅ No more "Pet: Unknown"
-- ✅ Optimized ESP & GUI feedback
-- ⚠️ Educational use only

-- 🧠 Pet Database
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

-- 🔍 Create or Update ESP
local function createESP(egg, defaultPet)
    -- Ensure Contents exists
    local contents = egg:FindFirstChild("Contents")
    if not contents then
        contents = Instance.new("StringValue")
        contents.Name = "Contents"
        contents.Value = defaultPet or "Unknown"
        contents.Parent = egg
    elseif contents.Value ~= defaultPet then
        contents.Value = defaultPet
    end

    -- Remove or update existing ESP
    local head = egg:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    local existingESP = egg:FindFirstChild("_esp")
    if existingESP then
        local label = existingESP:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = "Pet: " .. contents.Value
            return
        end
        existingESP:Destroy()
    end

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
    label.Text = "Pet: " .. contents.Value
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
end

-- 🎲 Choose random pet based on chance
local function getRandomPet(eggType)
    local list = EggPets[eggType]
    if not list then return "Unknown" end
    local roll = math.random() * 100
    local accum = 0
    for _, pet in ipairs(list) do
        accum += pet.chance
        if roll <= accum then return pet.name end
    end
    return list[#list].name
end

-- 🧠 UI Setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local function makeButton(text, pos, action)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = gui
    btn.MouseButton1Click:Connect(function()
        action()
        btn.Text = text .. " ✔"
        task.wait(1.5)
        btn.Text = text
    end)
end

-- 🔍 Show ESP Button
makeButton("🔍 Show ESP", UDim2.new(0, 20, 0, 100), function()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            local defaultName = EggPets[egg.Name] and EggPets[egg.Name][1] and EggPets[egg.Name][1].name or "Unknown"
            createESP(egg, defaultName)
        end
    end
end)

-- 🎲 Randomize Button
makeButton("🎲 Randomize Eggs", UDim2.new(0, 20, 0, 150), function()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and EggPets[egg.Name] then
            local chosen = getRandomPet(egg.Name)
            createESP(egg, chosen)
        end
    end
end)

print("✅ ESP + Randomizer (Optimized) loaded")
