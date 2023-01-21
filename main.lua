-- lzsfx#7977
repeat
    wait(); print("Waiting For Load")
until game:IsLoaded()

repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("MapUIContainer"):FindFirstChild("MapUI").BoothUI
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local VirtualUser=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)

local teleportFunc = queueonteleport or queue_on_teleport or syn and syn.queue_on_teleport

if _G.hopAtPlayerAmount > 0 then
    spawn(function()
        while wait() do
            local GUIDs = {}
            local maxPlayers = 0
            local pagesToSearch = 100
            function Search()
                local Http = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="))
                for i = 1,pagesToSearch do
                    for _,v in pairs(Http.data) do
                        if v.playing < 20 and v.id ~= game.JobId then
                            maxPlayers = v.maxPlayers
                            table.insert(GUIDs, {id = v.id, users = v.playing})
                        end
                    end
                    print("Searched! i=", i)
                    if Http.nextPageCursor ~= null then Http = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..Http.nextPageCursor)) else break end
                end 
            end
            Search()
            local randomServer = GUIDs[math.random(#GUIDs)]
            teleportFunc([[
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer.id, game.Players.LocalPlayer)
            ]])
            wait(_G.hopInterval)
        end
    end)
end
