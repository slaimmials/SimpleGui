local SimpleGuiLib = {}

local sg = Instance.new("ScreenGui")
sg.Name = "SimpleGuiLib"
sg.IgnoreGuiInset = true
sg.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame", sg)
main.Position = UDim2.new(0, 200, 0, 100)
main.Size = UDim2.new(0, 320, 0, 300)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0

local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,0,0,28)
header.BackgroundColor3 = Color3.fromRGB(50,50,50)
header.Text = "SimpleGuiLib"
header.TextColor3 = Color3.new(1,1,1)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Font = Enum.Font.SourceSansBold
header.TextSize = 20
header.ClipsDescendants = true

function SimpleGuiLib:SetTitle(text)
    header.Text = tostring(text or "")
end

do
    local drag, offset
    header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag = true
            offset = Vector2.new(i.Position.X, i.Position.Y) - Vector2.new(main.Position.X.Offset, main.Position.Y.Offset)
        end
    end)
    header.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local p = Vector2.new(i.Position.X, i.Position.Y) - offset
            main.Position = UDim2.new(0, math.clamp(p.X,0,sg.AbsoluteSize.X-main.AbsoluteSize.X), 0, math.clamp(p.Y,0,sg.AbsoluteSize.Y-main.AbsoluteSize.Y))
        end
    end)
end

local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0, 90, 1, -28)
tabs.Position = UDim2.new(0, 0, 0, 28)
tabs.BackgroundTransparency = 1

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -90, 1, -28)
content.Position = UDim2.new(0, 90, 0, 28)
content.BackgroundTransparency = 1

local pages = {}
local curPage
function SimpleGuiLib:Page(name)
    local btn = Instance.new("TextButton", tabs)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Position = UDim2.new(0, 0, 0, #pages*30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    local pg = Instance.new("Frame", content)
    pg.Visible = false
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Name = name
    table.insert(pages, {btn=btn, page=pg})
    btn.MouseButton1Click:Connect(function()
        for _,p in ipairs(pages) do p.page.Visible = false; p.btn.BackgroundColor3 = Color3.fromRGB(40,40,40) end
        pg.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(65,65,65)
        curPage = pg
    end)
    return pg
end

SimpleGuiLib.Draw = {}

function SimpleGuiLib.Draw.Line(x1, y1, x2, y2, color, parent)
    local l = Instance.new("Frame", parent or sg)
    l.BackgroundColor3 = color or Color3.new(1,1,1)
    l.BorderSizePixel = 0
    local dx, dy = x2-x1, y2-y1
    local len = ((dx*dx + dy*dy)^0.5)
    l.Size = UDim2.new(0,len,0,2)
    l.Position = UDim2.new(0,x1,0,y1)
    l.Rotation = math.deg(math.atan2(dy,dx))
    local obj = {
        SetPos = function(_, nx1, ny1, nx2, ny2)
            local ndx, ndy = nx2-nx1, ny2-ny1
            local nlen = ((ndx*ndx + ndy*ndy)^0.5)
            l.Size = UDim2.new(0,nlen,0,2)
            l.Position = UDim2.new(0,nx1,0,ny1)
            l.Rotation = math.deg(math.atan2(ndy,ndx))
            return obj
        end,
        SetColor = function(_, c)
            l.BackgroundColor3 = c
            return obj
        end,
        SetSize = function(_, s)
            l.Size = UDim2.new(l.Size.X.Scale, l.Size.X.Offset, 0, s or 2)
            return obj
        end,
        Remove = function(_)
            l:Destroy()
        end,
        Instance = l
    }
    return obj
end

function SimpleGuiLib.Draw.Box(x, y, w, h, color, parent, filled, outlineColor)
    local box, outline
    if not filled then
        outline = Instance.new("Frame", parent or sg)
        outline.BackgroundTransparency = 1
        outline.Size = UDim2.new(0,w,0,h)
        outline.Position = UDim2.new(0,x,0,y)
        local top = Instance.new("Frame", outline)
        top.Size = UDim2.new(1,0,0,2)
        top.Position = UDim2.new(0,0,0,0)
        top.BackgroundColor3 = outlineColor or color or Color3.new(1,1,1)
        top.BorderSizePixel = 0
        local bottom = Instance.new("Frame", outline)
        bottom.Size = UDim2.new(1,0,0,2)
        bottom.Position = UDim2.new(0,0,1,-2)
        bottom.BackgroundColor3 = outlineColor or color or Color3.new(1,1,1)
        bottom.BorderSizePixel = 0
        local left = Instance.new("Frame", outline)
        left.Size = UDim2.new(0,2,1,0)
        left.Position = UDim2.new(0,0,0,0)
        left.BackgroundColor3 = outlineColor or color or Color3.new(1,1,1)
        left.BorderSizePixel = 0
        local right = Instance.new("Frame", outline)
        right.Size = UDim2.new(0,2,1,0)
        right.Position = UDim2.new(1,-2,0,0)
        right.BackgroundColor3 = outlineColor or color or Color3.new(1,1,1)
        right.BorderSizePixel = 0
        box = outline
        local obj = {
            SetPos = function(_, nx, ny)
                outline.Position = UDim2.new(0,nx,0,ny)
                return obj
            end,
            SetSize = function(_, nw, nh)
                outline.Size = UDim2.new(0,nw,0,nh)
                return obj
            end,
            SetColor = function(_, c)
                for _,v in ipairs(outline:GetChildren()) do
                    if v:IsA("Frame") then
                        v.BackgroundColor3 = c
                    end
                end
                return obj
            end,
            SetFilled = function(_, f, c)
                if f then
                    outline:Destroy()
                    return SimpleGuiLib.Draw.Box(x, y, w, h, c or color, parent, true)
                end
                return obj
            end,
            Remove = function(_) outline:Destroy() end,
            Instance = outline
        }
        return obj
    else
        box = Instance.new("Frame", parent or sg)
        box.BackgroundColor3 = color or Color3.new(1,1,1)
        box.BorderSizePixel = 0
        box.Size = UDim2.new(0,w,0,h)
        box.Position = UDim2.new(0,x,0,y)
        local obj = {
            SetPos = function(_, nx, ny)
                box.Position = UDim2.new(0,nx,0,ny)
                return obj
            end,
            SetSize = function(_, nw, nh)
                box.Size = UDim2.new(0,nw,0,nh)
                return obj
            end,
            SetColor = function(_, c)
                box.BackgroundColor3 = c
                return obj
            end,
            SetFilled = function(_, f, c)
                if not f then
                    box:Destroy()
                    return SimpleGuiLib.Draw.Box(x, y, w, h, c or color, parent, false)
                end
                return obj
            end,
            Remove = function(_) box:Destroy() end,
            Instance = box
        }
        return obj
    end
end

function SimpleGuiLib.Draw.Circle(x, y, r, color, parent, filled)
    local c = Instance.new("Frame", parent or sg)
    c.BackgroundColor3 = color or Color3.new(1,1,1)
    c.Size = UDim2.new(0,2*r,0,2*r)
    c.Position = UDim2.new(0,x-r,0,y-r)
    c.BorderSizePixel = 0
    c.ClipsDescendants = true
    local uic = Instance.new("UICorner", c)
    uic.CornerRadius = UDim.new(1,0)
    c.BackgroundTransparency = filled==false and 1 or 0
    if filled==false then
        local outline = Instance.new("Frame", c)
        outline.Size = UDim2.new(1,0,1,0)
        outline.Position = UDim2.new(0,0,0,0)
        outline.BackgroundTransparency = 0
        outline.BackgroundColor3 = color or Color3.new(1,1,1)
        outline.BorderSizePixel = 0
        local uic2 = Instance.new("UICorner", outline)
        uic2.CornerRadius = UDim.new(1,0)
        outline.Size = UDim2.new(1,0,1,0)
        outline.BackgroundTransparency = 0
        outline.BackgroundColor3 = color or Color3.new(1,1,1)
    end
    local obj = {
        SetPos = function(_, nx, ny)
            c.Position = UDim2.new(0,nx-r,0,ny-r)
            return obj
        end,
        SetSize = function(_, nr)
            c.Size = UDim2.new(0,2*nr,0,2*nr)
            return obj
        end,
        SetColor = function(_, c3)
            c.BackgroundColor3 = c3
            for _,v in ipairs(c:GetChildren()) do
                if v:IsA("Frame") then v.BackgroundColor3 = c3 end
            end
            return obj
        end,
        SetFilled = function(_, f)
            c.BackgroundTransparency = f and 0 or 1
            for _,v in ipairs(c:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = not f
                end
            end
            return obj
        end,
        Remove = function(_) c:Destroy() end,
        Instance = c
    }
    return obj
end

function SimpleGuiLib.Draw.Text(x, y, str, color, size, parent)
    local t = Instance.new("TextLabel", parent or sg)
    t.Position = UDim2.new(0,x,0,y)
    t.Text = str
    t.BackgroundTransparency = 1
    t.TextColor3 = color or Color3.new(1,1,1)
    t.TextSize = size or 16
    t.Font = Enum.Font.SourceSansBold
    t.Size = UDim2.new(0,1000,0,math.max(tonumber(t.TextSize),16))
    local obj = {
        SetPos = function(_, nx, ny)
            t.Position = UDim2.new(0,nx,0,ny)
            return obj
        end,
        SetText = function(_, s)
            t.Text = s
            return obj
        end,
        SetColor = function(_, c3)
            t.TextColor3 = c3
            return obj
        end,
        SetSize = function(_, sz)
            t.TextSize = sz
            t.Size = UDim2.new(0,1000,0,math.max(tonumber(sz),16))
            return obj
        end,
        Remove = function(_) t:Destroy() end,
        Instance = t
    }
    return obj
end

function SimpleGuiLib:Slider(page, text, min, max, def, cb)
    local fr = Instance.new("Frame", page)
    fr.Size = UDim2.new(1,-12,0,30)
    fr.Position = UDim2.new(0,6,0,6+(#page:GetChildren()-1)*35)
    fr.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local lbl = Instance.new("TextLabel", fr)
    lbl.Text = text..": "..def
    lbl.Size = UDim2.new(1,0,0.5,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    local slider = Instance.new("Frame", fr)
    slider.BackgroundColor3 = Color3.new(.5,.5,.5)
    slider.Position = UDim2.new(0,10,0.6,0)
    slider.Size = UDim2.new(0,180,0,6)
    local thumb = Instance.new("Frame", slider)
    thumb.Size = UDim2.new(0,10,1,0)
    thumb.BackgroundColor3 = Color3.new(.8,.8,.8)
    local function setValue(val)
        val = math.clamp(val, min, max)
        local percent = (val-min)/(max-min)
        thumb.Position = UDim2.new(percent, -5, 0, 0)
        lbl.Text = text..": "..math.floor(val*10+0.5)/10
        if cb then cb(val) end
    end
    slider.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            local con; con = game:GetService("RunService").RenderStepped:Connect(function()
                local mx = game:GetService("UserInputService"):GetMouseLocation().X
                local sx = slider.AbsolutePosition.X
                local w = slider.AbsoluteSize.X
                local percent = math.clamp((mx-sx)/w, 0, 1)
                setValue(min + (max-min)*percent)
                if not game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    con:Disconnect()
                end
            end)
        end
    end)
    setValue(def)
    return fr
end

function SimpleGuiLib:Checkbox(page, text, def, cb)
    local fr = Instance.new("Frame", page)
    fr.Size = UDim2.new(1,-12,0,30)
    fr.Position = UDim2.new(0,6,0,6+(#page:GetChildren()-1)*35)
    fr.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local box = Instance.new("TextButton", fr)
    box.Size = UDim2.new(0,24,0,24)
    box.Position = UDim2.new(0,3,0,3)
    box.Text = def and "✔" or ""
    box.BackgroundColor3 = Color3.new(.3,.3,.3)
    box.TextColor3 = Color3.new(1,1,1)
    local lbl = Instance.new("TextLabel", fr)
    lbl.Text = text
    lbl.Position = UDim2.new(0,30,0,0)
    lbl.Size = UDim2.new(1,-30,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    local state = def
    box.MouseButton1Click:Connect(function()
        state = not state
        box.Text = state and "✔" or ""
        if cb then cb(state) end
    end)
    return fr
end

return SimpleGuiLib
