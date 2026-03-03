-- ╔══════════════════════════════════════════════════════════════╗
-- ║              axiom.win UI Library v1.0                       ║
-- ║         Roblox Executor UI Library                           ║
-- ╚══════════════════════════════════════════════════════════════╝

local axiom = {}
axiom.__index = axiom

-- ─── Services ───────────────────────────────────────────────────
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse and LocalPlayer:GetMouse() or nil

-- ─── Theme ──────────────────────────────────────────────────────
local Theme = {
    -- Window
    WindowBG        = Color3.fromRGB(13, 17, 23),
    WindowBorder    = Color3.fromRGB(48, 54, 61),
    TitleBar        = Color3.fromRGB(22, 27, 34),
    TitleText       = Color3.fromRGB(230, 237, 243),

    -- Tabs
    TabBar          = Color3.fromRGB(22, 27, 34),
    TabActive       = Color3.fromRGB(13, 17, 23),
    TabInactive     = Color3.fromRGB(22, 27, 34),
    TabText         = Color3.fromRGB(201, 209, 217),
    TabTextActive   = Color3.fromRGB(88, 166, 255),
    TabAccentLine   = Color3.fromRGB(88, 166, 255),

    -- Sections / Columns
    SectionBG       = Color3.fromRGB(13, 17, 23),
    SectionHeader   = Color3.fromRGB(22, 27, 34),
    SectionHeaderText = Color3.fromRGB(88, 166, 255),
    SectionBorder   = Color3.fromRGB(48, 54, 61),

    -- Elements
    ElementBG       = Color3.fromRGB(13, 17, 23),
    ElementHover    = Color3.fromRGB(22, 27, 34),
    ElementText     = Color3.fromRGB(201, 209, 217),
    ElementTextDim  = Color3.fromRGB(139, 148, 158),

    -- Toggle
    ToggleOff       = Color3.fromRGB(33, 38, 45),
    ToggleOn        = Color3.fromRGB(35, 134, 54),
    ToggleKnob      = Color3.fromRGB(230, 237, 243),

    -- Slider
    SliderBG        = Color3.fromRGB(33, 38, 45),
    SliderFill      = Color3.fromRGB(88, 166, 255),
    SliderKnob      = Color3.fromRGB(230, 237, 243),

    -- Dropdown / Button
    DropdownBG      = Color3.fromRGB(22, 27, 34),
    DropdownBorder  = Color3.fromRGB(48, 54, 61),
    ButtonBG        = Color3.fromRGB(33, 38, 45),
    ButtonHover     = Color3.fromRGB(48, 54, 61),
    ButtonText      = Color3.fromRGB(201, 209, 217),

    -- Color Picker
    PickerBorder    = Color3.fromRGB(48, 54, 61),

    -- Watermark
    WatermarkBG     = Color3.fromRGB(13, 17, 23),
    WatermarkBorder = Color3.fromRGB(48, 54, 61),
    WatermarkText   = Color3.fromRGB(201, 209, 217),
    WatermarkAccent = Color3.fromRGB(88, 166, 255),

    -- Notification
    NotifBG         = Color3.fromRGB(22, 27, 34),
    NotifBorder     = Color3.fromRGB(48, 54, 61),
    NotifTitle      = Color3.fromRGB(230, 237, 243),
    NotifText       = Color3.fromRGB(201, 209, 217),
    NotifAccentInfo = Color3.fromRGB(88, 166, 255),
    NotifAccentWarn = Color3.fromRGB(210, 153, 34),
    NotifAccentErr  = Color3.fromRGB(247, 129, 102),
    NotifAccentOk   = Color3.fromRGB(63, 185, 80),

    -- Scrollbar
    ScrollbarBG     = Color3.fromRGB(22, 27, 34),
    ScrollbarThumb  = Color3.fromRGB(48, 54, 61),
}

-- ─── Utility ─────────────────────────────────────────────────────
local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    return obj
end

local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ─── ScreenGui ───────────────────────────────────────────────────
local ScreenGui = Create("ScreenGui", {
    Name            = "AxiomUI",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset  = true,
})
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════════════════
--   WATERMARK
-- ═══════════════════════════════════════════════════════════════
local WatermarkData = {
    Visible  = true,
    FPS      = 0,
    Ping     = 0,
    CustomText = "",
    Frame    = nil,
}

local function BuildWatermark()
    local frame = Create("Frame", {
        Name            = "Watermark",
        Size            = UDim2.new(0, 200, 0, 22),
        Position        = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Theme.WatermarkBG,
        BorderSizePixel = 0,
        ZIndex          = 10,
        Parent          = ScreenGui,
    })
    Create("UICorner",    { CornerRadius = UDim.new(0, 3), Parent = frame })
    Create("UIStroke",    { Color = Theme.WatermarkBorder, Thickness = 1, Parent = frame })
    Create("UIPadding",   { PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6), Parent = frame })

    -- Accent left bar
    local bar = Create("Frame", {
        Size            = UDim2.new(0, 2, 1, 0),
        Position        = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.WatermarkAccent,
        BorderSizePixel = 0,
        ZIndex          = 11,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = bar })

    local label = Create("TextLabel", {
        Name            = "WatermarkLabel",
        Size            = UDim2.new(1, -8, 1, 0),
        Position        = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text            = "axiom.win",
        TextColor3      = Theme.WatermarkText,
        TextSize        = 11,
        Font            = Enum.Font.GothamBold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 11,
        Parent          = frame,
    })

    WatermarkData.Frame = frame
    WatermarkData.Label = label

    -- FPS / Ping updater
    local t = 0
    RunService.RenderStepped:Connect(function(dt)
        t = t + dt
        if t >= 0.5 then
            t = 0
            WatermarkData.FPS  = math.floor(1 / dt)
            WatermarkData.Ping = LocalPlayer:GetNetworkPing and math.floor(LocalPlayer:GetNetworkPing() * 1000) or 0
            local extra = WatermarkData.CustomText ~= "" and (" | " .. WatermarkData.CustomText) or ""
            label.Text = string.format(
                "axiom.win | fps: %d · ping: %dms%s",
                WatermarkData.FPS, WatermarkData.Ping, extra
            )
            frame.Size = UDim2.new(0, label.TextBounds.X + 24, 0, 22)
        end
    end)
end
BuildWatermark()

-- Watermark API
function axiom:SetWatermarkVisible(bool)
    WatermarkData.Visible = bool
    if WatermarkData.Frame then
        WatermarkData.Frame.Visible = bool
    end
end

function axiom:SetWatermarkText(text)
    WatermarkData.CustomText = text
end

-- ═══════════════════════════════════════════════════════════════
--   NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════
local NotifHolder = Create("Frame", {
    Name                 = "NotifHolder",
    Size                 = UDim2.new(0, 220, 1, 0),
    Position             = UDim2.new(1, -228, 0, 8),
    BackgroundTransparency = 1,
    ZIndex               = 50,
    Parent               = ScreenGui,
})
Create("UIListLayout", {
    SortOrder       = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding         = UDim.new(0, 5),
    Parent          = NotifHolder,
})

local notifCount = 0

function axiom:Notify(options)
    options = options or {}
    local title    = options.Title   or "Notification"
    local text     = options.Text    or ""
    local duration = options.Duration or 4
    local ntype    = options.Type    or "info"  -- info | warn | error | success

    local accentColor = ({
        info    = Theme.NotifAccentInfo,
        warn    = Theme.NotifAccentWarn,
        error   = Theme.NotifAccentErr,
        success = Theme.NotifAccentOk,
    })[ntype] or Theme.NotifAccentInfo

    notifCount = notifCount + 1

    -- Outer frame (clipping container for slide-in)
    local container = Create("Frame", {
        Name                 = "Notif_" .. notifCount,
        Size                 = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        ClipsDescendants     = true,
        ZIndex               = 50,
        Parent               = NotifHolder,
    })

    local card = Create("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        Position         = UDim2.new(1, 4, 0, 0),
        BackgroundColor3 = Theme.NotifBG,
        BorderSizePixel  = 0,
        ZIndex           = 51,
        Parent           = container,
    })
    Create("UICorner",  { CornerRadius = UDim.new(0, 4), Parent = card })
    Create("UIStroke",  { Color = Theme.NotifBorder, Thickness = 1, Parent = card })

    -- Accent left bar
    local abar = Create("Frame", {
        Size             = UDim2.new(0, 3, 1, -6),
        Position         = UDim2.new(0, 0, 0, 3),
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        ZIndex           = 52,
        Parent           = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = abar })

    -- Title
    Create("TextLabel", {
        Size             = UDim2.new(1, -14, 0, 18),
        Position         = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text             = title,
        TextColor3       = Theme.NotifTitle,
        TextSize         = 11,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 52,
        Parent           = card,
    })

    -- Body
    Create("TextLabel", {
        Size             = UDim2.new(1, -14, 0, 28),
        Position         = UDim2.new(0, 10, 0, 24),
        BackgroundTransparency = 1,
        Text             = text,
        TextColor3       = Theme.NotifText,
        TextSize         = 10,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        ZIndex           = 52,
        Parent           = card,
    })

    -- Progress bar (shrinks as duration passes)
    local progressBG = Create("Frame", {
        Size             = UDim2.new(1, -10, 0, 2),
        Position         = UDim2.new(0, 5, 1, -4),
        BackgroundColor3 = Theme.SliderBG,
        BorderSizePixel  = 0,
        ZIndex           = 52,
        Parent           = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 1), Parent = progressBG })

    local progressFill = Create("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        ZIndex           = 53,
        Parent           = progressBG,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 1), Parent = progressFill })

    -- Slide in
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    Tween(card, tweenInfo, { Position = UDim2.new(0, 0, 0, 0) })

    -- Progress shrink
    Tween(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })

    -- Auto dismiss
    task.delay(duration, function()
        Tween(card, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 4, 0, 0)
        })
        task.wait(0.3)
        container:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
--   WINDOW
-- ═══════════════════════════════════════════════════════════════
function axiom:CreateWindow(options)
    options = options or {}
    local title  = options.Title  or "axiom.win"
    local size   = options.Size   or UDim2.new(0, 520, 0, 340)
    local pos    = options.Position or UDim2.new(0.5, -260, 0.5, -170)

    local Window = {}
    Window._tabs      = {}
    Window._activeTab = nil

    -- ── Main Frame ──────────────────────────────────────────────
    local MainFrame = Create("Frame", {
        Name             = "AxiomWindow",
        Size             = size,
        Position         = pos,
        BackgroundColor3 = Theme.WindowBG,
        BorderSizePixel  = 0,
        ZIndex           = 2,
        Parent           = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = MainFrame })
    Create("UIStroke", { Color = Theme.WindowBorder, Thickness = 1, Parent = MainFrame })

    -- Drop shadow
    local shadow = Create("ImageLabel", {
        Size             = UDim2.new(1, 30, 1, 30),
        Position         = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://6014054959",
        ImageColor3      = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType        = Enum.ScaleType.Slice,
        SliceCenter      = Rect.new(49, 49, 450, 450),
        ZIndex           = 1,
        Parent           = MainFrame,
    })

    -- ── Title Bar ───────────────────────────────────────────────
    local TitleBar = Create("Frame", {
        Name             = "TitleBar",
        Size             = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = Theme.TitleBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = MainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = TitleBar })
    -- Cover bottom rounded corners of title bar
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 6),
        Position         = UDim2.new(0, 0, 1, -6),
        BackgroundColor3 = Theme.TitleBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = TitleBar,
    })

    -- Accent strip under title
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.WindowBorder,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = TitleBar,
    })

    Create("TextLabel", {
        Size             = UDim2.new(1, -10, 1, 0),
        Position         = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text             = "axiom.win",
        TextColor3       = Theme.TitleText,
        TextSize         = 11,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 4,
        Parent           = TitleBar,
    })

    MakeDraggable(MainFrame, TitleBar)

    -- ── Tab Bar ─────────────────────────────────────────────────
    local TabBar = Create("Frame", {
        Name             = "TabBar",
        Size             = UDim2.new(1, 0, 0, 24),
        Position         = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = Theme.TabBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = MainFrame,
    })
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.WindowBorder,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = TabBar,
    })

    local TabLayout = Create("UIListLayout", {
        FillDirection   = Enum.FillDirection.Horizontal,
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Parent          = TabBar,
    })

    -- ── Content Area ────────────────────────────────────────────
    local ContentArea = Create("Frame", {
        Name             = "ContentArea",
        Size             = UDim2.new(1, 0, 1, -50),
        Position         = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Theme.WindowBG,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex           = 2,
        Parent           = MainFrame,
    })

    -- ── Bottom bar (tab labels row) ──────────────────────────────
    local BottomBar = Create("Frame", {
        Name             = "BottomBar",
        Size             = UDim2.new(1, 0, 0, 20),
        Position         = UDim2.new(0, 0, 1, -20),
        BackgroundColor3 = Theme.TitleBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = MainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = BottomBar })
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 6),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.TitleBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = BottomBar,
    })
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 0, -1),
        BackgroundColor3 = Theme.WindowBorder,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = BottomBar,
    })

    local BottomLayout = Create("UIListLayout", {
        FillDirection   = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment   = Enum.VerticalAlignment.Center,
        Padding         = UDim.new(0, 4),
        Parent          = BottomBar,
    })

    -- ── Tab Creator ─────────────────────────────────────────────
    function Window:AddTab(tabName)
        local Tab = {}
        Tab._sections = {}
        Tab.Name = tabName

        -- Tab Button
        local tabBtn = Create("TextButton", {
            Name             = tabName,
            Size             = UDim2.new(0, 0, 1, 0),
            AutomaticSize    = Enum.AutomaticSize.X,
            BackgroundColor3 = Theme.TabInactive,
            BorderSizePixel  = 0,
            Text             = "",
            ZIndex           = 4,
            Parent           = TabBar,
        })
        Create("UIPadding", {
            PaddingLeft  = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            Parent       = tabBtn,
        })

        local tabLabel = Create("TextLabel", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text             = tabName,
            TextColor3       = Theme.TabText,
            TextSize         = 11,
            Font             = Enum.Font.Gotham,
            ZIndex           = 5,
            Parent           = tabBtn,
        })

        -- Active indicator line
        local indicator = Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 2),
            Position         = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = Theme.TabAccentLine,
            BorderSizePixel  = 0,
            Visible          = false,
            ZIndex           = 5,
            Parent           = tabBtn,
        })

        -- Bottom bar label
        local bottomLabel = Create("TextButton", {
            Size             = UDim2.new(0, 0, 1, 0),
            AutomaticSize    = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text             = tabName,
            TextColor3       = Theme.ElementTextDim,
            TextSize         = 10,
            Font             = Enum.Font.Gotham,
            BorderSizePixel  = 0,
            ZIndex           = 4,
            Parent           = BottomBar,
        })

        -- Tab content frame
        local tabFrame = Create("Frame", {
            Name             = tabName .. "_Content",
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible          = false,
            ZIndex           = 2,
            Parent           = ContentArea,
        })

        -- Two-column layout inside tab
        local colLayout = Create("UIListLayout", {
            FillDirection   = Enum.FillDirection.Horizontal,
            Padding         = UDim.new(0, 0),
            Parent          = tabFrame,
        })

        -- Left column
        local leftCol = Create("ScrollingFrame", {
            Name             = "LeftCol",
            Size             = UDim2.new(0.5, -0.5, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.ScrollbarThumb,
            CanvasSize       = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex           = 2,
            Parent           = tabFrame,
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 0),
            Parent    = leftCol,
        })

        -- Divider
        Create("Frame", {
            Name             = "Divider",
            Size             = UDim2.new(0, 1, 1, 0),
            BackgroundColor3 = Theme.WindowBorder,
            BorderSizePixel  = 0,
            ZIndex           = 2,
            Parent           = tabFrame,
        })

        -- Right column
        local rightCol = Create("ScrollingFrame", {
            Name             = "RightCol",
            Size             = UDim2.new(0.5, -0.5, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.ScrollbarThumb,
            CanvasSize       = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex           = 2,
            Parent           = tabFrame,
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 0),
            Parent    = rightCol,
        })

        Tab._leftCol  = leftCol
        Tab._rightCol = rightCol
        Tab._frame    = tabFrame

        -- Activate
        local function activate()
            -- Hide all
            for _, t in ipairs(Window._tabs) do
                t._frame.Visible = false
                if t._btn then
                    t._btn.BackgroundColor3 = Theme.TabInactive
                    t._label.TextColor3     = Theme.TabText
                    t._label.Font           = Enum.Font.Gotham
                    t._indicator.Visible    = false
                    t._bottomLabel.TextColor3 = Theme.ElementTextDim
                end
            end
            tabFrame.Visible            = true
            tabBtn.BackgroundColor3     = Theme.TabActive
            tabLabel.TextColor3         = Theme.TabTextActive
            tabLabel.Font               = Enum.Font.GothamBold
            indicator.Visible           = true
            bottomLabel.TextColor3      = Theme.TabTextActive
            Window._activeTab           = Tab
        end

        Tab._btn         = tabBtn
        Tab._label       = tabLabel
        Tab._indicator   = indicator
        Tab._bottomLabel = bottomLabel

        tabBtn.MouseButton1Click:Connect(activate)
        bottomLabel.MouseButton1Click:Connect(activate)

        table.insert(Window._tabs, Tab)

        -- Auto-activate first tab
        if #Window._tabs == 1 then
            activate()
        end

        -- ── Section Creator ──────────────────────────────────────
        function Tab:AddSection(sectionName, column)
            local col = (column == "right") and rightCol or leftCol

            local Section = {}

            local sectionFrame = Create("Frame", {
                Name             = sectionName,
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.SectionBG,
                BorderSizePixel  = 0,
                ZIndex           = 2,
                Parent           = col,
            })

            -- Header
            local header = Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 20),
                BackgroundColor3 = Theme.SectionHeader,
                BorderSizePixel  = 0,
                ZIndex           = 3,
                Parent           = sectionFrame,
            })
            Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Theme.SectionBorder,
                BorderSizePixel  = 0,
                ZIndex           = 3,
                Parent           = header,
            })
            -- Accent line left of header
            local hAccent = Create("Frame", {
                Size             = UDim2.new(0, 2, 0, 12),
                Position         = UDim2.new(0, 4, 0.5, -6),
                BackgroundColor3 = Theme.TabAccentLine,
                BorderSizePixel  = 0,
                ZIndex           = 4,
                Parent           = header,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 1), Parent = hAccent })

            Create("TextLabel", {
                Size             = UDim2.new(1, -14, 1, 0),
                Position         = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text             = sectionName,
                TextColor3       = Theme.SectionHeaderText,
                TextSize         = 10,
                Font             = Enum.Font.GothamBold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 4,
                Parent           = header,
            })

            -- Items list
            local itemList = Create("Frame", {
                Name             = "Items",
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 0, 20),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel  = 0,
                ZIndex           = 2,
                Parent           = sectionFrame,
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 0),
                Parent    = itemList,
            })

            Section._list = itemList

            -- ── ELEMENT: Toggle ──────────────────────────────────
            function Section:AddToggle(label, default, callback)
                local state = default or false
                callback = callback or function() end

                local row = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = Theme.ElementBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = itemList,
                })
                Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.SectionBorder,
                    ZIndex           = 3,
                    Parent           = row,
                })

                -- Hover
                local hoverBtn = Create("TextButton", {
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text             = "",
                    ZIndex           = 4,
                    Parent           = row,
                })
                hoverBtn.MouseEnter:Connect(function()
                    Tween(row, TweenInfo.new(0.1), { BackgroundColor3 = Theme.ElementHover })
                end)
                hoverBtn.MouseLeave:Connect(function()
                    Tween(row, TweenInfo.new(0.1), { BackgroundColor3 = Theme.ElementBG })
                end)

                Create("TextLabel", {
                    Size             = UDim2.new(1, -36, 1, 0),
                    Position         = UDim2.new(0, 6, 0, 0),
                    BackgroundTransparency = 1,
                    Text             = label,
                    TextColor3       = Theme.ElementText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 4,
                    Parent           = row,
                })

                -- Toggle pill
                local pill = Create("Frame", {
                    Size             = UDim2.new(0, 24, 0, 12),
                    Position         = UDim2.new(1, -30, 0.5, -6),
                    BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                    BorderSizePixel  = 0,
                    ZIndex           = 5,
                    Parent           = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = pill })

                local knob = Create("Frame", {
                    Size             = UDim2.new(0, 8, 0, 8),
                    Position         = state and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4),
                    BackgroundColor3 = Theme.ToggleKnob,
                    BorderSizePixel  = 0,
                    ZIndex           = 6,
                    Parent           = pill,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

                local twInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

                local function update()
                    Tween(pill, twInfo, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff })
                    Tween(knob, twInfo, { Position = state and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4) })
                    callback(state)
                end

                hoverBtn.MouseButton1Click:Connect(function()
                    state = not state
                    update()
                end)

                local obj = {}
                function obj:Set(val)
                    state = val
                    update()
                end
                function obj:Get() return state end
                return obj
            end

            -- ── ELEMENT: Slider ──────────────────────────────────
            function Section:AddSlider(label, min, max, default, callback)
                min = min or 0; max = max or 100
                local value = math.clamp(default or min, min, max)
                callback = callback or function() end

                local row = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = Theme.ElementBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = itemList,
                })
                Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.SectionBorder,
                    ZIndex           = 3,
                    Parent           = row,
                })

                Create("TextLabel", {
                    Size             = UDim2.new(1, -40, 0, 13),
                    Position         = UDim2.new(0, 6, 0, 2),
                    BackgroundTransparency = 1,
                    Text             = label,
                    TextColor3       = Theme.ElementText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 4,
                    Parent           = row,
                })

                local valLabel = Create("TextLabel", {
                    Size             = UDim2.new(0, 34, 0, 13),
                    Position         = UDim2.new(1, -40, 0, 2),
                    BackgroundTransparency = 1,
                    Text             = tostring(value),
                    TextColor3       = Theme.TabTextActive,
                    TextSize         = 10,
                    Font             = Enum.Font.GothamBold,
                    TextXAlignment   = Enum.TextXAlignment.Right,
                    ZIndex           = 4,
                    Parent           = row,
                })

                local track = Create("Frame", {
                    Size             = UDim2.new(1, -12, 0, 4),
                    Position         = UDim2.new(0, 6, 1, -10),
                    BackgroundColor3 = Theme.SliderBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 4,
                    Parent           = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

                local pct = (value - min) / (max - min)
                local fill = Create("Frame", {
                    Size             = UDim2.new(pct, 0, 1, 0),
                    BackgroundColor3 = Theme.SliderFill,
                    BorderSizePixel  = 0,
                    ZIndex           = 5,
                    Parent           = track,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

                local knob = Create("Frame", {
                    Size             = UDim2.new(0, 8, 0, 8),
                    Position         = UDim2.new(pct, -4, 0.5, -4),
                    BackgroundColor3 = Theme.SliderKnob,
                    BorderSizePixel  = 0,
                    ZIndex           = 6,
                    Parent           = track,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

                local dragging = false
                local function update(input)
                    local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                    rel = math.clamp(rel, 0, 1)
                    value = math.floor(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    knob.Position = UDim2.new(rel, -4, 0.5, -4)
                    valLabel.Text = tostring(value)
                    callback(value)
                end

                track.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true; update(i)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
                end)

                local obj = {}
                function obj:Set(val)
                    value = math.clamp(val, min, max)
                    local r = (value - min) / (max - min)
                    fill.Size = UDim2.new(r, 0, 1, 0)
                    knob.Position = UDim2.new(r, -4, 0.5, -4)
                    valLabel.Text = tostring(value)
                    callback(value)
                end
                function obj:Get() return value end
                return obj
            end

            -- ── ELEMENT: Dropdown ────────────────────────────────
            function Section:AddDropdown(label, options, default, callback)
                options = options or {}
                local selected = default or (options[1] or "")
                callback = callback or function() end

                local row = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = Theme.ElementBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    ClipsDescendants = false,
                    Parent           = itemList,
                })
                Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.SectionBorder,
                    ZIndex           = 3,
                    Parent           = row,
                })

                Create("TextLabel", {
                    Size             = UDim2.new(0.4, 0, 1, 0),
                    Position         = UDim2.new(0, 6, 0, 0),
                    BackgroundTransparency = 1,
                    Text             = label,
                    TextColor3       = Theme.ElementText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 4,
                    Parent           = row,
                })

                local btn = Create("TextButton", {
                    Size             = UDim2.new(0, 90, 0, 14),
                    Position         = UDim2.new(1, -96, 0.5, -7),
                    BackgroundColor3 = Theme.ButtonBG,
                    BorderSizePixel  = 0,
                    Text             = selected,
                    TextColor3       = Theme.ButtonText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    ZIndex           = 5,
                    Parent           = row,
                })
                Create("UICorner",  { CornerRadius = UDim.new(0, 3), Parent = btn })
                Create("UIStroke",  { Color = Theme.DropdownBorder, Thickness = 1, Parent = btn })

                -- Dropdown list
                local listFrame = Create("Frame", {
                    Size             = UDim2.new(0, 90, 0, 0),
                    Position         = UDim2.new(1, -96, 1, 2),
                    BackgroundColor3 = Theme.DropdownBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 20,
                    Visible          = false,
                    Parent           = row,
                })
                Create("UICorner",     { CornerRadius = UDim.new(0, 3), Parent = listFrame })
                Create("UIStroke",     { Color = Theme.DropdownBorder, Thickness = 1, Parent = listFrame })
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = listFrame })

                local isOpen = false
                for _, opt in ipairs(options) do
                    local optBtn = Create("TextButton", {
                        Size             = UDim2.new(1, 0, 0, 16),
                        BackgroundColor3 = Theme.DropdownBG,
                        BorderSizePixel  = 0,
                        Text             = opt,
                        TextColor3       = Theme.ElementText,
                        TextSize         = 10,
                        Font             = Enum.Font.Gotham,
                        ZIndex           = 21,
                        Parent           = listFrame,
                    })
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.ElementHover })
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.DropdownBG })
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        btn.Text = opt
                        isOpen = false
                        listFrame.Visible = false
                        callback(opt)
                    end)
                end
                listFrame.Size = UDim2.new(0, 90, 0, #options * 16 + 2)

                btn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    listFrame.Visible = isOpen
                end)

                local obj = {}
                function obj:Set(val) selected = val; btn.Text = val; callback(val) end
                function obj:Get() return selected end
                return obj
            end

            -- ── ELEMENT: Button ──────────────────────────────────
            function Section:AddButton(label, callback)
                callback = callback or function() end

                local row = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = Theme.ElementBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = itemList,
                })
                Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.SectionBorder,
                    ZIndex           = 3,
                    Parent           = row,
                })

                local btn = Create("TextButton", {
                    Size             = UDim2.new(1, -12, 0, 14),
                    Position         = UDim2.new(0, 6, 0.5, -7),
                    BackgroundColor3 = Theme.ButtonBG,
                    BorderSizePixel  = 0,
                    Text             = label,
                    TextColor3       = Theme.ButtonText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    ZIndex           = 4,
                    Parent           = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = btn })
                Create("UIStroke", { Color = Theme.WindowBorder, Thickness = 1, Parent = btn })

                btn.MouseEnter:Connect(function()
                    Tween(btn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.ButtonHover })
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.ButtonBG })
                end)
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, TweenInfo.new(0.05), { BackgroundColor3 = Theme.SliderFill })
                    task.delay(0.1, function()
                        Tween(btn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.ButtonBG })
                    end)
                    callback()
                end)
            end

            -- ── ELEMENT: Label ───────────────────────────────────
            function Section:AddLabel(text)
                local row = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 18),
                    BackgroundColor3 = Theme.ElementBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = itemList,
                })
                Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.SectionBorder,
                    ZIndex           = 3,
                    Parent           = row,
                })
                local lbl = Create("TextLabel", {
                    Size             = UDim2.new(1, -12, 1, 0),
                    Position         = UDim2.new(0, 6, 0, 0),
                    BackgroundTransparency = 1,
                    Text             = text,
                    TextColor3       = Theme.ElementTextDim,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 4,
                    Parent           = row,
                })
                local obj = {}
                function obj:Set(t) lbl.Text = t end
                return obj
            end

            -- ── ELEMENT: ColorPicker ─────────────────────────────
            function Section:AddColorPicker(label, default, callback)
                local color = default or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end

                local row = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = Theme.ElementBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = itemList,
                })
                Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.SectionBorder,
                    ZIndex           = 3,
                    Parent           = row,
                })
                Create("TextLabel", {
                    Size             = UDim2.new(1, -36, 1, 0),
                    Position         = UDim2.new(0, 6, 0, 0),
                    BackgroundTransparency = 1,
                    Text             = label,
                    TextColor3       = Theme.ElementText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 4,
                    Parent           = row,
                })

                local swatch = Create("Frame", {
                    Size             = UDim2.new(0, 24, 0, 13),
                    Position         = UDim2.new(1, -30, 0.5, -6.5),
                    BackgroundColor3 = color,
                    BorderSizePixel  = 0,
                    ZIndex           = 5,
                    Parent           = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = swatch })
                Create("UIStroke", { Color = Theme.PickerBorder, Thickness = 1, Parent = swatch })

                local obj = {}
                function obj:Set(c) color = c; swatch.BackgroundColor3 = c; callback(c) end
                function obj:Get() return color end
                return obj
            end

            -- ── ELEMENT: TextBox ─────────────────────────────────
            function Section:AddTextBox(label, placeholder, callback)
                callback = callback or function() end

                local row = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = Theme.ElementBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = itemList,
                })
                Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    Position         = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.SectionBorder,
                    ZIndex           = 3,
                    Parent           = row,
                })
                Create("TextLabel", {
                    Size             = UDim2.new(0.45, 0, 1, 0),
                    Position         = UDim2.new(0, 6, 0, 0),
                    BackgroundTransparency = 1,
                    Text             = label,
                    TextColor3       = Theme.ElementText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 4,
                    Parent           = row,
                })

                local box = Create("TextBox", {
                    Size             = UDim2.new(0, 80, 0, 14),
                    Position         = UDim2.new(1, -86, 0.5, -7),
                    BackgroundColor3 = Theme.ButtonBG,
                    BorderSizePixel  = 0,
                    Text             = "",
                    PlaceholderText  = placeholder or "...",
                    PlaceholderColor3 = Theme.ElementTextDim,
                    TextColor3       = Theme.ElementText,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    ZIndex           = 5,
                    Parent           = row,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = box })
                Create("UIStroke", { Color = Theme.WindowBorder, Thickness = 1, Parent = box })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = box })

                box.FocusLost:Connect(function(enter)
                    if enter then callback(box.Text) end
                end)

                local obj = {}
                function obj:Set(t) box.Text = t end
                function obj:Get() return box.Text end
                return obj
            end

            return Section
        end

        return Tab
    end

    -- ── Toggle Visibility (keybind) ──────────────────────────────
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            visible = not visible
            MainFrame.Visible = visible
        end
    end)

    function Window:SetVisible(bool)
        visible = bool
        MainFrame.Visible = bool
    end

    function Window:Destroy()
        MainFrame:Destroy()
    end

    return Window
end

return axiom


