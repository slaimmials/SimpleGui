--[[
MiniConsole - простейшая консоль для вывода текста в GUI Roblox

Console:Print(text, color?) -- выводит строку (по умолчанию белым)
Console:Warn(text)          -- выводит строку желтым цветом
Console:Error(text)         -- выводит строку красным цветом
Console:Remove()            -- удалить консоль из окна (или по нажатию на крестик)
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
    scroll.CanvasPosition = Vector2.new(0, math.huge)
end

function Console:Warn(text)
    self:Print(text, Color3.fromRGB(255, 230, 60))
end

function Console:Error(text)
    self:Print(text, Color3.fromRGB(255, 70, 60))
end

function Console:Remove()
    sg:Destroy()
end

closeBtn.MouseButton1Click:Connect(function()
    Console:Remove()
end)

return Console
