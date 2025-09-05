    btn.ZIndex = btn.ZIndex+2
    btn.LayoutOrder = y
    btn.AutoButtonColor = false
    local state = false
    local function updateVisual()
        circle.ImageColor3 = (state and Color3.fromRGB(50,255,60)) or Color3.fromRGB(255,40,40)
        btn.BackgroundColor3 = state and Color3.fromRGB(38,38,38) or Color3.fromRGB(28,28,28)
    end
    btn.MouseButton1Click:Connect(function()
        state = not state
        callback(state, btn)
        updateVisual()
    end)
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            callback(state, btn)
            updateVisual()
        end
    end)
    updateVisual()
    return btn, function(v)
        state = v
        callback(state, btn)
        updateVisual()
    end
end

local btnFPSDevourer, setFPSDevourerState = makeToggleBtn(main, "AkunBitch Devourer", BTN_Y0, function(on)
    if on then FPSDevourer:Start() else FPSDevourer:Stop() end
end)

-- Reseta botÃ£o OFF ao trocar de personagem e tira acessÃ³rios
player.CharacterAdded:Connect(function()
    setFPSDevourerState(false)
    task.wait(0.2)
    removeAllAccessoriesFromCharacter()
end)
