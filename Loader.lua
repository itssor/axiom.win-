local GAMES = {
    [100283815455755] = "https://raw.githubusercontent.com/itssor/axiom.win-/refs/heads/main/VagrantSurvival.lua",
}

local lp = game:GetService("Players").LocalPlayer
local id = game.PlaceId

local discordLink = "https://discord.gg/9VtZykNNkM"
local discordCode = "9VtZykNNkM"

if setclipboard then
    setclipboard(discordLink)
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "axiom.win",
        Text = "Joining Discord... (Link copied to clipboard!)",
        Duration = 6
    })
end)

task.spawn(function()
    local req = request or http_request or (syn and syn.request)
    if req then
        local hs = game:GetService("HttpService")
        for i = 6463, 6472 do
            task.spawn(function()
                pcall(function()
                    req({
                        Url = "http://127.0.0.1:" .. i .. "/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"] = "https://discord.com"
                        },
                        Body = hs:JSONEncode({
                            cmd = "INVITE_BROWSER",
                            nonce = string.lower(hs:GenerateGUID(false)),
                            args = { code = discordCode }
                        })
                    })
                end)
            end)
        end
    end
    pcall(function()
        if identifyexecutor and identifyexecutor():find("Solara") then
            game:GetService("GuiService"):OpenBrowserWindow(discordLink)
        end
    end)
end)

for _, l in ipairs({
    "",
    "    ░█████╗░██╗░░██╗██╗░█████╗░███╗░░░███╗",
    "    ██╔══██╗╚██╗██╔╝██║██╔══██╗████╗░████║",
    "    ███████║░╚███╔╝░██║██║░░██║██╔████╔██║",
    "    ██╔══██║░██╔██╗░██║██║░░██║██║╚██╔╝██║",
    "    ██║░░██║██╔╝╚██╗██║╚█████╔╝██║░╚═╝░██║",
    "    ╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░╚════╝░╚═╝░░░░╚═╝",
    "            axiom.win  ·  stay winning",
    ""
}) do
    print(l)
    task.wait(0.04)
end

print("\n  -------------------------------------------------------")
print("  JOIN THE DISCORD: " .. discordLink)
print("  -------------------------------------------------------\n")

local function ok(n, s)
    task.wait(n)
    print("  ✓  " .. s)
end

task.wait(0.2) print("  booting axiom...") task.wait(0.15)
ok(0.6, "checking environment")
ok(0.5, "resolving game context")
ok(0.7, "authenticating session")

local url = GAMES[id]
if not url then
    task.wait(0.2)
    print("  ╔══════════════════════════════════════╗")
    print("  ║                                      ║")
    print("  ║   lmao what game is this even        ║")
    print("  ║   axiom doesn't fw this place        ║")
    print("  ║                                      ║")
    print("  ╚══════════════════════════════════════╝")
    task.wait(1.2)
    lp:Kick("\n\n  axiom.win\n\n  unsupported game\n  placeid " .. id .. " is not on the list\n\n  go play a real game\n")
    return
end

ok(0.55, "fetching payload")
local s, r = pcall(function()
    return loadstring(request({ Url = url, Method = "GET" }).Body)()
end)

print("")
if s then
    print("  ✓  axiom loaded  ·  go cook")
    print("  ─────────────────────────────────")
    print("  game    : " .. (game:GetService("MarketplaceService"):GetProductInfo(id).Name or tostring(id)))
    print("  player  : " .. lp.Name)
    print("  place   : " .. id)
    print("  ─────────────────────────────────")
else
    print("  ✗  load failed — check your url or executor http perms")
    print("  error: " .. tostring(r))
end
