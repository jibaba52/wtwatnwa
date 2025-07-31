-- Inject this using Synapse X / KRNL

local eggPets = {
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
    -- Add more eggs here using the format from the wiki
}

-- Weighted random function
local function weightedRandom(petList)
    local total = 0
    for _, pet in pairs(petList) do total += pet.chance end
    local rnd = math.random() * total
    local sum = 0
    for _, pet in pairs(petList) do
        sum += pet.chance
        if rnd <= sum then
            return pet.name
        end
    end
end

-- Create GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "EggInspectorGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🌱 Egg Inspector"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1, -20, 0, 50)
espBtn.Position = UDim2.new(0, 10, 0.25, 0)
espBtn.Text = "🔍 ESP: Show Egg Contents"
espBtn.TextScaled = true
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espBtn.TextColor3 = Color3.new(1, 1, 1)

local randomBtn = Instance.new("TextButton", frame)
randomBtn.Size = UDim2.new(1, -20, 0, 50)
randomBtn.Position = UDim2.new(0, 10, 0.55, 0)
randomBtn.Text = "🎲 Randomize Egg Contents"
randomBtn.TextScaled = true
randomBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
randomBtn.TextColor3 = Color3.new(1, 1, 1)

-- ESP Function
espBtn.MouseButton1Click:Connect(function()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            local eggName = egg.Name:gsub("_", " ")
            local petList = eggPets[eggName]
            local tag = egg:FindFirstChild("EggESP")
            if tag then tag:Destroy() end

            if petList then
                local display = Instance.new("BillboardGui", egg)
                display.Name = "EggESP"
                display.AlwaysOnTop = true
                display.Size = UDim2.new(0, 200, 0, 50)
                display.StudsOffset = Vector3.new(0, 3, 0)

                local label = Instance.new("TextLabel", display)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                label.TextScaled = true
                label.Text = "Contents: " .. table.concat(
                    (function()
                        local names = {}
                        for _, p in pairs(petList) do table.insert(names, p.name) end
                        return names
                    end)(), ", "
                )
            end
        end
    end
end)

-- Randomize Contents Function
randomBtn.MouseButton1Click:Connect(function()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            local eggName = egg.Name:gsub("_", " ")
            local petList = eggPets[eggName]
            if petList then
                local contents = egg:FindFirstChild("Contents")
                if contents and contents:IsA("StringValue") then
                    contents.Value = weightedRandom(petList)
                    print("Set", eggName, "contents to", contents.Value)
                end
            end
        end
    end
end)
