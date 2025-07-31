-- Works with Synapse X, KRNL, etc.

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
    -- Add other eggs and pets here
}

local function weightedRandom(petList)
    local total = 0
    for _, pet in ipairs(petList) do
        total += pet.chance
    end
    local rand = math.random() * total
    local sum = 0
    for _, pet in ipairs(petList) do
        sum += pet.chance
        if rand <= sum then
            return pet.name
        end
    end
end

-- GUI Setup
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "EggESPTool"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.25, 0)
title.Text = "🥚 Egg ESP + Randomizer"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0.3, 0)
espBtn.Text = "🔍 Show Pet I'll Hatch"
espBtn.TextScaled = true
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espBtn.TextColor3 = Color3.new(1, 1, 1)

local randomBtn = Instance.new("TextButton", frame)
randomBtn.Size = UDim2.new(1, -20, 0, 40)
randomBtn.Position = UDim2.new(0, 10, 0.7, 0)
randomBtn.Text = "🎲 Randomize Egg Pet"
randomBtn.TextScaled = true
randomBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
randomBtn.TextColor3 = Color3.new(1, 1, 1)

-- ESP Logic (show exact pet from Contents.Value)
local function showEggESP()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            local contents = egg:FindFirstChild("Contents")
            if contents and contents:IsA("StringValue") then
                -- Remove old ESP if exists
                local oldESP = egg:FindFirstChild("EggESP")
                if oldESP then oldESP:Destroy() end

                -- Create new ESP
                local esp = Instance.new("BillboardGui", egg)
                esp.Name = "EggESP"
                esp.Size = UDim2.new(0, 200, 0, 50)
                esp.StudsOffset = Vector3.new(0, 3, 0)
                esp.AlwaysOnTop = true

                local label = Instance.new("TextLabel", esp)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                label.TextScaled = true
                label.Text = "🎁 Pet: " .. contents.Value
            end
        end
    end
end

-- Randomize Egg Contents
local function randomizeEggs()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name:lower():find("egg") then
            local contents = egg:FindFirstChild("Contents")
            if contents and contents:IsA("StringValue") then
                local eggName = egg.Name
                local petList = eggPets[eggName]
                if petList then
                    local chosenPet = weightedRandom(petList)
                    contents.Value = chosenPet
                end
            end
        end
    end
    showEggESP() -- Update ESP after randomizing
end

-- Button Events
espBtn.MouseButton1Click:Connect(showEggESP)
randomBtn.MouseButton1Click:Connect(randomizeEggs)
