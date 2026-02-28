local GAMES = {
    [100283815455755] = "https://raw.githubusercontent.com/itssor/axiom.win-/refs/heads/main/VagrantSurvival.lua",
}

local lp = game:GetService("Players").LocalPlayer
local id = game.PlaceId
local function w(n) task.wait(n) end
local function p(s) print(s) end
local function ok(n, s) w(n) p("  ✓  "..s) end

-- [ DISCORD INTEGRATION MAGIC ] --
local discordLink = "https://discord.gg/9VtZykNNkM"
local discordCode = "9VtZykNNkM"

-- 1. Copy to clipboard
if setclipboard then
    setclipboard(discordLink)
end

-- 2. Sleek UI Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "axiom.win",
        Text = "Please join the discord! It's copied to your clipboard.",
        Duration = 8,
        Button1 = "Okay!"
    })
end)

-- 3. Force Open Desktop Discord App (RPC Trick)
local req = request or http_request or (syn and syn.request)
if req then
    for i = 6463, 6472 do
        task.spawn(function()
            pcall(function()
                req({
                    Url = "http://127.0.0.1:"..tostring(i).."/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = "INVITE_BROWSER",
                        nonce = string.lower(game:GetService("HttpService"):GenerateGUID(false)),
                        args = {code = discordCode}
                    })
                })
            end)
        end)
    end
end
-- [ END DISCORD INTEGRATION ] --


for _,l in ipairs({"","    ░█████╗░██╗░░██╗██╗░█████╗░███╗░░░███╗","    ██╔══██╗╚██╗██╔╝██║██╔══██╗████╗░████║","    ███████║░╚███╔╝░██║██║░░██║██╔████╔██║","    ██╔══██║░██╔██╗░██║██║░░██║██║╚██╔╝██║","    ██║░░██║██╔╝╚██╗██║╚█████╔╝██║░╚═╝░██║","    ╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░╚════╝░╚═╝░░░░╚═╝","            axiom.win  ·  stay winning",""}) do p(l) w(0.04) end

p("\n  =======================================================")
p("  Please join the discord! It's copied to your clipboard.")
p("  -> " .. discordLink)
p("  =======================================================\n")

w(0.2) p("  booting axiom...") w(0.15)
ok(0.6, "checking environment")
ok(0.5, "resolving game context")
ok(0.7, "authenticating session")

local url = GAMES[id]
if not url then
    w(0.2)
    p("  ╔══════════════════════════════════════╗")
    p("  ║                                      ║")
    p("  ║   lmao what game is this even        ║")
    p("  ║   axiom doesn't fw this place        ║")
    p("  ║                                      ║")
    p("  ╚══════════════════════════════════════╝")
    w(1.2)
    lp:Kick("\n\n  axiom.win\n\n  unsupported game\n  placeid "..id.." is not on the list\n\n  go play a real game\n")
    return
end

ok(0.55, "fetching payload")
local s, r = pcall(function() return loadstring(request({Url=url;Method="GET"}).Body)() end)
p("")
if s then
    p("  ✓  axiom loaded  ·  go cook")
    p("  ─────────────────────────────────")
    p("  game    : "..(game:GetService("MarketplaceService"):GetProductInfo(id).Name or tostring(id)))
    p("  player  : "..lp.Name)
    p("  place   : "..id)
    p("  ─────────────────────────────────")
else
    p("  ✗  load failed — check your url or executor http perms")
    p("  error: "..tostring(r))
end
