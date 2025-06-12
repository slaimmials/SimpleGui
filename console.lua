--[[
MiniConsole - простейшая консоль для вывода текста в GUI Roblox

Console:Print(text, color?) -- выводит строку (по умолчанию белым)
Console:Warn(text)          -- выводит строку желтым цветом
Console:Error(text)         -- выводит строку красным цветом
Console:Clear()             -- очищает консоль
Console:Remove()            -- удалить консоль из окна (или по нажатию на крестик)

Автопрокрутка (примагничивание): если скроллбар внизу -- всегда после Print/Warn/Error прокручивает в самый низ.
Если пользователь вручную отскроллил вверх -- автомат не работает пока не вернется вниз.
--]]

local Console = {}

local sg = Instance.new("ScreenGui")
sg.Name = "MiniConsole"
sg.IgnoreGuiInset = true
sg.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", sg)
frame.Position = UDim2.new(0, 40, 1, -230)
frame.Size = UDim2.new(0, 480, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,22)
title.BackgroundTransparency = 1
title.Text = "Console"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 24, 0, 22)
closeBtn.Position = UDim2.new(1, -24, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.AutoButtonColor = true

local clearBtn = Instance.new("TextButton", frame)
clearBtn.Size = UDim2.new(0, 24, 0, 22)
clearBtn.Position = UDim2.new(1, -48, 0, 0)
clearBtn.BackgroundTransparency = 1
clearBtn.Text = "🗑"
clearBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.TextSize = 16
clearBtn.AutoButtonColor = true
clearBtn.ToolTip = "Clear"

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0,0,0,22)
scroll.Size = UDim2.new(1,0,1,-22)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

local stickToBottom = true
local function isAtBottom()
    return math.abs((scroll.CanvasPosition.Y + scroll.AbsoluteWindowSize.Y) - scroll.AbsoluteCanvasSize.Y) < 8
end

scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    stickToBottom = isAtBottom()
end)

local function scrollToBottom()
    scroll.CanvasPosition = Vector2.new(0, math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y))
end

function Console:Print(text, color)
    local t = Instance.new("TextLabel")
    t.Text = tostring(text)
    t.TextColor3 = color or Color3.new(1,1,1)
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.Code
    t.TextSize = 16
    t.Size = UDim2.new(1, -6, 0, 18)
    t.Parent = scroll
    if stickToBottom then
        -- Используем задержку чтобы корректно проскроллило после layout-а
        task.defer(scrollToBottom)
    end
end

function Console:Warn(text)
    self:Print(text, Color3.fromRGB(255, 230, 60))
end

function Console:Error(text)
    self:Print(text, Color3.fromRGB(255, 70, 60))
end

function Console:Clear()
    for _,v in ipairs(scroll:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
    task.defer(scrollToBottom)
end

function Console:Remove()
    sg:Destroy()
end

closeBtn.MouseButton1Click:Connect(function()
    Console:Remove()
end)

clearBtn.MouseButton1Click:Connect(function()
    Console:Clear()
end)

return Console
