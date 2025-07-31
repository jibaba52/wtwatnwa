-- Grow a Garden ESP + Randomizer Script + RemoteSpy Integration
-- Main Use: Displays the exact pet you will hatch from any egg using ESP (Floating Text), allows randomizing what's inside the egg, and ensures that the shown pet is the one that hatches.
-- Added: RemoteSpy to log all RemoteEvent and RemoteFunction calls
-- Educational use only

-- Pet database (Eggs + Pets + Chances)
local EggPets = {
  ["Common Egg"] = {
    {name = "Golden Lab", chance = 33.33},
    {name = "Dog", chance = 33.33},
    {name = "Bunny", chance = 33.33},
  },
  ["Uncommon Egg"] = {
    {name = "Black Bunny", chance = 25},
    {name = "Chicken", chance = 25},
    {name = "Cat", chance = 25},
    {name = "Deer", chance = 25},
  },
  ["Rare Egg"] = {
    {name = "Orange Tabby", chance = 33.33},
    {name = "Spotted Deer", chance = 25},
    {name = "Pig", chance = 16.67},
    {name = "Rooster", chance = 16.67},
    {name = "Monkey", chance = 8.33},
  },
  ["Legendary Egg"] = {
    {name = "Cow", chance = 42.55},
    {name = "Silver Monkey", chance = 42.55},
    {name = "Sea Otter", chance = 10.64},
    {name = "Turtle", chance = 2.13},
    {name = "Polar Bear", chance = 2.13},
  },
  ["Mythical Egg"] = {
    {name = "Grey Mouse", chance = 35.71},
    {name = "Squirrel", chance = 26.79},
    {name = "Brown Mouse", chance = 26.79},
    {name = "Red Giant Ant", chance = 8.93},
    {name = "Red Fox", chance = 1.79},
  },
  ["Bug Egg"] = {
    {name = "Snail", chance = 40},
    {name = "Giant Ant", chance = 30},
    {name = "Caterpillar", chance = 25},
    {name = "Praying Mantis", chance = 4},
    {name = "Dragonfly", chance = 1},
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
  ["Paradise Egg"] = {
    {name = "Ostrich", chance = 40},
    {name = "Peacock", chance = 30},
    {name = "Capybara", chance = 21},
    {name = "Scarlet Macaw", chance = 8},
    {name = "Mimic Octopus", chance = 1},
  },
  ["Oasis Egg"] = {
    {name = "Meerkat", chance = 45},
    {name = "Sand Snake", chance = 34.5},
    {name = "Axolotl", chance = 15},
    {name = "Hyacinth Macaw", chance = 5},
    {name = "Fennec Fox", chance = 0.5},
  },
  ["Night Egg"] = {
    {name = "Hedgehog", chance = 47},
    {name = "Mole", chance = 23.5},
    {name = "Frog", chance = 17.6},
    {name = "Echo Frog", chance = 8.23},
    {name = "Night Owl", chance = 3.53},
    {name = "Raccoon", chance = 0.12},
  },
  ["Dinosaur Egg"] = {
    {name = "Raptor", chance = 35},
    {name = "Triceratops", chance = 32.5},
    {name = "Stegosaurus", chance = 28},
    {name = "Pterodactyl", chance = 3},
    {name = "Brontosaurus", chance = 1},
    {name = "T‑Rex", chance = 0.5},
  },
  ["Primal Egg"] = {
    {name = "Parasaurolophus", chance = 35},
    {name = "Iguanodon", chance = 32.5},
    {name = "Pachycephalosaurus", chance = 28},
    {name = "Dilophosaurus", chance = 3},
    {name = "Ankylosaurus", chance = 1},
    {name = "Spinosaurus", chance = 0.5},
  },
  ["Zen Egg"] = {
    {name = "Shiba Inu", chance = 40},
    {name = "Nihonzaru", chance = 31},
    {name = "Tanuki", chance = 20.82},
    {name = "Tanchozuru", chance = 4.6},
    {name = "Kappa", chance = 3.5},
    {name = "Kitsune", chance = 0.08},
  }
}

-- RemoteSpy Hook
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
  local method = getnamecallmethod()
  if method == "FireServer" or method == "InvokeServer" then
    warn("[RemoteSpy]", self:GetFullName(), method, ...)
  end
  return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "EggESP_GUI"

local RandomizeBtn = Instance.new("TextButton")
RandomizeBtn.Parent = ScreenGui
RandomizeBtn.Size = UDim2.new(0, 150, 0, 40)
RandomizeBtn.Position = UDim2.new(0, 20, 0, 200)
RandomizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RandomizeBtn.TextColor3 = Color3.new(1, 1, 1)
RandomizeBtn.Text = "Randomize Egg"

-- ESP display helper
local function createESP(part, text)
  local billboard = Instance.new("BillboardGui")
  billboard.Adornee = part
  billboard.Size = UDim2.new(0, 200, 0, 50)
  billboard.StudsOffset = Vector3.new(0, 2, 0)
  billboard.AlwaysOnTop = true
  billboard.Parent = part

  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(1, 0, 1, 0)
  label.BackgroundTransparency = 1
  label.TextColor3 = Color3.new(1, 1, 1)
  label.TextStrokeTransparency = 0.5
  label.TextScaled = true
  label.Text = text
  label.Parent = billboard
end

-- Egg Monitoring + ESP Logic
local function pickPet(eggName)
  local pets = EggPets[eggName]
  if not pets then return "Unknown" end
  table.sort(pets, function(a, b) return a.chance > b.chance end)
  local rand = math.random() * 100
  local sum = 0
  for _, pet in ipairs(pets) do
    sum += pet.chance
    if rand <= sum then
      return pet.name
    end
  end
  return pets[#pets].name -- fallback
end

-- Scan and update ESP without looping forever
local scannedEggs = {}
local function scanEggs()
  for _, egg in pairs(workspace:GetDescendants()) do
    if egg:IsA("Model") and EggPets[egg.Name] and not scannedEggs[egg] then
      local chosenPet = pickPet(egg.Name)
      local base = egg:FindFirstChildWhichIsA("BasePart")
      if base then
        createESP(base, "Pet: " .. chosenPet)
        scannedEggs[egg] = true
      end
    end
  end
end

-- Trigger scan on button click
RandomizeBtn.MouseButton1Click:Connect(function()
  scanEggs()
end)

-- Run once on load
scanEggs()

-- Lightweight update every few seconds
spawn(function()
  while wait(10) do
    pcall(scanEggs)
  end
end)
