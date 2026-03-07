local GAMES = {
    [100283815455755] = "https://raw.githubusercontent.com/itssor/axiom.win-/refs/heads/main/VagrantSurvival.lua",
}

local BLACKLISTED_EXECUTORS = {"Xeno", "Ronix", "Solara"}

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")

local lp = Players.LocalPlayer
local id = game.PlaceId
local request = (syn and syn.request) or (http and http.request) or http_request or request

local function secureCheck()
    local exec = (identifyexecutor and type(identifyexecutor) == "function" and identifyexecutor()) or "Unknown"
    
    for _, name in ipairs(BLACKLISTED_EXECUTORS) do
        if exec:find(name) then
            lp:Kick("\n\naxiom.win\n\nAccess Denied: Blacklisted Executor ("..name..")\n")
            return false
        end
    end

    local integrityMethods = {
        ["hookmetamethod"] = hookmetamethod,
        ["hookfunction"] = hookfunction,
        ["getrawmetatable"] = getrawmetatable,
        ["checkcaller"] = checkcaller,
        ["setreadonly"] = setreadonly
    }

    for name, func in pairs(integrityMethods) do
        if not func or type(func) ~= "function" then
            lp:Kick("\n\naxiom.win\n\nIntegrity Failure: Missing/Spoofed "..name.."\n")
            return false
        end
    end

    return true
end

local function log(msg, symbol)
    symbol = symbol or "»"
    print(string.format("  %s  %s", symbol, msg))
end

if not secureCheck() then return end

print("\n")
local banner = {
    "    █████╗ ██╗  ██╗██╗ ██████╗ ███╗   ███╗",
    "   ██╔══██╗╚██╗██╔╝██║██╔═══██╗████╗ ████║",
    "   ███████║ ╚███╔╝ ██║██║   ██║██╔████╔██║",
    "   ██╔══██║ ██╔██╗ ██║██║   ██║██║╚██╔╝██║",
    "   ██║  ██║██╔╝ ██╗██║╚██████╔╝██║ ╚═╝ ██║",
    "   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝     ╚═╝",
    "            axiom.win  ·  stay winning",
    ""
}

for _, line in ipairs(banner) do
    print(line)
    task.wait(0.01)
end

log("Security validation passed", "🛡️")
task.wait(0.4)

local url = GAMES[id]
if not url then
    log("Axiom doesn't support PlaceID: " .. id, "✗")
    task.wait(1)
    lp:Kick("\n\naxiom.win\n\nUnsupported Game (ID: "..id..")\n")
    return
end

log("Synchronizing with remote...", "🛰️")
task.wait(0.4)

local success, result = pcall(function()
    local response = request({Url = url, Method = "GET"})
    return loadstring(response.Body)()
end)

print("\n  " .. string.rep("─", 40))
if success then
    local gameName = pcall(function() return MarketplaceService:GetProductInfo(id).Name end) and MarketplaceService:GetProductInfo(id).Name or "Unknown"
    log("Axiom Loaded", "★")
    log("Session  : " .. lp.Name, "•")
    log("Context  : " .. gameName, "•")
else
    log("Critical Error during load", "✗")
    log("Log: " .. tostring(result), "!")
end
print("  " .. string.rep("─", 40) .. "\n")
