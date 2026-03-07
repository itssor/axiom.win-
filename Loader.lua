local BLACKLIST = {
    "trigon",    "crochet",   "electron",  "furk",
    "hydrogen",  "sk8r",      "evon",      "fluxus",
    "comet",     "scriptware","visenya",   "nameless",
    "recoil",    "ronix",     "solara",    "xeno",
}

local function check()
    local req = request or http_request or (syn and syn.request)
    if not req        then return false, "no http function"   end
    if not loadstring  then return false, "loadstring missing" end
    if not game:GetService("Players").LocalPlayer then return false, "no localplayer" end
    if not (request ~= nil or http_request ~= nil or syn ~= nil or getgenv ~= nil) then
        return false, "no executor env"
    end
    local name = ""
    pcall(function()
        if identifyexecutor then name = identifyexecutor():lower()
        elseif syn then name = "synapse" end
    end)
    for _, v in ipairs(BLACKLIST) do
        if name:find(v, 1, true) then return false, "blocked: " .. name end
    end
    local canary = (getgenv or getrenv or getreg) ~= nil
    if not canary then return false, "env check failed" end
    return true, name ~= "" and name or "unknown"
end

local GAMES = {
    [100283815455755] = "https://raw.githubusercontent.com/itssor/axiom.win-/refs/heads/main/VagrantSurvival.lua",
}

local Players  = game:GetService("Players")
local TweenSvc = game:GetService("TweenService")
local HttpSvc  = game:GetService("HttpService")
local CoreGui  = game:GetService("CoreGui")
local lp       = Players.LocalPlayer
local id       = game.PlaceId
local DISCORD  = "https://discord.gg/JeyA4jgnaJ"
local DISC_CODE = "JeyA4jgnaJ"

if setclipboard then setclipboard(DISCORD) end

spawn(function()
    local req = request or http_request or (syn and syn.request)
    if not req then return end
    for i = 6463, 6472 do
        wait()
        spawn(function()
            pcall(function()
                req({
                    Url    = "http://127.0.0.1:" .. i .. "/rpc?v=1",
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
                    Body = HttpSvc:JSONEncode({
                        cmd   = "INVITE_BROWSER",
                        nonce = string.lower(HttpSvc:GenerateGUID(false)),
                        args  = { code = DISC_CODE },
                    }),
                })
            end)
        end)
    end
end)

local sg = Instance.new("ScreenGui")
sg.Name           = "AxiomLoader"
sg.ResetOnSpawn   = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.DisplayOrder   = 9999
pcall(function() sg.Parent = CoreGui end)
if not sg.Parent then sg.Parent = lp:WaitForChild("PlayerGui") end

local function tw(obj, t, props, style, dir)
    TweenSvc:Create(obj,
        TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end
local label = Instance.new("TextLabel")
label.Size               = UDim2.fromOffset(400, 60)
label.Position           = UDim2.new(0.5, -200, 0, -80)
label.BackgroundTransparency = 1
label.Text               = "AXIOM.WIN"
label.TextColor3         = Color3.fromRGB(255, 210, 60)
label.TextTransparency   = 1
label.Font               = Enum.Font.RobotoMono
label.TextSize           = 42
label.TextXAlignment     = Enum.TextXAlignment.Center
label.ZIndex             = 10
label.Parent             = sg
wait(0.05)
tw(label, 0.6,
    { Position = UDim2.new(0.5, -200, 0, 28), TextTransparency = 0 },
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)
wait(0.65)
spawn(function()
    while label and label.Parent do
        tw(label, 1.4, { TextColor3 = Color3.fromRGB(255, 175, 30) }, Enum.EasingStyle.Sine)
        wait(1.4)
        tw(label, 1.4, { TextColor3 = Color3.fromRGB(255, 215, 60) }, Enum.EasingStyle.Sine)
        wait(1.4)
    end
end)

local function closeGUI()
    tw(label, 0.4,
        { Position = UDim2.new(0.5, -200, 0, -80), TextTransparency = 1 },
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )
    delay(0.5, function() pcall(function() sg:Destroy() end) end)
end

spawn(function()

    local passed, execInfo = check()
    if not passed then
        tw(label, 0.2, { TextColor3 = Color3.fromRGB(220, 55, 55) })
        wait(1.5)
        closeGUI()
        wait(0.5)
        lp:Kick("\n\n  axiom.win  —  access denied\n  " .. execInfo .. "\n")
        return
    end

    local url = GAMES[id]
    if not url then
        tw(label, 0.2, { TextColor3 = Color3.fromRGB(220, 55, 55) })
        wait(1.5)
        closeGUI()
        wait(0.5)
        lp:Kick("\n\n  axiom.win  —  unsupported game\n  placeid " .. id .. "\n")
        return
    end

    local req = request or http_request or (syn and syn.request)
    local res = req({ Url = url, Method = "GET" })
    local src = res and res.Body

    if not src or #src == 0 then
        tw(label, 0.2, { TextColor3 = Color3.fromRGB(220, 55, 55) })
        wait(1.5)
        closeGUI()
        return
    end

    local fn
    local cleaned = src:gsub("^\xEF\xBB\xBF", ""):gsub("\r\n", "\n"):gsub("\r", "\n")
    fn = loadstring(cleaned)
    if not fn and syn and syn.loadstring then
        fn = syn.loadstring(cleaned)
    end

    if not fn then
        tw(label, 0.2, { TextColor3 = Color3.fromRGB(220, 55, 55) })
        wait(1.5)
        closeGUI()
        return
    end
    tw(label, 0.25, { TextColor3 = Color3.fromRGB(60, 210, 110) })
    wait(0.6)
    closeGUI()
    wait(0.45)

    if setfenv then pcall(setfenv, fn, getfenv()) end
    fn()

end)
