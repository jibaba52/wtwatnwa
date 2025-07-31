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

-- Fly Hack (Improved)
local flying = false
local BV, BG
local flySpeed = 50
local flyKeys = {W = false, A = false, S = false, D = false}

createToggle("Fly Hack", 50, function()
	flying = not flying
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart")

	if flying then
		BV = Instance.new("BodyVelocity")
		BV.Velocity = Vector3.zero
		BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		BV.Parent = root

		BG = Instance.new("BodyGyro")
		BG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		BG.P = 1e4
		BG.CFrame = root.CFrame
		BG.Parent = root
	else
		if BV then BV:Destroy() end
		if BG then BG:Destroy() end
	end

	return flying
end)

-- Fly Controls
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.W then flyKeys.W = true end
	if key == Enum.KeyCode.A then flyKeys.A = true end
	if key == Enum.KeyCode.S then flyKeys.S = true end
	if key == Enum.KeyCode.D then flyKeys.D = true end
end)

UIS.InputEnded:Connect(function(input)
	local key = input.KeyCode
	if key == Enum.KeyCode.W then flyKeys.W = false end
	if key == Enum.KeyCode.A then flyKeys.A = false end
	if key == Enum.KeyCode.S then flyKeys.S = false end
	if key == Enum.KeyCode.D then flyKeys.D = false end
end)

-- Update Fly Movement
RunService.RenderStepped:Connect(function()
	if flying and BV and BG then
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.zero

		if flyKeys.W then moveDir = moveDir + cam.CFrame.LookVector end
		if flyKeys.S then moveDir = moveDir - cam.CFrame.LookVector end
		if flyKeys.A then moveDir = moveDir - cam.CFrame.RightVector end
		if flyKeys.D then moveDir = moveDir + cam.CFrame.RightVector end

		BV.Velocity = moveDir.Unit * flySpeed
		if moveDir.Magnitude == 0 then
			BV.Velocity = Vector3.zero
		end
		BG.CFrame = cam.CFrame
	end
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
