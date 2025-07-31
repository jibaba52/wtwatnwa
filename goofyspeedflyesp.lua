-- LocalScript

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "GoofyGui"

-- Notification Text
local textLabel = Instance.new("TextLabel", screenGui)
textLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
textLabel.Position = UDim2.new(0.3, 0, 0.4, 0)
textLabel.Text = "GOOFY SCRIPTS"
textLabel.TextScaled = true
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Visible = true

wait(2)
textLabel.Visible = false

-- Main GUI Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Drag manually (in case Draggable doesn't work)
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Utility for toggles
local function createToggle(name, pos, callback)
	local button = Instance.new("TextButton", frame)
	button.Size = UDim2.new(1, -20, 0, 30)
	button.Position = UDim2.new(0, 10, 0, pos)
	button.Text = name .. ": OFF"
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.AutoButtonColor = false
	button.MouseButton1Click:Connect(function()
		local state = callback()
		button.Text = name .. ": " .. (state and "ON" or "OFF")
	end)
end

-- Speed Hack
local speedEnabled = false
local speedValue = 100

createToggle("Speed Hack", 10, function()
	speedEnabled = not speedEnabled
	return speedEnabled
end)

-- Fly Hack
local flying = false
local velocity

createToggle("Fly Hack", 50, function()
	flying = not flying
	if flying then
		local character = player.Character or player.CharacterAdded:Wait()
		local root = character:WaitForChild("HumanoidRootPart")

		velocity = Instance.new("BodyVelocity")
		velocity.Velocity = Vector3.new(0,0,0)
		velocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		velocity.Parent = root
	else
		if velocity then velocity:Destroy() end
	end
	return flying
end)

-- ESP Hack
local espEnabled = false

createToggle("Player ESP", 90, function()
	espEnabled = not espEnabled
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
			if espEnabled then
				local billboard = Instance.new("BillboardGui", v.Character.Head)
				billboard.Name = "ESP"
				billboard.Size = UDim2.new(0, 100, 0, 40)
				billboard.AlwaysOnTop = true

				local label = Instance.new("TextLabel", billboard)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.Text = v.Name
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.new(1, 0, 0)
			else
				local esp = v.Character.Head:FindFirstChild("ESP")
				if esp then esp:Destroy() end
			end
		end
	end
	return espEnabled
end)

-- Speed Hack Updater
RunService.RenderStepped:Connect(function()
	if speedEnabled then
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = speedValue
		end
	else
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = 16
		end
	end
end)

-- Optional: Speed Adjustment Slider
local sliderLabel = Instance.new("TextLabel", frame)
sliderLabel.Text = "Speed: " .. speedValue
sliderLabel.Size = UDim2.new(1, -20, 0, 20)
sliderLabel.Position = UDim2.new(0, 10, 0, 130)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.new(1,1,1)

local minus = Instance.new("TextButton", frame)
minus.Text = "-"
minus.Size = UDim2.new(0, 30, 0, 30)
minus.Position = UDim2.new(0, 10, 0, 160)
minus.MouseButton1Click:Connect(function()
	speedValue = math.max(0, speedValue - 5)
	sliderLabel.Text = "Speed: " .. speedValue
end)

local plus = Instance.new("TextButton", frame)
plus.Text = "+"
plus.Size = UDim2.new(0, 30, 0, 30)
plus.Position = UDim2.new(0, 50, 0, 160)
plus.MouseButton1Click:Connect(function()
	speedValue = speedValue + 5
	sliderLabel.Text = "Speed: " .. speedValue
end)
